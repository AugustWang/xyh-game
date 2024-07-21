%% ------------------------------------------------------------------
%%
%% $Id: mod_sign.erl 13256 2014-06-18 05:40:49Z rolong $
%%
%% @doc 登录连续签到
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_sign).
-export([
        login_sign/1
        ,login_sign2/1
        ,sign_stores/1
        ,sign_zip/1
        ,sign_unzip/1
        ,sign_init/1
        ,send_sign/1
    ]).

-include("common.hrl").

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_sign_test() ->
    Ids = data_sign:get(ids),
    ?assert(length(Ids) > 0 ),
    lists:foreach(fun(Id) ->
                Data = data_sign:get(Id),
                TidNum = util:get_val(tid_num,Data,[]),
                ?assert(TidNum =/= []),
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
                    end, TidNum),
                ?assert(util:get_val(coin, Data, 0) > 0 ),
                ?assert(util:get_val(diamond, Data, 0) > 0 )
        end, Ids),
    ok.
-endif.

%% 登录签到
send_sign(Rs) ->
    #role{loginsign = LoginSign, loginsign_time = SignTime, loginsign_type = Type} = Rs,
    %% ?DEBUG("LoginSign:~w, SignTime:~w, Type:~w", [LoginSign, SignTime, Type]),
    case LoginSign =:= [] orelse SignTime =:= 0 of
        true ->
            [Days1, Days2, PriceState] = [1, 1, [{1, 1},{2, 0},{3, 0},{4, 0},{5, 0},{6, 0},{7, 0}]],
            Rs1 = Rs#role{loginsign = [Days1, Days2, PriceState], loginsign_time = util:unixtime()},
            {[0, 1, Days1, Days2, PriceState], Rs1#role{save=[sign]}};
        false ->
            NewTime = util:unixtime(),
            %% AmSix = util:unixtime(today) + 21600,       %% 今天6点时间戳
            AmSix = util:unixtime(today),       %% 今天0点时间戳(修改成凌晨签到)
            %% 签到时间>6点,上次签到时间<6点
            case NewTime > AmSix andalso SignTime < AmSix of
                true ->
                    F1 = fun({_X, Y}) -> Y =:= 1 end,
                    F2 = fun({_X, Y}) -> Y =:= 2 end,
                    %% 全部领取开始下一轮,
                    #role{loginsign = [Days1, Days2, PriceState]} = Rs,
                    case Days1 =:= 7 andalso lists:any(F1, PriceState) of
                        true ->
                            #role{loginsign = [Days1, Days2, PriceState]} = Rs,
                            {[1, Type, Days1, Days2, PriceState], Rs#role{save=[sign]}};
                        false ->
                            case Days1 =:= 7 andalso lists:all(F2, PriceState) of
                                true ->
                                    [NewDays1, NewDays2, NewPriceState] = [1, 1, [{1, 1},{2, 0},{3, 0},{4, 0},{5, 0},{6, 0},{7, 0}]],
                                    Rs1 = Rs#role{loginsign = [NewDays1, NewDays2, NewPriceState], loginsign_time = NewTime, loginsign_type = 2},
                                    {[0, 2, NewDays1, NewDays2, NewPriceState], Rs1#role{save=[sign]}};
                                false ->
                                    Rs1 = login_sign2(Rs),
                                    #role{loginsign = [NewDays1, NewDays2, NewPriceState]} = Rs1,
                                    {[0, Type, NewDays1, NewDays2, NewPriceState], Rs1#role{save=[sign]}}
                            end
                    end;
                false ->
                    #role{loginsign = [Days1, Days2, PriceState]} = Rs,
                    {[1, Type, Days1, Days2, PriceState], Rs}
            end
    end.

%% @doc login sign
-spec login_sign(Rs) -> NewRs when
    Rs :: #role{},
    NewRs :: #role{}.

login_sign(Rs) ->
    #role{loginsign = LoginSign, loginsign_time = SignTime} = Rs,
    NewTime = util:unixtime(),
    %% AmSix = util:unixtime(noon) - 21600,       %% 今天6点时间戳
    AmSix = util:unixtime(today),       %% 今天0点时间戳(修改成凌晨签到)
    Mistiming = case SignTime > 0 of   % 上次签到时间差
        true -> AmSix - SignTime;
        false -> 0
    end,
    [Days1, Days2, PriceState] = LoginSign,
    %% 昨天是否登录,登录+1,没有重新开始
    {NewDays1, NewDays2} = case Mistiming < 86400 of
        true ->
            %% (是否漏签后连续签到,是就不累加Days2)
            case Days1 < Days2 of
                true -> {Days1 + 1, Days2};
                false -> {Days1 + 1, Days2 + 1}
            end;
        false -> {1, Days2}
    end,
    NewPriceState = case lists:keyfind(NewDays1, 1, PriceState) of
        {NewDays1, 2} -> PriceState;
        %% {NewDays1, _} when NewDays1 =< 7 ->
        {NewDays1, _} ->
            lists:keyreplace(NewDays1, 1, PriceState, {NewDays1, 1});
        false -> PriceState
    end,
    Rs#role{loginsign = [NewDays1, NewDays2, NewPriceState], loginsign_time = NewTime}.

login_sign2(Rs) ->
    #role{loginsign = LoginSign, loginsign_time = SignTime} = Rs,
    NewTime = util:unixtime(),
    AmSix = util:unixtime(today),       %% 今天0点时间戳(修改成凌晨签到)
    [Days1, Days2, PriceState] = LoginSign,
    Days3 = case Days1 < Days2 of
        true -> Days2;
        false -> Days1
    end,
    {NewDays1, NewDays2} =  case SignTime < AmSix of
        true -> {Days3 + 1, Days3 + 1};
        false -> {Days3, Days3}
    end,
    NewPriceState = case lists:keyfind(NewDays1, 1, PriceState) of
        {NewDays1, 2} -> PriceState;
        {NewDays1, _} ->
            lists:keyreplace(NewDays1, 1, PriceState, {NewDays1, 1});
        false -> PriceState
    end,
    Rs#role{loginsign = [NewDays1, NewDays2, NewPriceState], loginsign_time = NewTime}.

%% sign_init
%% @doc 登录时初始化
-spec sign_init(Rs) -> {ok, NewRs} | {error, Reason} when
    Rs :: #role{},
    NewRs :: #role{},
    Reason :: term() | sign_init_error .

sign_init(Rs) ->
    Id = Rs#role.id,
    Sql = list_to_binary([<<"SELECT `sign` FROM `sign` WHERE `role_id` = ">>
            , integer_to_list(Id), <<";">>]),
    case db:get_one(Sql) of
        {error, null} ->
            {ok, Rs};
        {error, Reason} ->
            {error, Reason};
        {ok, Bin} ->
            case sign_unzip(Bin) of
                [] ->
                    {error, sign_init_error};
                Sign ->
                    {ok, Rs#role{loginsign = Sign}}
            end
    end.

%% @doc sign_stores, 领奖时和退出时保存
-spec sign_stores(Rs) -> {ok, 0} | {error, Reason} | {ok, _Num} when
    Rs :: #role{},
    _Num :: integer(),
    Reason :: term().

sign_stores(Rs) ->
    #role{
        id = Id
        ,loginsign = Sign
    } = Rs,
    Val = ?ESC_SINGLE_QUOTES(sign_zip(Sign)),
    Sql = list_to_binary([<<"UPDATE `sign` SET `sign` = '">>
            , Val, <<"' WHERE `role_id` = ">>, integer_to_list(Id), <<";">>]),
    case db:execute(Sql) of
        {ok, 0} ->
            sign_stores2(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

sign_stores2(Rs) ->
    #role{
        id = Id
        ,loginsign = Sign
    } = Rs,
    Val = ?ESC_SINGLE_QUOTES(sign_zip(Sign)),
    Sql = list_to_binary([<<"SELECT count(*) FROM `sign` WHERE `role_id` = ">>
            ,integer_to_list(Id), <<";">>]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `sign` (`role_id`, `sign`) VALUES (">>
                    , integer_to_list(Id),<<",'">>, Val,<<"');">>]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

%% sign_zip / sign_unzip
%% 打包成binary
-define(SIGN_ZIP_VERSION, 1).
sign_zip([X1,X2,[{D1,S1},{D2,S2},{D3,S3},{D4,S4},{D5,S5},{D6,S6},{D7,S7}]]) ->
    <<?SIGN_ZIP_VERSION:8, X1:8,X2:8,D1:8,S1:8,D2:8,S2:8,D3:8,S3:8,D4:8,S4:8,D5:8,S5:8,D6:8,S6:8,D7:8,S7:8>>.

sign_unzip(<<1:8,X1:8,X2:8,D1:8,S1:8,D2:8,S2:8,D3:8,S3:8,D4:8,S4:8,D5:8,S5:8,D6:8,S6:8,D7:8,S7:8>>) ->
    [X1,X2,[{D1,S1},{D2,S2},{D3,S3},{D4,S4},{D5,S5},{D6,S6},{D7,S7}]];

sign_unzip(Else) ->
    ?WARN("Error sign Binary Data: ~w", [Else]),
    [].

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
