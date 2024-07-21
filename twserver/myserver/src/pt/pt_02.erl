%%----------------------------------------------------
%% $Id: pt_02.erl 13209 2014-06-05 08:38:57Z rolong $
%% @doc 内部协议02 - 游戏内部事件
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(pt_02).
-export([handle/3]).

-include("common.hrl").
-include("hero.hrl").
-include("prop.hrl").
-include("equ.hrl").
-define(BINDING, 66).

%% 获得物品
handle(2002, [Ids], Rs) ->
    ?DEBUG("~s, Add Item:~w", [Rs#role.account_id, Ids]),
    case mod_item:add_items(Rs, Ids) of
        {ok, Rs2, PA, EA} ->
            case is_pid(Rs#role.pid_sender) of
                true -> mod_item:send_notice(Rs#role.pid_sender, PA, EA);
                false -> ok
            end,
            mod_item:log_item(add_item,Rs#role.id,3,Ids),
            {ok, Rs2#role{save = [role, items]}};
        {error, Reason} ->
            ?WARN("Add Item:~w", [Reason]),
            {ok}
    end;

%% 增加属性(金币/钻石)
handle(2008, [Attr, Num], Rs) ->
    ?DEBUG("~s, Add ~w: ~w", [Rs#role.account_id, Attr, Num]),
    Rs1 = lib_role:add_attr(Attr, Num, Rs),
    case is_pid(Rs#role.pid_sender) of
        true -> lib_role:notice(Rs1);
        false -> ok
    end,
    Rs2 = lib_role:add_attr_ok(Attr, 34, Rs, Rs1),
    {ok, Rs2#role{save = [role]}};

%% 增加成就完成数
handle(2009, [Type, Num], Rs) ->
    ?DEBUG("~s, Add attain:~w", [Rs#role.account_id, Num]),
    Rs1 = mod_attain:attain_state2(Type, Num, Rs),
    {ok, Rs1};

%% 英雄升级成就推送
handle(2010, [Lev], Rs) ->
    Rs1 = mod_attain:attain_state2(1, Lev, Rs),
    Rs2 = mod_attain:hero_attain(10, 15, Rs1),
    Rs3 = mod_attain:hero_attain(11, 30, Rs2),
    Rs4 = mod_attain:hero_attain(12, 45, Rs3),
    Rs0 = mod_attain:hero_attain(13, 60, Rs4),
    {ok, Rs0};

%% 清除英雄身上的装备ID
handle(2012, [HeroId, Pos, EquId], Rs) ->
    #role{heroes = Heroes} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false ->
            ?WARN("No Hero:~w", [HeroId]),
            %% 英雄不存在
            {ok};
        Hero ->
            #hero{equ_grids = EquGrids} = Hero,
            %% OldEquId = element(Pos, EquGrids),
            %% case OldEquId =:= EquId of
            case element(Pos, EquGrids) of
                EquId ->
                    EquGrids1 = setelement(Pos, EquGrids, 0),
                    Hero1 = Hero#hero{equ_grids = EquGrids1, changed = 1},
                    Heroes1 = mod_hero:set_hero(Hero1, Heroes),
                    {ok, Rs#role{heroes = Heroes1}};
                OldEquId ->
                    ?WARN("error equ pos at hero: ~w", [[HeroId, EquId, OldEquId, EquId, Pos]]),
                    {ok}
            end
    end;

%% 增加疲劳值
handle(2013, [Num], Rs) ->
    #role{power = Power
        ,buy_power = Buys
        ,buy_power_time = BuyTime
        ,power_time = Time} = Rs,
    NewPower = case Power + Num > 1000 of
        true -> 1000;
        false -> Power + Num
    end,
    TiredPower = data_config:get(tired_power),
    Rest = case Time of
        0 -> TiredPower;
        _ -> util:floor(TiredPower - (util:unixtime() - Time))
    end,
    NewBuys = case BuyTime < util:unixtime(today) of
        true -> 0;
        false -> Buys
    end,
    case Rs#role.pid_sender of
        undefined -> ok;
        PidSender ->
            sender:pack_send(PidSender,11007,[NewPower,NewBuys,Rest])
    end,
    {ok, Rs#role{power = NewPower}};

%% 竞技场悬赏次数
handle(2015, [], Rs) ->
    RevNum = Rs#role.arena_revenge,
    {ok, Rs#role{arena_revenge = RevNum + 1}};

%% 服务器启动后第一次登陆
handle(2020, [], _Rs) ->
    {ok};

%% 在线即时刷新日常成就
handle(2022, [], Rs) ->
    ?DEBUG("2022: ~w", [Rs#role.id]),
    Rs1 = mod_attain:attain_refresh(Rs),
    {ok, Rs1};

%% 加英雄经验
handle(2025, [Num], Rs) ->
    ?DEBUG("2025 add_heroes_exp: ~w", [Num]),
    #role{heroes = Heroes} = Rs,
    {Heroes1, _} = mod_hero:add_heroes_exp(Heroes, Num, Heroes),
    {ok, Rs#role{heroes = Heroes1}};

%% 重置竞技场挑战次数
handle(2026, [], Rs) ->
    %% {ok, Rs#role{arena_wars = 20}};
    case Rs#role.coliseum of
        [] -> {ok};
        [A,B,C,D,_E,F,G,H] ->
            Rs1 = Rs#role{coliseum = [A,B,C,D,5,F,G,H]},
            {ok,Rs1#role{save = [coliseum]}}
    end;

%% 设置成长值
handle(2027, [Num], Rs) ->
    {ok, Rs#role{growth = Num}};

%% 设置关卡(通关)
handle(2030, [], Rs) ->
    {ok, Rs#role{tollgate_newid = 264}};

%% 设置关卡(指定关卡)
handle(2032, [Num], Rs) ->
    {ok, Rs#role{tollgate_newid = Num}};

%% 赠送英雄
handle(2034, [HeroId], Rs) ->
    %% #role{givehero = GiveHero} = Rs,
    case data_hero:get(HeroId) of
        undefined -> {ok};
        _ ->
            {ok, Rs1, Hero} = mod_hero:add_hero(Rs, HeroId),
            mod_hero:hero_notice(Rs1#role.pid_sender, Hero),
            %% {ok, Rs1#role{givehero = GiveHero + 1, save = [heroes]}};
            {ok, Rs1#role{save = [heroes]}}
    end;

handle(2035, [HeroId, Quality], Rs) ->
    %% #role{givehero = GiveHero} = Rs,
    case data_hero:get(HeroId) of
        undefined -> {ok};
        _ ->
            {ok, Rs1, Hero} = mod_hero:add_hero(Rs, HeroId, Quality),
            mod_hero:hero_notice(Rs1#role.pid_sender, Hero),
            %% {ok, Rs1#role{givehero = GiveHero + 1, save = [heroes]}};
            {ok, Rs1#role{save = [heroes]}}
    end;

%% 加送荣誉值
handle(2036, [Num], Rs) ->
    case Rs#role.coliseum of
        [] -> {ok};
        [A,B,C,D,E,F,G,H] ->
            Rs2 = Rs#role{coliseum = [A,B,C + Num,D,E,F,G,H]},
            lib_role:notice(honor, Rs2),
            ?LOG({honor, Rs#role.id, 3, C, C + Num}),
            {ok, Rs2#role{save = [coliseum]}}
    end;

%% 推送竞技场刷新列表
handle(2038, [], Rs) ->
    Rs1 = mod_arena:refresh(Rs),
    {ok, Rs1};

%% 确认验证码
handle(2040, [FromRid, FromPid, Verify], Rs) ->
    case Rs#role.verify of
        Verify ->
            Friends = Rs#role.friends,
            Rs1 = Rs#role{friends = [FromRid | Friends]},
            sender:send_info(FromPid, 2041, [Rs#role.id]),
            {ok, role:save_delay(fest, Rs1)};
        _ ->
            sender:send_info(FromPid, 2041, [0]),
            {ok}
    end;

%% 绑定激活码登录(验证码无效)
handle(2041, [0], Rs) ->
    sender:pack_send(Rs#role.pid_sender, 25040, [2]),
    {ok};

%% 绑定激活码登录
handle(2041, [FromRid], Rs) ->
    #role{activity = Activity, pid_sender = PidSender, friends = Friend} = Rs,
    case lists:keyfind(?BINDING, 1, Activity) of
        {?BINDING, V, N, St} ->
            case St of
                0 ->
                    NewAct = lists:keyreplace(?BINDING, 1, Activity, {?BINDING, V, N, 1}),
                    sender:pack_send(PidSender, 25040, [0]),
                    Rs2 = role:save_delay(fest, Rs),
                    {ok, Rs2#role{friends = [FromRid | Friend], activity = NewAct, save = []}};
                _ ->
                    sender:pack_send(PidSender, 25040, [1]),
                    {ok}
            end;
        false ->
            sender:pack_send(PidSender, 25040, [127]),
            {ok}
    end;

%% 凌晨重置广播
handle(2043, [], Rs) ->
    %% {ok, Rs1} = mod_arena:arena_init(Rs),
    Rs3 = case mod_attain:attain_init(Rs) of
        {ok, Rs2} -> Rs2;
        {error, Reason} ->
            ?WARN("reset attain error:~w", [Reason]),
            Rs
    end,
    Rs4 = mod_colosseum:coliseum_wars_reset(Rs3),
    Rs5 = mod_item:herosoul_give_num(Rs4),
    {ok, Rs5};

%% 领取荣誉值
handle(2044, [], Rs) ->
    case Rs#role.coliseum of
        [] -> {ok};
        [Id,_,_,_,_,_,Time,_] ->
            %% coliseum ! {add_exp, self(), Id},
            %% {ok}
            TimeNow = util:unixtime(),
            TimeNine = util:unixtime(today) + 21 * 3600,
            TimeYester = util:unixtime(today) - 3 * 3600,
            case Time =< TimeYester of
                true ->
                    coliseum ! {add_exp, self(), Id},
                    {ok};
                false ->
                    case Time =< TimeNine andalso TimeNow >= TimeNine of
                        true ->
                            coliseum ! {add_exp, self(), Id},
                            {ok};
                        false ->
                            {ok}
                    end
            end
    end;

%% jewelry_upgrade
handle(2045, [Ids,Items1,Expend,Level2,Exp2], Rs) ->
    case lib_role:spend(gold,Expend,Rs) of
        {ok, Rs1} ->
            DelIds = lists:flatten(Ids),
            DelIds2 = [{X,1} || X <- DelIds],
            case mod_item:del_items(by_id, DelIds2, Items1) of
                {ok, Items2, Notice} ->
                    mod_item:send_notice(Rs#role.pid_sender, Notice),
                    %% 从数据库中删除物品
                    mod_item:del_items_from_db(Rs#role.id, Notice),
                    Rs2 = lib_role:spend_ok(gold,60,Rs,Rs1),
                    lib_role:notice(Rs2),
                    sender:pack_send(Rs#role.pid_sender, 13025, [0,Level2,Exp2]),
                    mod_item:log_item(del_item,Rs#role.id,10,DelIds2,Items1),
                    Rs3 = mod_task:set_task(12,{1,1},Rs2),
                    {ok, Rs3#role{items = Items2, save = [items]}};
                {error,_} ->
                    sender:pack_send(Rs#role.pid_sender, 13025, [2,0,0]),
                    {ok}
            end;
        {error, _} ->
            sender:pack_send(Rs#role.pid_sender, 13025, [4,0,0]),
            {ok}
    end;

%% 新版竞技场增加经验
handle(2050, [Num], Rs) ->
    %% {_Lev1, _Exp1, Rs1} = mod_arena:add_arena_exp(Num, Rs),
    %% {ok, Rs1};
    case Rs#role.coliseum of
        [] -> {ok};
        [A,B,C,D,E,F,G,H] ->
            Rs1 = Rs#role{coliseum = [A,B,C+Num,D,E,F,G,H]},
            lib_role:notice(honor, Rs1),
            ?LOG({honor, Rs#role.id, 3, C, C + Num}),
            {ok, Rs1#role{save = [coliseum]}}
    end;

%% 增加喇叭
handle(2052, [Num], Rs) ->
    Rs1 = lib_role:add_attr(horn, Num, Rs),
    lib_role:notice(horn, Rs1),
    {ok, Rs1};

%% 新邮件通知
handle(2054, [], Rs) ->
    sender:pack_send(Rs#role.pid_sender, 26001, []),
    {ok};

%% 关卡礼包通知
handle(2056, [Id], Rs) ->
    sender:pack_send(Rs#role.pid_sender, 13058, [Id]),
    {ok};

%% 新版竞技场更新role newlev
handle(2059, [NewLev], Rs) ->
    case Rs#role.pid_sender of
        undefined -> {ok};
        Sender ->
            case Rs#role.coliseum of
                [] -> {ok};
                [A,B,C,D,E,F,G,H] ->
                    case B == NewLev of
                        true -> ok;
                        false ->
                            sender:pack_send(Sender, 33040, [1])
                    end,
                    Rs1 = Rs#role{coliseum = [A,NewLev,C,D,E,F,G,H]},
                    {ok, Rs1}
            end
    end;

handle(2060, [Num], Rs) ->
    case Rs#role.pid_sender of
        undefined -> {ok};
        _Sender ->
            case Rs#role.coliseum of
                [] -> {ok};
                [A,B,C,D,E,F,_G,H] ->
                    Time = util:unixtime(),
                    Rs1 = Rs#role{coliseum = [A,B,C+Num,D,E,F,Time,H]},
                    lib_role:notice(honor, Rs1),
                    ?LOG({honor, Rs#role.id, 2, C, C + Num}),
                    {ok, Rs1#role{save = [coliseum]}}
            end
    end;

handle(2061, [Num,Rank], Rs) ->
    if
        Num == 0 ->
            case Rs#role.coliseum of
                [] -> {ok};
                [A,B,C,D,E,F,G,H] ->
                    Rank1 = case F > Rank orelse F == 0 of
                        true -> Rank;
                        false -> F
                    end,
                    Rs0 = Rs#role{coliseum = [A,B,C,D,E,Rank1,G,H]},
                    {ok, Rs0#role{save = [coliseum]}}
            end;
        Num > 0 ->
            Rs1 = lib_role:add_attr(diamond, Num, Rs),
            Rs2 = lib_role:add_attr_ok(diamond, 14, Rs, Rs1),
            lib_role:notice(diamond,Rs2),
            sender:pack_send(Rs#role.pid_sender, 33042, [Num, 0, 0]),
            %% #role{coliseum = Coliseum} = Rs2,
            case Rs2#role.coliseum of
                [] -> {ok, Rs2};
                [A,B,C,D,E,F,G,H] ->
                    %% [A,B,C,D,E,F,G,H] = Coliseum,
                    Rank1 = case F > Rank orelse F == 0 of
                        true -> Rank;
                        false -> F
                    end,
                    Rs3 = Rs2#role{coliseum = [A,B,C,D,E,Rank1,G,H]},
                    {ok, Rs3#role{save = [coliseum]}}
            end;
        true -> {ok}
    end;

%% 新版竞技场更新role newlev
handle(2062, [], Rs) ->
    case Rs#role.pid_sender of
        undefined -> {ok};
        Sender ->
            case Rs#role.coliseum of
                [] -> {ok};
                _ ->
                    sender:pack_send(Sender, 33040, [1]),
                    {ok}
            end
    end;

%% 卸载英雄身上装备
handle(2066, [], Rs) ->
    %% #role{heroes = Heroes, items = Items} = Rs,
    F1 = fun(Hero) ->
            %% 把英雄相应格子上设置为装备ID
            Hero#hero{equ_grids = {0, 0, 0, 0, 0, 0}, changed = 1}
    end,
    F2 = fun(Item) ->
            %% 更新装备上的英雄ID
            Equ2 = case Item#item.tab of
                5 ->
                    Item#item.attr#equ{hero_id = 0};
                _ ->
                    Item#item.attr
            end,
            Item#item{attr = Equ2, changed = 1}
    end,
    Heroes1 = [F1(X) || X <- Rs#role.heroes],
    Items1 = [F2(I) || I <- Rs#role.items],
    {ok, Rs#role{items = Items1, heroes = Heroes1, save = [items,heroes]}};

handle(2067, [Target,Cid,Num], Rs) ->
    Rs1 = mod_task:set_task(Target,{Cid,Num},Rs),
    {ok,Rs1};

%% 新角斗场33025对手信息
handle(2068, [Id, Type], Rs) ->
    case mod_colosseum:get_data(Id) of
        {2, Rid, _Lev, _Exp, _Name, _S} ->
            Heroes = mod_colosseum:init_new_robot(Rid),
            Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
            ?DEBUG("MON:33025:~w", [Data]),
            Rs1 = Rs#role{produce_pass = {3, Type}},
           sender:pack_send(Rs#role.pid_sender, 33025, [0, Id, Data]),
            {ok, Rs1};
        {1, _Rid, _Lev, _Exp, _Name, S} ->
            Heroes = mod_combat:init_monster(S),
            Data = [[Tid, Lev, Hp, Pos, 0] || #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos} <- Heroes],
            ?DEBUG("MON:33025:~w", [Data]),
            Rs1 = Rs#role{produce_pass = {3, Type}},
           sender:pack_send(Rs#role.pid_sender, 33025, [0, Id, Data]),
            {ok, Rs1};
        {0, _Rid, _Lev, _Exp, _Name, S} ->
            ?DEBUG("Role  ******************  **", []),
            Heroes = mod_colosseum:fix_coliseum_pos(S),
            F = fun(EquGrids) ->
                    EquId = element(1, EquGrids),
                    case EquId < 99999 of
                        true -> 0;
                        false -> EquId
                    end
            end,
            Data = [[Tid, Lev, Hp, Pos, F(EquGrids)] ||
                #hero{tid = Tid, lev = Lev, hp = Hp, pos = Pos, equ_grids = EquGrids}
                <- Heroes],
            ?DEBUG("ROLE:33025:~w", [Data]),
            Rs1 = Rs#role{produce_pass = {3, Type}},
            sender:pack_send(Rs#role.pid_sender, 33025, [0, Id, Data]),
            {ok, Rs1};
        {error, Reason} ->
            ?WARN("33025 Id:~w, Type:~w, ERROR:~w", [Id, Type, Reason]),
            sender:pack_send(Rs#role.pid_sender, 33025, [127, 0, []]),
            {ok}
    end;

%% vip 设置
handle(2070, [Num], Rs) ->
    case Rs#role.vip of
        [] -> {ok};
        _ ->
            Rs1 = mod_vip:set_vip(diamond, Num, 0, Rs),
            {ok, Rs1#role{save = [vip]}}
    end;

%% pay double notice
handle(2071, [], Rs) ->
    List = mod_fest:pay_double_info(Rs),
    sender:pack_send(Rs#role.pid_sender,25046,[List]),
    {ok};

%% 活动设置
handle(2072, [FestId, Num], Rs) ->
    #role{activity = Act} = Rs,
    case Act of
        [] ->
            case mod_fest:activity_init(Rs) of
                {ok, Rs1} ->
                    Rs2 = role:save_delay(fest, Rs1),
                    {ok, Rs2};
                {error, Reason} ->
                    ?INFO("repeat init error:~w", [Reason]),
                    {ok, Rs}
            end;
        _ ->
            case lists:keyfind(FestId, 1, Act) of
                false -> {ok};
                {FestId, _V, N, _St} ->
                    case data_fest_prize:get({FestId, N}) of
                        undefined -> {ok};
                        Data ->
                            Cond = util:get_val(condition, Data),
                            case Num >= Cond of
                                true ->
                                    NewAct = lists:keyreplace(FestId, 1, Act, {FestId, Num, N, 1}),
                                    Rs1 = Rs#role{activity = NewAct},
                                    Rs2 = role:save_delay(fest, Rs1),
                                    {ok, Rs2};
                                false -> {ok}
                            end
                    end
            end
    end;

handle(2073, [Tid], Rs) ->
    #role{items = Items} = Rs,
    case mod_item:get_items(Tid, Items) of
        false ->
            ?INFO("no Tid(~w) items", [Tid]),
            {ok};
        ItemL ->
            F = fun(Item,Rt) ->
                    case Item#item.attr of
                        Attr1 when is_record(Attr1, prop) ->
                            [{Item#item.id,Attr1#prop.num}|Rt];
                        Attr2 when is_record(Attr2, equ) ->
                            case Attr2#equ.hero_id of
                                0 ->
                                    [{Item#item.id,1}|Rt];
                                _ -> Rt
                            end;
                        _ -> Rt
                    end
            end,
            DelL = lists:foldl(F,[],ItemL),
            case mod_item:del_items(by_id,DelL,Items) of
                {ok, Items1, Notice} ->
                    mod_item:send_notice(Rs#role.pid_sender, Notice),
                    %% 从数据库中删除物品
                    mod_item:del_items_from_db(Rs#role.id, Notice),
                    {ok, Rs#role{items = Items1, save = [items]}};
                {error, Reason} ->
                    ?WARN("2073 del items error:~w", [Reason]),
                    {ok}
            end
    end;

%% 后台扣除用户钻石
handle(2074, [Type, Num], Rs) ->
    case Type of
        luck ->
            Rs1 = case Rs#role.luck of
                {Star,A,B,C} ->
                    Star1 = Star - Num,
                    case Star1 > 0 andalso Star1 < Star of
                        true ->
                            Rs#role{luck = {Star1,A,B,C}};
                        false -> Rs
                    end;
                _ -> Rs
            end,
            lib_role:notice(luck, Rs1),
            {ok, Rs1};
        _ ->
            case lib_role:spend(Type, Num, Rs) of
                {ok, Rs1} ->
                    case is_pid(Rs#role.pid_sender) of
                        true -> lib_role:notice(Rs1);
                        false -> ok
                    end,
                    Rs2 = lib_role:spend_ok(Type, 46, Rs, Rs1),
                    {ok, Rs2#role{save = [role]}};
                {error, Reason} ->
                    ?WARN("2074 deduct error:~w", [Reason]),
                    {ok}
            end
    end;

handle(2075, [Num], Rs) ->
    {ok, Rs#role{bag_equ_max = Num
            ,bag_prop_max = Num
            ,bag_mat_max = Num}};

handle(2076, [Num], Rs) ->
    case Rs#role.vip of
        [] -> Rs;
        [Vip,Time,Val] ->
            case data_mcard:get(Num) of
                undefined -> {ok};
                Data ->
                    Day = util:get_val(day, Data, 0),
                    First = util:get_val(first, Data, 0),
                    Time1 = util:unixtime(),
                    Time2 = util:unixtime() + Day * 86400,
                    Card = {mcard,Time2,Num,Time1},
                    Val2 = lists:keystore(mcard,1,Val,Card),
                    Rs1 = lib_role:add_attr(diamond, First, Rs),
                    Rs2 = lib_role:add_attr_ok(diamond, 49, Rs, Rs1),
                    lib_role:notice(Rs2),
                    {ok, Rs2#role{vip = [Vip,Time,Val2], save = [vip]}}
            end
    end;

handle(2077, [], Rs) ->
    case Rs#role.loginsign of
        [] -> {ok};
        [_,Type,D1,D2,P] ->
            Yesterday = util:unixtime(yesterday),
            {ok, Rs#role{loginsign = [Yesterday,Type,D1,D2,P]}}
    end;

%%' add buy
handle(2078, [ProductId], Rs) ->
    case data_diamond_shop:get(ProductId) of
    %% case data_diamond_shop:get(binary_to_list(ProductId)) of
        undefined ->
            ?WARN("[ADD_BUY ERROR] Aid: ~s, product_id: ~s", [Rs#role.account_id, ProductId]),
            {ok};
        DiamondData ->
            case util:get_val(diamond, DiamondData) of
                undefined ->
                    ?WARN("[ADD_BUY ERROR] Aid: ~s, Diamond Data: ~w, product_id: ~s", [Rs#role.account_id, DiamondData, ProductId]),
                    {ok};
                Diamond ->
                    RMB = util:get_val(rmb, DiamondData),
                    %% 充值购买钻石成功
                    Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                    case is_pid(Rs#role.pid_sender) of
                        true -> lib_role:notice(Rs1);
                        false -> ok
                    end,
                    Rs2 = lib_role:add_attr_ok(diamond, 35, Rs, Rs1),
                    %% PurchaseDate = util:get_val(purchase_date_ms, ReceiptData, <<>>),
                    Bvrs = case env:get(version) of
                        undefined -> "1.4.0";
                        Bvrss -> Bvrss
                    end,
                    db:execute("INSERT INTO `app_store`(`role_id`, `transaction_id`, `product_id`, `purchase_date`, `bvrs`, `diamond`, `rmb`, `ctime`) "
                        "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s);", [Rs#role.id, 1, ProductId, util:unixtime() * 1000, Bvrs, Diamond, RMB, util:unixtime()]),
                    ?INFO("[IN_APP_PURCHASE OK] Account: ~s, ProductId: ~s", [Rs#role.account_id, ProductId]),
                    %% 土豪成就
                    Rs3 = mod_attain:attain_state(33, RMB, Rs2),
                    %% firstpay double
                    %% Rs4 = case util:get_val(double, DiamondData) of
                    %%     1 -> mod_fest:firstpay(Rs3, Diamond);
                    %%     _ -> Rs3
                    %% end,
                    Rs4 = mod_fest:pay_double(Rs3, DiamondData),
                    %% 首充推送
                    {Rs5, FirstPaySt} = mod_fest:activity_first_pay(Rs4),
                    case FirstPaySt =:= 0 of
                        true ->
                            case Rs#role.pid_sender of
                                undefined -> ok;
                                _ ->
                                    sender:pack_send(Rs#role.pid_sender, 25032, [0])
                            end;
                        false -> ok
                    end,
                    %% vip 充值钻石累加
                    Rs6 = mod_vip:set_vip(diamond, Diamond, 0, Rs5),
                    %% lib_admin:new_server_active(Diamond, Rs#role.id),
                    %% month card
                    Rs7 = mod_vip:set_mcard(Rs6, DiamondData),
                    %% lib_admin:android_server_active4(Rs#role.id, RMB),
                    extra:set_use(rmb,RMB,Rs#role.id),
                    SaveState = Rs7#role.save,
                    {ok, Rs7#role{save = [role, vip] ++ SaveState}}
            end
    end;
%%.

%%' ios pay
handle(2087, [<<"ios">>, Receipt, Rand, Signature, TryNum], Rs) ->
    #role{id = Rid, account_id = Aid, pid_sender = Sender} = Rs,
    case lib_role:in_app_purchase_check(Receipt) of
        {ok, ReceiptData} ->
            ProductId = util:get_val(product_id, ReceiptData, <<>>),
            TransactionId = util:get_val(transaction_id, ReceiptData, <<>>),
            Bvrs = util:get_val(bvrs, ReceiptData, <<>>),
            ChkSql = "select count(*) from app_store where role_id = ~s and transaction_id = ~s",
            SignatureChkStr = list_to_binary([
                    integer_to_list(env:get(server_id))
                    ,env:get(server_key)
                    ,Aid
                    ,integer_to_list(Rand)
                ]),
            SignatureChk = util:md5(SignatureChkStr),
            if
                Signature =/= SignatureChk ->
                    %% 签名不正确
                    ?DEBUG("Signature:~s", [Signature]),
                    ?DEBUG("SignatureChk:~s", [SignatureChk]),
                    ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Signature:~s~nSignatureChk:~s", [Aid, Signature, SignatureChk]),
                    sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                    {ok};
                true ->
                    case db:get_one(ChkSql, [Rid, TransactionId]) of
                        {ok, 0} ->
                            case data_diamond_shop:get(binary_to_list(ProductId)) of
                                undefined ->
                                    ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, product_id: ~s~nReceipt:~n~s", [Aid, ProductId, Receipt]),
                                    sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                                    {ok};
                                DiamondData ->
                                    case util:get_val(diamond, DiamondData) of
                                        undefined ->
                                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Diamond Data: ~w, product_id: ~s~nReceipt:~n~s", [Aid, DiamondData, ProductId, Receipt]),
                                            sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                                            {ok};
                                        Diamond ->
                                            RMB = util:get_val(rmb, DiamondData),
                                            %% 充值购买钻石成功
                                            Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                                            case is_pid(Rs#role.pid_sender) of
                                                true -> lib_role:notice(Rs1);
                                                false -> ok
                                            end,
                                            Rs2 = lib_role:add_attr_ok(diamond, 35, Rs, Rs1),
                                            PurchaseDate = util:get_val(purchase_date_ms, ReceiptData, <<>>),
                                            PlatformCode = case util:find_platform(<<"ios">>) of
                                                false -> 0;
                                                {PlatformC,_} -> PlatformC
                                            end,
                                            db:execute("INSERT INTO `app_store`(`role_id`, `transaction_id`, `product_id`, `purchase_date`, `bvrs`, `platform`, `diamond`, `rmb`, `ctime`) "
                                                "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s);", [Rs#role.id, TransactionId, ProductId, PurchaseDate, Bvrs, PlatformCode, Diamond, RMB, util:unixtime()]),
                                            ?INFO("[IN_APP_PURCHASE OK] Account: ~s, ProductId: ~s", [Aid, ProductId]),
                                            %% 土豪成就
                                            Rs3 = mod_attain:attain_state(33, RMB, Rs2),
                                            %% firstpay double
                                            %% Rs4 = case util:get_val(double, DiamondData) of
                                            %%     1 -> mod_fest:firstpay(Rs3, Diamond);
                                            %%     _ -> Rs3
                                            %% end,
                                            Rs4 = mod_fest:pay_double(Rs3, DiamondData),
                                            %% 首充推送
                                            {Rs5, FirstPaySt} = mod_fest:activity_first_pay(Rs4),
                                            case FirstPaySt =:= 0 of
                                                true ->
                                                    sender:pack_send(Sender, 25032, [0]);
                                                false -> ok
                                            end,
                                            %% vip 充值钻石累加
                                            Rs6 = mod_vip:set_vip(diamond, Diamond, 0, Rs5),
                                            %% lib_admin:new_server_active(Diamond, Rs#role.id),
                                            %% month card
                                            Rs7 = mod_vip:set_mcard(Rs6, DiamondData),
                                            SaveState = Rs7#role.save,
                                            sender:pack_send(Rs#role.pid_sender, 10011, [0]),
                                            %% lib_admin:android_server_active4(Rs#role.id, RMB),
                                            extra:set_use(rmb,RMB,Rs#role.id),
                                            {ok, Rs7#role{save = [role, vip] ++ SaveState}}
                                    end
                            end;
                        {ok, Count} ->
                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Resubmit Receipt: ~w~nReceipt:~n~s", [Aid, Count, Receipt]),
                            sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                            {ok};
                        {error, Reason} ->
                            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, ~w~nReceipt:~n~s", [Aid, Reason, Receipt]),
                            case TryNum =< 5 of
                                true ->
                                    Ms = 1000 + TryNum * 1000,
                                    ?INFO("Request error(~w), The ~wth retry after ~wms ...", [Reason, TryNum + 1, Ms]),
                                    erlang:send_after(Ms, self(), {pt, 2087, [<<"ios">>, Receipt, Rand, Signature, TryNum + 1]}),
                                    {ok};
                                false ->
                                    ?WARN("Request(~s) still error(~w), after retry ~w times!", [Receipt, Reason, TryNum]),
                                    sender:pack_send(Rs#role.pid_sender, 10011, [2]),
                                    {ok}
                            end
                    end
            end;
        {error, {bid, Reason}} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, Bid: ~s", [Aid, Reason]),
            sender:pack_send(Rs#role.pid_sender, 10011, [1]),
            {ok};
        {error, {httpc_request, Reason}} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, httpc_request: ~w, ~nReceipt:~n~s", [Aid, Reason, Receipt]),
            case TryNum =< 5 of
                true ->
                    Ms = 1000 + TryNum * 1000,
                    ?INFO("Request error(~w), The ~wth retry after ~wms ...", [Reason, TryNum + 1, Ms]),
                    erlang:send_after(Ms, self(), {pt, 2087, [<<"ios">>, Receipt, Rand, Signature, TryNum + 1]}),
                    {ok};
                false ->
                    ?WARN("Request(~s) still error(~w), after retry ~w times!", [Receipt, Reason, TryNum]),
                    sender:pack_send(Rs#role.pid_sender, 10011, [2]),
                    {ok}
            end;
        {error, Reason} ->
            ?WARN("[IN_APP_PURCHASE ERROR] Aid: ~s, ~w, ~nReceipt:~n~s", [Aid, Reason, Receipt]),
            sender:pack_send(Rs#role.pid_sender, 10011, [1]),
            {ok}
    end;
%%.

%%' android pay
handle(2088, [Platform, Receipt, TryNum], Rs) ->
    #role{account_id = Aid, pid_sender = Sender} = Rs,
    case get(success_charge_order_id) of
        Receipt ->
            %% 本订单已经成功发货
            ?INFO("Order(~s) already done!", [Receipt]),
            %% 让客户端提示成功
            sender:pack_send(Sender, 10011, [0]),
            {ok};
        _ ->
            case binary:split(Receipt, <<"-">>) of
                [ShopIdBin, _ServerId_UserId_Time] ->
                    case shopid2shopdata(binary_to_list(ShopIdBin)) of
                        {error, Error} ->
                            ?WARN("[PURCHASE ERROR] Aid: ~s, Receipt:~s, Error:~w", [Aid, Receipt, Error]),
                            {ok};
                        DiamondData ->
                            ShopId = util:get_val(shopid, DiamondData),
                            Diamond = util:get_val(diamond, DiamondData),
                            case purchase_check(Platform, Receipt) of
                                {ok, Money} ->
                                    RMB = util:get_val(rmb, DiamondData),
                                    %% 充值购买钻石成功
                                    Rs1 = lib_role:add_attr(diamond, Diamond, Rs),
                                    case is_pid(Rs#role.pid_sender) of
                                        true -> lib_role:notice(Rs1);
                                        false -> ok
                                    end,
                                    Rs2 = lib_role:add_attr_ok(diamond, 35, Rs, Rs1),
                                    ?INFO("[UNION PURCHASE OK] Account: ~s, ShopId: ~w money:~w, diamond:~w", [Aid, ShopId, Money / 100, Diamond]),
                                    %% 土豪成就
                                    Rs3 = mod_attain:attain_state(33, RMB, Rs2),
                                    %% firstpay double
                                    %% Rs4 = case util:get_val(double, DiamondData) of
                                    %%     1 -> mod_fest:firstpay(Rs3, Diamond);
                                    %%     _ -> Rs3
                                    %% end,
                                    Rs4 = mod_fest:pay_double(Rs3, DiamondData),
                                    %% 首充推送
                                    {Rs5, FirstPaySt} = mod_fest:activity_first_pay(Rs4),
                                    case FirstPaySt =:= 0 of
                                        true ->
                                            sender:pack_send(Sender, 25032, [0]);
                                        false -> ok
                                    end,
                                    %% vip 充值钻石累加
                                    Rs6 = mod_vip:set_vip(diamond, Diamond, 0, Rs5),
                                    %% lib_admin:new_server_active(Diamond, Rs#role.id),
                                    %% month card
                                    Rs7 = mod_vip:set_mcard(Rs6, DiamondData),
                                    %% lib_admin:android_server_active4(Rs#role.id, RMB),
                                    extra:set_use(rmb,RMB,Rs#role.id),
                                    sender:pack_send(Rs#role.pid_sender, 10011, [0]),
                                    SaveState = Rs7#role.save,
                                    Now = util:unixtime(),
                                    PlatformCode = case util:find_platform(Platform) of
                                        false -> 0;
                                        {PlatformC,_} -> PlatformC
                                    end,
                                    %% 日志
                                    db:execute("INSERT INTO `app_store`(`role_id`, `transaction_id`, `product_id`, `purchase_date`, `bvrs`, `platform`, `diamond`, `rmb`, `ctime`) "
                                        "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s);", [Rs#role.id, Receipt, ShopId, Now * 1000, data_config:get(version), PlatformCode, Diamond, RMB, Now]),
                                    %% ###################################################
                                    %% 缓存已成功发货的订单号
                                    put(success_charge_order_id, Receipt),
                                    %% ###################################################
                                    {ok, Rs7#role{save = [role, vip] ++ SaveState}};
                                {error, {status, 1}} ->
                                    %% 订单已验证过了，返回0，让客户端提示成功
                                    ?INFO("Order(~s) is verified!", [Receipt]),
                                    sender:pack_send(Rs#role.pid_sender, 10011, [0]),
                                    {ok};
                                {error, {status, 6}} ->
                                    case TryNum =< 5 of
                                        true ->
                                            Ms = 1000 + TryNum * 1000,
                                            ?INFO("Order(~s) not found, The ~wth retry after ~wms ...", [Receipt, TryNum + 1, Ms]),
                                            erlang:send_after(Ms, self(), {pt, 2088, [Platform, Receipt, TryNum + 1]}),
                                            {ok};
                                        false ->
                                            ?WARN("Order(~s) still not found, after retry ~w times!", [Receipt, TryNum]),
                                            %% 可能平台还没回调，下次登陆时客户端继续尝试
                                            sender:pack_send(Rs#role.pid_sender, 10011, [2]),
                                            {ok}
                                    end;
                                {error, {httpc_request, ErrorType}} ->
                                    case TryNum =< 5 of
                                        true ->
                                            Ms = 1000 + TryNum * 1000,
                                            ?INFO("Request error(~w), The ~wth retry after ~wms ...", [ErrorType, TryNum + 1, Ms]),
                                            erlang:send_after(Ms, self(), {pt, 2088, [Platform, Receipt, TryNum + 1]}),
                                            {ok};
                                        false ->
                                            ?WARN("Request(~s) still error(~w), after retry ~w times!", [Receipt, ErrorType, TryNum]),
                                            sender:pack_send(Rs#role.pid_sender, 10011, [2]),
                                            {ok}
                                    end;
                                {error, Error} ->
                                    ?WARN("[PURCHASE ERROR] Aid: ~s Receipt:~s Error:~w", [Aid, Receipt, Error]),
                                    sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                                    {ok}
                            end
                    end;
                E ->
                    ?WARN("[PURCHASE ERROR] Aid: ~s Receipt:~s E:~w", [Aid, Receipt, E]),
                    sender:pack_send(Rs#role.pid_sender, 10011, [1]),
                    {ok}
            end
    end;
%%.

handle(_Cmd, _Data, _Rs) ->
    {error, bad_request}.

%% === 私有函数 ===

shopid2shopdata([$0 | ShopIdList]) ->
    case catch list_to_integer(ShopIdList) of
        {'EXIT', Error} -> {error, Error};
        Diamond ->
            Rmb = Diamond div 10,
            Data = data_diamond_shop:get("card"),
            Data2 = lists:keyreplace(rmb, 1, Data, {rmb, Rmb}),
            lists:keyreplace(diamond, 1, Data2, {diamond, Diamond})
    end;
shopid2shopdata(ShopIdList) ->
    ?INFO("shopid2shopdata:~w", [ShopIdList]),
    case catch list_to_integer(ShopIdList) of
        {'EXIT', Error} -> {error, Error};
        ShopId ->
            Ids = data_diamond_shop:get(ids),
            shopid2shopdata1(Ids, ShopId)
    end.

shopid2shopdata1([Id | T], ShopId) ->
    Data = data_diamond_shop:get(Id),
    case lists:member({shopid, ShopId}, Data) of
        true -> Data;
        false -> shopid2shopdata1(T, ShopId)
    end;
shopid2shopdata1([], _) -> {error, undefined}.

purchase_check(Platform, RecvReceipt) ->
    Now = util:unixtime(),
    NowL = integer_to_list(Now),
    Key = "oyKhRmKDDd8lA1AASD6FxlrrOjWlZ",
    PlatformL = binary_to_list(Platform),
    RecvReceiptL = binary_to_list(RecvReceipt),
    Sign = binary_to_list(util:md5(PlatformL ++ NowL ++ Key ++ RecvReceiptL)),
    CallbackURL = case Platform of
        <<"a_fun">> -> "http://211.72.249.246/charge.php";
        _ -> "http://42.62.14.78/charge.php"
    end,
    Query = CallbackURL ++ "?mod=verify&platform="++PlatformL++"&time="++NowL++"&sign="++Sign++"&myOrderId=" ++ RecvReceiptL,
    try httpc:request(get, {Query, []}, [{timeout, 4000}], []) of
        {error, Reason} ->
            {error, {httpc_request, Reason}};
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Kvs}, _} ->
                    case lists:keyfind("status", 1, Kvs) of
                        {"status", 0} ->
                            case lists:keyfind("money", 1, Kvs) of
                                {"money", Money} -> {ok, Money};
                                Else -> {error, {find_money, Else}}
                            end;
                        {"status", RecvCode} ->
                            %% 订单不存在 {"status", 6}
                            {error, {status, RecvCode}};
                        Else ->
                            {error, {find_status, Else}}
                    end;
                Error ->
                    {error, {decode, Error}}
            end;
        Error ->
            {error, {httpc_request, Error}}
        catch X:Y ->
            {error, {catch_error, X, Y}}
    end.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
