%% ------------------------------------------------------------------
%%
%% $Id: mod_vip.erl 13210 2014-06-05 08:41:45Z piaohua $
%%
%% @doc vip
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_vip).
-export([
        vip_privilege_check/1
        ,vip_privilege_check/2
        ,set_vip/4
        ,set_vip2/4
        ,set_mcard/2
        ,send_mcard/1
        ,init_vip/1
        ,stores_vip/1
    ]).

-include("common.hrl").

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_vip_test() ->
    Ids = data_vip:get(ids),
    ?assert(length(Ids) > 0 ),
    lists:foreach(fun(Id) ->
                Data = data_vip:get(Id),
                ?assert(util:get_val(diamond, Data) >= 0 ),
                ?assert(util:get_val(free, Data) >= 0 ),
                ?assert(util:get_val(chat, Data) >= 0 ),
                Prize = util:get_val(prize, Data,0),
                ?assert(util:get_val(prize, Data) >= 0 ),
                ?assertMatch(ok, test_prize(Prize)),
                Reward = util:get_val(reward,Data, 0),
                ?assert(util:get_val(reward,Data) >=0),
                ?assertMatch(ok, test_reward(Reward)),
                ?assert(util:get_val(fast, Data) >= 0 ),
                ?assert(util:get_val(buys1, Data) >= 0 ),
                ?assert(util:get_val(buys2, Data) >= 0 ),
                ?assert(util:get_val(buys3, Data) >= 0 ),
                ?assert(util:get_val(mcard, Data) >= 0 )
        end, Ids),
    ok.

test_prize(Id) ->
    Ids = data_vip_prize:get(ids),
    ?assert(
        case Id == 0 of
            true -> true;
            false ->lists:member(Id,Ids)
        end),
    ok.

test_reward(Id) when Id /= 0 ->
    Ids = data_vip_reward:get(ids),
    ?assert(lists:member(Id,Ids)),
    ok;

test_reward(_) ->
    ok.

data_vip_prize_test() ->
    Ids = data_vip_prize:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_vip_prize:get(Id),
                Prize = util:get_val(prize,Data,[]),
                ?assert(Prize =/= []),
                lists:foreach(fun({A,C}) ->
                            ?assertMatch(ok,case A < ?MIN_EQU_ID of
                                    true ->
                                        case A == 5 of
                                            true ->
                                                ?assert(is_tuple(C)),
                                                {Hid,_} = C,
                                                ?assert(data_hero:get(Hid) =/= undefined),
                                                ok;
                                            false ->
                                                ?assert(C > 0),
                                                ?assert(data_prop:get(A) =/= undefined),
                                                ok
                                        end;
                                    false ->
                                        ?assert(C > 0),
                                        ?assert(data_equ:get(A) =/= undefined),
                                        ok
                                end)
                    end, Prize)
        end, Ids),
    ok.

data_vip_reward_test() ->
    Ids = data_vip_reward:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_vip_reward:get(Id),
                Prize = util:get_val(prize,Data,[]),
                ?assert(
                    case Id == 1 of
                        true -> Prize == [];
                        false -> Prize =/= []
                    end),
                lists:foreach(fun({A,C}) ->
                            ?assertMatch(ok,case A < ?MIN_EQU_ID of
                                    true ->
                                        case A == 5 of
                                            true ->
                                                ?assert(is_tuple(C)),
                                                {Hid,_} = C,
                                                ?assert(data_hero:get(Hid) =/= undefined),
                                                ok;
                                            false ->
                                                ?assert(C > 0),
                                                ?assert(data_prop:get(A) =/= undefined),
                                                ok
                                        end;
                                    false ->
                                        ?assert(C > 0),
                                        ?assert(data_equ:get(A) =/= undefined),
                                        ok
                                end)
                    end, Prize)
        end, Ids),
    ok.


-endif.

%% vip 验证是否过期(返回ture有vip)
vip_privilege_check(Rs) ->
    case Rs#role.vip of
        undefined -> false;
        [] -> false;
        [Vip, Time, _Val] ->
            [_A|Ids] = data_vip:get(ids),
            case lists:member(Vip, Ids) of
                true ->
                    case Time == 0 of
                        true -> true;
                        false ->
                            (Time - util:unixtime()) > 0
                    end;
                false -> false
            end
    end.
%% 验证vip特权是否可使用(先验证是vip)
vip_privilege_check(AtomId, Rs) ->
    case Rs#role.vip of
        undefined -> false;
        [] -> false;
        [_Vip, _Time, Val] ->
            case lists:keyfind(AtomId, 1, Val) of
                false -> false;
                {AtomId,V,N,C} ->
                    N2 = case C < util:unixtime(today) of
                        true -> 0;
                        false -> N
                    end,
                    V > N2
            end
    end.

%% 充值成为vip
set_vip(AtomId, Num, Custom, Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            Rs;
        [Vip,Time,Val] ->
            {AtomId,V,N,_C} = lists:keyfind(AtomId, 1, Val),
            Num2 = N + Num,
            Val2 = lists:keyreplace(AtomId,1,Val,{AtomId,V,Num2,Custom}),
            ?DEBUG("Val2:~w", [Val2]),
            Rs1 = Rs#role{vip=[Vip,Time,Val2]},
            DataL = get_vip_val(Rs1),
            case Rs#role.pid_sender of
                undefined -> ok;
                _ ->
                    sender:pack_send(Rs#role.pid_sender, 35010, DataL)
            end,
            set_vip_up(Rs1)
    end.

set_vip2(AtomId, Num, Custom, Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            Rs;
        [Vip,Time,Val] ->
            {AtomId,V,_N,_C} = lists:keyfind(AtomId, 1, Val),
            %% Num2 = N + Num,
            Val2 = lists:keyreplace(AtomId,1,Val,{AtomId,V,Num,Custom}),
            ?DEBUG("Val2:~w", [Val2]),
            Rs1 = Rs#role{vip=[Vip,Time,Val2]},
            DataL = get_vip_val(Rs1),
            sender:pack_send(Rs#role.pid_sender, 35010, DataL),
            set_vip_up(Rs1)
    end.

set_vip_up(Rs) ->
    [Vip, Time, Val] = Rs#role.vip,
    case set_vip_up3(Rs) of
        true ->
            NewVal = set_vip_up2(Val, Vip),
            Rs1 = Rs#role{vip = [Vip + 1,Time,NewVal]},
            send_reward(Rs1#role.id, NewVal),
            sender:pack_send(Rs#role.pid_sender, 35001, [1]),
            set_vip_up(Rs1);
        false -> Rs
    end.
set_vip_up2(Val, Vip) ->
    set_vip_up2(Val, Vip, []).
set_vip_up2([], _Vip, Rt) -> Rt;
set_vip_up2([{Atom,V,N,C}|Rest], Vip, Rt) ->
    Data = data_vip:get(Vip + 1),
    VN = case Atom of
        mcard -> V;
        _ ->
            util:get_val(Atom, Data)
    end,
    set_vip_up2(Rest, Vip, [{Atom,VN,N,C}|Rt]).
set_vip_up3(Rs) ->
    [Vip, _Time, Val] = Rs#role.vip,
    {diamond,_V1,N1,_C1} = lists:keyfind(diamond, 1, Val),
    {free,V2,N2,_C2} = lists:keyfind(free, 1, Val),
    Ids = data_vip:get(ids),
    case (Vip + 1) > length(Ids) of
        true -> false;
        false ->
            N23 = case N2 >= V2 of
                true -> V2;
                false -> N2
            end,
            Data = data_vip:get(Vip + 1),
            Di = util:get_val(diamond,Data),
            (N1 + N23) >= Di
    end.

%% vip 初始化
%% 如果修改了表数据,初始化就要重新验证下
%% 如果添加或删除了特权,初始化时要添加或删除数据(mcard月卡数据例外)
init_vip(Rs) ->
    Sql = list_to_binary([<<"SELECT `vip` FROM `vip` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Data]} ->
            Data2 = unzip(Data),
            Data3 = init_vip3(Data2),
            Rs1 = Rs#role{vip = Data3},
            Rs2 = role:save_delay(vip, Rs1),
            {ok, Rs2};
        {error, null} ->
            Num = init_vip22(Rs#role.id),
            Rs1 = init_vip2(Rs),
            Rs2 = set_vip(diamond, Num, 0, Rs1),
            {ok, Rs2};
        {error, Reason} ->
            {error, Reason}
    end.
init_vip2(Rs) ->
    Data = data_vip:get(1),
    Val = [{A,B,0,0} || {A,B} <- Data],
    Vip = [1, 0, Val],
    Rs#role{vip = Vip}.
init_vip22(Rid) ->
    Sql = list_to_binary([<<"SELECT sum(`diamond`) FROM `app_store` WHERE `role_id` = ">>
            ,integer_to_list(Rid)]),
    case db:get_one(Sql) of
        {ok, undefined} -> 0;
        {error, null} -> 0;
        {error, Reason} ->
            ?WARN("vip init_vip22 rid(~w) error:~w",[Rid,Reason]),
            0;
        {ok, Num} -> Num
    end.

init_vip3([]) -> [];
init_vip3([Vip, Time, Val]) ->
    Data = case data_vip:get(Vip) of
        undefined -> [];
        R -> R
    end,
    NewVal1 = init_vip4(Data, Val),
    NewVal2 = init_vip5(NewVal1, Data),
    [Vip, Time, NewVal2].
init_vip4([], Val) -> Val;
init_vip4([{Atom, Num}|T], Val) ->
    case lists:keyfind(Atom, 1, Val) of
        false ->
            init_vip4(T, [{Atom,Num,0,0}|Val]);
        _ ->
            init_vip4(T, Val)
    end.
init_vip5(Val,Data) ->
    init_vip5(Val,Data,[]).
init_vip5(Val,Data,_Rt) when Data == [] -> Val;
init_vip5([], _Data, Rt) -> Rt;
init_vip5([{Atom,Num,V,C}|T],Data,Rt) ->
    case lists:keyfind(Atom,1,Data) of
        false ->
            init_vip5(T, Data, Rt);
        {mcard, _} ->
            init_vip5(T, Data, [{Atom,Num,V,C}|Rt]);
        {Atom,N} ->
            init_vip5(T, Data, [{Atom,N,V,C}|Rt])
    end.

%% vip 存储
stores_vip(Rs) ->
    Vip = ?ESC_SINGLE_QUOTES(zip(Rs#role.vip)),
    Sql = list_to_binary([<<"UPDATE `vip` SET `vip` = '">>
            ,Vip, <<"' WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:execute(Sql) of
        {ok, 0} ->
            stores_vip2(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.
stores_vip2(Rs) ->
    Vip = ?ESC_SINGLE_QUOTES(zip(Rs#role.vip)),
    Sql = list_to_binary([<<"SELECT count(*) FROM `vip` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `vip` (`role_id`, `vip`) VALUES (">>
                    ,integer_to_list(Rs#role.id), <<", '">>
                    ,Vip, <<"')">>]),
            case db:execute(Sql2) of
                {ok, Num} -> {ok, Num};
                {error, Reason} -> {error, Reason}
            end;
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

get_vip_val(Rs) ->
    case Rs#role.vip of
        [] ->
            ?WARN("vip data is empty :", []),
            [0,0,0,0,0,0,0,0,0];
        [Vip, _Time, Val] ->
            Dia   = get_vip_val(diamond, Val),
            Free  = get_vip_val(free, Val),
            Chat  = get_vip_val(chat, Val),
            Prize = get_vip_val(prize, Val),
            Fast  = get_vip_val(fast, Val),
            Buys1 = get_vip_val(buys1, Val),
            Buys2 = get_vip_val(buys2, Val),
            Buys3 = get_vip_val(buys3, Val),
            [Vip - 1,Dia,Free,Chat,Prize,Fast,Buys1,Buys2,Buys3]
    end.
get_vip_val(prize, Val) ->
    case lists:keyfind(prize, 1, Val) of
        false -> 0;
        {_,_,N,C} ->
            case C < util:unixtime(today) of
                true -> 0;
                false -> N
            end
    end;
get_vip_val(AtomId, Val) ->
    case lists:keyfind(AtomId, 1, Val) of
        false -> 0;
        {_,_,N,_} -> N
    end.

send_reward(Rid, Val) ->
    Num = case lists:keyfind(reward, 1, Val) of
        false -> 0;
        {reward,N,_,_} -> N
    end,
    case data_vip_reward:get(Num) of
        undefined -> ok;
        Data ->
            Prize = util:get_val(prize, Data, []),
            Title = data_text:get(2),
            Body = data_text:get(16),
            mod_mail:new_mail(Rid, 0, 56, Title, Body, Prize),
            ok
    end.

%% month card
%% {mcard,V,N,S}
%% V=月卡有效期
%% N=月卡礼包id
%% S=今天领奖时间
set_mcard(Rs, DiamondData) ->
    case Rs#role.vip of
        [] -> Rs;
        [Vip,Time,Val] ->
            case util:get_val(mcard, DiamondData) of
                undefined -> Rs;
                Num ->
                    Data = data_mcard:get(Num),
                    Day = util:get_val(day, Data, 0),
                    %% First = util:get_val(first, Data, 0),
                    Time1 = util:unixtime(),
                    %% Time2 = util:unixtime() + Day * 86400,
                    Time2 = case lists:keyfind(mcard,1,Val) of
                        false -> Time1 + Day * 86400;
                        {mcard,MV,_MN,_MS} ->
                            case MV =< Time1 of
                                true -> Time1 + Day * 86400;
                                false -> MV + Day * 86400
                            end
                    end,
                    Card = {mcard,Time2,Num,Time1},
                    %% Rs3 = case is_mcard(Val) of
                    %%     true ->
                    %%         Rs1 = lib_role:add_attr(diamond, First, Rs),
                    %%         Rs2 = lib_role:add_attr_ok(diamond, 49, Rs, Rs1),
                    %%         case is_pid(Rs2#role.pid_sender) of
                    %%             true -> lib_role:notice(Rs2);
                    %%             false -> ok
                    %%         end,
                    %%         Rs2;
                    %%     false -> Rs
                    %% end,
                    Val2 = lists:keystore(mcard,1,Val,Card),
                    Rs4 = mod_attain:attain_state(70, 1, Rs),
                    Today = util:get_val(today,Data,0),
                    Title = data_text:get(2),
                    Body = data_text:get(17),
                    Prize = [{2, Today}],
                    mod_mail:new_mail(Rs#role.id,0,49,Title,Body,Prize),
                    Rs4#role{vip=[Vip,Time,Val2],save = [vip]}
            end
    end.

%% is_mcard(Val) ->
%%     case lists:keyfind(mcard,1,Val) of
%%         false -> true;
%%         {mcard,Time2,_Num,_Time1} ->
%%             Time2 < util:unixtime()
%%     end.

send_mcard(Rs) ->
    case Rs#role.vip of
        [] -> Rs;
        [Vip,Time,Val] ->
            {V2,N2,S2} = case lists:keyfind(mcard,1,Val) of
                false -> {0,0,0};
                {mcard,V,N,S} -> {V,N,S}
            end,
            Time1 = util:unixtime(today),
            Time2 = util:unixtime(),
            %% ?INFO("V2:~w,N2:~w,S2:~w,Time2:~w",[V2,N2,S2,Time2]),
            case V2 >= Time1 andalso S2 =< Time1 of
                true ->
                    Rs1 = mod_attain:attain_state(70, 1, Rs),
                    Data = data_mcard:get(N2),
                    Today = util:get_val(today,Data,0),
                    Card = {mcard,V2,N2,Time2},
                    Val2 = lists:keystore(mcard,1,Val,Card),
                    %% Rs1 = lib_role:add_attr(diamond, Today, Rs),
                    %% Rs2 = lib_role:add_attr_ok(diamond, 49, Rs, Rs1),
                    %% Rs2#role{vip = [Vip,Time,Val2]};
                    Title = data_text:get(2),
                    Body = data_text:get(17),
                    Prize = [{2, Today}],
                    mod_mail:new_mail(Rs#role.id,0,49,Title,Body,Prize),
                    Rs1#role{vip = [Vip,Time,Val2], save = [vip]};
                false -> Rs
            end
    end.

-define(VIP_ZIP_VERSION, 1).

zip([]) -> <<>>;
zip(VipInfo) ->
    [Vip, Time, Val] = VipInfo,
    Val1 = zip1(Val, []),
    Rt = list_to_binary([<<Vip:8, Time:32>>] ++ Val1),
    <<?VIP_ZIP_VERSION:8, Rt/binary>>.
zip1([], Rt) -> Rt;
zip1([H|T], Rt) ->
    {Id, V, N, C} = H,
    Id2 = atom_to_binary(Id, utf8),
    Id_ = byte_size(Id2),
    Rt1 = <<Id_:16, Id2:Id_/binary, V:32, N:32, C:32>>,
    zip1(T, [Rt1|Rt]).

unzip(<<>>) -> [];
unzip(undefined) -> [];
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            <<X1:8, X2:32, X3/binary>> = Bin1,
            Bin2 = unzip1(X3, []),
            [X1, X2, Bin2];
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
unzip1(<<>>, Rt) -> Rt;
unzip1(<<X1_:16, X1:X1_/binary, X2:32, X3:32, X4:32, RestBin/binary>>, Rt) ->
    X11 = binary_to_atom(X1, utf8),
    Rt1 = {X11, X2, X3, X4},
    unzip1(RestBin, [Rt1|Rt]).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
