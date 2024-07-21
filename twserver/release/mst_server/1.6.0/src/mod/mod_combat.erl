%%----------------------------------------------------
%% $Id: mod_combat.erl 13194 2014-06-05 01:08:13Z piaohua $
%%
%% @doc 战斗模块
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

%% -define(TEST, true).
-module(mod_combat).
-export([
        combat/3
        ,arena/2
        ,init_monster/1
        %% ,fix_pos/1
        ,db_init_fb/1
        ,db_stores_fb/1
        ,fix_fb_combat/2
        ,zip/1
        ,unzip/1
    ]
).

-include("common.hrl").
-include("hero.hrl").
-include("fb.hrl").

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).

%% get({1,3}) -> [{monsters, [{3,1},{2,2},{4,6}]}, {exp, 109}, {produce, [{2,2,102}]}, {gold, 180}, {power, 6}];
data_test() ->
    Ids = data_tollgate:get(ids),
    data_test1(Ids).

data_test1([H | T]) ->
    data_test2(H),
    data_test1(T);
data_test1([]) ->
    ok.

data_test2(Id) ->
    Data = data_tollgate:get(Id),
    Monsters = util:get_val(monsters, Data),
    ?assert([] /= Monsters),
    ?assertMatch([], util:find_repeat_element(Monsters)),
    %% case [] == util:find_repeat_element(Monsters) of
    %%     true -> ok;
    %%     false ->
    %%         ?INFO("Monsters:~w", [Monsters]),
    %%         ok
    %% end,
    Produce = util:get_val(produce, Data),
    ?assertMatch([], util:find_repeat_element(Produce)),
    %% case [] == util:find_repeat_element(Produce) of
    %%     true -> ok;
    %%     false ->
    %%         ?INFO("Produce:~w", [Produce]),
    %%         ok
    %% end,
    ?assertMatch(ok, test_produce(Produce)),
    Gold = util:get_val(gold, Data, 0),
    Power = util:get_val(power, Data, 0),
    Exp = util:get_val(exp, Data, 0),
    Combat = util:get_val(combat, Data, 0),
    ?assert(Gold >= 0),
    ?assert(Power >= 0),
    ?assert(Exp >= 0),
    ?assert(Combat >= 0),
    Nightmare = util:get_val(nightmare, Data, 0),
    ?assertMatch(ok, case Id of
            {1,_} -> test_nigthmare(Nightmare);
            _ -> ok
        end),
    ok.

test_produce([{1, X2, X3} | T]) ->
    ?assert(X2 > 0),
    D = data_produce:get(X3),
    ?assert(is_list(D)),
    ?assert(length(D) >= X2),
    ?assertMatch(ok, test_produce_val(D)),
    test_produce(T);
test_produce([{2, X2, X3} | T]) ->
    ?assert(X2 > 0),
    D = data_produce:get(X3),
    ?assert(is_list(D)),
    ?assert(length(D) >= 0),
    test_produce(T);
test_produce([H | _]) ->
    H;
test_produce([]) ->
    ok.

test_produce_val([]) -> ok;
test_produce_val([{Id,{Num1,Num2}}|Rest]) ->
    ?assert(Num1 < Num2 andalso Num2 =/= 0),
    case Id == 0 of
        true ->
            test_produce_val(Rest);
        false ->
            ?assertMatch(ok,case Id < ?MIN_EQU_ID of
                    true ->
                        ?assert(data_prop:get(Id) =/= undefined),
                        ok;
                        %% case data_prop:get(Id) =/= undefined of
                        %%     true -> ok;
                        %%     false ->
                        %%         ?INFO("===Id:~w", [Id]),
                        %%         ok
                        %% end;
                    false ->
                        ?assert(data_equ:get(Id) =/= undefined),
                        ok
                end),
            test_produce_val(Rest)
    end.

test_nigthmare(Nightmare) when Nightmare =/= 0 ->
    %% Ids = data_tollgate:get(ids),
    Data = data_tollgate:get({5, Nightmare}),
    ?assert(case util:get_val(consume,Data) of
            undefined -> false;
            L when is_list(L) -> true;
            _ -> false
        end),
    %% case util:get_val(consume,Data,[]) =/= [] of
    %%     true ->
    %%         ?INFO("Data:~w", [Data]),
    %%         ok;
    %%     false ->
    %%         ok
    %% end,
    ?assert(Data =/= undefined),
    ok;
test_nigthmare(_) ->
    ok.

data_mail_prize_test() ->
    Ids = data_mail_prize:get(ids),
    ?assert(Ids =/= []),
    lists:foreach(fun(Id) ->
                ?assert(Id > 0 andalso Id < 451),
                Data = data_mail_prize:get(Id),
                Prize = util:get_val(prize, Data, []),
                ?assert(Prize =/= []),
                lists:foreach(fun({Id2,_}) ->
                            ?assertMatch(ok,case Id2 < ?MIN_EQU_ID of
                                    true ->
                                        ?assert(data_prop:get(Id2) =/= undefined),
                                        ok;
                                    false ->
                                        ?assert(data_equ:get(Id2) =/= undefined),
                                        ok
                                end) end, Prize)
        end, Ids),
    ok.

data_reg_prize_test() ->
    Ids = data_reg_prize:get(ids),
    ?assert(Ids =/= []),
    [A|_] = Ids,
    ?assert(A == 1),
    Data = data_reg_prize:get(A),
    Prize = util:get_val(prize, Data, []),
    ?assert(Prize =/= []),
    lists:foreach(fun({Id2,_}) ->
                ?assertMatch(ok,case Id2 < ?MIN_EQU_ID of
                        true ->
                            ?assert(data_prop:get(Id2) =/= undefined),
                            ok;
                        false ->
                            ?assert(data_equ:get(Id2) =/= undefined),
                            ok
                    end) end, Prize),
    ok.

data_power_multiple_test() ->
    Ids = data_power_multiple:get(ids),
    ?assert(Ids =/= []),
    lists:foreach(fun(Id) ->
                ?assert(Id > 0 ),
                Data = data_power_multiple:get(Id),
                Multiple = util:get_val(multiple,Data,0),
                ?assert(Multiple > 0)
        end, Ids),
    ok.

-endif.

%%' 角斗场
arena(Rs, ArenaId) ->
    case Rs#role.produce_pass of
        {3, Type} ->
            #role{coliseum = Coliseum} = Rs,
            [Id1,Lev1,Exp1,Pic1,Num1,HighR,PrizeT,Report1] = Coliseum,
            case mod_colosseum:get_data(ArenaId) of
                {Robot, Rid, _Lev, _, Name, S} ->
                    Heroes2 = case Robot of
                        2 ->
                            ?DEBUG("New Robot PVP ************** **", []),
                            mod_colosseum:init_new_robot(Rid);
                        1 ->
                            ?DEBUG("Robot PVP ****************** **", []),
                            init_monster1(S, []);
                        0 ->
                            ?DEBUG("Role PVP ****************** **", []),
                            mod_colosseum:fix_coliseum_pos(S)
                    end,
                    Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Rs#role.items),
                    HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
                    mod_battle:print_hero(HeroesTmp),
                    {Over, InitHp, Data2, _, _, _, _} = mod_battle:battle(arena, Heroes1, Heroes2),
                    {IsWin, Report} = case Over =:= 1 of
                        true ->
                            case Robot of
                                0 ->
                                    %% 自己胜，对方败，给对方发送反击战报
                                    Time = util:unixtime(),
                                    myevent:send_event(Rid, {new_lost_report, Id1, Rs#role.name, Time});
                                _ -> ok
                            end,
                            Combat = mod_hero:calc_power(Heroes1),
                            RankInfo = {Id1,Rs#role.id,Rs#role.name,Pic1,Combat,HighR},
                            gen_server:cast(coliseum, {change_rank_pos,self(),ArenaId,RankInfo}),
                            %% gen_server:cast(coliseum, {change_rank_power,Id1,Combat}),
                            {1, undefined};
                        false ->
                            {0, {ArenaId, Name}}
                    end,
                    Produce = {3, Report},
                    Rs1 = Rs#role{produce_pass = Produce},
                    mod_colosseum:set_data(Rs, Lev1, Exp1, Heroes1),
                    %% 竞技场成就推送
                    Rs2 = mod_attain:attain_state(36, 1, Rs1),
                    %% Rs3 = case IsWin of
                    %%     1 ->
                    %%         mod_attain:attain_state(37, 1, Rs2);
                    %%     0 ->
                    %%         Rs2
                    %% end,
                    Report2 = case Type == 2 of
                        true ->
                            lists:keydelete(ArenaId, 1, Report1);
                        false -> Report1
                    end,
                    NewWars = case Type == 2 of
                        true -> Num1;
                        false -> Num1 - 1
                    end,
                    Rs4 = Rs2#role{coliseum = [Id1,Lev1,Exp1,Pic1,NewWars,HighR,PrizeT,Report2]},
                    {Rs5, [Data3, Data4]} = case IsWin == 1 of
                        true ->
                            mod_item:drop_produce_arena(Rs4, Lev1);
                        false ->
                            {Rs4, [[], []]}
                    end,
                    Rs6 = role:save_delay(coliseum, Rs5),
                    Rs7 = case IsWin of
                        1 -> mod_task:set_task(16,{1,1},Rs6);
                        _ -> Rs6
                    end,
                    Rs8 = mod_task:set_task(15,{1,1},Rs7),
                    ?LOG({combat,Rs#role.id,0}),
                    {[Rs8#role.power, 0, IsWin, 0, InitHp, Data2, [], Data3, Data4], Rs8};
                {error, Reason} ->
                    ?WARN("ARENA COMBAT ERROR: ~w", [Reason]),
                    {[0, 0, 0, 0, [], [], [], [], []], Rs}
            end;
        E ->
            ?ERR("ERROR:~w", [E]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs}
    end.
%%.

%%' 主线战斗
combat(1, Rs, ReqPassId) ->
    #role{items = Items
        %% ,tollgate_id = PassId
        ,tollgate_newid = PassId
        ,power = Power
        ,fb_nightware = Nightmare} = Rs,
    ?DEBUG("Main CurGateId:~w, ReqGateId:~w, Power:~w", [PassId, ReqPassId, Power]),
    Data = data_tollgate:get({1, ReqPassId}),
    if
        Data == undefined ->
            ?WARN("Error ReqPassId: ~w", [{1, ReqPassId}]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs};
        ReqPassId > 3 andalso ReqPassId > PassId ->
            ?WARN("Error ReqPassId: ~w, PassId:~w", [ReqPassId, PassId]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs};
        true ->
            Power1 = Power - util:get_val(power, Data, 0),
            %% ?DEBUG("NewPower:~w,Power:~w",[Power1,Power]),
            case Power1 > 0 of
                true ->
                    Monsters = util:get_val(monsters, Data),
                    SumExp  = util:get_val(exp, Data, 0),
                    Heroes2 = init_monster1(Monsters, []),
                    Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Items),
                    ?DEBUG("Heroes2:~w, Heroes1:~w", [Heroes2, Heroes1]),
                    case mate_hero(Data,Heroes1) of
                        false ->
                            {[0, 0, 0, 0, [], [], [], [], []], Rs};
                        Heroes3 ->
                            %% monster combat roll
                            Combat = mod_hero:calc_power(Heroes1),
                            ?DEBUG("Heroes1 Combat:~w", [Combat]),
                            %% MonsterCombat = mod_hero:calc_power(Heroes2),
                            RemmCombat = util:get_val(combat,Data,1),
                            Heroes22 = case Combat < RemmCombat of
                                true ->
                                    Multiple = get_power_multiple(Combat),
                                    AddCoe = ((RemmCombat - Combat) / RemmCombat) * Multiple,
                                    init_monster2(Monsters, AddCoe, []);
                                false -> Heroes2
                            end,
                            HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
                            mod_battle:print_hero(HeroesTmp),
                            %% Heroes11 = fix_pos(Heroes1),
                            {Over, InitHp, Data2, _OverHP,MHEROES,EHEROES,Bout} = mod_battle:battle(main, Heroes1 ++ Heroes3, Heroes22),
                            {Power2, IsWin, Rs2, Data3, Data4, Data5} =
                            case Over =:= 1 of
                                true ->
                                    {NewHeroes, HeroesInfo} = add_heroes_exp(Heroes1, SumExp, Rs#role.heroes),
                                    NewGateId = case (ReqPassId + 1) > PassId of
                                        true ->
                                            #role{tollgate_prize = Id, id = Rid} = Rs,
                                            notice_tollgate_prize(Id, ReqPassId),
                                            %% lib_admin:android_server_active2(Rid,PassId),
                                            extra:set_use(tollgate,PassId,Rid),
                                            ReqPassId + 1;
                                        false -> PassId
                                    end,
                                    Rs01 = mod_task:upgrade_task(Heroes1,NewHeroes,Rs),
                                    Rs1 = Rs01#role{
                                        heroes = NewHeroes,
                                        produce_pass = {1, ReqPassId},
                                        %% tollgate_id = NewGateId,
                                        tollgate_newid = NewGateId,
                                        power = Power1
                                    },
                                    %% 关卡成就推送
                                    %% A = util:floor((PassId - 1) / 50),
                                    %% B = util:floor((NewGateId - 1) / 50),
                                    %% Rs3 = case A < B of
                                    %%     true ->
                                    %%         mod_attain:attain_state(8, 1, Rs1);
                                    %%     false ->
                                    %%         Rs1
                                    %% end,
                                    %% Rs4 = mod_attain:attain_state(35, 1, Rs1),
                                    %% 副本开户成就推送
                                    %% Rs5 = mod_attain:attain_state2(60, PassId, Rs4),
                                    %% 战斗胜利请求战斗掉落
                                    #role{produce_pass = ProducePass} = Rs1,
                                    {Rs6, [Data6, Data7]} = mod_item:drop_produce(Rs1, ProducePass),
                                    %% 关卡邮件奖励
                                    case NewGateId > PassId of
                                        true -> notice_mail_prize(Rs6, ReqPassId);
                                        false -> ok
                                    end,
                                    %% 每日必做任务
                                    Rs7 = case NewGateId > PassId of
                                        true ->
                                            mod_attain:attain_today9(Rs6);
                                        false -> Rs6
                                    end,
                                    %% 成就
                                    Rs77 = case (ReqPassId + 1) > PassId of
                                        true ->
                                            if
                                                ReqPassId == 263 ->
                                                    mod_attain:attain_state(79, 1, Rs7);
                                                ReqPassId == 264 ->
                                                    mod_attain:attain_state(80, 1, Rs7);
                                                ReqPassId == 246 ->
                                                    mod_attain:attain_state(74, 1, Rs7);
                                                true -> Rs7
                                            end;
                                        false ->
                                            case ReqPassId == 246 of
                                                true ->
                                                    mod_attain:attain_state(74, 1, Rs7);
                                                false -> Rs7
                                            end
                                    end,
                                    %% Rs777 = combat_attain(Data7,Rs77),
                                    {Power1, 1, Rs77, HeroesInfo, Data6, Data7};
                                false ->
                                    {Power, 0, Rs, [], [], []}
                            end,
                            %% 主线战斗成就推送
                            Rs0 = mod_attain:attain_state(34, 1, Rs2),
                            %% combat 主线战报
                            case IsWin == 1 of
                                true ->
                                    Name = lib_admin:get_name(Rs),
                                    Pic1 = lib_admin:get_picture(Rs),
                                    VideoData = [IsWin, InitHp, Data2, Data3],
                                    Heroes111 = get_hero_equ_tid(Heroes1, Rs#role.items),
                                    %% mod_video:set_report_list(ReqPassId, Name, Pic1, Combat, Heroes111, VideoData);
                                    gen_server:cast(video, {set_video,ReqPassId, Name, Pic1, Combat, Heroes111, VideoData});
                                false -> ok
                            end,
                            Rs00 = case Combat > Rs0#role.combat of
                                true -> Rs0#role{combat = Combat};
                                false -> Rs0
                            end,
                            %% nightmare fb
                            {Rs000,Star} = case IsWin == 1 andalso lists:keymember(nightmare,1,Data) of
                                true ->
                                    %% InitHpList = [X || [P,X,_] <- InitHp, P div 10 == 1],
                                    %% InitHpSum = lists:sum(InitHpList),
                                    InitHeroes1 = erlang:length(Heroes1 ++ Heroes3),
                                    OverHeroes = erlang:length(MHEROES),
                                    %% LittleBout = erlang:length(Data2) + 1,
                                    %% ?INFO("===LittleBout:~w", [LittleBout]),
                                    Star0 = case lists:keyfind(ReqPassId,1,Nightmare) of
                                        false -> 0;
                                        {ReqPassId, StarO} -> StarO
                                    end,
                                    %% Star1 = case OverHP >= InitHpSum of
                                    %%     true -> Star0 bor 1;
                                    %%     false -> 0
                                    %% end,
                                    Star1 = case IsWin == 1 of
                                        true -> Star0 bor 1;
                                        false -> 0
                                    end,
                                    Star2 = case OverHeroes == InitHeroes1 of
                                        true ->
                                            Star1 bor 2;
                                        false -> Star1
                                    end,
                                    Star3 = case Bout =< 5 of
                                        true -> Star2 bor 4;
                                        false -> Star2
                                    end,
                                    Fbn = lists:keystore(ReqPassId,1,Nightmare,{ReqPassId,Star3}),
                                    #role{save = SaveState} = Rs00,
                                    {Rs00#role{fb_nightware = Fbn,save = [fbinfo] ++ SaveState},Star3};
                                false -> {Rs00,0}
                            end,
                            %% task
                            Rs0001 = case IsWin of
                                1 ->
                                    mod_task:set_task(1,{ReqPassId,1},Rs000);
                                _ ->
                                    mod_task:set_task(1,{ReqPassId,0},Rs000)
                            end,
                            Rs0002 = mod_task:enemy_task(Heroes2,EHEROES,Rs0001),
                            ?LOG({combat,Rs#role.id,ReqPassId}),
                            {[Power2, PassId, IsWin, Star, InitHp, Data2, Data3, Data4, Data5], Rs0002}
                    end;
                false ->
                    ?WARN("Power: ~w -> ~w", [Power, Power1]),
                    {[0, 0, 0, 0, [], [], [], [], []], Rs}
            end
    end;
%%.

%%' 副本战斗
combat(2, Rs, ReqPassId) ->
    #role{items = Items, power = Power} = Rs,
    ?DEBUG("Fb GateId:~w", [ReqPassId]),
    Data = data_tollgate:get({2, ReqPassId}),
    if
        Data == undefined ->
            ?WARN("Error ReqPassId: ~w", [{2, ReqPassId}]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs};
        true ->
            Power1 = Power - util:get_val(power, Data, 0),
            case Power1 > 0 of
                true ->
                    Monsters = util:get_val(monsters, Data),
                    SumExp = util:get_val(exp, Data, 0),
                    Heroes2 = init_monster1(Monsters, []),
                    Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Items),
                    case mate_hero(Data,Heroes1) of
                        false ->
                            {[0, 0, 0, 0, [], [], [], [], []], Rs};
                        Heroes3 ->
                            HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
                            mod_battle:print_hero(HeroesTmp),
                            {Over, InitHp, Data2, _, _, EHEROES, _} = mod_battle:battle(fb, Heroes1 ++ Heroes3, Heroes2),
                            {IsWin, Rs3, Data33, Data5, Data6} =
                            case Over =:= 1 of
                                true ->
                                    {NewHeroes, HeroesInfo} = add_heroes_exp(Heroes1, SumExp, Rs#role.heroes),
                                    Rs1 = Rs#role{heroes = NewHeroes},
                                    %% Rs1 = mod_attain:combat_attain(ReqPassId, Rs),
                                    %% 请求战斗掉落
                                    %% #role{produce_pass = ProducePass} = Rs,
                                    {Rs2, [Data3, Data4]} = mod_item:drop_produce(Rs1, {2, ReqPassId}),
                                    %% {1, fix_fb_combat(Rs2, ReqPassId), Data3, Data4};
                                    Rs01 = mod_task:upgrade_task(Heroes1,NewHeroes,Rs2),
                                    {1, Rs01, HeroesInfo, Data3, Data4};
                                false -> {0, Rs, [], [], []}
                                    % false -> {1, fix_fb_combat(Rs, ReqPassId)}
                            end,
                            Combat = mod_hero:calc_power(Heroes1),
                            %% gen_server:cast(rank, {rank_set, Combat, Rs#role.id, Rs#role.name, 3}),
                            Rs4 = case Combat > Rs3#role.combat of
                                true -> Rs3#role{combat = Combat};
                                false -> Rs3
                            end,
                            Rs5 = mod_attain:attain_state(64, 1, Rs4),
                            Rs6 = case IsWin == 1 andalso ReqPassId == 1001 of
                                true ->
                                    mod_attain:attain_state(75,1,Rs5);
                                false -> Rs5
                            end,
                            Rs7 = case IsWin of
                                1 ->
                                    Rs6#role{power = Power1};
                                _ -> Rs6#role{power = Power -1}
                            end,
                            %% task
                            Rs8 = case IsWin of
                                1 ->
                                    mod_task:set_task(1,{ReqPassId,1},Rs7);
                                _ ->
                                    mod_task:set_task(1,{ReqPassId,0},Rs7)
                            end,
                            Rs9 = mod_task:enemy_task(Heroes2,EHEROES,Rs8),
                            ?LOG({combat,Rs#role.id,ReqPassId}),
                            {[Rs9#role.power, ReqPassId, IsWin, 0, InitHp, Data2, Data33, Data5, Data6], Rs9}
                    end;
                false ->
                    ?WARN("Power: ~w -> ~w", [Power, Power1]),
                    {[0, 0, 0, 0, [], [], [], [], []], Rs}
            end
    end;
%%.

%%' 活动战斗请求
%% combat(4, Rs, ReqPassId) ->
%%     #role{items = Items} = Rs,
%%     ?DEBUG("fest GateId:~w", [ReqPassId]),
%%     Data = data_tollgate:get({4, ReqPassId}),
%%     if
%%         Data == undefined ->
%%             ?WARN("Error ReqPassId: ~w", [{4, ReqPassId}]),
%%             {[0, 0, 0, 0, [], [], []], Rs};
%%         true ->
%%             Monsters = util:get_val(monsters, Data),
%%             Heroes2 = init_monster1(Monsters, []),
%%             Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Items),
%%             HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
%%             mod_battle:print_hero(HeroesTmp),
%%             {Over, InitHp, Data2, _, _, _, _} = mod_battle:battle(fest, Heroes1, Heroes2),
%%             {IsWin, Rs2} = case Over =:= 1 of
%%                 true -> {1, Rs};
%%                 false -> {0, Rs}
%%             end,
%%             %% 请求战斗掉落
%%             %% #role{produce_pass = ProducePass} = Rs2,
%%             %% {Rs0, [Data3, Data4]} = mod_item:drop_produce(Rs2, ProducePass),
%%             ?LOG({combat,Rs#role.id,ReqPassId}),
%%             {[Rs#role.power, ReqPassId, IsWin, 0, InitHp, Data2, []], Rs2}
%%     end;
%%.

%%' 噩梦副本战斗
combat(5, Rs, ReqPassId) ->
    #role{items = Items, power = Power} = Rs,
    ?DEBUG("nightmare Fb GateId:~w", [ReqPassId]),
    Data = data_tollgate:get({5, ReqPassId}),
    if
        Data == undefined ->
            ?WARN("Error nightmare ReqPassId: ~w", [{5, ReqPassId}]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs};
        true ->
            Power1 = Power - util:get_val(power, Data, 0),
            case Power1 > 0 of
                true ->
                    DelIds = util:get_val(consume, Data, []),
                    case mod_item:del_items(by_tid, DelIds, Items) of
                        {ok, Items1, Notice} ->
                            Rs1 = Rs#role{items = Items1},
                            Monsters = util:get_val(monsters, Data),
                            SumExp = util:get_val(exp,Data,0),
                            Heroes2 = init_monster1(Monsters, []),
                            Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Items),
                            case mate_hero(Data,Heroes1) of
                                false ->
                                    {[0, 0, 0, 0, [], [], [], [], []], Rs};
                                Heroes3 ->
                                    HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
                                    mod_battle:print_hero(HeroesTmp),
                                    {Over, InitHp, Data2, _, _, EHEROES, _} = mod_battle:battle(fb, Heroes1 ++ Heroes3, Heroes2),
                                    {IsWin, Rs3, Data33, Data5, Data6} =
                                    case Over =:= 1 of
                                        true ->
                                            {NewHeroes, HeroesInfo} = add_heroes_exp(Heroes1, SumExp, Rs#role.heroes),
                                            Rs11 = Rs1#role{heroes = NewHeroes},
                                            %% Rs1 = mod_attain:combat_attain(ReqPassId, Rs),
                                            %% 请求战斗掉落
                                            {Rs2, [Data3, Data4]} = mod_item:drop_produce(Rs11, {5, ReqPassId}),
                                            Rs01 = mod_task:upgrade_task(Heroes1,NewHeroes,Rs2),
                                            {1, Rs01, HeroesInfo, Data3, Data4};
                                        false -> {0, Rs1, [], [], []}
                                    end,
                                    Combat = mod_hero:calc_power(Heroes1),
                                    Rs4 = case Combat > Rs3#role.combat of
                                        true -> Rs3#role{combat = Combat};
                                        false -> Rs3
                                    end,
                                    %% 物品删除通知
                                    mod_item:send_notice(Rs4#role.pid_sender, Notice),
                                    %% 一切都OK后，从数据库中删除物品
                                    mod_item:del_items_from_db(Rs#role.id, Notice),
                                    %% #role{save = SaveState} = Rs4,
                                    %% Rs5 = Rs4#role{power = Power1},
                                    Rs5 = case IsWin of
                                        1 ->
                                            Rs4#role{power = Power1};
                                        _ -> Rs4#role{power = Power -1}
                                    end,
                                    %% task
                                    Rs6 = case IsWin of
                                        1 ->
                                            mod_task:set_task(1,{ReqPassId,1},Rs5);
                                        _ ->
                                            mod_task:set_task(1,{ReqPassId,0},Rs5)
                                    end,
                                    Rs7 = mod_task:enemy_task(Heroes2,EHEROES,Rs6),
                                    ?LOG({combat,Rs#role.id,ReqPassId}),
                                    {[Rs7#role.power, ReqPassId, IsWin, 0, InitHp, Data2, Data33, Data5, Data6], Rs7}
                            end;
                        {error, _} ->
                            ?WARN("del_items ReqPassId: ~w -> DelIds ~w", [ReqPassId, DelIds]),
                            {[0, 0, 0, 0, [], [], [], [], []], Rs}
                    end;
                false ->
                    ?WARN("Power: ~w -> ~w", [Power, Power1]),
                    {[0, 0, 0, 0, [], [], [], [], []], Rs}
            end
    end;
%%.

%%' XX副本战斗
combat(6, Rs, ReqPassId) ->
    #role{items = Items, power = Power} = Rs,
    ?DEBUG("invariable Fb GateId:~w", [ReqPassId]),
    Data = data_tollgate:get({6, ReqPassId}),
    if
        Data == undefined ->
            ?WARN("Error invariable ReqPassId: ~w", [{6, ReqPassId}]),
            {[0, 0, 0, 0, [], [], [], [], []], Rs};
        true ->
            Power1 = Power - util:get_val(power, Data, 0),
            case Power1 > 0 of
                true ->
                    DelIds = util:get_val(consume, Data, []),
                    case mod_item:del_items(by_tid, DelIds, Items) of
                        {ok, Items1, Notice} ->
                            Rs1 = Rs#role{items = Items1},
                            Monsters = util:get_val(monsters, Data),
                            SumExp = util:get_val(exp,Data,0),
                            Heroes2 = init_monster1(Monsters, []),
                            Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Items),
                            %% Heroes3 = mate_hero(Data,Heroes1),
                            case mate_hero(Data,Heroes1) of
                                false ->
                                    {[0, 0, 0, 0, [], [], [], [], []], Rs};
                                Heroes3 ->
                                    HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
                                    mod_battle:print_hero(HeroesTmp),
                                    {Over, InitHp, Data2, _, _, _, _} = mod_battle:battle(fb, Heroes1 ++ Heroes3, Heroes2),
                                    {IsWin, Rs3, Data33, Data5, Data6} =
                                    case Over =:= 1 of
                                        true ->
                                            {NewHeroes, HeroesInfo} = add_heroes_exp(Heroes1, SumExp, Rs#role.heroes),
                                            Rs11 = Rs1#role{heroes = NewHeroes},
                                            %% Rs1 = mod_attain:combat_attain(ReqPassId, Rs),
                                            %% 请求战斗掉落
                                            {Rs2, [Data3, Data4]} = mod_item:drop_produce(Rs11, {5, ReqPassId}),
                                            Rs01 = mod_task:upgrade_task(Heroes1,NewHeroes,Rs2),
                                            {1, Rs01, HeroesInfo, Data3, Data4};
                                        false -> {0, Rs1, [], [], []}
                                    end,
                                    Combat = mod_hero:calc_power(Heroes1),
                                    Rs4 = case Combat > Rs3#role.combat of
                                        true -> Rs3#role{combat = Combat};
                                        false -> Rs3
                                    end,
                                    %% 物品删除通知
                                    mod_item:send_notice(Rs4#role.pid_sender, Notice),
                                    %% 一切都OK后，从数据库中删除物品
                                    mod_item:del_items_from_db(Rs#role.id, Notice),
                                    %% #role{save = SaveState} = Rs4,
                                    %% Rs5 = Rs4#role{power = Power1},
                                    Rs5 = case IsWin of
                                        1 ->
                                            Rs4#role{power = Power1};
                                        _ -> Rs4#role{power = Power -1}
                                    end,
                                    ?LOG({combat,Rs#role.id,ReqPassId}),
                                    {[Rs5#role.power, ReqPassId, IsWin, 0, InitHp, Data2, Data33, Data5, Data6], Rs5}
                            end;
                        {error, _} ->
                            ?WARN("del_items ReqPassId: ~w -> DelIds ~w", [ReqPassId, DelIds]),
                            {[0, 0, 0, 0, [], [], [], [], []], Rs}
                    end;
                false ->
                    ?WARN("Power: ~w -> ~w", [Power, Power1]),
                    {[0, 0, 0, 0, [], [], [], [], []], Rs}
            end
    end.
%%.

fix_fb_combat(Rs, ReqPassId) ->
    Rs1 = case Rs#role.fb_gate of
        {1, _} -> Rs#role{ fb_combat1 = Rs#role.fb_combat1 - 1 };
        {2, _} -> Rs#role{ fb_combat2 = Rs#role.fb_combat2 - 1 };
        {3, _} -> Rs#role{ fb_combat3 = Rs#role.fb_combat3 - 1 };
        Else -> ?ERR("Error Gate: ~w", [Else]), Rs
    end,
    Rs1#role{
      fb_gate = undefined
      ,produce_pass = {2, ReqPassId}
     }.

init_monster(Data) ->
    init_monster1(Data, []).

init_monster1([], Result) -> Result;
init_monster1([{Tid, Pos} | Monsters], Result) ->
    Result1 = case data_monster:get(Tid) of
        undefined ->
            ?WARN("Error monster id: ~w", [Tid]),
            Result;
        Data ->
            Pos1     = 20 + Pos,
            Hp       = util:get_val(hp        , Data),
            Atk      = util:get_val(atk       , Data),
            Def      = util:get_val(def       , Data),
            Pun      = util:get_val(pun       , Data),
            Hit      = util:get_val(hit       , Data),
            Dod      = util:get_val(dod       , Data),
            Crit     = util:get_val(crit      , Data),
            CritNum  = util:get_val(crit_num  , Data),
            CritAnit = util:get_val(crit_anti , Data),
            Tou      = util:get_val(tou       , Data, 0),
            TouAnit  = util:get_val(tou_anit  , Data, 0),
            Hero = #hero{
                id         = 0
                ,pos       = Pos1
                ,tid       = Tid
                ,hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,tou_anit  = TouAnit
                ,skills    = lib_role:init_skills(Data)
            },
            [Hero | Result]
    end,
    init_monster1(Monsters, Result1).

%% monster combat roll
%% 怪物所增加的攻击=怪物表数据*((怪物推荐战力-玩家战斗力)/ 怪物推荐战力)*战斗力碾压表内系数
%% 怪物所增加的生命=怪物表数据*((怪物推荐战力-玩家战斗力)/ 怪物推荐战力)*战斗力碾压表内系数
init_monster2([], _, Result) -> Result;
init_monster2([{Tid, Pos} | Monsters], Ace, Result) ->
    Result1 = case data_monster:get(Tid) of
        undefined ->
            ?WARN("Error monster id: ~w", [Tid]),
            Result;
        Data ->
            Pos1     = 20 + Pos,
            Hp       = util:get_val(hp        , Data),
            Atk      = util:get_val(atk       , Data),
            Def      = util:get_val(def       , Data),
            Pun      = util:get_val(pun       , Data),
            Hit      = util:get_val(hit       , Data),
            Dod      = util:get_val(dod       , Data),
            Crit     = util:get_val(crit      , Data),
            CritNum  = util:get_val(crit_num  , Data),
            CritAnit = util:get_val(crit_anti , Data),
            Tou      = util:get_val(tou       , Data, 0),
            TouAnit  = util:get_val(tou_anit  , Data, 0),
            Hero = #hero{
                id         = 0
                ,pos       = Pos1
                ,tid       = Tid
                ,hp        = Hp + util:ceil(Hp * Ace)
                ,atk       = Atk + util:ceil(Atk * Ace)
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,tou_anit  = TouAnit
                ,skills    = lib_role:init_skills(Data)
            },
            [Hero | Result]
    end,
    init_monster2(Monsters, Ace, Result1).

init_monster3([], Result) -> Result;
init_monster3([{Tid, Pos} | Monsters], Result) ->
    Result1 = case data_monster:get(Tid) of
        undefined ->
            ?WARN("Error monster id: ~w", [Tid]),
            Result;
        Data ->
            Pos1     = 10 + Pos,
            Hp       = util:get_val(hp        , Data),
            Atk      = util:get_val(atk       , Data),
            Def      = util:get_val(def       , Data),
            Pun      = util:get_val(pun       , Data),
            Hit      = util:get_val(hit       , Data),
            Dod      = util:get_val(dod       , Data),
            Crit     = util:get_val(crit      , Data),
            CritNum  = util:get_val(crit_num  , Data),
            CritAnit = util:get_val(crit_anti , Data),
            Tou      = util:get_val(tou       , Data, 0),
            TouAnit  = util:get_val(tou_anit  , Data, 0),
            Hero = #hero{
                id         = 0
                ,pos       = Pos1
                ,tid       = Tid
                ,hp        = Hp
                ,atk       = Atk
                ,def       = Def
                ,pun       = Pun
                ,hit       = Hit
                ,dod       = Dod
                ,crit      = Crit
                ,crit_num  = CritNum
                ,crit_anti = CritAnit
                ,tou       = Tou
                ,tou_anit  = TouAnit
                ,skills    = lib_role:init_skills(Data)
            },
            [Hero | Result]
    end,
    init_monster3(Monsters, Result1).

get_power_multiple(Power) ->
    Ids = data_power_multiple:get(ids),
    get_power_multiple(Ids, Power).
get_power_multiple([], _) -> 1;
get_power_multiple([Id|Ids], Power) ->
    case Power < Id of
        true ->
            Data = data_power_multiple:get(Id),
            util:get_val(multiple,Data,1);
        false ->
            get_power_multiple(Ids, Power)
    end.

mate_hero(Data, Heroes1) ->
    case util:get_val(mate,Data) of
        undefined -> [];
        MateHero ->
            Heroes3 = init_monster3(MateHero, []),
            Heroes1_pos = [H1#hero.pos || H1 <- Heroes1, H1#hero.pos > 0],
            Heroes3_pos = [H3#hero.pos || H3 <- Heroes3, H3#hero.pos > 0],
            case util:find_repeat_element(Heroes3_pos ++ Heroes1_pos) of
                [] -> Heroes3;
                _ ->
                    ?WARN("mate pos repeat Heroes1_pos: ~w -> Heroes3_pos ~w", [Heroes1_pos, Heroes3_pos]),
                    false
            end
    end.

%%.

%%' fix_pos
%% fix_pos(Heroes) ->
%%     Poses = util:shuffle([11, 12, 13, 14, 15, 16, 17, 18, 19]),
%%     fix_pos1(Heroes, Poses, []).
%%
%% fix_pos1([H = #hero{pos = Pos} | Heroes], [PosH | PosT], Rt) ->
%%     Pos1 = if
%%         Pos >= 11, Pos =< 19 ->
%%             case lists:member(Pos, [PosH | PosT]) of
%%                 true -> ok;
%%                 false -> ?WARN("Repeat Pos: ~w", [Pos])
%%             end,
%%             Pos;
%%         true -> PosH
%%     end,
%%     PosL = lists:delete(Pos1, [PosH | PosT]),
%%     Rt1 = [H#hero{pos = Pos1} | Rt],
%%     fix_pos1(Heroes, PosL, Rt1);
%% fix_pos1([], _, Rt) ->
%%     Rt.
%%.

%%' add_heroes_exp
add_heroes_exp(_CombatHeroes, 0, Heroes) ->
    {Heroes, []};
add_heroes_exp(CombatHeroes, SumExp, Heroes) ->
    add_heroes_exp1(CombatHeroes, SumExp, Heroes, []).

add_heroes_exp1([], _Exp, Heroes, Rt) -> {Heroes, Rt};
add_heroes_exp1([#hero{id = Id} | T], Exp, Heroes, Rt) ->
    Hero = mod_hero:get_hero(Id, Heroes),
    Hero1 = mod_hero:add_hero_exp(Hero, Exp),
    #hero{pos = Pos, lev = Lev, exp = Exp1} = Hero1,
    Rt1 = [[Pos, Lev, Exp1] | Rt],
    Heroes1 = mod_hero:set_hero(Hero1, Heroes),
    add_heroes_exp1(T, Exp, Heroes1, Rt1).
%%.

%% 通知关卡礼包是否开启
notice_tollgate_prize(Id, TollgateId) ->
    Ids = data_tollgate_prize:get(ids),
    case lists:member({Id, TollgateId}, Ids) of
        true ->
            self() ! {pt, 2056, [Id]};
        false ->
            ok
    end.

%% 关卡邮件奖励
notice_mail_prize(Rs, ReqPassId) ->
    List = data_mail_prize:get(ids),
    case lists:member(ReqPassId, List) of
        true ->
            Data = data_mail_prize:get(ReqPassId),
            Prize = util:get_val(prize, Data, []),
            Title = data_text:get(2),
            Body = data_text:get(1),
            mod_mail:new_mail(Rs#role.id, 0, 57, Title, Body, Prize);
        false -> ok
    end.

%% attain
%% combat_attain([],Rs) -> Rs;
%% combat_attain([[_,Tid,_,_,_]|PropData],Rs) ->
%%     Data = data_prop:get(Tid),
%%     Sort = util:get_val(sort,Data,0),
%%     Qual = util:get_val(quality,Data,0),
%%     case Sort == 1 andalso Qual == 1 of
%%         true ->
%%             Rs1 = mod_attain:attain_state(77,1,Rs),
%%             combat_attain(PropData,Rs1);
%%         false ->
%%             combat_attain(PropData,Rs)
%%     end;
%% combat_attain(_,Rs) -> Rs.

%% 数据库存储
db_init_fb(Rs) ->
    Sql = list_to_binary([<<"SELECT `fb_info` FROM `fb_info` WHERE `role_id` = ">>, integer_to_list(Rs#role.id)]),
    case db:get_one(Sql) of
        {error, null} -> {ok, Rs};
        {error, Reason} -> {error, Reason};
        {ok, FbInfo} ->
            [F1, F2, F3, T1, T2, T3, Type, GateId, Fbn] = unzip(FbInfo),
            FbGate = case Type =:= 0 andalso GateId =:= 0 of
                true -> undefined;
                false -> {Type, GateId}
            end,
            Rs1 = Rs#role{
                fb_combat1 = F1
                ,fb_combat2 = F2
                ,fb_combat3 = F3
                ,fb_time1 = T1
                ,fb_time2 = T2
                ,fb_time3 = T3
                ,fb_gate = FbGate
                ,fb_nightware = Fbn
            },
            {ok, Rs1}
    end.

db_stores_fb(Rs) ->
    #role{
        id	=	Id
        ,fb_combat1 = FbC1
        ,fb_combat2 = FbC2
        ,fb_combat3 = FbC3
        ,fb_time1 = FbT1
        ,fb_time2 = FbT2
        ,fb_time3 = FbT3
        %% ,fb_gate = FbGate
        ,fb_nightware = Fbn
    } = Rs,
    {Type, GateId} = case Rs#role.fb_gate of
        undefined -> {0, 0};
        {A, B} -> {A, B}
    end,
    Val = ?ESC_SINGLE_QUOTES(zip([FbC1, FbC2, FbC3, FbT1, FbT2, FbT3, Type, GateId, Fbn])),
    Sql = list_to_binary([<<"UPDATE `fb_info` SET `fb_info` = '">>
            , Val,<<"' WHERE `role_id` = ">>, integer_to_list(Id), <<";">>]),
    case db:execute(Sql) of
        {ok, 0} ->
            db_stores_fb2(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

db_stores_fb2(Rs) ->
    #role{
        id	=	Id
        ,fb_combat1 = FbC1
        ,fb_combat2 = FbC2
        ,fb_combat3 = FbC3
        ,fb_time1 = FbT1
        ,fb_time2 = FbT2
        ,fb_time3 = FbT3
        %% ,fb_gate = FbGate
        ,fb_nightware = Fbn
    } = Rs,
    {Type, GateId} = case Rs#role.fb_gate of
        undefined -> {0, 0};
        {A, B} -> {A, B}
    end,
    Val = ?ESC_SINGLE_QUOTES(zip([FbC1, FbC2, FbC3, FbT1, FbT2, FbT3, Type, GateId, Fbn])),
    Sql = list_to_binary([
            <<"SELECT count(*) FROM `fb_info` WHERE role_id = ">>,integer_to_list(Id),<<";">>]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql1 = list_to_binary([<<"INSERT `fb_info` (`role_id`, `fb_info`) VALUES (">>
                    , integer_to_list(Id), <<",'">>, Val, <<"');">>]),
            db:execute(Sql1);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

%% zip / unzip
%% -define(FB_ZIP_VERSION, 1).
%% unzip(<<1:8, F1:8, F2:8, F3:8, T1:32, T2:32, T3:32, Type:8, GateId:16>>) ->
%%     [F1, F2, F3, T1, T2, T3, Type, GateId];
%%
%% unzip(Else) ->
%%     ?WARN("Error FbInfo Binary Data: ~w", [Else]),
%%     [].
%%
%% zip([F1, F2, F3, T1, T2, T3, Type, GateId]) ->
%%     <<?FB_ZIP_VERSION:8, F1:8, F2:8, F3:8, T1:32, T2:32, T3:32, Type:8, GateId:16>>.

-define(FB_ZIP_VERSION, 2).
unzip(<<>>) -> [];
unzip(undefined) -> [];
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            <<F1:8, F2:8, F3:8, T1:32, T2:32, T3:32, Type:8, GateId:16>> = Bin1,
            [F1, F2, F3, T1, T2, T3, Type, GateId, []];
        2 ->
            <<F1:8, F2:8, F3:8, T1:32, T2:32, T3:32, Type:8, GateId:16, Fbn/binary>> = Bin1,
            Fbn2 = unzip1(Fbn, []),
            [F1, F2, F3, T1, T2, T3, Type, GateId, Fbn2];
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
unzip1(<<>>, Rt) -> Rt;
unzip1(<<X1:16, X2:8, RestBin/binary>>, Rt) ->
    unzip1(RestBin, [{X1,X2}|Rt]).

zip([F1, F2, F3, T1, T2, T3, Type, GateId, Fbn]) ->
    Fbn1 = [<<F1:8, F2:8, F3:8, T1:32, T2:32, T3:32, Type:8, GateId:16>>],
    Fbn2 = zip1(Fbn, []),
    Rt = list_to_binary(Fbn1 ++ Fbn2),
    <<?FB_ZIP_VERSION:8, Rt/binary>>.
zip1([], Rt) -> Rt;
zip1([{Id,Star}|T], Rt) ->
    zip1(T, [<<Id:16,Star:8>>|Rt]).

get_hero_equ_tid(Heroes, Items) ->
    get_hero_equ_tid(Heroes, Items, []).
get_hero_equ_tid([], _Items, Rt) -> Rt;
get_hero_equ_tid([H | T], Items, Rt) ->
    E = H#hero.equ_grids,
    E2 = get_item_tid(tuple_to_list(E), Items),
    H2 = H#hero{equ_grids = list_to_tuple(E2)},
    get_hero_equ_tid(T, Items, [H2 | Rt]).

get_item_tid(E, Items) ->
    get_item_tid(E, Items, []).
get_item_tid([], _Items, Rt1) ->
    lists:reverse(Rt1);
get_item_tid([E1 | E2], Items, Rt1) ->
    case E1 == 0 of
        true -> get_item_tid(E2, Items, [E1 | Rt1]);
        false ->
            case mod_item:get_item(E1, Items) of
                false -> get_item_tid(E2, Items, [0 | Rt1]);
                Item ->
                    get_item_tid(E2, Items, [Item#item.tid | Rt1])
            end
    end.

%%' arena stop using
%% arena(Rs, ArenaId) ->
%%     case Rs#role.produce_pass of
%%         {3, Type} ->
%%             case mod_arena:get_data(ArenaId) of
%%                 {Robot, Rid, Lev, _, Name, S} ->
%%                     Heroes2 = case Robot of
%%                         1 ->
%%                             ?DEBUG("Robot PVP ****************** **", []),
%%                             init_monster1(S, []);
%%                         0 ->
%%                             ?DEBUG("Role PVP ****************** **", []),
%%                             mod_arena:fix_arena_pos(S)
%%                     end,
%%                     Heroes1 = mod_hero:get_combat_heroes(Rs#role.heroes, Rs#role.items),
%%                     HeroesTmp = [XX || XX <- Rs#role.heroes, XX#hero.pos > 0],
%%                     mod_battle:print_hero(HeroesTmp),
%%                     {Over, InitHp, Data2} = mod_battle:battle(arena, Heroes1, Heroes2),
%%                     {IsWin, AddExp, Gold, Report} = case Over =:= 1 of
%%                         true ->
%%                             E = (Lev - Rs#role.arena_lev) + 10,
%%                             G = case Type of
%%                                 3 ->
%%                                     %% 成功揭榜
%%                                     gen_server:cast(arena, {del_offer_report, ArenaId}),
%%                                     %% 悬赏奖励
%%                                     Lev * 300;
%%                                 _ ->
%%                                     %% 非揭榜战斗不给予金币奖励
%%                                     0
%%                             end,
%%                             case Robot of
%%                                 0 ->
%%                                     %% 自己胜，对方败，给对方发送反击战报
%%                                     myevent:send_event(Rid, {lost_report, Rs#role.arena_id, Rs#role.name});
%%                                 _ -> ok
%%                             end,
%%                             {1, E, G, undefined};
%%                         false ->
%%                             E = (Lev - Rs#role.arena_lev) - 10,
%%                             {0, E, 0, {ArenaId, Name}}
%%                     end,
%%                     {Lev1, Exp1, Rs1} = mod_arena:add_arena_exp(AddExp, Rs),
%%                     Rs2 = lib_role:add_attr(gold, Gold, Rs1),
%%                     Produce = {3, [Gold, AddExp, Lev1, Exp1], Report},
%%                     Rs3 = Rs2#role{produce_pass = Produce},
%%                     mod_arena:set_data(Rs, Lev1, Exp1, Heroes1),
%%                     Rs4 = case IsWin of
%%                         1 ->
%%                             mod_arena:update_arena_state(Name, Rs3);
%%                         0 ->
%%                             Rs3
%%                     end,
%%                     %% 竞技场成就推送
%%                     Rs6 = mod_attain:attain_state(36, 1, Rs4),
%%                     Rs5 = case IsWin of
%%                         1 ->
%%                             mod_attain:attain_state(37, 1, Rs6);
%%                         0 ->
%%                             Rs6
%%                     end,
%%                     #role{arena_wars = WarsNum, arena_prize = PrizeNum} = Rs5,
%%                     Rs0 = case Type of
%%                         3 ->
%%                             Rs5#role{arena_wars = WarsNum - 1, arena_prize = PrizeNum + 1};
%%                         _ ->
%%                             Rs5#role{arena_wars = WarsNum - 1}
%%                     end,
%%                     %% 请求战斗掉落
%%                     %% #role{produce_pass = ProducePass} = Rs7,
%%                     %% {Rs0, [Data3, Data4]} = mod_item:drop_produce(Rs7, ProducePass),
%%                     Combat = mod_hero:calc_power(Heroes1),
%%                     %% gen_server:cast(rank, {rank_set, Combat, Rs#role.id, Rs#role.name, 3}),
%%                     %% 记录历史最高战斗力
%%                     Rs00 = case Combat > Rs0#role.combat of
%%                         true -> Rs0#role{combat = Combat};
%%                         false -> Rs0
%%                     end,
%%                     {[Rs00#role.power, 0, IsWin, InitHp, Data2, [], [], []], Rs00};
%%                 {error, Reason} ->
%%                     ?WARN("ARENA COMBAT ERROR: ~w", [Reason]),
%%                     {[0, 0, 0, [], [], [], [], []], Rs}
%%             end;
%%         E ->
%%             ?ERR("ERROR:~w", [E]),
%%             {[0, 0, 0, [], [], [], [], []], Rs}
%%     end.
%%.

%%' zip / unzip
%% unzip([Val]) ->
%%     <<Version:8, Bin1/binary>> = Val,
%%     case Version of
%%         1 ->
%%             <<?HERO_ZIP_VERSION:8
%%             ,Id       :32
%%             ,MapId    :8
%%             ,MapPos1  :32
%%             ,MapPos2  :32
%%             ,MyPos1   :32
%%             ,MyPos2   :32
%%             ,RTime    :32
%%             ,FreeTimes:32
%%             ,Bin2/binary
%%             >> = Bin1,
%%             Rule = [[int32, int8, int16, int8, int32]],
%%             Data = protocol_fun:unpack(Rule, Bin1),
%%             %% ?INFO("unzip step:~w, skills:~w", [Step, Skills]),
%%             Data = data_hero:get(Tid),
%%             #hero{
%%                 id         = Id
%%                 ,tid       = Tid
%%                 ,job       = Job
%%                 ,sort      = Sort
%%                 ,frequency = Frequency
%%                 ,hp        = Hp
%%                 ,atk       = Atk
%%                 ,def       = Def
%%                 ,pun       = Pun
%%                 ,hit       = Hit
%%                 ,dod       = Dod
%%                 ,crit = Crit
%%                 ,crit_num  = CritNum
%%                 ,crit_anti = CritAnit
%%                 ,tou       = Tou
%%                 ,pos       = Pos
%%                 ,exp_max   = ExpMax
%%                 ,exp       = Exp
%%                 ,lev       = Lev
%%                 ,step      = Step
%%                 ,quality   = Quality
%%                 ,skills = lib_role:init_skills(Data)
%%             };
%%         _ ->
%%             ?ERR("undefined version: ~w", [Version]),
%%             undefined
%%     end.

%% -define(HERO_ZIP_VERSION, 1).

%% zip(Fb) ->
%%     #fb{
%%           id            = Id
%%           ,map_id       = MapId
%%           ,map_pos1     = MapPos1
%%           ,map_pos2     = MapPos2
%%           ,mypos1       = MyPos1
%%           ,mypos2       = MyPos2
%%           ,refresh_time = RTime
%%           ,free_times   = FreeTimes
%%           ,monsters     = Ms
%%     } = Fb,
%%     MsLen = length(Ms),
%%     MsBin = list_to_binary([<<X1:32, X2:8, X3:16, X4:8, X5:32>> ||
%%             #fbm{
%%                 pos           = X1
%%                 ,type         = X2
%%                 ,gate_id      = X3
%%                 ,status       = X4
%%                 ,revival_time = X5
%%             } <- Ms]),
%%     <<?HERO_ZIP_VERSION:8
%%     ,Id       :32
%%     ,MapId    :8
%%     ,MapPos1  :32
%%     ,MapPos2  :32
%%     ,MyPos1   :32
%%     ,MyPos2   :32
%%     ,RTime    :32
%%     ,FreeTimes:32
%%     ,MsLen    :32
%%     ,MsBin/binary
%%     >>.
%%.
%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
