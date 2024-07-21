%%----------------------------------------------------
%% $Id: pt_combat.erl 13109 2014-06-03 07:32:41Z piaohua $
%% @doc 协议22 - 战斗
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_combat).
-export([handle/3]).

-include("common.hrl").
-include("fb.hrl").

%% 主线战斗
%% :%s/tollgate_id/tollgate_newid/g
handle(22002, [1, GateId, _], Rs) ->
    ?DEBUG("[Main line] GateId:~w, tollgate_newid:~w", [GateId, Rs#role.tollgate_newid]),
    Rs1 = lib_role:time2power(Rs),
    GateId1 = case GateId > 0 of
                  true -> GateId;
                  false -> Rs#role.tollgate_newid
              end,
    {Data, Rs2} = mod_combat:combat(1, Rs1, GateId1),
    {ok, Data, Rs2};

%% 副本战斗
handle(22002, [2, GateId, _], Rs) ->
    ?DEBUG("[New Fb] GateId:~w", [GateId]),
    Rs1 = lib_role:time2power(Rs),
    case data_tollgate:get({2,GateId}) of
        undefined ->
            ?WARN("new fb gate id wrong : ~w", [GateId]),
            {ok, [0, 0, 0, 0, [], [], [], [], []]};
        _ ->
            {Data, Rs2} = mod_combat:combat(2, Rs1, GateId),
            {ok, Data, Rs2}
    end;

%% 副本战斗
%% handle(22002, [2, GateId, _], Rs) ->
%%     ?DEBUG("[Fb] GateId:~w, fb_gate:~w", [GateId, Rs#role.fb_gate]),
%%     case Rs#role.fb_gate of
%%         {_, GateId} ->
%%             {Data, Rs2} = mod_combat:combat(2, Rs, GateId),
%%             Rs3 = role:save_delay(fbinfo, Rs2),
%%             {ok, Data, Rs3};
%%         E ->
%%             ?WARN("fb gate id wrong: ~w", [E]),
%%             {ok, [0, 0, 0, 0, [], [], [], [], []]}
%%     end;

%% 竞技场
handle(22002, [3, ArenaId, _], Rs) ->
    ?DEBUG("ArenaId:~w", [ArenaId]),
    {Data, Rs2} = mod_combat:arena(Rs, ArenaId),
    {ok, Data, Rs2};

%% 节日活动战斗
%% handle(22002, [4, GateId, _], Rs) ->
%%     GateId1 = case GateId > 0 of
%%                   true -> GateId;
%%                   false -> Rs#role.tollgate_newid
%%               end,
%%     {Data, Rs2} = mod_combat:combat(4, Rs, GateId1),
%%     {ok, Data, Rs2};

%% 噩梦副本战斗
handle(22002, [5, GateId, _], Rs) ->
    ?DEBUG("[nightmare Fb] GateId:~w ", [GateId]),
    Rs1 = lib_role:time2power(Rs),
    case data_tollgate:get({5, GateId}) of
        undefined ->
            ?WARN("nightmare fb gate id wrong: ~w", [GateId]),
            {ok, [0, 0, 0, 0, [], [], [], [], []]};
        _Data ->
            {Data2, Rs2} = mod_combat:combat(5, Rs1, GateId),
            Rs3 = role:save_delay(fbinfo, Rs2),
            {ok, Data2, Rs3}
    end;

%% invariable副本战斗
%% handle(22002, [6, GateId, _], Rs) ->
%%     ?DEBUG("[invariable Fb] GateId:~w ", [GateId]),
%%     Rs1 = lib_role:time2power(Rs),
%%     Data = case data_tollgate:get({6, GateId}) of
%%         undefined -> [];
%%         D -> D
%%     end,
%%     case lists:keymember(consume,1,Data) of
%%         true ->
%%             {Data2, Rs2} = mod_combat:combat(6, Rs1, GateId),
%%             Rs3 = role:save_delay(fbinfo, Rs2),
%%             {ok, Data2, Rs3};
%%         false ->
%%             ?WARN("invariable fb gate id wrong: ~w", [GateId]),
%%             {ok, [0, 0, 0, 0, [], [], [], [], []]}
%%     end;

%% 副本
handle(22010, [FbId, Type], Rs) ->
    {Rs1, Num, RestSec} = fb_refresh(Rs, Type),
    #role{tollgate_newid = Tollgate, fb_buys_time = BuyTime} = Rs,
    {A,B,C} = case BuyTime < util:unixtime(today) of
        true -> {0,0,0};
        false -> Rs#role.fb_buys
    end,
    OpenLevel = case data_fb:get(FbId) of
        undefined -> 0;
        {G1, G2, G3} ->
            case Type of
                1 -> G1;
                2 -> G2;
                3 -> G3;
                _ -> 0
            end
    end,
    GateId = case Num > 0 of
        true ->
            %% 副本开放限制
            case Tollgate >= OpenLevel andalso OpenLevel =/= 0 of
                true -> get_fb_gate_id(FbId, Type);
                false -> 0
            end;
        false -> 0
    end,
    Fb_buys = case Type of
        1 -> A;
        2 -> B;
        3 -> C;
        E -> ?ERR("Error Gate Type: ~w", [E]),0
    end,
    {ok, [GateId, Num, RestSec, Fb_buys], Rs1#role{fb_gate = {Type, GateId}}};

%% 购买副本战斗次数
%% 消息代码：
%% Code:
%% 0 = 成功
%% 1 = 钻石不足
%% 2 = 无需购买(已有战斗)
%% >=127 = 程序异常
handle(22014, [FbId, Type], Rs) ->
    {Rs1, Num, _ReshSec} = fb_refresh(Rs, Type),
    %% Diamond = lib_role:time2diamond(RestSec),
    #role{fb_buys_time = BuyTime} = Rs,
    {Fb_buy1, Fb_buy2, Fb_buy3} = case BuyTime < util:unixtime(today) of
        true -> {0,0,0};
        false -> Rs#role.fb_buys
    end,
    case data_fb_monsters:get({FbId, Type}) of
        undefined -> {ok, [127, 0, 0, 0]};
        _GateId ->
            case Num > 0 of
                true ->
                    {ok, [2, 0, 0, 0]};
                false ->
                    case mod_vip:vip_privilege_check(buys3, Rs1) of
                        true ->
                            Diamond = case Type of
                                1 -> util:ceil(data_fun:fb_buy1(Fb_buy1));
                                2 -> util:ceil(data_fun:fb_buy2(Fb_buy2));
                                3 -> util:ceil(data_fun:fb_buy3(Fb_buy3));
                                E -> ?ERR("Error Gate Type: ~w", [E]),0
                            end,
                            case lib_role:spend(diamond, Diamond, Rs1) of
                                {ok, Rs2} ->
                                    {Rs6, Fb_buys, Fbs} = case Type of
                                        1 ->
                                            %% 成就推送(日常成就)
                                            %% Rs3 = mod_attain:attain_state(56, 1, Rs2),
                                            Rs4 = Rs2#role{fb_combat1 = util:floor(data_config:get(fb_max1)/2)},
                                            Rs5 = Rs4#role{fb_buys = {Fb_buy1 + 1, Fb_buy2, Fb_buy3}},
                                            {Rs5, Fb_buy1 + 1, Rs5#role.fb_combat1};
                                        2 ->
                                            %% Rs3 = mod_attain:attain_state(55, 1, Rs2),
                                            Rs4 = Rs2#role{fb_combat2 = util:floor(data_config:get(fb_max2)/2)},
                                            Rs5 = Rs4#role{fb_buys = {Fb_buy1, Fb_buy2 + 1, Fb_buy3}},
                                            {Rs5, Fb_buy2 + 1, Rs5#role.fb_combat2};
                                        3 ->
                                            %% Rs3 = mod_attain:attain_state(54, 1, Rs2),
                                            Rs4 = Rs2#role{fb_combat3 = util:floor(data_config:get(fb_max3)/2)},
                                            Rs5 = Rs4#role{fb_buys = {Fb_buy1, Fb_buy2, Fb_buy3 + 1}},
                                            {Rs5, Fb_buy3 + 1, Rs5#role.fb_combat3};
                                        Else -> ?ERR("Error Gate Type: ~w", [Else]), {Rs2, 0, 0}
                                    end,
                                    GateId2 = get_fb_gate_id(FbId, Type),
                                    lib_role:notice(Rs6),
                                    Rs7 = lib_role:spend_ok(diamond, 25, Rs, Rs6),
                                    %% Rs0 = mod_vip:set_vip(buys3, 1, util:unixtime(),Rs7),
                                    Rs0 = mod_vip:set_vip2(buys3, Fb_buys, util:unixtime(),Rs7),
                                    {ok, [0, GateId2, Fb_buys, Fbs], Rs0#role{fb_gate = {Type, GateId2}, fb_buys_time = util:unixtime(), save = [vip]}};
                                {error, _} ->
                                    {ok, [1, 0, 0, 0]}
                            end;
                        false -> {ok, [4, 0, 0, 0]}
                    end
            end
    end;

handle(22020, [], Rs) ->
    #role{fb_nightware = Nightmare} = Rs,
    {ok, [Nightmare]};

handle(22021, [GateId], Rs) ->
    #role{power = Power
        ,items = Items
        ,fb_nightware = Nightmare} = Rs,
    case data_tollgate:get({5, GateId}) of
        undefined -> {ok, [127]};
        Data ->
            case lists:keyfind(GateId,1,Nightmare) of
                false -> {ok, [1]};
                {GateId,7} ->
                    %% Star band 1 + Star band 2 + Star band 4,
                    DelIds = util:get_val(consume,Data,[]),
                    case mod_item:del_items(by_tid, DelIds, Items) of
                        {ok, _,_} ->
                            Power1 = util:get_val(power, Data, 0),
                            Power2 = Power - Power1,
                            case Power2 >= 0 of
                                true -> {ok, [0]};
                                false -> {ok, [2]}
                            end;
                        {error, _} -> {ok, [3]}
                    end;
                _ -> {ok, [1]}
            end
    end;

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.

%% === 私有函数 ===

get_fb_gate_id(FbId, Type) ->
    Data1 = data_fb_monsters:get({FbId, Type}),
    Data2 = data_fb_monsters:get({FbId, Type+1}),
    case Data1 =/= undefined andalso Data2 =/= undefined of
        true ->
            %% {GateId} = util:rand_element(Data1 ++ Data2),
            {GateId} = case Type == 1 of
                true -> util:rand_element(Data1 ++ Data2);
                false -> util:rand_element(Data2)
            end,
            GateId;
        false ->
            ?WARN("Error FbId:~w, Type:~w", [FbId, Type]),
            0
    end.


%% -> {Rs, RestSec}
fb_refresh(Rs, 1) ->
    #role{fb_combat1 = N, fb_time1 = T} = Rs,
    Max = data_config:get(fb_max1),
    Cd = data_config:get(fb_cd1),
    {N1, T1, RestSec} = fb_refresh1(N, T, Cd, Max),
    Rs0 = Rs#role{fb_combat1 = N1, fb_time1 = T1},
    {Rs0, N1, RestSec};
fb_refresh(Rs, 2) ->
    #role{fb_combat2 = N, fb_time2 = T} = Rs,
    Max = data_config:get(fb_max2),
    Cd = data_config:get(fb_cd2),
    {N1, T1, RestSec} = fb_refresh1(N, T, Cd, Max),
    Rs0 = Rs#role{fb_combat2 = N1, fb_time2 = T1},
    {Rs0, N1, RestSec};
fb_refresh(Rs, 3) ->
    #role{fb_combat3 = N, fb_time3 = T} = Rs,
    Max = data_config:get(fb_max3),
    Cd = data_config:get(fb_cd3),
    {N1, T1, RestSec} = fb_refresh1(N, T, Cd, Max),
    Rs0 = Rs#role{fb_combat3 = N1, fb_time3 = T1},
    {Rs0, N1, RestSec};
fb_refresh(Rs, Type) ->
    ?WARN("Error Type: ~w", [Type]),
    {Rs, 0, 9999}.

%% -> {Num, Time, RestSec}
fb_refresh1(0, 0, Cd, Max) ->
    {Max, util:unixtime(), Cd};
fb_refresh1(Num, LastTime, Cd, Max) ->
    case Num >= Max of
        true ->
            {Max, util:unixtime(), Cd};
        false ->
            Now = util:unixtime(),
            Sec = Now - LastTime,
            case Sec >= Cd of
                true ->
                    RestSec = Sec rem Cd,
                    AddNum = Sec div Cd,
                    Num1 = Num + AddNum,
                    LastTime1 = Now - RestSec,
                    fb_refresh1(Num1, LastTime1, Cd, Max);
                false ->
                    {Num, LastTime, Cd - Sec}
            end
    end.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
