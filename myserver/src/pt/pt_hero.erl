%%----------------------------------------------------
%% $Id: pt_hero.erl 13256 2014-06-18 05:40:49Z rolong $
%% @doc 协议14 - hero
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_hero).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("equ.hrl").

-define(SEARCHED_HERO, searched_hero).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_hero_tab_test() ->
    Ids = data_hero_tab:get(ids),
    [A|_] = Ids,
    B = lists:last(Ids),
    ?assert(A >= 6),
    ?assert(lists:seq(A,B) == Ids),
    lists:foreach(fun(Id) ->
                Data = data_hero_tab:get(Id),
                Money = util:get_val(money, Data, 0),
                ?assert(Money > 0)
        end, Ids),
    ok.
-endif.

%% 布阵
handle(14001, [L], Rs) ->
    case length(L) =< 5 of
        true ->
            case mod_hero:set_pos(Rs, L) of
                {ok, Rs1} -> {ok, [0], Rs1};
                {error, _} -> {ok, [1]}
            end;
        false ->
            {ok, [1]}
    end;

%% 英雄列表
handle(14002, [], Rs) ->
    Data = [mod_hero:pack_hero(X) || X <- Rs#role.heroes],
    %% 图鉴
    #role{pictorialial = Pictorial} = Rs,
    Rs2 = case Pictorial == [] of
        true ->
            Pic = [lists:nth(2, L) || L <- Data],
            Pic1 = util:del_repeat_element(Pic),
            Rs#role{pictorialial = Pic1, save = [pictorial]};
            %% role:save_delay(pictorial, Rs1);
        false -> Rs
    end,
    {ok, [Data], Rs2};

%% handle(14005, [ItemId, HeroId, Pos], Rs) ->
%%     %% ?DEBUG("ItemId:~w, HeroId:~w, Del:~w", [ItemId, HeroId, Del]),
%%     Items = Rs#role.items,
%%     Heroes = Rs#role.heroes,
%%     Hero = mod_hero:get_hero(HeroId, Heroes),
%%     Item = mod_item:get_item(ItemId, Items),
%%     % ?DEBUG("===Items:~w, Heroes:~w, Hero:~w, Item:~w ", [Items,Heroes,Hero,Item]),
%%     if
%%         Hero == false ->
%%             {ok, [127]};
%%         Item == false ->
%%             {ok, [128]};
%%         true ->
%%             Data = data_item:get(Item#item.tid),
%%             SkillId = util:get_val(ctl1, Data, 0),
%%             case mod_hero:set_skill(Pos, SkillId, Hero) of
%%                 {ok, Hero1} ->
%%                     Heroes1 = mod_hero:set_hero(Hero1, Heroes),
%%                     Rs1 = Rs#role{heroes = Heroes1},
%%                     {ok, [0], Rs1};
%%                 {error, Reason} ->
%%                     ?WARN("set_skill:~w", [Reason]),
%%                     {ok, [129]}
%%             end
%%     end;

%% 净化
%% -> [Code, EH, Setp, ER]
handle(14010, [HeroId], Rs) ->
    #role{heroes = Heroes, items = Items} = Rs,
    % ?DEBUG("===Heroes:~w, Items:~w", [hd(Heroes), hd(Items)]),
    Hero = mod_hero:get_hero(HeroId, Heroes),
    if
        Hero == false ->
            {ok, [127]};
        true ->
            case data_purge:get(Hero#hero.quality) of
                undefined ->
                    {ok, [4]};
                Data ->
                    Materials = util:get_val(materials, Data),
                    % {materials, [{13002,20},{13001,5},{13003,1},{13004,1}]}
                    Type = util:get_val(type, Data),
                    Num = util:get_val(num, Data),
                    {CType, RtCode} = case Type of
                        1 -> {gold, 1};
                        2 -> {diamond, 2}
                    end,
                    case lib_role:spend(CType, Num, Rs) of
                        {ok, Rs1} ->
                            case mod_item:del_items(by_tid, Materials, Items) of
                                {ok, Items1, Dels} ->
                                    Hero1 = mod_hero:upgrade_quality(Hero),
                                    %% mod_hero:hero_notice(Rs#role.pid_sender, Hero1),
                                    Heroes1 = mod_hero:set_hero(Hero1, Heroes),
                                    Rs2 = Rs1#role{items = Items1, heroes = Heroes1, save = [items, role, heroes]},
                                    lib_role:notice(Rs2),
                                    mod_item:send_notice(Rs2#role.pid_sender, Dels),
                                    %% 成就推送
                                    %% Rs3 = case Hero1#hero.quality >= 5 of
                                    %%     true -> mod_attain:attain_state(49, 1, Rs2);
                                    %%     false -> Rs2
                                    %% end,
                                    Rs4 = mod_attain:attain_state(45, 1, Rs2),
                                    Rs0 = lib_role:spend_ok(CType, 30, Rs, Rs4),
                                    %% 一切都OK后，从数据库中删除物品
                                    mod_item:del_items_from_db(Rs#role.id, Dels),
                                    {ok, [0], Rs0};
                                {error, _} ->
                                    {ok, [3]}
                            end;
                        {error, _} ->
                            {ok, [RtCode]}
                    end
            end
    end;

%% delete hero
%% -> [Code, HeroId, Essence]
%% handle(14015, [HeroId], Rs) ->
%%     case mod_hero:del_hero(Rs, HeroId) of
%%         {ok, Rs1} ->
%%             {ok, [0, HeroId, Rs1#role.essence], Rs1};
%%         {error, Reason} ->
%%             ?DEBUG("14015 ERROR:~w", [Reason]),
%%             {ok, [128, 0, 0]}
%%     end;

%% 英雄锁
handle(14019, [Id, Lock], Rs) ->
    ?DEBUG("lock, Id:~w, Lock:~w", [Id, Lock]),
    Tavern = Rs#role.tavern,
    case lists:keyfind(Id, 1, Tavern) of
        false ->
            ?DEBUG("When lock, Id:~w, Lock:~w, not found", [Id, Lock]),
            {ok, [127]};
        {_, _, Hero} ->
            Tavern1 = lists:keyreplace(Id, 1, Tavern, {Id, Lock, Hero}),
            Rs1 = Rs#role{tavern = Tavern1},
            {ok, [0], Rs1}
    end;

%% handle(14020, [0], Rs) ->
%%     case mod_hero:db_init_tavern(Rs) of
%%         {ok, Rs1} ->
%%             RestTime = mod_hero:tavern_rest_time(Rs1),
%%             HeroesData = pack_tavern(Rs#role.tavern, []),
%%             {ok, [0, RestTime, HeroesData], Rs1};
%%         {error, Reason} ->
%%             ?WARN("Error When Init Tavern: ~w", [Reason]),
%%             {ok, [127, 0, []]}
%%     end;

%%----------------------------------------------------
%% Type=0:
%% 请求酒馆数据，
%% 如果是注册后第一次进酒馆，
%% 会自动刷新一次
%%
%% Type=1:
%% 酒馆刷新(最多3个英雄)
%%----------------------------------------------------
handle(14020, [Type], Rs) ->
    Rs1 = case Rs#role.tavern_time =:= undefined of
        true ->
            case mod_hero:db_init_tavern(Rs) of
                {ok, RsTmp1} -> RsTmp1;
                {error, Reason} ->
                    ?WARN("Error When Init Tavern: ~w", [Reason]),
                    false
            end;
        false -> Rs
    end,
    if
        Rs1 =:= false ->
            {ok, [127, 0, []]};
        Type =:= 0 ->
            RestTime = mod_hero:tavern_rest_time(Rs1),
            HeroesData = pack_tavern(Rs1#role.tavern, []),
            {ok, [0, RestTime, HeroesData], Rs1};
        true ->
            RestTime = mod_hero:tavern_rest_time(Rs1),
            SearchPrice1 = lib_role:time2diamond(RestTime),
            ?DEBUG("=== Tavern SearchPrice:~w, RestTime:~w ===", [SearchPrice1, RestTime]),
            case lib_role:spend(diamond, SearchPrice1, Rs1) of
                {ok, Rs2} ->
                    Tavern1 = mod_hero:tavern_refresh(Rs2#role.tavern),
                    HeroesData = pack_tavern(Tavern1, []),
                    Max = data_config:get(refresh_time),
                    Rs3 = Rs2#role{
                        save = [role, tavern]
                        ,tavern = Tavern1
                        ,tavern_time = util:unixtime()
                    },
                    lib_role:notice(diamond, Rs3),
                    Rs4 = lib_role:spend_ok(diamond, 18, Rs, Rs3),
                    Rs0 = mod_attain:attain_state(32, 1, Rs4),
                    {ok, [0, Max, HeroesData], Rs0};
                {error, _} ->
                    {ok, [2, 0, []]}
            end
    end;

%% handle(14020, [1], _Rs) ->
%%     ?WARN("Tavern not initialized!", []),
%%     {128, 0, []};

%%' 酒馆中购买英雄
%% # 消息代码：
%% # Code:
%% # 0 = 成功
%% # 1 = 金币不足
%% # 2 = 钻石不足
%% # 3 = 英雄格子数不足
%% # >=127 = 程序异常
%% 'code' => 'int32',
%% 引导guide={2,N}时为赠送
handle(14022, [Id], Rs) ->
    Tavern = Rs#role.tavern,
    case lists:keyfind(Id, 1, Tavern) of
        false ->
            ?DEBUG("When Buy, Id:~w, Tavern:~w", [Id, Tavern]),
            {ok, [127]};
        {_, _, Hero} ->
            #hero{tid = Tid, rare = Rare, quality = Q} = Hero,
            case data_hero_price:get({Rare, Q}) of
                undefined -> {ok, [128]};
                [{type, Type}, {price, Price}] ->
                    {CType, RtCode} = case Type of
                        1 -> {gold, 1};
                        2 -> {diamond, 2}
                    end,
                    %% case Rs#role.givehero =:= 0 of
                    %%     true ->
                    %%         {ok, Rs1, Hero2} = mod_hero:add_hero(Rs, Tid, Q),
                    %%         mod_hero:hero_notice(Rs1#role.pid_sender, Hero2),
                    %%         Tavern2 = lists:keydelete(Id, 1, Tavern),
                    %%         {ok, [0], Rs1#role{givehero = 1, tavern = Tavern2}};
                    %%     false ->
                    case lib_role:spend(CType, Price, Rs) of
                        {ok, Rs1} ->
                            case length(Rs#role.heroes) < Rs#role.herotab of
                                true ->
                                    Tavern1 = lists:keydelete(Id, 1, Tavern),
                                    Rs2 = Rs1#role{tavern = Tavern1},
                                    {ok, Rs3, Hero1} = mod_hero:add_hero(Rs2, Tid, Q),
                                    %% {ok, HeroId, Rs3} = lib_role:get_new_id(hero, Rs2),
                                    %% Hero1 = Hero#hero{id = HeroId},
                                    %% Heroes = [Hero1 | Rs3#role.heroes],
                                    %% Rs4 = Rs3#role{tavern = Tavern1, heroes = Heroes, save = [role, heroes]},
                                    Rs4 = Rs3#role{tavern = Tavern1, save = [role, heroes]},
                                    mod_hero:hero_notice(Rs4#role.pid_sender, Hero1),
                                    lib_role:notice(Rs4),
                                    Rs5 = lib_role:spend_ok(CType, 7, Rs, Rs4),
                                    %% 成就推送
                                    %% Rs6 = case Hero1#hero.quality >= 5 of
                                    %%     true -> mod_attain:attain_state(49, 1, Rs5);
                                    %%     false -> Rs5
                                    %% end,
                                    Rs0 = mod_attain:attain_state(73, 1, Rs5),
                                    mod_hero:db_update_tavern(Rs0),
                                    %% 玩家经常反馈买的英雄消失
                                    %% 这里强制保存
                                    mod_hero:db_insert(Rs#role.id, Hero1),
                                    case Hero1#hero.quality >= 6 of
                                        true ->
                                            Name = lib_admin:get_name(Rs),
                                            Vip = lib_admin:get_vip(Rs),
                                            H = util:quality2string(Hero1#hero.quality),
                                            Msg = data_text:get(9),
                                            Msg1 = io_lib:format(Msg, [Name, H, Tid]),
                                            lib_system:cast_sys_msg(0, Name, Msg1, Vip);
                                        false -> ok
                                    end,
                                    {ok, [0], Rs0};
                                false ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(12),
                                    mod_mail:new_mail(Rs1#role.id, 0, 7, Title, Body, [{5,{Tid, Q}}]),
                                    Tavern1 = lists:keydelete(Id, 1, Tavern),
                                    Rs2 = Rs1#role{tavern = Tavern1},
                                    %% 成就推送
                                    %% Rs3 = case Q >= 5 of
                                    %%     true -> mod_attain:attain_state(49, 1, Rs2);
                                    %%     false -> Rs2
                                    %% end,
                                    Rs4 = mod_attain:attain_state(73, 1, Rs2),
                                    case Q >= 6 of
                                        true ->
                                            Name = lib_admin:get_name(Rs),
                                            Vip = lib_admin:get_vip(Rs),
                                            H = util:quality2string(Q),
                                            Msg = data_text:get(9),
                                            Msg1 = io_lib:format(Msg, [Name, H, Tid]),
                                            lib_system:cast_sys_msg(0, Name, Msg1, Vip);
                                        false -> ok
                                    end,
                                    lib_role:notice(Rs4),
                                    Rs5 = lib_role:spend_ok(CType, 7, Rs, Rs4),
                                    {ok, [3], Rs5}
                            end;
                        {error, _} ->
                            {ok, [RtCode]}
                    end
                    %% end
            end
    end;
%%.

%% 赠送英雄
%% : 1 = 已经赠送(限制赠送)
%% # 消息代码：
%% # Code:
%% # 0 = 成功
%% # 1 = 已经赠送
%% # >=127 = 程序异常
%% 'code' => 'int8',
handle(14023, [Tid], Rs) ->
    ?DEBUG("14023:~w, Growth:~w", [Tid, Rs#role.growth]),
    case Rs#role.growth =< 1 of
        true ->
            %% L = [30002,30003,30004,30005],
            L = data_hero_give:get(ids),
            case lists:member(Tid, L) of
                true  ->
                    %% 酒馆引导初始酒馆数据
                    %% List = lists:delete(Tid, L),
                    %% [Tid1, Tid2, Tid3] = List,
                    %% Tavern = mod_hero:tavern_guide([{1, Tid1}, {2, Tid2}, {3, Tid3}]),
                    GiveData = data_hero_give:get(Tid),
                    Quality = util:get_val(quality, GiveData),
                    {ok, Rs1, Hero} = mod_hero:add_hero(Rs, Tid, Quality),
                    mod_hero:hero_notice(Rs1#role.pid_sender, Hero),
                    Rs2 = Rs1#role{growth = 2, save = [heroes]},
                    %% Rs2 = Rs1#role{growth = 2, tavern = Tavern, tavern_time = util:unixtime(), save = [heroes]},
                    %% mod_hero:db_insert_tavern(Rs2),
                    {ok, [0], Rs2};
                false ->
                    ?DEBUG("14023 Not member", []),
                    {ok, [127]}
            end;
        false ->
            ?DEBUG("14023 No login", []),
            {ok, [128]}
    end;

%% 英雄吞噬
%% 吞噬消耗的金币计算：
%% FLOOR【吞噬的总经验/50】+300
%% 吞噬转移的经验计算：
%% FLOOR【所有被吞噬的英雄经验累加*0.8】+500
handle(14030, [HeroId, Id1, Id2, Id3, Id4], Rs) ->
    #role{id = Rid, heroes = Heroes, items = Items} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false ->
            {ok, [127, 0, 0, 0]};
        Hero ->
            L = [{Id1, 1}, {Id2, 1}, {Id3, 1}, {Id4, 1}],
            case absorb(L, Rid, Heroes, Items, [], 0) of
                {ok, Heroes1, Items1, Cmd, AddExp} ->
                    SpendGold = util:floor(AddExp/50+300),
                    case lib_role:spend(gold, SpendGold, Rs) of
                        {ok, Rs1} ->
                            AddExp1 = util:floor(AddExp * 0.8 + 500),
                            ?DEBUG("AddExp:~w", [AddExp1]),
                            ?DEBUG("HERO1 LEV:~w EXP:~w", [Hero#hero.lev, Hero#hero.exp]),
                            Hero1 = mod_hero:add_hero_exp(Hero, AddExp1),
                            ?DEBUG("HERO2 LEV:~w EXP:~w", [Hero1#hero.lev, Hero1#hero.exp]),
                            Heroes2 = mod_hero:set_hero(Hero1, Heroes1),
                            L2 = [X1 || {X1, _X2} <- L, X1 > 0],
                            Items2 = fix_items(Items1, L2),
                            Rs2 = Rs1#role{heroes = Heroes2, items = Items2, save = [items]},
                            lib_role:exec_cmd(Cmd),
                            lib_role:notice(Rs2),
                            DelL = [X || {X, _} <- L, X > 0],
                            sender:pack_send(Rs#role.pid_sender, 14015, [DelL]),
                            %% 成就推送
                            Rs3 = mod_attain:attain_state(44, 1, Rs2),
                            Rs0 = lib_role:spend_ok(gold, 5, Rs, Rs3),
                            %% ?DEBUG("herolev:~w", [Hero1#hero.lev]),
                            {ok, [0, HeroId, Hero1#hero.lev, Hero1#hero.exp], Rs0#role{save = [role, heroes]}};
                        {error, _} ->
                            {ok, [1, 0, 0, 0]}
                    end;
                {error, Reason} ->
                    ?WARN("~w", [Reason]),
                    {ok, [128, 0, 0, 0]}
            end
    end;

%%'英雄携带数
handle(14032, [], Rs) ->
    Tab = case Rs#role.herotab < length(Rs#role.heroes) of
        true -> length(Rs#role.heroes);
        false -> Rs#role.herotab
    end,
    Data = data_hero_tab:get(Tab + 1),
    Money = util:get_val(money, Data, 0),
    case Data =/= undefined of
        true ->
            case lib_role:spend(diamond, Money, Rs) of
                {ok, Rs1} ->
                    Rs2 = lib_role:spend_ok(diamond, 39, Rs, Rs1),
                    lib_role:notice(Rs2),
                    {ok, [0, Tab + 1], Rs2#role{herotab = Tab + 1}};
                {error, _} ->
                    {ok, [1, 0]}
            end;
        false -> {ok, [2, 0]}
    end;

%%.

%%'英雄解雇
%% handle(14034, [HeroId], Rs) ->
%%     #role{heroes = Heroes, id = Rid} = Rs,
%%     case mod_hero:get_hero(HeroId, Heroes) of
%%         false -> {ok, [127]};
%%         Hero ->
%%             #hero{lev = Lev, quality = Quality} = Hero,
%%             Rare3 = case Hero#hero.rare of
%%                 0 -> 1;
%%                 Rare2 -> Rare2
%%             end,
%%             DataList = data_hero_price:get({Rare3, Quality}),
%%             {CType, _RtCode} = case util:get_val(type, DataList) of
%%                 1 -> {gold, 1};
%%                 2 -> {diamond, 2}
%%             end,
%%             Price = util:get_val(price, DataList, 0),
%%             Price1 = util:ceil(data_fun:hero_dismissal(Price, Lev)),
%%             case check_bag_grids(HeroId, Rs) of
%%                 {ok, Rs1} ->
%%                     Heroes1 = lists:keydelete(HeroId, 2, Heroes),
%%                     mod_hero:db_delete(Rid, HeroId),
%%                     Rs2 = lib_role:add_attr(CType, Price1, Rs1),
%%                     Rs3 = lib_role:add_attr_ok(CType, 38, Rs, Rs2),
%%                     lib_role:notice(Rs3),
%%                     Rs0 = mod_attain:attain_state(72, 1, Rs3),
%%                     {ok, [0], Rs0#role{heroes = Heroes1, save = [heroes, items]}};
%%                 {error, Code} ->
%%                     {ok, [Code]}
%%             end
%%     end;
%%.

%%'英雄解雇
handle(14034, [HeroId], Rs) ->
    #role{heroes = Heroes, id = Rid} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false -> {ok, [127]};
        Hero ->
            #hero{tid = Tid} = Hero,
            case check_bag_grids(HeroId, Rs) of
                {ok, Rs1} ->
                    Data = data_hero:get(Tid),
                    Items = case util:get_val(items,Data) of
                        undefined -> [];
                        Item -> Item
                    end,
                    case mod_item:add_items(Rs1,Items) of
                        {ok, Rs2, PA, EA} ->
                            Heroes1 = lists:keydelete(HeroId, 2, Heroes),
                            mod_hero:db_delete(Rid, HeroId),
                            mod_item:send_notice(Rs2#role.pid_sender, PA, EA),
                            Rs0 = mod_attain:attain_state(72, 1, Rs2),
                            {ok, [0], Rs0#role{heroes = Heroes1, save = [heroes, items]}};
                        {error, full} ->
                            {ok, [3]};
                        {error, Reason} ->
                            ?WARN("~w", [Reason]),
                            {ok, [129]}
                    end;
                {error, Code} ->
                    {ok, [Code]}
            end
    end;
%%.

%% 英雄培养
handle(14035, [HeroId], Rs) ->
    #role{heroes = Heroes, items = Items} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false -> {ok, [127]};
        Hero ->
            #hero{tid = Tid, foster = Foster} = Hero,
            Data = data_hero:get(Tid),
            FosterUpper = util:get_val(foster,Data,0),
            [{ItemId,_}|_] = util:get_val(items,Data),
            Rand = data_fun:foster_succeed(Foster),
            Golds = data_fun:foster_golds(Foster),
            ItemNum = data_fun:foster_items(Foster),
            Code = case Foster < FosterUpper of
                true ->
                    case util:rate(Rand) of
                        true -> 0;
                        false -> 1
                    end;
                false -> 2
            end,
            case Code == 0 of
                true ->
                    case lib_role:spend(gold,Golds,Rs) of
                        {ok, Rs1} ->
                            case mod_item:del_item(by_id, ItemId, ItemNum, Items) of
                                {ok, Items1, Dels} ->
                                    Hero1 = Hero#hero{foster = Foster + 1, changed = 1},
                                    Heroes1 = mod_hero:set_hero(Hero1,Heroes),
                                    mod_item:send_notice(Rs1#role.pid_sender, Dels),
                                    %% 一切都OK后，从数据库中删除物品
                                    mod_item:del_items_from_db(Rs#role.id, Dels),
                                    {ok, [0], Rs1#role{heroes = Heroes1,items = Items1}};
                                {error, Reason} ->
                                    ?WARN("foster hero del_item error: ~w", [Reason]),
                                    {ok, [5]}
                            end;
                        {error,_} -> {ok, [4]}
                    end;
                false -> {ok, [Code]}
            end
    end;

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

pack_tavern([{_Id, _IsLock, false} | T], Data) ->
    pack_tavern(T, Data);
pack_tavern([{Id, IsLock, Hero} | T], Data) ->
    #hero{
        tid = Tid
        ,rare = Rare
        ,quality = Qua
        %% ,hp        = Hp
        %% ,atk       = Atk
        %% ,def       = Def
        %% ,pun       = Pun
        %% ,hit       = Hit
        %% ,dod       = Dod
        %% ,crit = Crit
        %% ,crit_num  = CritNum
        %% ,crit_anti = CritAnit
        %% ,tou       = Tou
    } = Hero,
    Rt = [Id, Tid, IsLock, Qua, Rare
        %% ,Hp
        %% ,Atk
        %% ,Def
        %% ,Pun
        %% ,Hit
        %% ,Dod
        %% ,Crit
        %% ,CritNum
        %% ,CritAnit
        %% ,Tou
    ],
    Data1 = [Rt | Data],
    pack_tavern(T, Data1);
pack_tavern([], Data) ->
    Data.

absorb([{0, _} | T], Rid, Heroes, Items, Cmd, AddExp) ->
    absorb(T, Rid, Heroes, Items, Cmd, AddExp);

absorb([{HeroId, 1} | T], Rid, Heroes, Items, Cmd, AddExp) ->
    case mod_hero:get_hero(HeroId, Heroes) of
        false -> {error, error_hid};
        #hero{exp = Exp, lev = Lev} ->
            Data = data_exp:get(Lev),
            ExpSum = util:get_val(exp_sum, Data, 0),
            AddExp1 = AddExp + Exp + ExpSum,
            ?DEBUG("ABSORB Lev:~w, AccExp:~w+Exp:~w+ExpSum:~w=~w", [Lev, AddExp, Exp, ExpSum, AddExp1]),
            Heroes1 = lists:keydelete(HeroId, 2, Heroes),
            Cmd1 = [{mod_hero, db_delete, [Rid, HeroId]} | Cmd],
            absorb(T, Rid, Heroes1, Items, Cmd1, AddExp1)
    end;
absorb([{ItemId, 2} | T], Rid, Heroes, Items, Cmd, AddExp) ->
    case mod_item:get_item(ItemId, Items) of
        false -> {error, error_item_id};
        #item{sort = 3, tid = Tid} ->
            Data = data_prop:get(Tid),
            Exp = util:get_val(control1, Data, 0),
            AddExp1 = AddExp + Exp,
            case mod_item:del_item(by_id, ItemId, 1, Items) of
                {ok, Items1, Dels} ->
                    Cmd1 = [{mod_item, db_delete, [Rid, ItemId]} | Cmd],
                    Cmd2 = [{mod_item, send_notice, [Rid, Dels]} | Cmd1],
                    absorb(T, Rid, Heroes, Items1, Cmd2, AddExp1);
                {error, Reason} ->
                    {error, Reason}
            end;
        _ -> {error, error_tid}
    end;
absorb([], _, Heroes, Items, Cmd, AddExp) ->
    {ok, Heroes, Items, Cmd, AddExp}.

fix_items(Items, L) ->
    fix_items(Items, L, []).

fix_items([], _L, Rt) ->
    Rt;
fix_items([Item | Items], L, Rt) ->
    case Item#item.tid >= ?MIN_EQU_ID andalso
        lists:member(Item#item.attr#equ.hero_id, L) of
        true ->
            ?DEBUG("fix_items: hero_id:~w", [Item#item.attr#equ.hero_id]),
            Attr = Item#item.attr#equ{hero_id = 0},
            Item1 = Item#item{attr = Attr, changed = 1},
            fix_items(Items, L, [Item1 | Rt]);
        false ->
            fix_items(Items, L, [Item | Rt])
    end.


check_bag_grids(HeroId, Rs) ->
    #role{heroes = Heroes} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false -> {error, 128};
        Hero ->
            #hero{equ_grids = EquGrids} = Hero,
            OldEquIds = tuple_to_list(EquGrids),
            check_bag_grids2(OldEquIds, Rs)
    end.
check_bag_grids2([], Rs) -> {ok, Rs};
check_bag_grids2([OldEquId|T], Rs) ->
    Items = Rs#role.items,
    %% 卸载装备
    case OldEquId > 0 of
        true ->
            case mod_item:get_item(OldEquId, Items) of
                false ->
                    %% 原穿戴的装备不存在，当作卸载成功
                    ?WARN("non-existent old equ: ~w", [OldEquId]),
                    {ok, Rs};
                OldItem ->
                    case mod_item:count_unit(?TAB_EQU, Items) < Rs#role.bag_equ_max of
                        true ->
                            %% 把装备卸下 (装备上的英雄ID置0)
                            Equ = OldItem#item.attr#equ{hero_id = 0},
                            OldItem1 = OldItem#item{attr = Equ, changed = 1},
                            Items1 = mod_item:set_item(OldItem1, Items),
                            %% 把英雄相应格子设置0
                            %% EquGrids1 = setelement(Pos, EquGrids, 0),
                            %% Hero1 = Hero#hero{equ_grids = EquGrids1, changed = 1},
                            %% Heroes1 = mod_hero:set_hero(Hero1, Heroes),
                            %% {ok, Rs#role{items = Items1, heroes = Heroes1}},
                            check_bag_grids2(T, Rs#role{items = Items1});
                        false ->
                            {error, 3}
                    end
            end;
        false ->
            check_bag_grids2(T, Rs)
    end.

%%'英雄解雇
%% handle(14034, [HeroId], Rs) ->
%%     #role{heroes = Heroes, items = Items, id = Rid} = Rs,
%%     Data = [list_to_tuple(pack_hero(H)) || H <- Heroes],
%%     case lists:keyfind(HeroId, 1, Data) of
%%         false -> {ok, [127]};
%%         R ->
%%             R1 = tuple_to_list(R),
%%             Rare = case lists:nth(3, R1) of
%%                 0 -> 1;
%%                 Rare2 -> Rare2
%%             end,
%%             Quality = lists:nth(5, R1),
%%             Lev = lists:nth(6, R1),
%%             DataList = data_hero_price:get({Rare, Quality}),
%%             {CType, _RtCode} = case util:get_val(type, DataList) of
%%                 1 -> {gold, 1};
%%                 2 -> {diamond, 2}
%%             end,
%%             Price = util:get_val(price, DataList, 0),
%%             %% Price1 = util:ceil(Price * Lev / 50),
%%             Price1 = util:ceil(data_fun:hero_dismissal(Price, Lev)),
%%             ItemIds = lists:sublist(R1, length(R1) - 3, length(R1)),
%%             ItemIds1 = [{X, 1} || X <- ItemIds, X =/= 0],
%%             F = fun(X, I) ->
%%                     case mod_item:get_item(X, I) of
%%                         false -> 0;
%%                         Item -> Item#item.tid
%%                     end
%%             end,
%%             ItemTids = [F(X, Items) || X <- ItemIds, F(X, Items) =/= 0],
%%             ItemTids1 = [{X, 1} || X <- ItemTids, X =/= 0],
%%             case mod_item:del_items(by_id, ItemIds1, Items) of
%%                 {ok, Items1, Notice} ->
%%                     case mod_item:add_items(Rs#role{items = Items1}, ItemTids1) of
%%                         {ok, Rs1, PA, EA} ->
%%                             Heroes1 = lists:keydelete(HeroId, 2, Heroes),
%%                             mod_hero:db_delete(Rid, HeroId),
%%                             mod_item:send_notice(Rs#role.pid_sender, Notice),
%%                             mod_item:del_items_from_db(Rs#role.id, Notice),
%%                             mod_item:send_notice(Rs#role.pid_sender, PA, EA),
%%                             Rs2 = lib_role:add_attr(CType, Price1, Rs1),
%%                             Rs0 = lib_role:add_attr_ok(CType, 38, Rs, Rs2),
%%                             lib_role:notice(Rs0),
%%                             {ok, [0], Rs0#role{heroes = Heroes1, save = [heroes, items]}};
%%                         {error, full} ->
%%                             Heroes1 = lists:keydelete(HeroId, 2, Heroes),
%%                             mod_hero:db_delete(Rid, HeroId),
%%                             mod_item:send_notice(Rs#role.pid_sender, Notice),
%%                             mod_item:del_items_from_db(Rs#role.id, Notice),
%%                             Title = data_text:get(2),
%%                             Body  = data_text:get(4),
%%                             mod_mail:new_mail(Rs#role.id, 0, 38, Title, Body, ItemTids1),
%%                             Rs3 = lib_role:add_attr(CType, Price1, Rs),
%%                             Rs4 = lib_role:add_attr_ok(CType, 38, Rs, Rs3),
%%                             lib_role:notice(Rs4),
%%                             {ok, [3], Rs4#role{heroes = Heroes1, items = Items1, save = [heroes, items]}};
%%                         {error, _} ->
%%                             {ok, [129]}
%%                     end;
%%                 {error, _Reason} ->
%%                     {ok, [128]}
%%             end
%%     end;
%%

%% pack_hero(Hero) ->
%%     #hero{
%%         id  = Id
%%         ,tid       = Tid
%%         ,rare      = Rare
%%         ,hp        = Hp
%%         ,atk       = Atk
%%         ,def       = Def
%%         ,pun       = Pun
%%         ,hit       = Hit
%%         ,dod       = Dod
%%         ,crit      = Crit
%%         ,crit_num  = CritNum
%%         ,crit_anti = CritAnit
%%         ,tou       = Tou
%%         ,pos       = Pos
%%         ,exp       = Exp
%%         ,lev       = Lev
%%         ,quality   = Quality
%%         ,equ_grids = {Pos1, Pos2, Pos3, Pos4, _Pos5, _Pos6}
%%     } = Hero,
%%     [
%%         Id
%%         ,Tid
%%         ,Rare
%%         ,Pos
%%         ,Quality
%%         ,Lev
%%         ,Exp
%%         % --- Base ---
%%         ,Hp
%%         ,Atk
%%         ,Def
%%         ,Pun
%%         ,Hit
%%         ,Dod
%%         ,Crit
%%         ,CritNum
%%         ,CritAnit
%%         ,Tou
%%         ,Pos1
%%         ,Pos2
%%         ,Pos3
%%         ,Pos4
%%     ].
%%.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
