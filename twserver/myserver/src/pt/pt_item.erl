%%----------------------------------------------------
%% $Id: pt_item.erl 13210 2014-06-05 08:41:45Z piaohua $
%% @doc 协议13 - 物品相关
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(pt_item).
-export([handle/3]).

-include("common.hrl").
-include("equ.hrl").
-include("prop.hrl").
-include("hero.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_jewel_pick_test() ->
    Ids1 = data_jewel:get(ids),
    Ids2 = data_jewel_pick:get(ids),
    ?assert(Ids1 == Ids2),
    lists:foreach(fun(Id) ->
                Data = data_jewel_pick:get(Id),
                Type = util:get_val(type, Data, 0),
                Num  = util:get_val(num, Data, 0),
                ?assert(Type > 0 andalso Num > 0)
        end, Ids2),
    ok.

data_tollgate_prize_test() ->
    Ids = data_tollgate_prize:get(ids),
    ?assert(Ids =/= []),
    lists:foreach(fun(Id) ->
                Data = data_tollgate_prize:get(Id),
                Prize = util:get_val(prize, Data, []),
                ?assert(Prize =/= []),
                lists:foreach(fun({Tid,Num}) ->
                            ?assertMatch(ok,case Tid < ?MIN_EQU_ID of
                                    true ->
                                        case Tid == 5 of
                                            true ->
                                                ?assert(is_tuple(Num)),
                                                {Hid,_} = Num,
                                                ?assert(data_hero:get(Hid) =/= undefined),
                                                ok;
                                            false ->
                                                ?assert(data_prop:get(Tid) =/= undefined),
                                                ok
                                        end;
                                    false ->
                                        ?assert(data_equ:get(Tid) =/= undefined),
                                        ok
                                end) end, Prize)
        end, Ids),
    ok.

data_picture_test() ->
    Ids = data_picture:get(ids),
    ?assert(Ids =/= []),
    ok.

data_jewel_lev_test() ->
    Ids = data_jewel_lev:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                {Lev,Q} = Id,
                ?assert(Lev > 0),
                ?assert(Q > 0),
                Data = data_jewel_lev:get(Id),
                Exp = util:get_val(exp,Data,0),
                Expend = util:get_val(expend,Data,0),
                Provide = util:get_val(provide,Data,0),
                ?assert(Exp > 0),
                ?assert(Expend > 0),
                ?assert(Provide > 0)
        end, Ids),
    ok.

data_forge_test() ->
    Ids = data_forge:get(ids),
    ?assert(Ids =/= []),
    ?assertMatch(ok, data_forge_test1(Ids)),
    %% {Send,_Rate,Del,_Type,_Price,_Dels} = data_forge:get(Tid),
    ok.

data_forge_test1([]) -> ok;
data_forge_test1([Id|Ids]) ->
    {Send,Rate,Del,Type,Price,Dels} = data_forge:get(Id),
    ?assertMatch(ok,case Id < ?MIN_EQU_ID of
            true ->
                ?assert(data_prop:get(Id) =/= undefined),
                ok;
            false ->
                ?assert(data_equ:get(Id) =/= undefined),
                ok
        end),
    ?assert(lists:member(Send,[1,2])),
    ?assert(Rate > 0),
    ?assert(lists:member(Del, [1,2])),
    ?assert(lists:member(Type, [1,2])),
    ?assert(Price > 0),
    ?assertMatch(ok,data_forge_test2(Dels)),
    data_forge_test1(Ids).

data_forge_test2([]) -> ok;
data_forge_test2([{Id,Num}|T]) ->
    ?assertMatch(ok,case Id < ?MIN_EQU_ID of
            true ->
                ?assert(data_prop:get(Id) =/= undefined),
                ok;
            false ->
                ?assert(data_equ:get(Id) =/= undefined),
                ok
        end),
    ?assert(Num > 0),
    data_forge_test2(T).

-endif.

%% 请求玩家所有物品
handle(13001, [1], Rs) ->
    F = fun(I, {Es, Ps}) ->
            case I#item.tid > 99999 of
                true -> {[mod_item:pack_equ(I)|Es], Ps};
                false -> {Es, [mod_item:pack_prop(I)|Ps]}
            end
    end,
    {Data1, Data2} = lists:foldl(F, {[],[]}, Rs#role.items),
    {ok, [1, Data1, Data2]};
%% 请求战斗掉落物品
handle(13001, [2], Rs) ->
    case data_tollgate:get(Rs#role.produce_pass) of
        undefined ->
            ?WARN("Error pass: ~w", [Rs#role.produce_pass]),
            {ok, [2, [], []]};
        Data ->
            %% 请求extra produce
            {T, _} = Rs#role.produce_pass,
            ExtraProduce = lib_system:extra_product(T),
            Produce = util:get_val(produce, Data) ++ ExtraProduce,
            Gold = util:get_val(gold, Data, 0),
            Ids = get_produce_ids(Produce, []),
            case mod_item:add_items(Rs#role{produce_pass = undefined}, Ids) of
                {ok, Rs1, Prop, Equ} ->
                    Data1 = [mod_item:pack_equ(X) || X <- Equ],
                    Data2 = [mod_item:pack_prop(X) || X <- Prop],
                    Rs2 = lib_role:add_attr(gold, Gold, Rs1),
                    lib_role:notice(gold, Rs2),
                    Type = 11 + element(1, Rs#role.produce_pass),
                    Rs0 = lib_role:add_attr_ok(gold, Type, Rs, Rs2),
                    {ok, [2, Data1, Data2], Rs0};
                %% TODO:背包已满
                {error, full} ->
                    Title = data_text:get(2),
                    Body = data_text:get(4),
                    sender:send_error(Rs#role.pid_sender, 1008),
                    mod_mail:new_mail(Rs#role.id, 0, 12, Title, Body, Ids),
                    ?DEBUG("bag full", []),
                    {ok, [2, [], []]};
                {error, Reason} ->
                    ?WARN("produce error: ~w", [Reason]),
                    {ok, [2, [], []]}
            end
    end;

handle(13003, [Data], Rs) ->
    ?DEBUG("set equ: ~w", [Data]),
    case equ_handle(Data, Rs) of
        {ok, Rs1} -> {ok, [0], Rs1};
        {error, Reason} -> {ok, [Reason]}
    end;

%%' 装备强化
%% -> [Code, EquId, Level, RestTime, Pay]
%% Code:
%% 1 = 强化失败（注：不是错误）
%% 2 = 金币不足
%% 3 = 疲劳CD
%% 4 = 材料不足
%% 5 = 已到最高等级
%% >=127 = 异常
handle(13005, [EquId, EnId1, EnId2, EnId3, Pay], Rs) ->
    ?DEBUG("====EquId:~w, EnId1:~w, EnId2:~w, EnId3:~w ", [EquId, EnId1, EnId2, EnId3]),
    Items = Rs#role.items,
    Dels = [X || X <- [EnId1, EnId2, EnId3], X > 0],
    case lists:sum([EnId1,EnId2, EnId3]) > 0 of
        true ->
            case mod_item:get_item(EquId, Items) of
                false -> {ok, [127, 0, 0, 0]};
                EquItem ->
                    #item{sort = Sort, attr = Attr, tid = Tid} = EquItem,
                    #equ{lev = Lev, atime = ATime} = Attr,
                    ?DEBUG("===sort:~w, tid:~w, lev:~w", [Sort, Tid, Lev]),
                    RestTime = mod_item:get_strengthen_rest_time(ATime),
                    EquData = data_equ:get(Tid),
                    EnhanceLimit = case util:get_val(enhance_limit,EquData) of
                        undefined ->
                            StrengthenIds = data_strengthen:get(ids),
                            case lists:keyfind(Sort,1,StrengthenIds) of
                                false -> Lev;
                                _ -> length(util:find_all_repeat_key_element(Sort,1,StrengthenIds))
                            end;
                        LevLimit -> LevLimit
                    end,
                    if
                        EquData =:= undefined ->
                            {ok, [128, 0, 0, 0]};
                        RestTime > 0, Pay == 0 ->
                            {ok, [3, 0, 0, 0]};
                        EnhanceLimit < Lev orelse EnhanceLimit == 0 ->
                            {ok, [7, 0, 0, 0]};
                        true ->
                            case data_strengthen:get({Sort, Lev+1}) of
                                [{Gold, AddTime, RateF, Rise}] ->
                                    F = fun(Id) ->
                                            case Id > 0 of
                                                true ->
                                                    case data_enhance_rate:get({Lev + 1, Id}) of
                                                        undefined -> 0;
                                                        N -> N
                                                    end;
                                                false -> 0
                                            end
                                    end,
                                    RateSum = lists:sum([F(Id) || Id <- [EnId1, EnId2, EnId3]]),
                                    %% EquData = data_equ:get(EquId),
                                    RateRise = util:get_val(enhance_rate_arg, EquData),%% 强化成功系数
                                    GoldRise = util:get_val(enhance_gold_arg, EquData),%% 强化金币系数
                                    ?DEBUG("=====Gold:~w, GoldRise:~w, RateRise:~w, RateSum:~w", [Gold, GoldRise, RateRise, RateSum]),
                                    GoldVal = util:ceil(Gold * GoldRise),
                                    ?DEBUG("====GoldVal:~w, GoldRise:~w", [GoldVal, GoldRise]),
                                    Rate = util:ceil(RateSum * RateRise),
                                    Diamond = case RestTime > 0 of
                                        true ->
                                            %% 按时间计算扣费额
                                            Unit = data_config:get(diamond_per_min),
                                            util:ceil(RestTime / 60 * Unit);
                                        false -> 0
                                    end,
                                    case lib_role:spend(gold, GoldVal, Rs) of
                                        {ok, Rs1} ->
                                            case lib_role:spend(diamond, Diamond, Rs1) of
                                                {ok, Rs2} ->
                                                    case mod_item:del_items(by_tid, Dels, Items) of
                                                        {ok, Items1, Notice} ->
                                                            case mod_item:strengthen(EquItem, Rate, RateF, Rise, AddTime) of
                                                                {ok, Status, EquItem1} ->
                                                                    NewLev = EquItem1#item.attr#equ.lev,
                                                                    Items2 = mod_item:set_item(EquItem1, Items1),
                                                                    Rs3 = Rs2#role{items = Items2, save = [role, items]},
                                                                    %% 物品删除通知
                                                                    mod_item:send_notice(Rs#role.pid_sender, Notice),
                                                                    %% 通知货币更新
                                                                    lib_role:notice(Rs3),
                                                                    %% 强化成就推送
                                                                    Rs4 = case Status of
                                                                        0 ->
                                                                            %% 强化成功公告
                                                                            case NewLev >= 8 of
                                                                                true ->
                                                                                    %% Msg = "恭喜“~s”玩家经过不懈努力,成功将其“[{equ, ~w}]”装备,强化至+~w.太吓人了!",
                                                                                    Name = lib_admin:get_name(Rs),
                                                                                    Vip = lib_admin:get_vip(Rs),
                                                                                    Msg = data_text:get(5),
                                                                                    Msg1 = io_lib:format(Msg, [Name, Tid, NewLev]),
                                                                                    lib_system:cast_sys_msg(0, Name, Msg1, Vip);
                                                                                false ->
                                                                                    ok
                                                                            end,
                                                                            Rs3_ = mod_attain:attain_state(14, 1, Rs3),
                                                                            mod_task:set_task(18,{1,1},Rs3_);
                                                                        1 -> mod_attain:attain_state(16, 1, Rs3);
                                                                        _ -> Rs3
                                                                    end,
                                                                    Rs5 = case NewLev of
                                                                        5 ->
                                                                            mod_attain:attain_state(78, 1, Rs4);
                                                                        _ -> Rs4
                                                                    end,
                                                                    Rs6 = case Diamond > 0 of
                                                                        true ->
                                                                            mod_attain:attain_state(29, 1, Rs5);
                                                                            %% mod_attain:attain_state(52, 1, Rs5);
                                                                        false -> Rs5
                                                                    end,
                                                                    Rs7 = mod_attain:attain_state(42, 1, Rs6),
                                                                    Rs8 = lib_role:spend_ok(gold, 1, Rs, Rs7),
                                                                    Rs9 = lib_role:spend_ok(diamond, 1, Rs, Rs8),
                                                                    Rs0 = mod_task:set_task(3,{1,1},Rs9),
                                                                    %% 一切都OK后，从数据库中删除物品
                                                                    mod_item:del_items_from_db(Rs0#role.id, Notice),
                                                                    ?LOG({enhance, Rs0#role.id, Tid, NewLev, Status}),
                                                                    {ok, [Status, EquId, EquItem1#item.attr#equ.lev, AddTime], Rs0};
                                                                {error, Reason} ->
                                                                    ?ERR("~w", [Reason]),
                                                                    {ok, [129, 0, 0, 0]}
                                                            end;
                                                        {error, _} ->
                                                            {ok, [4, 0, 0, 0]}
                                                    end;
                                                {error, _} ->
                                                    {ok, [6, 0, 0, 0]}
                                            end;
                                        {error, _} ->
                                            {ok, [2, 0, 0, 0]}
                                    end;
                                undefined ->
                                    {ok, [5, 0, 0, 0]};
                                _Data ->
                                    ?WARN("undefined strengthen data: ~w", [_Data]),
                                    {ok, [5, 0, 0, 0]}
                            end
                    end
            end;
        false ->
            {ok, [130, 0, 0, 0]}
    end;
%%.

handle(13006, [EquId], Rs) ->
    Items = Rs#role.items,
    case mod_item:get_item(EquId, Items) of
        false -> {ok, [127, 0]};
        EquItem ->
            #item{attr = Attr} = EquItem,
            #equ{atime = ATime} = Attr,
            RestTime = mod_item:get_strengthen_rest_time(ATime),
            RestTime1 = case RestTime < 0 of
                true -> 0;
                false -> RestTime
            end,
            %% ?DEBUG("RestTime:~w", [RestTime]),
            {ok, [0, RestTime1]}
    end;

%% 当SORT为4时
%% 1,攻击
%% 2,血量
%% 3,防御
%% 4,穿刺
%% 5,命中
%% 6,闪避
%% 7,暴击
%% 8,暴强
%% 9,免爆
%% 10,韧性

%%' 镶嵌
%% -> [Code, EquId]
%% Code:
%% 0 = 成功
%% 1 = 镶嵌失败（注：不是错误）
%% 2 = 金币不足
%% 3 = 钻石不足
%% 4 = 装备的孔不足
%% >=127 = 程序异常
%% handle(13010, [EquId, GemTid], Rs) ->
handle(13010, [EquId, GemId], Rs) ->
    Items = Rs#role.items,
    EquItem = mod_item:get_item(EquId, Items),
    %% 宝珠堆叠数为1了,这里GemTid改成唯一id
    GemItem = mod_item:get_item(GemId, Items),
    %% GemItem = mod_item:get_less_prop(Items, GemTid),
    % ?DEBUG("==GemItem:~w, tid:~w ", [GemItem, GemItem#item.tid]),
    if
        EquItem == false ->
            {ok, [127, 0]};
        GemItem == false ->
            {ok, [128, 0]};
        EquItem#item.tid < ?MIN_EQU_ID ->
            {ok, [129, 0]};
        GemItem#item.tid > ?MIN_EQU_ID ->
            {ok, [130, 0]};
        GemItem#item.sort =/= 4 ->
            {ok, [131, 0]};
        EquItem#item.attr#equ.sockets < 0 ->
            {ok, [132, 0]};
        true ->
            %% #item{tid = GemTid, attr = GemAttr} = GemItem,
            #item{id = GemId, tid = GemTid, attr = GemAttr} = GemItem,
            JewelData = data_jewel:get(GemAttr#prop.quality),
            Currency = util:get_val(money1, JewelData),
            Num = util:get_val(num1, JewelData),
            {CType, RtCode} = case Currency of
                1 -> {gold, 2};
                2 -> {diamond, 3}
            end,
            case lib_role:spend(CType, Num, Rs) of
                {ok, Rs1} ->
                    %% case mod_item:del_items(by_tid, [{GemTid, 1}], Items) of
                    case mod_item:del_items(by_id, [{GemId, 1}], Items) of
                        {ok, Items1, Notice} ->
                            case mod_item:embed(EquItem, GemItem) of
                                {ok, EquItem1} ->
                                    Items2 = mod_item:set_item(EquItem1, Items1),
                                    Rs2 = Rs1#role{items = Items2, save = [role, items]},
                                    mod_item:send_notice(Rs#role.pid_sender, Notice),
                                    mod_item:send_notice(Rs#role.pid_sender, [], [EquItem1]),
                                    lib_role:notice(Rs2),
                                    %% 成就推送
                                    Rs3 = mod_attain:attain_state(47, 1, Rs2),
                                    Rs4 = lib_role:spend_ok(CType, 2, Rs, Rs3),
                                    Rs0 = mod_task:set_task(4,{1,1},Rs4),
                                    %% 一切都OK后，从数据库中删除物品
                                    mod_item:del_items_from_db(Rs#role.id, Notice),
                                    ?LOG({embed, Rs#role.id, EquItem#item.tid, GemTid}),
                                    {ok, [0, EquId], Rs0};
                                {error, no_sock} ->
                                    {ok, [4, EquId]};
                                {error, quality} ->
                                    {ok, [135, EquId]};
                                {error, Reason} ->
                                    ?ERR("~w", [Reason]),
                                    {ok, [136, 0]}
                            end;
                        {error, _} ->
                            {ok, [RtCode, 0]}
                    end;
                {error, _} ->
                    {ok, [2, 0]}
            end
    end;
%%.

%%' 宝珠拆卸
%% 等级和经验要不变(level,exp),
%% -> [Code, EquId]
%% Code:
%% 0 = 成功
%% 1 = 卸载失败（注：不是错误）
%% 2 = 钻石不足
%% 3 = 背包已满
%% >=127 = 程序异常
handle(13011, [EquId, GemTid], Rs) ->
    Data1 = data_prop:get(GemTid),
    Q = util:get_val(quality, Data1),
    Data2 = data_jewel_pick:get(Q),
    case Data2 =/= undefined of
        true ->
            {CType, RtCode} = case util:get_val(type, Data2) of
                1 -> {gold, 1};
                2 -> {diamond, 2}
            end,
            Num = util:get_val(num, Data2),
            case mod_item:get_item(EquId, Rs#role.items) of
                false -> {ok, [131]};
                Item ->
                    {Code, EquItem, Lev, Exp, Rs1} = unembed(Item, GemTid, Rs),
                    case Code == 0 of
                        true ->
                            case lib_role:spend(CType, Num, Rs1) of
                                {ok, Rs2} ->
                                    %% TODO:add_item加物品不会保留原有物品属性
                                    case mod_item:add_item(Rs2, GemTid, 1) of
                                        {ok, Rs3, PA, EA} ->
                                            %% ?DEBUG("PA:~w, EA:~w", [PA, EA]),
                                            %% 添加物品的唯一id,有可能错误应该改进
                                            %% Id = Rs3#role.max_item_id,
                                            %% PA  返回里面有id
                                            %% [PAItem|_] = PA,
                                            %% Id = PAItem#item.id,
                                            [#item{id = Id} | _] = EA ++ PA,
                                            case mod_item:get_item(Id,Rs3#role.items) of
                                                false ->
                                                    {ok, [132]};
                                                Item2 ->
                                                    Attr2 = Item2#item.attr#prop{level = Lev, exp = Exp},
                                                    Item3 = Item2#item{attr = Attr2, changed = 1},
                                                    Items3 = mod_item:set_item(Item3,Rs3#role.items),
                                                    %% mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                                                    mod_item:send_notice(Rs#role.pid_sender, [Item3], [EquItem]),
                                                    Rs4 = lib_role:spend_ok(CType, 37, Rs, Rs3),
                                                    lib_role:notice(Rs4),
                                                    {ok, [0], Rs4#role{items = Items3}}
                                            end;
                                        {error, full} ->
                                            %% Title = data_text:get(2),
                                            %% Body = data_text:get(4),
                                            %% mod_mail:new_mail(Rs#role.id, 0, 37, Title, Body, [{GemTid,1}]),
                                            %% mod_item:send_notice(Rs#role.pid_sender, [], [EquItem]),
                                            %% Rs3 = lib_role:spend_ok(CType, 37, Rs, Rs2),
                                            %% lib_role:notice(Rs3),
                                            %% {ok, [3], Rs3#role{save = [items]}};
                                            {ok, [3]};
                                        {error, _} ->
                                            {ok, [130]}
                                    end;
                                {error, _} ->
                                    {ok, [RtCode]}
                            end;
                        false -> {ok, [Code]}
                    end
            end;
        false ->
            {ok, [127]}
    end;
%%.

%%' 合成
%% -> [Code]
%% Code:
%% 0 = 成功
%% 1 = 失败（注：不是错误）
%% 2 = 材料不足
%% >=127 = 程序异常
%% TODO:日志记录
%% handle(13012, [Tid], Rs) ->
%%     Items = Rs#role.items,
%%     Data = data_forge:get(Tid),
%%     %% ?DEBUG("Tid:~w, Data:~w, Itmes:~w ", [Tid, Data,hd(Items)]),
%%     if
%%         Data == undefined ->
%%             {ok, [127]};
%%         true ->
%%             {Send, Rate, Del, Type, Price, Dels} = Data,
%%             {CType, RtCode} = case Type of
%%                 1 -> {gold, 4};
%%                 2 -> {diamond, 5}
%%             end,
%%             case lib_role:spend(CType, Price, Rs) of
%%                 {ok, Rs1} ->
%%                     case mod_item:del_items(by_tid, Dels, Items) of
%%                         {ok, Items1, Notice} ->
%%                             case util:rate(Rate) of
%%                                 true ->
%%                                     Rs2 = Rs1#role{items = Items1},
%%                                     case mod_item:add_item(Rs2, Tid, 1) of
%%                                         {ok, Rs3, PA2, EA2} ->
%%                                             mod_item:send_notice(Rs#role.pid_sender, PA2, EA2),
%%                                             %% 合成成就推送
%%                                             Rs4 = mod_attain:attain_state(23,1, Rs3),
%%                                             Rs5 = case Dels of
%%                                                 [{11093,_}] -> mod_attain:attain_state(18,1,Rs4);
%%                                                 [{11381,_}] -> mod_attain:attain_state(19,1,Rs4);
%%                                                 [{11189,_}] -> mod_attain:attain_state(20,1,Rs4);
%%                                                 [{11285,_}] -> mod_attain:attain_state(21,1,Rs4);
%%                                                 _ -> Rs4
%%                                             end,
%%                                             Rs6 = mod_attain:attain_state(43, 1, Rs5),
%%                                             %% 一切都OK后，从数据库中删除物品
%%                                             mod_item:send_notice(Rs6#role.pid_sender, Notice),
%%                                             mod_item:del_items_from_db(Rs6#role.id, Notice),
%%                                             Rs0 = lib_role:spend_ok(CType, 3, Rs, Rs6),
%%                                             lib_role:notice(Rs0),
%%                                             ?LOG({forge, Rs#role.id, Tid}),
%%                                             case Send == 1 of
%%                                                 true ->
%%                                                     Name = lib_admin:get_name(Rs),
%%                                                     Vip = lib_admin:get_vip(Rs),
%%                                                     Msg = data_text:get(6),
%%                                                     Msg1 = io_lib:format(Msg, [Name, Tid]),
%%                                                     lib_system:cast_sys_msg(0, Name, Msg1, Vip);
%%                                                 false -> ok
%%                                             end,
%%                                             {ok, [0], Rs0#role{save = [items]}};
%%                                         %% TODO:邮件系统
%%                                         {error, full} ->
%%                                             Title = data_text:get(2),
%%                                             Body = data_text:get(4),
%%                                             mod_mail:new_mail(Rs#role.id, 0, 3, Title, Body, [Tid]),
%%                                             %% 从数据库中删除物品
%%                                             mod_item:send_notice(Rs2#role.pid_sender, Notice),
%%                                             mod_item:del_items_from_db(Rs2#role.id, Notice),
%%                                             Rs3 = lib_role:spend_ok(CType, 3, Rs, Rs2),
%%                                             lib_role:notice(Rs3),
%%                                             ?LOG({forge, Rs#role.id, Tid}),
%%                                             case Send == 1 of
%%                                                 true ->
%%                                                     Name = lib_admin:get_name(Rs),
%%                                                     Vip = lib_admin:get_vip(Rs),
%%                                                     Msg = data_text:get(6),
%%                                                     Msg1 = io_lib:format(Msg, [Name, Tid]),
%%                                                     lib_system:cast_sys_msg(0, Name, Msg1, Vip);
%%                                                 false -> ok
%%                                             end,
%%                                             %% 合成成就推送
%%                                             Rs4 = mod_attain:attain_state(23,1, Rs3),
%%                                             Rs5 = case Dels of
%%                                                 [{11093,_}] -> mod_attain:attain_state(18,1,Rs4);
%%                                                 [{11381,_}] -> mod_attain:attain_state(19,1,Rs4);
%%                                                 [{11189,_}] -> mod_attain:attain_state(20,1,Rs4);
%%                                                 [{11285,_}] -> mod_attain:attain_state(21,1,Rs4);
%%                                                 _ -> Rs4
%%                                             end,
%%                                             {ok, [3], Rs5#role{save = [items]}};
%%                                         {error, _} ->
%%                                             {ok, [128]}
%%                                     end;
%%                                 false ->
%%                                     %% 成就推送
%%                                     Rs2 = case Del == 1 of
%%                                         true -> Rs1#role{items = Items1};
%%                                         false -> Rs1
%%                                     end,
%%                                     Rs3 = mod_attain:attain_state(22, 1, Rs2),
%%                                     Rs4 = mod_attain:attain_state(43, 1, Rs3),
%%                                     Rs0 = lib_role:spend_ok(CType, 3, Rs, Rs4),
%%                                     lib_role:notice(Rs0),
%%                                     case Del == 1 of
%%                                         true ->
%%                                             mod_item:send_notice(Rs0#role.pid_sender, Notice),
%%                                             mod_item:del_items_from_db(Rs0#role.id, Notice),
%%                                             ?LOG({forge, Rs#role.id, Tid}),
%%                                             {ok, [1], Rs0};
%%                                         false ->
%%                                             ?LOG({forge, Rs#role.id, Tid}),
%%                                             {ok, [1], Rs0}
%%                                     end
%%                             end;
%%                         {error, _} ->
%%                             {ok, [2]}
%%                     end;
%%                 {error, _} ->
%%                     {ok, [RtCode]}
%%             end
%%     end;
%%.

%% 批量合成
%% -> [Code]
%% Code:
%% 0 = 成功
%% 1 = 失败（注：不是错误）
%% 2 = 材料不足
%% >=127 = 程序异常
handle(13012, [List], Rs) ->
    ?DEBUG("List:~w", [List]),
    T = erlang:now(),
    case forge(List, Rs) of
        [0,Tidss,Rs1] ->
            Rs3 = case Rs1#role.diamond < Rs#role.diamond of
                true ->
                    lib_role:spend_ok(diamond,3,Rs,Rs1);
                false -> Rs1
            end,
            Rs5 = case Rs3#role.gold < Rs#role.gold of
                true ->
                    lib_role:spend_ok(gold,3,Rs,Rs3);
                false -> Rs3
            end,
            lib_role:notice(Rs5),
            DT = timer:now_diff(erlang:now(), T) / 1000,
            ?DEBUG("Rid: ~w, forge items: ~w ms", [Rs#role.id, DT]),
            %% Rs0 = forge_attain(Tidss, Rs6),
            Rs6 = mod_task:jewel_task(List,Rs5),
            {ok, [0, Tidss], Rs6#role{save = [items]}};
        [3,Tidss,Rs1] ->
            Rs3 = case Rs1#role.diamond < Rs#role.diamond of
                true ->
                    lib_role:spend_ok(diamond,3,Rs,Rs1);
                false -> Rs1
            end,
            Rs5 = case Rs3#role.gold < Rs#role.gold of
                true ->
                    lib_role:spend_ok(gold,3,Rs,Rs3);
                false -> Rs3
            end,
            %% Rs0 = forge_attain(Tidss, Rs6),
            Rs6 = mod_task:jewel_task(List,Rs5),
            {ok, [3, Tidss], Rs6#role{save = [items]}};
        [R] -> {ok, [R, []]}
    end;

%%' 在商城购买商品
%% 消息代码：
%% Code:
%% 0 = 成功
%% 1 = 金币不足
%% 2 = 钻石不足
%% >=127 = 程序异常
handle(13021, [ShopId], Rs) ->
    Data = data_shop:get(ShopId),
    if
        Data == undefined ->
            {ok, [127]};
        true ->
            Price = util:get_val(price1, Data),
            Num = util:get_val(num1, Data),
            Diamond = util:ceil(Price * Num),
            case lib_role:spend(diamond, Diamond, Rs) of
                {ok, Rs1} ->
                    case util:get_val(tid, Data) of
                        ?CUR_GOLD ->
                            %% 购买金币
                            Rs2 = lib_role:add_attr(gold, Num, Rs1),
                            Rs3 = lib_role:add_attr_ok(gold, 28, Rs1, Rs2),
                            Rs0 = lib_role:spend_ok(diamond, 28, Rs, Rs3),
                            lib_role:notice(Rs0),
                            ?LOG({shop, Rs#role.id, ShopId}),
                            {ok, [0], Rs0};
                        ?CUR_LUCK ->
                            %% 购买幸运星
                            Rs2 = lib_role:add_attr(luck, Num, Rs1),
                            %% 购买幸运星日常成就推送
                            %% Rs3 = mod_attain:attain_state(57, 1, Rs2),
                            Rs0 = lib_role:spend_ok(diamond, 28, Rs, Rs2),
                            lib_role:notice(luck, Rs0),
                            lib_role:notice(diamond, Rs0),
                            ?LOG({shop, Rs#role.id, ShopId}),
                            {ok, [0], Rs0};
                        ?CUR_HORN ->
                            %% 购买喇叭
                            Rs2 = lib_role:add_attr(horn, Num, Rs1),
                            %% Rs3 = lib_role:add_attr_ok(horn, 28, Rs1, Rs2),
                            Rs0 = lib_role:spend_ok(diamond, 28, Rs, Rs2),
                            lib_role:notice(horn, Rs0),
                            lib_role:notice(diamond, Rs0),
                            ?LOG({shop, Rs#role.id, ShopId}),
                            {ok, [0], Rs0};
                        Tid ->
                            %% 普通物品
                            % ?DEBUG("==add_item:~w",[mod_item:add_item(Rs1, Tid, Num)]),
                            case mod_item:add_item(Rs1, Tid, Num) of
                                {ok, Rs2, PA, EA} ->
                                    mod_item:send_notice(Rs2#role.pid_sender, PA, EA),
                                    Rs0 = lib_role:spend_ok(diamond, 28, Rs, Rs2),
                                    lib_role:notice(diamond, Rs0),
                                    ?LOG({shop, Rs#role.id, ShopId}),
                                    {ok, [0], Rs0#role{save = [role, items]}};
                                %% TODO:邮件系统
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 28, Title, Body, [{Tid, Num}]),
                                    lib_role:notice(Rs1),
                                    {ok, [3], Rs1};
                                {error, _} ->
                                    {ok, [128]}
                            end
                    end;
                {error, _} ->
                    {ok, [2]}
            end
    end;
%%.

%% ------------------------------------------------------------------
%% 魔法宝珠获取
%% jewel: 宝珠抽取状态
%% 如为[]时会初始化为: [{1, 1}, {2, 0}, {3, 0}, {4, 0}, {5, 0}]
%% 格式: [{Quality, Status}, ...]
%%       Quality : 宝珠品质等级
%%       Status : 是否开始(1=是,0=否)
%% ------------------------------------------------------------------
handle(13022, [Quality], Rs) ->
    Rs1 = lib_role:jewel_init(Rs),
    case lists:member({Quality, 1}, Rs1#role.jewel) of
        true ->
            jewel(Quality, Rs1);
        false ->
            %% 请求了末开启的宝珠品质等级
            {ok, [128, 0, 0, 0]}
    end;

%% 魔法宝珠状态
handle(13024, [], Rs) ->
    Rs1 = lib_role:jewel_init(Rs),
    {ok, [Rs1#role.jewel], Rs1};

%%' jewelry upgrade
handle(13025, [Id,Ids], Rs) ->
    ?DEBUG("==Id:~w, Ids:~w", [Id, Ids]),
    #role{items = Items} = Rs,
    %% F = fun(X) ->
    %%         case mod_item:get_item(X,Items) of
    %%             false -> 0;
    %%             Item ->
    %%                 Sort = Item#item.sort,
    %%                 Attr = Item#item.attr,
    %%                 case is_record(Attr,prop) andalso Sort == 4 of
    %%                     true ->
    %%                         #prop{
    %%                             quality   = Quality
    %%                             ,level     = Level
    %%                         } = Attr,
    %%                         Data = data_jewel_lev:get({Level,Quality}),
    %%                         ?INFO("==Data:~w", [Data]),
    %%                         util:get_val(provide,Data,0);
    %%                     false -> 0
    %%                 end
    %%         end
    %% end,
    %% AddExp = lists:sum([F(X) || X <- lists:flatten(Ids)]),
    %% T = erlang:now(),
    {AddExp,Expend} = jewelry_upgrade_exp(Ids, Items),
    case mod_item:get_item(Id, Items) of
        false -> {ok, [127,0,0]};
        Item1 ->
            Sort1 = Item1#item.sort,
            Attr1 = Item1#item.attr,
            case is_record(Attr1,prop) andalso Sort1 == 4 of
                true ->
                    #prop{
                        quality = Quality1
                        ,level = Level1
                        ,exp = Exp1
                    } = Attr1,
                    Exp2 = Exp1 + AddExp,
                    {Level2,Exp22} = jewelry_upgrade(Level1,Quality1,Exp2),
                    Attr2 = Attr1#prop{
                        level = Level2
                        ,exp  = Exp22
                    },
                    Item2 = Item1#item{changed = 1, attr = Attr2},
                    Items1 = mod_item:set_item(Item2,Items),
                    %% Expend = case data_jewel_lev:get({Level1,Quality1}) of
                    %%     undefined -> 0;
                    %%     Data ->
                    %%         util:get_val(expend,Data,0)
                    %% end,
                    %% case lib_role:spend(gold,Expend,Rs) of
                    %%     {ok, Rs1} ->
                    %%         DelIds = lists:flatten(Ids),
                    %%         DelIds2 = [{X,1} || X <- DelIds],
                    %%         case mod_item:del_items(by_id, DelIds2, Items1) of
                    %%             {ok, Items2, Notice} ->
                    %%                 mod_item:send_notice(Rs#role.pid_sender, Notice),
                    %%                 %% 从数据库中删除物品
                    %%                 mod_item:del_items_from_db(Rs#role.id, Notice),
                    %%                 Rs2 = lib_role:spend_ok(gold,60,Rs,Rs1),
                    %%                 lib_role:notice(Rs2),
                    %%                 DT = timer:now_diff(erlang:now(), T) / 1000,
                    %%                 ?DEBUG("Rid: ~w, jewelry upgrade: ~w ms", [Rs#role.id, DT]),
                    %%                 {ok, [0,Level2,Exp2], Rs2#role{items = Items2, save = [items]}};
                    %%             {error,_} ->
                    %%                 {ok, [2,0,0]}
                    %%         end;
                    %%     {error, _} ->
                    %%         {ok, [4,0,0]}
                    %% end;
                    self() ! {pt, 2045, [Ids,Items1,Expend,Level2,Exp22]},
                    {ok};
                false ->
                    {ok, [128,0,0]}
            end
    end;

handle(13026, [EquId,JewTid,JewIds], Rs) ->
    #role{items = Items} = Rs,
    T = erlang:now(),
    case mod_item:get_item(EquId, Items) of
        false -> {ok, [127,0,0]};
        Item ->
            Attr = Item#item.attr,
            case is_record(Attr,equ) of
                true ->
                    #equ{embed = Embed} = Attr,
                    {AddExp,Expend} = jewelry_upgrade_exp(JewIds, Items),
                    case lists:keyfind(JewTid, 1, Embed) of
                        false -> {ok, [128,0,0]};
                        {JewTid,AttrId,_AttrVal,JewLev,JewExp} ->
                            JewData = data_prop:get(JewTid),
                            Quality = util:get_val(quality,JewData,0),
                            Control2 = util:get_val(control2,JewData,0),
                            Exp = JewExp + AddExp,
                            {NewJewLev,NewExp} = jewelry_upgrade(JewLev,Quality,Exp),
                            NewAttrVal = util:ceil(data_fun:jewelry_upgrade(Control2,NewJewLev)),
                            NewEmbed = lists:keyreplace(AttrId,2,Embed,{JewTid,AttrId,NewAttrVal,NewJewLev,NewExp}),
                            Attr2 = Attr#equ{embed = NewEmbed},
                            Item2 = Item#item{changed = 1, attr = Attr2},
                            Items1 = mod_item:set_item(Item2,Items),
                            case lib_role:spend(gold,Expend,Rs) of
                                {ok, Rs1} ->
                                    DelIds = lists:flatten(JewIds),
                                    DelIds2 = [{X,1} || X <- DelIds],
                                    case mod_item:del_items(by_id, DelIds2, Items1) of
                                        {ok, Items2, Notice} ->
                                            mod_item:send_notice(Rs#role.pid_sender, Notice),
                                            %% 从数据库中删除物品
                                            mod_item:del_items_from_db(Rs#role.id, Notice),
                                            Rs2 = lib_role:spend_ok(gold,60,Rs,Rs1),
                                            lib_role:notice(Rs2),
                                            DT = timer:now_diff(erlang:now(), T) / 1000,
                                            ?DEBUG("Rid: ~w, jewelry upgrade: ~w ms", [Rs#role.id, DT]),
                                            {ok, [0,NewJewLev,NewExp], Rs2#role{items = Items2, save = [items]}};
                                        {error,_} ->
                                            {ok, [2,0,0]}
                                    end;
                                {error, _} ->
                                    {ok, [4,0,0]}
                            end
                    end;
                false ->
                    {ok, [129,0,0]}
            end
    end;
%%.

%%' 背包格子数开放
%% # 消息代码：
%% # Code:
%% # 0 = 成功
%% # 1 = 失败
%% # >=127 = 程序异常
handle(13027, [Type, Line, Tab], Rs) ->
    %% ?DEBUG("Type:~p, Tab:~p, Line:~p ~n", [Type, Tab, Line]),
    if
        Type =:= 1 ->
            Ids = data_bags:get(ids),
            #role{bag_mat_max = Mats, bag_prop_max = Props, bag_equ_max = Equs} = Rs,
            Line2 = case Tab of
                1 -> util:ceil(Mats / 8) + 1;
                2 -> util:ceil(Props / 8) + 1;
                5 -> util:ceil(Equs / 8) + 1;
                _ -> 0
            end,
            case lists:member(Line, Ids) andalso Line =:= Line2 andalso Line2 =/= 0 of
                true ->
                    case data_bags:get(Line) of
                        [{price, Price}] ->
                            Price2 = util:ceil(Price),
                            case lib_role:spend(diamond, Price2, Rs) of
                                {ok, Rs1} ->
                                    if
                                        Tab =:= 1 ->
                                            Rs2 = Rs1#role{bag_mat_max = Mats + 8},
                                            Rs3 = mod_attain:attain_state(27,1,Rs2),
                                            Rs0 = lib_role:spend_ok(diamond, 6, Rs, Rs3),
                                            lib_role:notice(Rs0),
                                            {ok, [0, Tab, Mats + 8], Rs0};
                                        Tab =:= 2 ->
                                            Rs2 = Rs1#role{bag_prop_max = Props + 8},
                                            Rs3 = mod_attain:attain_state(27,1,Rs2),
                                            Rs0 = lib_role:spend_ok(diamond, 6, Rs, Rs3),
                                            lib_role:notice(Rs0),
                                            {ok, [0, Tab, Props + 8], Rs0};
                                        Tab =:= 5 ->
                                            Rs2 = Rs1#role{bag_equ_max = Equs + 8},
                                            Rs3 = mod_attain:attain_state(27,1,Rs2),
                                            Rs0 = lib_role:spend_ok(diamond, 6, Rs, Rs3),
                                            lib_role:notice(Rs0),
                                            {ok, [0, Tab, Equs + 8], Rs0};
                                        true ->
                                            {ok, [127, 0, 0]}
                                    end;
                                {error, _} ->
                                    {ok, [1, 0, 0]}
                            end;
                        undefined ->
                            {ok, [128, 0, 0]}
                    end;
                false ->
                    {ok, [129, 0, 0]}
            end;
        true ->
            {ok, [130, 0, 0]}
    end;
%%.

%%' 批量出售物品
%% # 消息代码:
%% # Code:
%% # 0 = 出售成功
%% # >=127 = 程序异常
handle(13028, [Tab, List], Rs) ->
    %% ?DEBUG("List:~p~n", [List]),
    %% List :: [[ID1], [ID2], ...]
    Items = Rs#role.items,
    %% 先把收到的参数List转成自己所需的数据
    %% DelsData :: [Id, Num, Sell, Price]
    F1 = fun(Id) ->
            case mod_item:get_item(Id, Items) of
                false ->
                    ?WARN("Error Id: ~w, Tab: ~w, Data: ~w", [Id, Tab, List]),
                    {0, 0, 0, 0, 0};
                I ->
                    Attr = I#item.attr,
                    if
                        Tab == ?TAB_EQU andalso is_record(Attr, equ) ->
                            Data = data_equ:get(I#item.tid),
                            Sell = util:get_val(sell, Data),
                            Price = util:get_val(price, Data),
                            case I#item.attr#equ.hero_id > 0 of
                                true ->
                                    ?ERR("Del hero's equ: ~w", [I]),
                                    {0, 0, 0, 0, 0};
                                false -> {Id, 1, Sell, Price, 0}
                            end;
                        (Tab == ?TAB_MAT orelse Tab == ?TAB_PROP) andalso is_record(Attr, prop) ->
                            Data = data_prop:get(I#item.tid),
                            Sell = util:get_val(sell, Data),
                            Price = util:get_val(price, Data),
                            {Id, I#item.attr#prop.num, Sell, Price, 0};
                        true ->
                            ?WARN("Error Tab: ~w, Data: ~w", [Tab, List]),
                            {0, 0, 0, 0, 0}
                    end
            end
    end,
    DelsData = [F1(Id) || [Id] <- List],
    %% 通过DelsData生成删除特品的参数[{Id, Num}, ...]
    DelIds = [{Id, Num} || {Id, Num, _, _, _} <- DelsData, Id > 0],
    case mod_item:del_items(by_id, DelIds, Items) of
        {ok, Items1, Notice} ->
            Rs1 = Rs#role{items=Items1},
            %% 计算批量出售所得到的金币或钻石的总额
            F2 = fun
                ({0, _, _, _, _}, Rt) -> Rt;
                ({_, Num, 1, Gold, _}, {G, D}) -> {(Gold * Num) + G, D};
                ({_, Num, 2, Diamond, _}, {G, D}) -> {G, (Diamond * Num) + D};
                (Else, Rt) ->
                    ?WARN("Error Data: ~w, Rt: ~w", [Else, Rt]),
                    Rt
            end,
            {AddGold, AddDiamond} = lists:foldl(F2, {0, 0}, DelsData),
            %% 如果被删的装备是已装在某英雄上的，需要清理相应英雄装备格子
            %% lists:map(fun
            %%         ({Id, _, _, _, {Hid, Pos}}) -> self() ! {pt, 2012, [Hid, Pos, Id]};
            %%         (_) -> ok
            %%     end, DelsData),
            Rs2 = lib_role:add_attr(gold, AddGold, Rs1),
            Rs3 = lib_role:add_attr(diamond, AddDiamond, Rs2),
            Rs4 = lib_role:add_attr_ok(gold, 29, Rs, Rs3),
            Rs0 = lib_role:add_attr_ok(diamond, 29, Rs, Rs4),
            %% 物品删除通知
            mod_item:send_notice(Rs1#role.pid_sender, Notice),
            %% 通知钱币更新
            lib_role:notice(Rs0),
            %% 一切都OK后，从数据库中删除物品
            mod_item:del_items_from_db(Rs#role.id, Notice),
            mod_item:log_item(del_item,Rs#role.id,8,DelIds,Items),
            {ok, [0], Rs0};
        {error, _} ->
            {ok, [127]}
    end;
%%.

%%' 出售宝珠
handle(13032, [Tab, AccIds0], Rs) ->
    AccIds = mod_item:merge_tid(AccIds0),
    Items = Rs#role.items,
    %% 先把收到的参数AccIds转成自己所需的数据
    F1 = fun(Tid, N) ->
            case mod_item:get_less_prop(Items, Tid) of
                false ->
                    ?ERR("Error Tid: ~w, Tab: ~w, Data: ~w", [Tid, Tab, AccIds0]),
                    {0, 0, 0, 0};
                I ->
                    if
                        Tab == ?TAB_MAT orelse Tab == ?TAB_PROP ->
                            Data = data_prop:get(Tid),
                            Sell = util:get_val(sell, Data),
                            Price = util:get_val(price, Data),
                            N1 = case N =< I#item.attr#prop.num of
                                true -> N;
                                false -> I#item.attr#prop.num
                            end,
                            {Tid, N1, Sell, Price};
                        true ->
                            ?ERR("Error Tab: ~w, Data: ~w", [Tab, AccIds0]),
                            {0, 0, 0, 0}
                    end
            end
    end,
    DelsData = [F1(Id, N) || {Id, N} <- AccIds],
    %% 通过DelsData生成删除特品的参数[{Id, Num}, ...]
    DelIds = [{Id, Num} || {Id, Num, _, _} <- DelsData, Id > 0],
    case mod_item:del_items(by_tid, DelIds, Items) of
        {ok, Items1, Notice} ->
            Rs1 = Rs#role{items=Items1},
            %% 计算批量出售所得到的金币或钻石的总额
            F2 = fun
                ({0, _, _, _}, Rt) -> Rt;
                ({_, _, 1, Gold}, {G, D}) -> {Gold + G, D};
                ({_, _, 2, Diamond}, {G, D}) -> {G, Diamond + D};
                (Else, Rt) ->
                    ?WARN("Error Data: ~w, Rt: ~w", [Else, Rt]),
                    Rt
            end,
            {AddGold, AddDiamond} = lists:foldl(F2, {0, 0}, DelsData),
            Rs2 = lib_role:add_attr(gold, AddGold, Rs1),
            Rs3 = lib_role:add_attr(diamond, AddDiamond, Rs2),
            Rs4 = lib_role:add_attr_ok(gold, 29, Rs, Rs3),
            Rs0 = lib_role:add_attr_ok(diamond, 29, Rs, Rs4),
            %% 物品删除通知
            mod_item:send_notice(Rs1#role.pid_sender, Notice),
            %% 通知钱币更新
            lib_role:notice(Rs0),
            %% 一切都OK后，从数据库中删除物品
            mod_item:del_items_from_db(Rs#role.id, Notice),
            {ok, [0], Rs0};
        {error, _} ->
            {ok, [127]}
    end;
%%.

%%' 幸运星抽取
%% # 消息代码：
%% # 0=成功
%% # 1=没有幸运星
%% # 3=背包已满
%% # >=127 = 程序异常
handle(13040, [], Rs) ->
    #role{id = Rid, name = Name, luck = {LuckStar, LuckDia, LuckUsed, ValSum}} = Rs,
    case LuckStar >= 1 of
        true ->
            LuckId = mod_luck:get_luck_id(),
            case data_luck:get(LuckId) of
                undefined ->
                    ?WARN("luck id is wrong", []),
                    {ok, [128, 0, 0]};
                LuckData ->
                    Cumulative = data_config:get(starCumulative),
                    LastData = lists:last(LuckData),
                    RandTop = element(size(LastData) - 1, LastData),
                    Rand = util:rand(1, RandTop),
                    case luck_process(Rand, LuckData) of
                    %%test case {5, {30012, 2}, 2, 4, 4000} of
                        %% RewardTid=3是钻石返利(要特殊处理,因为add_item(3)是幸运星)
                        {3, Num, Quality, Pos, Val} ->
                            Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
                            Rs1 = Rs#role{luck = Luck1},
                            Rs2 = luck_rebate(LuckDia + Cumulative, Rs1),
                            lib_role:notice(luck, Rs2),
                            {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
                            gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, 3, Num, Quality}),
                            %% 幸运星排行榜设置
                            %% gen_server:cast(rank, {rank_set, ValSum1, Rid, Name, 1}),
                            Rs3 = mod_attain:attain_state(46, 1, Rs2),
                            Rs0 = mod_task:set_task(5,{1,1},Rs3),
                            case Quality =:= 2 of
                                true ->
                                    Vip = lib_admin:get_vip(Rs),
                                    Name2 = lib_admin:get_name(Rs),
                                    Msg = data_text:get(7),
                                    Msg1 = io_lib:format(Msg, [Name2, 3, Pos]),
                                    lib_system:cast_sys_msg(0, Name2, Msg1, Vip);
                                false -> ok
                            end,
                            {ok, [0, LuckDia1, Pos], Rs0};
                        {RewardTid, Num, Quality, Pos, Val} ->
                            case mod_item:add_item(Rs, RewardTid, Num) of
                                {ok, Rs1, PA, EA} ->
                                    mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                                    Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
                                    Rs3 = Rs1#role{luck = Luck1},
                                    lib_role:notice(luck, Rs3),
                                    lib_role:notice(Rs3),
                                    Rs4 = lib_role:add_attr_ok(gold, 9, Rs, Rs3),
                                    Rs5 = lib_role:add_attr_ok(diamond, 9, Rs, Rs4),
                                    {_, LuckDia1, LuckUsed1, ValSum1} = Rs5#role.luck,
                                    gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, RewardTid, Num, Quality}),
                                    %% 幸运星排行榜设置
                                    %% gen_server:cast(rank, {rank_set, ValSum1, Rid, Name, 1}),
                                    Rs6 = mod_attain:attain_state(46, 1, Rs5),
                                    Rs0 = mod_task:set_task(5,{1,1},Rs6),
                                    case Quality =:= 2 of
                                        true ->
                                            Vip = lib_admin:get_vip(Rs),
                                            Name2 = lib_admin:get_name(Rs),
                                            Msg = data_text:get(7),
                                            Msg1 = io_lib:format(Msg, [Name2, RewardTid, Pos]),
                                            lib_system:cast_sys_msg(0, Name2, Msg1, Vip);
                                        false -> ok
                                    end,
                                    mod_item:log_item(add_item,Rs#role.id,11,[{RewardTid,Num}]),
                                    %% lib_admin:android_server_active5(Rs#role.id,RewardTid),
                                    extra:set_use(luck,RewardTid,Rs#role.id),
                                    {ok, [0, LuckDia1, Pos], Rs0#role{save = [items]}};
                                %% TODO:邮件系统
                                {error, full} ->
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs#role.id, 0, 9, Title, Body, [{RewardTid, Num}]),
                                    Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
                                    Rs1 = Rs#role{luck = Luck1},
                                    lib_role:notice(luck, Rs1),
                                    %% lib_admin:android_server_active5(Rs#role.id,RewardTid),
                                    extra:set_use(luck,RewardTid,Rs#role.id),
                                    Rs2 = mod_task:set_task(5,{1,1},Rs1),
                                    {ok, [3, 0, 0], Rs2};
                                {error, Reason} ->
                                    ?WARN("Error:~w, Id: ~w", [Reason, RewardTid]),
                                    {ok, [127, 0, 0]}
                            end
                    end
            end;
        false ->
            {ok, [1, 0, 0]}
    end;
%%.

%% 幸运星实时排行榜
handle(13042, [], Rs) ->
    ?DEBUG("recent_list 13042", []),
    luck ! {recent_list, Rs#role.pid_sender},
    {ok};
%%
%% 幸运星总排行榜,本周排行
handle(13044, [1], Rs) ->
    ?DEBUG("rank_list 13044", []),
    luck ! {rank_list, Rs#role.pid_sender},
    {ok};
handle(13044, [0], Rs) ->
    luck ! {week_rank_list, Rs#role.pid_sender},
    {ok};

%% 幸运星期号
handle(13045, [], Rs) ->
    LuckId = mod_luck:get_luck_id(),
    {LuckStar, LuckUsed, _, _} = Rs#role.luck,
    {ok, [LuckId, LuckStar, LuckUsed], Rs};


%%' 连续签到
handle(13052, [], Rs) ->
    #role{loginsign = LoginSign} = Rs,
    case LoginSign of
        [] ->
            [Days1, Days2, PriceState] = [1, 1, [{1, 1},{2, 0},{3, 0},{4, 0},{5, 0},{6, 0},{7, 0}]],
            Rs1 = Rs#role{loginsign = [util:unixtime(),1,Days1, Days2, PriceState]},
            {ok, [0, 1, Days1, Days2, PriceState], Rs1#role{save=[sign]}};
        [SignTime,Type,Days1,Days2,PriceState] ->
            NewTime = util:unixtime(),
            %% AmSix = util:unixtime(today) + 21600,       %% 今天6点时间戳
            AmSix = util:unixtime(today),       %% 今天0点时间戳(修改成凌晨签到)
            %% 签到时间>6点,上次签到时间<6点
            case NewTime > AmSix andalso SignTime < AmSix of
                true ->
                    F1 = fun({_X, Y}) -> Y =:= 1 end,
                    F2 = fun({_X, Y}) -> Y =:= 2 end,
                    %% 全部领取开始下一轮,
                    case Days1 =:= 7 andalso lists:any(F1, PriceState) of
                        true ->
                            {ok, [1, Type, Days1, Days2, PriceState], Rs#role{save=[sign]}};
                        false ->
                            case Days1 =:= 7 andalso lists:all(F2, PriceState) of
                                true ->
                                    [NewDays1, NewDays2, NewPriceState] = [1, 1, [{1, 1},{2, 0},{3, 0},{4, 0},{5, 0},{6, 0},{7, 0}]],
                                    Rs1 = Rs#role{loginsign = [NewTime,2,NewDays1, NewDays2, NewPriceState]},
                                    {ok, [0, 2, NewDays1, NewDays2, NewPriceState], Rs1#role{save=[sign]}};
                                false ->
                                    Rs1 = mod_sign:login_sign2(Rs),
                                    #role{loginsign = [_T1,_T2,NewDays1, NewDays2, NewPriceState]} = Rs1,
                                    {ok, [0, Type, NewDays1, NewDays2, NewPriceState], Rs1#role{save=[sign]}}
                            end
                    end;
                false ->
                    {ok, [1, Type, Days1, Days2, PriceState], Rs}
            end
    end;
%%.

%% 签到续签
handle(13054, [], Rs) ->
    #role{loginsign = LoginSign} = Rs,
    [Time,Type,Days1, Days2, PriceState] = LoginSign,
    case Days1 == Days2 andalso Days1 == 1 andalso Days1 == 7 of
        true -> {ok, [2, Days1, Days2, PriceState], Rs};
        false ->
            Days = lists:seq(Days1, Days2),
            F = fun({X, Y}) ->
                    Data = data_sign:get({X, Y}),
                    util:get_val(resign_cost, Data)
            end,
            Diamond = lists:sum([F({Type, X}) || X <- Days]),
            case lib_role:spend(diamond, Diamond, Rs) of
                {ok, Rs1} ->
                    Rs2 = Rs1#role{loginsign = [Time,Type,Days2, Days2, PriceState]},
                    Rs0 = lib_role:spend_ok(diamond, 11, Rs, Rs2),
                    lib_role:notice(Rs0),
                    {ok, [0, Days2, Days2, PriceState], Rs0#role{save=[sign]}};
                {error, _} ->
                    {ok, [1, Days1, Days2, PriceState], Rs}
            end
    end;

%%' 签到领奖
handle(13056, [Day], Rs) ->
    #role{loginsign = LoginSign} = Rs,
    [Time,Type,Days1, Days2, PriceState] = LoginSign,
    Lists1 = data_sign:get(ids),
    F1 = fun({_X, Y}) -> Y =:= 1 end,
    case lists:member({Type,Day}, Lists1) of
        true ->
            case lists:member({Day, 2}, PriceState) of
                true ->
                    %% 1=还有未领取天数,else = 0
                    Next = case lists:any(F1, PriceState) of
                        true -> 1;
                        false -> 0
                    end,
                    {ok, [1, Next]};
                false ->
                    case lists:member({Day, 1}, PriceState) of
                        true ->
                            Data = data_sign:get({Type, Day}),
                            Gold    = util:get_val(coin, Data),
                            Diamond = util:get_val(diamond, Data),
                            TidNum  = util:get_val(tid_num, Data),
                            Rs1     = lib_role:add_attr(gold, Gold, Rs),
                            Rs2     = lib_role:add_attr(diamond, Diamond, Rs1),
                            Rs3     = lib_role:add_attr_ok(gold, 11, Rs, Rs2),
                            Rs4     = lib_role:add_attr_ok(diamond, 11, Rs, Rs3),
                            Lists2 = lists:keyreplace(Day, 1, PriceState, {Day, 2}),
                            Next = case lists:any(F1, Lists2) of
                                true -> 1;
                                false -> 0
                            end,
                            case mod_item:add_items(Rs4, TidNum) of
                                {ok, Rs5, PA, EA} ->
                                    Rs6 = mod_attain:attain_state(67, 1, Rs5),
                                    Rs0 = case util:get_val(hero, Data, undefined) of
                                        undefined -> Rs6;
                                        {HeroId, Quality} ->
                                            {ok, Rs7, Hero} = mod_hero:add_hero(Rs6, HeroId, Quality),
                                            mod_hero:hero_notice(Rs7#role.pid_sender, Hero),
                                            Rs7#role{save = [heroes]}
                                    end,
                                    case PA =:= [] andalso EA =:= [] of
                                        true ->
                                            mod_sign:sign_stores(Rs0),
                                            lib_role:notice(Rs0),
                                            lib_role:notice(luck, Rs0),
                                            {ok, [0, Next], Rs0#role{loginsign = [Time,Type,Days1, Days2, Lists2], save = [sign]}};
                                        false ->
                                            mod_item:send_notice(Rs0#role.pid_sender, PA, EA),
                                            mod_sign:sign_stores(Rs0),
                                            lib_role:notice(Rs0),
                                            lib_role:notice(luck, Rs0),
                                            mod_item:log_item(add_item,Rs#role.id,4,TidNum),
                                            {ok, [0, Next], Rs0#role{loginsign = [Time,Type,Days1, Days2, Lists2], save = [sign]}}
                                    end;
                                {error, full} ->
                                    Rs5 = mod_attain:attain_state(67, 1, Rs4),
                                    Rs0 = case util:get_val(hero, Data, undefined) of
                                        undefined -> Rs5;
                                        {HeroId, Quality} ->
                                            {ok, Rs6, Hero} = mod_hero:add_hero(Rs5, HeroId, Quality),
                                            mod_hero:hero_notice(Rs6#role.pid_sender, Hero),
                                            Rs6#role{save = [heroes]}
                                    end,
                                    mod_sign:sign_stores(Rs0),
                                    Title = data_text:get(2),
                                    Body = data_text:get(4),
                                    mod_mail:new_mail(Rs0#role.id, 0, 11, Title, Body, TidNum),
                                    {ok, [3, Next], Rs0#role{loginsign = [Time,Type,Days1, Days2, Lists2], save = [sign]}};
                                {error, _} ->
                                    {ok, [128, 1]}
                            end;
                        false ->
                            {ok, [2, 1]}
                    end
            end;
        false ->
            {ok, [127, 1]}
    end;
%%.

%% 关卡礼包领取
handle(13059, [], Rs) ->
    #role{tollgate_prize = Id, tollgate_newid = TollgateId2} = Rs,
    Ids = data_tollgate_prize:get(ids),
    {A, B} = case lists:keyfind(Id, 1, Ids) of
        false -> {0, 0};
        R -> R
    end,
    %% ?INFO("==Id:~w, TollgateId2:~w, A:~w, B:~w", [Id, TollgateId2, A, B]),
    case TollgateId2 - 1 >= B andalso B =/= 0 of
        true ->
            case data_tollgate_prize:get({A, B}) of
                undefined -> {ok, [127, 0, 0]};
                Data ->
                    Prize = util:get_val(prize, Data, []),
                    Next = case lists:keyfind(Id + 1, 1, Ids) of
                        false -> 0;
                        {_C, D} ->
                            case TollgateId2 - 1  >= D of
                                true -> 1;
                                false -> 0
                            end
                    end,
                    case mod_item:add_items(Rs, Prize) of
                        {ok, Rs1, PA, EA} ->
                            lib_role:notice(Rs1),
                            lib_role:notice(luck, Rs1),
                            mod_item:send_notice(Rs1#role.pid_sender, PA, EA),
                            NextId = case lists:keyfind(Id + 1, 1, Ids) of
                                false -> 0;
                                _ -> Id + 1
                            end,
                            Rs2 = lib_role:add_attr_ok(batch, 44, Rs, Rs1),
                            {ok, [0, NextId, Next], Rs2#role{tollgate_prize = Id + 1}};
                        {error, full} ->
                            Title = data_text:get(2),
                            Body = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id, 0, 44, Title, Body, Prize),
                            NextId = case lists:keyfind(Id + 1, 1, Ids) of
                                false -> 0;
                                _ -> Id + 1
                            end,
                            {ok, [3, NextId, Next], Rs#role{tollgate_prize = Id + 1}};
                        {error, _} ->
                            {ok, [128, 0, 0]}
                    end
            end;
        false ->
            {ok, [1, 0, 0]}
    end;

%% 图鉴功能(pictorialial)
handle(13062, [], Rs) ->
    #role{pictorialial = Pic} = Rs,
    Pic1 = [[A] || A <- Pic],
    {ok, [Pic1]};

%% 角色头像更换
handle(13064, [PicId], Rs) ->
    #role{coliseum = Coliseum} = Rs,
    Ids = data_picture:get(ids),
    case Coliseum of
        [] -> {ok, [1]};
        [Id,Lev,Exp,_Pic,Num,HighR,PrizeT,Report]->
            case lists:member(PicId, Ids) of
                true ->
                    Rs1 = Rs#role{coliseum = [Id,Lev,Exp,PicId,Num,HighR,PrizeT,Report]},
                    coliseum ! {set_rank_picture, Id, PicId},
                    {ok, [0], Rs1#role{save = [coliseum]}};
                false ->
                    {ok, [127]}
            end
    end;

%% 客户端数据存储
%% type=1(存储),=2(获取),=3(删除)
handle(13066, [Type, Key, Value], Rs) ->
    case Type of
        1 ->
            case mod_item:client_info_from_db(1, Key, Value, Rs) of
                {ok, _} -> {ok, [0, <<>>]};
                {error, _} -> {ok, [1, <<>>]}
            end;
        2 ->
            case mod_item:client_info_from_db(2, Key, Value, Rs) of
                {ok, V} -> {ok, [0, V]};
                {error, _} -> {ok, [1, <<>>]}
            end;
        3 ->
            case mod_item:client_info_from_db(3, Key, Value, Rs) of
                {ok, _} -> {ok, [0, <<>>]};
                {error, _} -> {ok, [1, <<>>]}
            end;
        _ ->
            ?WARN("13066 Type error:~w",[Type]),
            {ok, [127, <<>>]}
    end;

%%----------------------------------------------------------
%% Type=0:
%% 请求英雄魂数据
%% 第一次进入会刷新一次
%% Type=1
%% 英雄魂刷新(最多9个)
%% 如果cd时间到就免费刷新,否则扣除钻石
%%----------------------------------------------------------
%%' hero soul
handle(13067, [Type], Rs) ->
    Time = util:unixtime(),
    RefNum = data_config:get(herosoul_cq_times),
    DiamCd = data_config:get(herosoul_cd),
    GoldCd = data_config:get(herosoul_coin_cd),
    %% DiamCd = 30,
    %% GoldCd = 30,
    Price = data_config:get(herosoul_refresh),
    Rs1 = case Rs#role.herosoul of
        [] ->
            H = mod_item:herosoul_refresh(),
            Rs#role{herosoul = [Time,Time,Time,0,H]
                ,save=[herosoul]};
        [DT,GT,TN,N,_S] ->
            case max(0,DiamCd - (Time - DT)) of
                0 ->
                    HS = mod_item:herosoul_refresh(),
                    Rs#role{herosoul = [Time,GT,TN,N,HS]
                        ,save = [herosoul]};
                _ -> Rs
            end
    end,
    [Cd1,Cd2,RT,Num,HeroSoul] = Rs1#role.herosoul,
    SD = max(0,DiamCd - (Time - Cd1)),
    SG = max(0,GoldCd - (Time - Cd2)),
    SN = max(0,RefNum-Num),
    case Type of
        1 ->
            case lib_role:spend(diamond,Price,Rs1) of
                {ok,Rs2} ->
                    RHS = mod_item:herosoul_refresh(),
                    RHSD = pack_herosoul(RHS),
                    Rs3 = Rs2#role{
                        herosoul = [Time,Cd2,RT,Num,RHS]
                        ,save = [herosoul]
                    },
                    lib_role:notice(Rs3),
                    Rs4 = lib_role:spend_ok(diamond, 66, Rs, Rs3),
                    {ok,[0,SD,SG,SN,RHSD],Rs4};
                {error,_} -> {ok, [1,0,0,0,[]]}
            end;
        _ ->
            HeroSoulData = pack_herosoul(HeroSoul),
            {ok, [0,SD,SG,SN,HeroSoulData],Rs1}
    end;

handle(13068, [Type], Rs) ->
    case Rs#role.herosoul of
        [] ->
            ?WARN("13068 herosoul not init ~w", [Rs#role.id]),
            {ok, [127,0,0,0,0]};
        [Cd1,Cd2,TN,Num,HeroSoul] ->
            Num1 = data_config:get(herosoul_cq_times),
            Time = util:unixtime(),
            CoinCd = data_config:get(herosoul_coin_cd),
            %% CoinCd = 30,
            Time2 = max(0,CoinCd - (Time - Cd2)),
            if
                Time2 > 0 andalso Type == 1 ->
                    {ok, [3,Time2,0,0,0]};
                Num >= Num1 andalso Type == 1 ->
                    {ok, [7,0,0,0,0]};
                true ->
                    case herosoul_cq(HeroSoul, []) of
                        [] -> {ok, [128,0,0,0,0]};
                        {Pos,Id,_St,Rare} ->
                            {CType, RtCode, Money, Prize} = case Type of
                                1 ->
                                    Expend = data_config:get(herosoul_coin_count),
                                    {gold, 1, Expend, [Id]};
                                2 ->
                                    Expend = data_config:get(herosoul_cq),
                                    {diamond, 2, Expend, [Id]};
                                3 ->
                                    L = [{C,B} || {_A,B,C,_D} <- HeroSoul, C == 0],
                                    IdList = [Id1 || {_,Id1} <- L],
                                    OnePrice = data_config:get(herosoul_cq),
                                    Expend = length(L) *  OnePrice,
                                    {diamond, 2, Expend, IdList};
                                _ -> {error,129,0,0}
                            end,
                            Id2 = case Type of
                                3 -> 0;
                                _ -> Id
                            end,
                            Num2 = case Type of
                                1 -> Num + 1;
                                _ -> Num
                            end,
                            NewHeroSoul = case Type of
                                3 -> [{P1,P2,1,P4} || {P1,P2,_P3,P4} <- HeroSoul];
                                _ ->
                                    lists:keyreplace(Pos,1,HeroSoul,{Pos,Id,1,Rare})
                            end,
                            NewTime = case Type of
                                1 -> util:unixtime();
                                _ -> Cd2
                            end,
                            case lib_role:spend(CType, Money, Rs) of
                                {ok, Rs1} ->
                                    case mod_item:add_items(Rs1, Prize) of
                                        {ok,Rs2,PA,EA} ->
                                            mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                                            lib_role:notice(Rs2),
                                            Rs3 = lib_role:spend_ok(CType, 67, Rs, Rs2),
                                            Rs4 = Rs3#role{herosoul = [Cd1,NewTime,TN,Num2,NewHeroSoul]},
                                            Time3 = max(0,CoinCd - (Time - NewTime)),
                                            Num3 = max(0,Num1-Num2),
                                            mod_item:log_item(add_item,Rs#role.id,13,Prize),
                                            Rs5 = mod_task:set_task(17,{1,1},Rs4),
                                            {ok, [0,Time3,Num3,Pos,Id2], Rs5#role{save=[herosoul]}};
                                        {error, full} ->
                                            {ok, [6,0,0,0,0]};
                                        {error, Reason} ->
                                            ?WARN("hero soul error:~w", [Reason]),
                                            {ok, [130,0,0,0,0]}
                                    end;
                                {error, _} -> {ok, [RtCode,0,0,0,0]}
                            end
                    end
            end
    end;
%%.

%%' 命运之轮
%% handle(13067, [Type], Rs) ->
%%     Num1 = case data_config:get(herosoul_cq_times) of
%%         undefined -> 0;
%%         N -> N
%%     end,
%%     Time = util:unixtime(),
%%     case Type of
%%         0 ->
%%             {Cd1,Cd2,Num,S} = case Rs#role.herosoul of
%%                 [] -> {Time,Time,0,[]};
%%                 [C1,C2,C3,C4] -> {C1,C2,C3,C4}
%%             end,
%%             Time1 = herosoul_lefttime(Cd1),
%%             Time2 = herosoul_coin_lefttime(Cd2),
%%             %% ?INFO("==Time1:~w,Time2:~w",[Time1,Time2]),
%%             {NewTime,HeroSoul} = case S == [] orelse Time1 == 0 of
%%                 true -> {Time,mod_item:herosoul_refresh()};
%%                 false -> {Cd1,S}
%%             end,
%%             SoulData = pack_herosoul(HeroSoul),
%%             Num2 = max(0,Num1-Num),
%%             Rs2 = Rs#role{herosoul = [NewTime,Cd2,Num,HeroSoul]
%%                 ,save = [herosoul]},
%%             {ok, [0,Time1,Time2,Num2,SoulData],Rs2};
%%         _ ->
%%             case Rs#role.herosoul of
%%                 [] -> {ok, [127,0,0,0,[]]};
%%                 [Cd1,Cd2,Num,_S] ->
%%                     Time1 = herosoul_lefttime(Cd1),
%%                     Time2 = herosoul_coin_lefttime(Cd2),
%%                     Num2 = max(0,Num1-Num),
%%                     HeroSoul = mod_item:herosoul_refresh(),
%%                     HeroSoulData = pack_herosoul(HeroSoul),
%%                     case Time1 == 0 of
%%                         true ->
%%                             Rs3 = Rs#role{
%%                                 herosoul = [Time,Cd2,Num,HeroSoul]
%%                                 ,save = [herosoul]
%%                             },
%%                             {ok,[0,Time1,Time2,Num2,HeroSoulData],Rs3};
%%                         false ->
%%                             Price = data_config:get(herosoul_refresh),
%%                             case lib_role:spend(diamond, Price, Rs) of
%%                                 {error, _} ->
%%                                     {ok,[1,0,0,0,[]]};
%%                                 {ok,Rs2} ->
%%                                     Rs3 = Rs2#role{
%%                                         herosoul = [Time,Cd2,Num,HeroSoul]
%%                                         ,save = [herosoul]
%%                                     },
%%                                     lib_role:notice(Rs3),
%%                                     Rs4 = lib_role:spend_ok(diamond, 66, Rs, Rs3),
%%                                     {ok,[0,Time1,Time2,Num2,HeroSoulData],Rs4}
%%                             end
%%                     end
%%             end
%%     end;
%%.

%%' 抽取英雄魂
%% Type=1金币抽取
%% Type=2钻石抽取
%% Type=3一键收取
%% 如果所有格子都被抽取,系统自动再次刷新
%% handle(13068, [Type], Rs) ->
%%    [Cd1,Cd2,Num,HeroSoul] = Rs#role.herosoul,
%%    Num1 = check_num_can_cq(HeroSoul,0),
%%     if  Num1 =< 0 ->
%%             %% 这种情况可能服务端和客户端数据不一致，客户端需要重新获取
%%             {ok, [8,0,0], Rs};
%%         Type == 1 ->
%%             LeftTime = herosoul_coin_lefttime(Cd2),
%%             if  LeftTime > 0 ->
%%                     {ok, [3,0,0], Rs};
%%                 Num =< 0 ->
%%                     {ok, [7,0,0], Rs};
%%                 true ->
%%                     Price = data_config:get(herosoul_coin_count),
%%                     case lib_role:spend(gold, Price, Rs) of
%%                         {error, _} ->
%%                             {ok,1,0,0};
%%                         {ok,Rs2} ->
%%                             Pos = herosoul_cq(HeroSoul),
%%                             {_,Id,_,Rare} = lists:keyfind(Pos,1,HeroSoul),
%%                             NewHeroSoul = lists:keyreplace(Pos,1,HeroSoul ,{Pos,Id,1,Rare}),
%%                             CheckNeedRefresh = need_hs_refresh(NewHeroSoul),
%%                             NewHeroSoul2 =
%%                             if  CheckNeedRefresh ->
%%                                     NewHeroSoul;
%%                                     %% mod_item:herosoul_refresh();
%%                                 true ->
%%                                     NewHeroSoul
%%                             end,
%%                             lib_role:notice(Rs2),
%%                             Rs3 = lib_role:spend_ok(gold, 67, Rs, Rs2),
%%                             CurTime = util:unixtime(),
%%                             Rs4=Rs3#role{
%%                                 herosoul = [Cd1,CurTime,Num-1,NewHeroSoul2]
%%                                 ,save = [herosoul,items]
%%                             },
%%                             {Rs6,Ret} =
%%                             case mod_item:add_item(Rs4, Id, 1) of
%%                                 {ok,Rs5,PA,EA} ->
%%                                     mod_item:send_notice(Rs5#role.pid_sender, PA, EA),
%%                                     {Rs5,0};
%%                                 {error, full} ->
%%                                     Title = data_text:get(2),
%%                                     Body = data_text:get(4),
%%                                     mod_mail:new_mail(Rs#role.id, 0, 12, Title, Body, [Id]),
%%                                     {Rs4, 6}
%%                             end,
%%                             {ok, [Ret,Pos,Id], Rs6}
%%                     end
%%             end;
%%         Type == 2 ->
%%             Price = data_config:get(herosoul_cq),
%%             case lib_role:spend(diamond, Price, Rs) of
%%                 {error, _} ->
%%                     {ok,2,0,0};
%%                 {ok,Rs2} ->
%%                     lib_role:notice(Rs2),
%%                     Rs3 = lib_role:spend_ok(diamond, 67, Rs, Rs2),
%%                     Pos = herosoul_cq(HeroSoul),
%%                     {_,Id,_,Rare} = lists:keyfind(Pos,1,HeroSoul),
%%                     NewHeroSoul = lists:keyreplace(Pos,1,HeroSoul ,{Pos,Id,1,Rare}),
%%                     CheckNeedRefresh = need_hs_refresh(NewHeroSoul),
%%                     NewHeroSoul2 =
%%                     if  CheckNeedRefresh ->
%%                             %% mod_item:herosoul_refresh();
%%                            NewHeroSoul;
%%                         true ->
%%                            NewHeroSoul
%%                     end,
%%                     Rs4=Rs3#role{
%%                         herosoul = NewHeroSoul2,
%%                         %% herosoul_time = CurTime,
%%                         save = [herosoul,items]},
%%                     {Rs6,Ret} =
%%                     case mod_item:add_item(Rs4, Id, 1) of
%%                         {ok,Rs5,PA,EA} ->
%%                             mod_item:send_notice(Rs5#role.pid_sender, PA, EA),
%%                             {Rs5,0};
%%                         {error, full} ->
%%                             Title = data_text:get(2),
%%                             Body = data_text:get(4),
%%                             mod_mail:new_mail(Rs#role.id, 0, 12, Title, Body, [Id]),
%%                             {Rs4, 6}
%%                     end,
%%                     {ok, [Ret,Pos,Id], Rs6}
%%             end;
%%         Type == 3 ->
%%             {LeftCount,IdList} =
%%             lists:foldl(fun(Pos,{Count,IdList1}) ->
%%                         {_,Id,State,_} = lists:keyfind(Pos,1,HeroSoul),
%%                         if  State == 0  ->
%%                                 {Count+1, [Id|IdList1]};
%%                             true ->
%%                                 {Count, IdList1}
%%                         end
%%                 end, {0, []}, lists:seq(1,9)),
%%             OnePrice = data_config:get(herosoul_cq),
%%             Price = LeftCount *  OnePrice,
%%             case lib_role:spend(diamond, Price, Rs) of
%%                 {error, _} ->
%%                     {ok,2,0,0};
%%                 {ok,Rs2} ->
%%                     %% NewHeroSoul2 = mod_item:herosoul_refresh(),
%%                     NewHeroSoul2 = lists:map(fun({Pos,Id,_,Rare}) ->
%%                             {Pos,Id,1,Rare}
%%                         end, HeroSoul),
%%                     lib_role:notice(Rs2),
%%                     Rs3 = lib_role:spend_ok(diamond, 67, Rs, Rs2),
%%                     Rs4=Rs3#role{
%%                         herosoul = NewHeroSoul2,
%%                         save = [herosoul,items]},
%%                     {Rs6,Ret} =
%%                     case mod_item:add_items(Rs4, IdList) of
%%                         {ok,Rs5,PA,EA} ->
%%                             mod_item:send_notice(Rs5#role.pid_sender, PA, EA),
%%                             {Rs5,0};
%%                         {error, full} ->
%%                             Title = data_text:get(2),
%%                             Body = data_text:get(4),
%%                             %% Type??
%%                             mod_mail:new_mail(Rs#role.id, 0, 12, Title, Body, IdList),
%%                             {Rs4, 6}
%%                     end,
%%                     {ok, [Ret,0,0], Rs6}
%%             end
%%     end;
%%.

handle(_Cmd, _Data, _RoleState) ->
    {error, bad_request}.


%% === 私有函数 ===

%% 测试函数,测试正常后修改/删除
%% timetest() ->
%%     {M, S, _MS} = os:timestamp(),
%%     M * 1000000 + S. % + MS / 1000000.
%%
%% timetest2(today) ->
%% 	{M, S, MS} = os:timestamp(),
%%     {_, Time} = calendar:now_to_local_time({M, S, MS}),
%%     M * 1000000 + S - calendar:time_to_seconds(Time).

%% luck star
luck_process(Rand, [{Tid, Pos, Num, Quality, Min, Max, Value} | T]) ->
    case Rand >= Min andalso Rand =< Max of
        true -> {Tid, Num, Quality, Pos, Value};
        false -> luck_process(Rand, T)
    end;
luck_process(_, []) -> {0, 0, 0, 0, 0}.

-spec luck_rebate(LuckDia, Rs) -> NewRs when
    LuckDia :: integer(),
    Rs :: #role{},
    NewRs :: #role{}.
luck_rebate(LuckDia, Rs) ->
    case LuckDia >= data_config:get(starBack) of
        true ->
            Rs1 = lib_role:add_attr(diamond, LuckDia, Rs),
            lib_role:notice(diamond, Rs1),
            {LuckStar1, _LuckDia1, LuckUsed1, ValSum1} = Rs1#role.luck,
            Lists1 = {LuckStar1, 0, LuckUsed1, ValSum1},
            Rs2 = Rs1#role{luck = Lists1},
            lib_role:add_attr_ok(diamond, 9, Rs, Rs2);
        false ->
            Rs
    end.

jewel(Q, Rs) ->
    JewelData = data_jewel:get(Q),
    RateN = util:get_val(rate_next, JewelData),
    Rate  = util:get_val(rate, JewelData),
    Rate2 = util:get_val(rate2, JewelData),
    Rate3 = util:get_val(rate3, JewelData),
    Rate4 = util:get_val(rate4, JewelData),
    RateList = [Rate, Rate2, Rate3, Rate4],
    Money = util:get_val(money, JewelData),
    Num   = util:get_val(num, JewelData),
    {CType, RtCode} = case Money of
        1 -> {gold, 1};
        2 -> {diamond, 2}
    end,
    case lib_role:spend(CType, Num, Rs) of
        {ok, Rs1} ->
            case jewel1(RateList, RateN, Q, Rs1) of
                {ok, NextQ, ItemId, Tid, Rs2} ->
                    Rs3 = lib_role:spend_ok(CType, 8, Rs, Rs2),
                    lib_role:notice(Rs3),
                    Rs4 = role:save_delay(jewel, Rs3),
                    Rs5 = mod_attain:attain_state(63, 1, Rs4),
                    Rs6 = mod_task:set_task(20,{1,1},Rs5),
                    ?LOG({jewel, Rs#role.id, Tid}),
                    {ok, [0, NextQ, ItemId, Tid], Rs6};
                {error, full, NextQ, Rs22} ->
                    Rs2 = lib_role:spend_ok(CType, 8, Rs, Rs22),
                    lib_role:notice(Rs2),
                    Rs3 = mod_attain:attain_state(63, 1, Rs2),
                    Rs4 = mod_task:set_task(20,{1,1},Rs3),
                    {ok, [3, NextQ, 0, 0], Rs4};
                {error, Reason} ->
                    ?ERR("~w", [Reason]),
                    {ok, [130, 0, 0, 0]}
            end;
        {error, _} -> {ok, [RtCode, 0, 0, 0]}
    end.

jewel1(RateList, RateN, Q, Rs) ->
    %% 状态处理
    Jewel = case Q > 1 of
        true ->
            %% 如果当前抽取的品质大于1，则把状态置0
            lists:keyreplace(Q, 1, Rs#role.jewel, {Q, 0});
        false ->
            %% 品质1的状态始终为1
            Rs#role.jewel
    end,
    {Jewel1, NextQ} = case util:rate(RateN) of
        true ->
            %% 成功开启下一品质等级
            J = lists:keyreplace(Q+1, 1, Jewel, {Q+1, 1}),
            {J, Q+1};
        false ->
            %% 开启下一品质等级失败，则掉回品质1
            {Jewel, 1}
    end,
    %% 抽取宝珠
    {Tid, ObtainQ} = rate_jewel(RateList, Q),
    case ObtainQ >= 4 of
        true ->
            Vip = lib_admin:get_vip(Rs),
            Name = lib_admin:get_name(Rs),
            Msg = data_text:get(8),
            Msg1 = io_lib:format(Msg, [Name, Tid]),
            lib_system:cast_sys_msg(0, Name, Msg1, Vip);
        false -> ok
    end,
    case Tid > 0 of
        true ->
            %% 抽取到了宝珠，添加物品
            case mod_item:add_item(Rs, Tid, 1) of
                {ok, Rs1, PA, EA} ->
                    mod_item:send_notice(Rs#role.pid_sender, PA, EA),
                    %% 成就推送
                    Rs0 = case ObtainQ of
                        3 -> mod_attain:attain_state(24, 1, Rs1);
                        4 -> mod_attain:attain_state(25, 1, Rs1);
                        5 -> mod_attain:attain_state(26, 1, Rs1);
                        _ -> Rs1
                    end,
                    %% Rs0 = case ObtainQ =:= 4 of
                    %%     true -> mod_attain:attain_state(53, 1, Rs2);
                    %%     false -> Rs2
                    %% end,
                    [#item{id = ItemId} | _] = EA ++ PA,
                    {ok, NextQ, ItemId, Tid, Rs0#role{save = [items], jewel = Jewel1}};
                %% TODO:邮件系统
                {error, full} ->
                    Title = data_text:get(2),
                    Body = data_text:get(4),
                    mod_mail:new_mail(Rs#role.id, 0, 8, Title, Body, [{Tid, 1}]),
                    %% 成就推送
                    Rs1 = case ObtainQ of
                        3 -> mod_attain:attain_state(24, 1, Rs);
                        4 -> mod_attain:attain_state(25, 1, Rs);
                        5 -> mod_attain:attain_state(26, 1, Rs);
                        _ -> Rs
                    end,
                    {error, full, NextQ, Rs1#role{jewel = Jewel1}};
                {error, Error} ->
                    {error, Error}
            end;
        false ->
            {ok, NextQ, 0, 0, Rs#role{jewel = Jewel1}}
    end.

rate_jewel([R1 | R], Q) ->
    %% 抽取宝珠
    case util:rate(R1) of
        true ->
            %% 成功抽取到当前等级的宝珠
            {get_jewel_id(Q), Q};
        false ->
            %% 没有抽取到当前等级的宝珠
            %% 计算是否能抽取到其它等级的宝珠
            QQ = case Q > 1 of
                true -> Q - 1;
                false -> 1
            end,
            rate_jewel(R, QQ)
    end;

rate_jewel([], _Q) -> {0, 0}.

get_jewel_id(Quality) ->
    Ids = data_prop:get(ids),
    {Type} = util:get_range_data(data_jewel2),
    get_jewel_id1(Ids, Quality, Type).

get_jewel_id1([Tid | Ids], Q, T) ->
    Data = data_prop:get(Tid),
    Quality = util:get_val(quality, Data),
    Sort = util:get_val(sort, Data),
    Control1 = util:get_val(control1, Data),
    case Sort == 4 andalso Quality == Q
        andalso Control1 == T of
        true -> Tid;
        false -> get_jewel_id1(Ids, Q, T)
    end;
get_jewel_id1([], Q, T) ->
    ?WARN("[Not Found Jewel] Quality:~w, Attr:~w", [Q, T]),
    0.

%% ----------------------

get_produce_ids([H | T], Rt) ->
    Rt1 = Rt ++ get_produce_ids1(H),
    get_produce_ids(T, Rt1);
get_produce_ids([], Rt) ->
    Rt.

%% {Type,Num,ID}
%%
%% 掉落类型(Type)：
%% 1一次性抽取Num个，ID不会重复；
%% 2为Num个独立事件，每次抽取1个ID，最终抽取的ID可能会重复.
%%
%% 以上两种类型中，抽取到的掉落ID不代表一定会有物品，这要取决于掉落ID对应的物品ID中是否有0存在。
get_produce_ids1({Type, Num, Id}) ->
    case data_produce:get(Id) of
        undefined ->
            ?WARN("Error Produce Id: ~w", [Id]),
            [];
        ProduceData ->
            {_, {_, Top}} = lists:last(ProduceData),
            case Type of
                1 -> get_produce_ids21(Num, Top, ProduceData, []);
                2 -> get_produce_ids22(Num, Top, ProduceData, [])
            end
    end.

get_produce_ids21(0, _Top, _Range, Rt) -> Rt;
get_produce_ids21(Num, Top, Range, Rt) ->
    %% ?DEBUG("Range:~w", [Range]),
    Rand = util:rand(1, Top),
    {Rt1, Range1} = case [{N, {S, E}} || {N, {S, E}} <- Range, S =< Rand, E >= Rand] of
        [{0, X1}] -> {[], lists:delete({0, X1}, Range)};
        [{Tid, X1}] -> {[Tid], lists:delete({Tid, X1}, Range)};
        [] -> {[], Range}
    end,
    Num1 = Num - 1,
    {Range2, Top1} = case Num1 > 0 andalso Range1 =/= [] of
        true ->
            Range11 = fix_range(Range1, 1, []),
            {_, {_, Top11}} = lists:last(Range11),
            {Range11, Top11};
        false ->
            {Range1, Top}
    end,
    get_produce_ids21(Num1, Top1, Range2, Rt1 ++ Rt).

get_produce_ids22(0, _Top, _Range, Rt) -> Rt;
get_produce_ids22(Num, Top, Range, Rt) ->
    Rand = util:rand(1, Top),
    case [N || {N, {S, E}} <- Range, S =< Rand, E >= Rand] of
        [0] -> get_produce_ids22(Num-1, Top, Range, Rt);
        [Tid] -> get_produce_ids22(Num-1, Top, Range, [Tid|Rt]);
        [] ->
            ?WARN("get_produce_ids22", []),
            get_produce_ids22(Num-1, Top, Range, Rt)
    end.

%% [{101001,{1,50}},{101000,{51,70}},{101001,{71,100}},{101002,{1,48}},{0,{49,98}}]
fix_range([{Tid, {S, E}} | T], Fix, Rt) ->
    {Fix1, Elem} = case S == Fix of
        true ->
            {E + 1, {Tid, {S, E}}};
        false ->
            Range = E - S,
            S1 = Fix,
            E1 = S1 + Range,
            {E1 + 1, {Tid, {S1, E1}}}
    end,
    Rt1 = [Elem | Rt],
    fix_range(T, Fix1, Rt1);
fix_range([], _, Rt) ->
    lists:reverse(Rt).

%% gen_range(Data) ->
%%     gen_range(Data, 1, []).
%% gen_range([{X1, X2, W} | T], Fix, Rt) ->
%%     S = Fix,
%%     E = S + W - 1,
%%     Rt1 = [{X1, X2, S, E} | Rt],
%%     gen_range(T, E + 1, Rt1);
%% gen_range([], _, Rt) ->
%%     lists:reverse(Rt).
%%
%% gen_item_tid(Num, Range) ->
%%     {_, _, _, Top} = lists:last(Range),
%%     gen_item_tid(Num, Top, Range, []).
%%
%% gen_item_tid(0, _Top, _Range, Rt) ->
%%     Rt;
%% gen_item_tid(Num, Top, Range, Rt) ->
%%     Rand = util:rand(1, Top),
%%     case [{N, C} || {N, C, S, E} <- Range, S =< Rand, E >= Rand] of
%%         [{N, C}] -> gen_item_tid(Num-1, Top, Range, [{N, C}|Rt]);
%%         [] ->
%%             ?WARN("gen_item_tid", []),
%%             gen_item_tid(Num-1, Top, Range, Rt)
%%     end.


equ_handle([H | T], Rs) ->
    case equ_handle1(H, Rs) of
        {ok, Rs1} -> equ_handle(T, Rs1);
        {error, Error} -> {error, Error}
    end;
equ_handle([], Rs) ->
    {ok, Rs}.

equ_handle1([HeroId, Pos, EquId], Rs) when Pos > 0 andalso Pos =< 5 ->
    #role{heroes = Heroes, items = Items} = Rs,
    case mod_hero:get_hero(HeroId, Heroes) of
        false ->
            ?WARN("No Hero:~w", [HeroId]),
            %% 英雄不存在
            {error, 127};
        Hero ->
            #hero{equ_grids = EquGrids} = Hero,
            OldEquId = element(Pos, EquGrids),
            case EquId > 0 of
                true ->
                    %% 穿装备
                    case mod_item:get_item(EquId, Items) of
                        false ->
                            ?WARN("No Item:~w", [EquId]),
                            %% 装备不存在
                            {error, 128};
                        Item ->
                            %% {ItemPos,ItemLev} = case data_equ:get(Item#item.tid) of
                            %%     undefined -> {0,1};
                            %%     ItemData -> {util:get_val(pos, ItemData, 0),util:get_val(lev,ItemData,1)}
                            %% end,
                             case data_equ:get(Item#item.tid) of
                                undefined -> {error,141};
                                ItemData ->
                                    {ItemPos,ItemLev} = {util:get_val(pos, ItemData, 0),util:get_val(lev,ItemData,1)},
                                    if
                                        ItemPos =/= Pos ->
                                            %% 穿戴位置不正确
                                            {error, 129};
                                        Item#item.attr#equ.hero_id > 0 andalso Item#item.attr#equ.hero_id =/= HeroId ->
                                            %% 此装备已穿在别的英雄身上
                                            {error, 131};
                                        %% Item#item.attr#equ.lev > Hero#hero.lev ->
                                        ItemLev > Hero#hero.lev ->
                                            %% 英雄等级不够
                                            {error, 2};
                                        true ->
                                            #hero{equ_grids = EquGrids} = Hero,
                                            OldEquId = element(Pos, EquGrids),
                                            Items11 = case OldEquId > 0 of
                                                true ->
                                                    %% 替换装备，对原穿戴的装备进行处理
                                                    Items1 = case mod_item:get_item(OldEquId, Items) of
                                                        false ->
                                                            %% 原穿戴的装备不存在
                                                            ?WARN("non-existent old equ: ~w", [OldEquId]),
                                                            Items;
                                                        OldItem ->
                                                            %% 把原装备卸下 (装备上的英雄ID置0)
                                                            Equ = OldItem#item.attr#equ{hero_id = 0},
                                                            OldItem1 = OldItem#item{attr = Equ, changed = 1},
                                                            mod_item:set_item(OldItem1, Items)
                                                    end,
                                                    Equ1 = Item#item.attr#equ{hero_id = HeroId},
                                                    Item1 = Item#item{attr = Equ1, changed = 1},
                                                    mod_item:set_item(Item1, Items1);
                                                false ->
                                                    %% 在空格子上穿装备
                                                    Items
                                            end,
                                            %% 把英雄相应格子上设置为装备ID
                                            EquGrids1 = setelement(Pos, EquGrids, EquId),
                                            Hero1 = Hero#hero{equ_grids = EquGrids1, changed = 1},
                                            Heroes1 = mod_hero:set_hero(Hero1, Heroes),
                                            %% 更新装备上的英雄ID
                                            Equ2 = Item#item.attr#equ{hero_id = HeroId},
                                            Item2 = Item#item{attr = Equ2, changed = 1},
                                            Items12 = mod_item:set_item(Item2, Items11),
                                            Rs1 = mod_attain:item_attain(Items12, Rs),
                                            Rs2 = mod_task:set_task(13,{1,1},Rs1),
                                            {ok, Rs2#role{items = Items12, heroes = Heroes1}}
                                    end
                            end
                    end;
                false ->
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
                                            EquGrids1 = setelement(Pos, EquGrids, 0),
                                            Hero1 = Hero#hero{equ_grids = EquGrids1, changed = 1},
                                            Heroes1 = mod_hero:set_hero(Hero1, Heroes),
                                            {ok, Rs#role{items = Items1, heroes = Heroes1}};
                                        false ->
                                            {error, 1}
                                    end
                            end;
                        false ->
                            %% 没有装备可被卸载
                            ?WARN("non-existent old equ: ~w", [OldEquId]),
                            {error, 130}
                    end
            end
    end;
equ_handle1([_HeroId, Pos, _EquId], _Rs) ->
    ?WARN("error equ pos: ~w", [Pos]),
    {error, 140}.


%%' 批量镶嵌
%% -> [Code, EquId]
%% Code:
%% 0 = 成功
%% 1 = 镶嵌失败（注：不是错误）
%% 2 = 金币不足
%% 3 = 钻石不足
%% 4 = 装备的孔不足
%% >=127 = 程序异常
%% handle(13010, [List], Rs) ->
%%     [Code, L3, Rs3] = case jewel_embed(List, Rs) of
%%         [0, Rs2] ->
%%             L = [E || [E, _] <- List],
%%             [0, L, Rs2];
%%         [N, L2] -> [N, L2, Rs]
%%     end,
%%     {ok, [Code, L3], Rs3};
%%
%% jewel_embed(List, Rs) ->
%%     jewel_embed(List, Rs, [], []).
%% jewel_embed([], _Rs, Rt, Et) when Rt == [] orelse Et == [] -> [136, []];
%% jewel_embed([], Rs, Rt, Et) ->
%%     F1 = fun({Notice, EquItem1}, R) ->
%%             mod_item:send_notice(R#role.pid_sender, Notice),
%%             mod_item:send_notice(R#role.pid_sender, [], [EquItem1]),
%%             %% 一切都OK后，从数据库中删除物品
%%             mod_item:del_items_from_db(R#role.id, Notice)
%%     end,
%%     F2 = fun({EquItem, GemTid}, R) ->
%%             ?LOG({embed, R#role.id, EquItem#item.tid, GemTid})
%%     end,
%%     lists:foldl(F1, Rs, Rt),
%%     lists:foldl(F2, Rs, Et),
%%     lib_role:notice(Rs),
%%     [0, Rs];
%% jewel_embed([[EquId, GemTid] | T], Rs, Rt, Et) ->
%%     Items = Rs#role.items,
%%     EquItem = mod_item:get_item(EquId, Items),
%%     GemItem = mod_item:get_less_prop(Items, GemTid),
%%     % ?DEBUG("GemItem:~w, tid:~w ", [GemItem, GemItem#item.tid]),
%%     % ?DEBUG("EquId:~w, GemTid:~w", [EquId, GemTid]),
%%     if
%%         EquItem == false ->
%%             [127, []];
%%         GemItem == false ->
%%             [128, []];
%%         EquItem#item.tid < ?MIN_EQU_ID ->
%%             [129, []];
%%         GemItem#item.tid > ?MIN_EQU_ID ->
%%             [130, []];
%%         GemItem#item.sort =/= 4 ->
%%             [131, []];
%%         EquItem#item.attr#equ.sockets =< 0 ->
%%             [132, []];
%%         true ->
%%             #item{tid = GemTid, attr = GemAttr} = GemItem,
%%             JewelData = data_jewel:get(GemAttr#prop.quality),
%%             Currency = util:get_val(money1, JewelData),
%%             Num = util:get_val(num1, JewelData),
%%             {CType, RtCode} = case Currency of
%%                 1 -> {gold, 2};
%%                 2 -> {diamond, 3}
%%             end,
%%             case lib_role:spend(CType, Num, Rs) of
%%                 {ok, Rs1} ->
%%                     case mod_item:del_items(by_tid, [{GemTid, 1}], Items) of
%%                         {ok, Items1, Notice} ->
%%                             case mod_item:embed(EquItem, GemItem) of
%%                                 {ok, EquItem1} ->
%%                                     Items2 = mod_item:set_item(EquItem1, Items1),
%%                                     Rs2 = Rs1#role{items = Items2, save = [role, items]},
%%                                     %% 成就推送
%%                                     Rs3 = mod_attain:attain_state(47, 1, Rs2),
%%                                     Rs0 = lib_role:spend_ok(CType, 2, Rs, Rs3),
%%                                     jewel_embed(T, Rs0, [{Notice, EquItem1} | Rt], [{EquItem, GemTid} | Et]);
%%                                 {error, no_sock} -> [4, []];
%%                                 {error, quality} -> [135, []];
%%                                 {error, Reason} ->
%%                                     ?ERR("~w", [Reason]),
%%                                     [136, []]
%%                             end;
%%                         {error, _} -> [RtCode, []]
%%                     end;
%%                 {error, _} -> [2, []]
%%             end
%%     end.
%%.

%%' 批量合成
forge(List, Rs) ->
    forge(List, Rs, []).

forge([], Rs, Rt) ->
    forge1(Rt, Rs);
forge([[Tid]|Tids], Rs, Rt) ->
    Items = Rs#role.items,
    Data = data_forge:get(Tid),
    if
        Data == undefined ->
            [127];
        true ->
            {_Send, Rate, Del, Type, Price, Dels} = Data,
            {CType, RtCode} = case Type of
                1 -> {gold, 4};
                2 -> {diamond, 5}
            end,
            case lib_role:spend(CType, Price, Rs) of
                {ok, Rs1} ->
                    {DelsEqu, DelsMat} = dels_tids(Dels,Items),
                    case DelsEqu of
                        130 -> [130];
                        2 -> [2];
                        6 -> [6];
                        _ ->
                            {Rs11, Rt11} = case DelsEqu == [] of
                                true -> {Rs1,[]};
                                false ->
                                    case mod_item:del_items(by_id, DelsEqu, Items) of
                                        {ok, Items1, Notice1} ->
                                            {Rs1#role{items = Items1},Notice1};
                                        {error, _} ->
                                            {Rs1,error}
                                    end
                            end,
                            case Rt11 of
                                error -> [2];
                                _ ->
                                    case mod_item:del_items(by_tid, DelsMat, Rs11#role.items) of
                                        {ok, Items2, Notice2} ->
                                            case util:rate(Rate) of
                                                true ->
                                                    Rs2 = Rs11#role{items = Items2},
                                                    %% 合成成功成就推送
                                                    Rs3 = mod_attain:attain_state(23,1, Rs2),
                                                    Rs4 = case DelsMat of
                                                        [{11093,_}] -> mod_attain:attain_state(18,1,Rs3);
                                                        [{11381,_}] -> mod_attain:attain_state(19,1,Rs3);
                                                        [{11189,_}] -> mod_attain:attain_state(20,1,Rs3);
                                                        [{11285,_}] -> mod_attain:attain_state(21,1,Rs3);
                                                        _ -> Rs3
                                                    end,
                                                    Rs5 = mod_attain:attain_state(43, 1, Rs4),
                                                    Rs6 = case data_hero:get(Tid) of
                                                        undefined -> Rs5;
                                                        _ ->
                                                            mod_task:set_task(9,{1,1},Rs5)
                                                    end,
                                                    forge(Tids, Rs6, [{Tid,{Notice2,Rt11},0}|Rt]);
                                                false ->
                                                    %% 失败成就推送和是否损毁
                                                    Rs2 = case Del == 1 of
                                                        true -> Rs11#role{items = Items2};
                                                        false -> Rs11
                                                    end,
                                                    Rs3 = mod_attain:attain_state(22, 1, Rs2),
                                                    Rs4 = mod_attain:attain_state(43, 1, Rs3),
                                                    Rs5 = case data_hero:get(Tid) of
                                                        undefined -> Rs4;
                                                        _ ->
                                                            mod_task:set_task(9,{1,1},Rs4)
                                                    end,
                                                    forge(Tids,Rs5,[{Tid,{Notice2,Rt11},1}|Rt])
                                            end;
                                        {error, _} ->
                                            [2]
                                    end
                            end
                    end;
                {error, _} ->
                    [RtCode]
            end
    end.

forge1([], _Rs) -> [129];
forge1(List, Rs) ->
    F = fun({Tid,_,Is}) ->
            case Is == 1 of
                true -> [];
                false ->
                    case data_hero:get(Tid) of
                        undefined -> {Tid,1};
                        _ -> {5, {Tid,1}}
                    end
            end
    end,
    Tids = [F(X) || X <- List, F(X) =/= []],
    %% Tids = [Tid || {Tid,_,Is} <- List, Is == 0],
    Tidss = [{Tid,Is} || {Tid,_,Is} <- List],
    case mod_item:add_items(Rs,Tids) of
        {ok, Rs1, PA, EA} ->
            %% ItemIds = [Item#item.id || Item <- EA++PA],
            mod_item:send_notice(Rs#role.pid_sender, PA, EA),
            Rs2 = forge2(List,Rs1),
            mod_item:log_item(add_item,Rs#role.id,2,Tids),
            [0,Tidss,Rs2];
        {error, full} ->
            Title = data_text:get(2),
            Body = data_text:get(4),
            mod_mail:new_mail(Rs#role.id, 0, 3, Title, Body, Tids),
            Rs3 = forge2(List,Rs),
            [3,Tidss,Rs3];
        {error, _} ->
            [128]
    end.

forge2([], Rs) -> Rs;
forge2([{Tid,{Notice1,Notice2},Is}|T], Rs) ->
    {Send,_Rate,Del,_Type,_Price,_Dels} = data_forge:get(Tid),
    case Is == 0 of
        true ->
            %% 从数据库中删除物品
            mod_item:send_notice(Rs#role.pid_sender, Notice1),
            mod_item:del_items_from_db(Rs#role.id, Notice1),
            case Notice2 of
                [] -> ok;
                _ ->
                    mod_item:send_notice(Rs#role.pid_sender, Notice2),
                    mod_item:del_items_from_db(Rs#role.id, Notice2)
            end;
        false ->
            case Del == 1 of
                true ->
                    mod_item:send_notice(Rs#role.pid_sender, Notice1),
                    mod_item:del_items_from_db(Rs#role.id, Notice1),
                    case Notice2 of
                        [] -> ok;
                        _ ->
                            mod_item:send_notice(Rs#role.pid_sender, Notice2),
                            mod_item:del_items_from_db(Rs#role.id, Notice2)
                    end;
                false -> ok
            end
    end,
    %% 是否推送广播消息
    case Send == 1 andalso Is == 0 of
        true ->
            Name = lib_admin:get_name(Rs),
            Vip = lib_admin:get_vip(Rs),
            Msg = case data_hero:get(Tid) of
                undefined -> data_text:get(6);
                _ -> data_text:get(21)
            end,
            Msg1 = io_lib:format(Msg, [Name, Tid]),
            lib_system:cast_sys_msg(0, Name, Msg1, Vip);
        false -> ok
    end,
    %% 批量写日志
    ?LOG({forge, Rs#role.id, Tid}),
    forge2(T,Rs).

dels_tids(Dels,Items) ->
    Delss = dels_tids_broken(Dels, []),
    dels_tids(Delss,Items,[],[]).
dels_tids([],_,Rt1,Rt2) -> {Rt1,Rt2};
dels_tids([{Tid,Num}|Dels],Items,Rt1,Rt2) ->
    case Tid > ?MIN_EQU_ID of
        true ->
            case mod_item:get_items(Tid, Items) of
                false -> {2, Rt2};
                ItemL ->
                    case dels_tids1(ItemL) of
                        6 -> {6, Rt2};
                        130 -> {130, Rt2};
                        Item ->
                            Items1 = lists:keydelete(Item#item.id, #item.id, Items),
                            dels_tids(Dels,Items1,[{Item#item.id,Num}|Rt1],Rt2)
                    end
            end;
            %% case lists:keyfind(Tid, #item.tid, Items) of
            %%     false -> {2, Rt2};
            %%     Item when is_record(Item,item) ->
            %%         case Item#item.attr#equ.hero_id == 0 andalso Num == 1 of
            %%             true ->
            %%                 Items1 = lists:keydelete(Item#item.id, #item.id, Items),
            %%                 dels_tids(Dels,Items1,[{Item#item.id,Num}|Rt1],Rt2);
            %%             false ->
            %%                 {6, Rt2}
            %%         end;
            %%     _ -> {error, Rt2}
            %% end;
        false ->
            dels_tids(Dels,Items,Rt1,[{Tid,Num}|Rt2])
    end.

dels_tids1([]) -> 6;
dels_tids1([Item|ItemL]) when is_record(Item,item) ->
    case Item#item.attr#equ.hero_id of
        0 -> Item;
        _ -> dels_tids1(ItemL)
    end;
dels_tids1(_) -> 130.

dels_tids_broken([], Rt) -> Rt;
dels_tids_broken([{Tid,Num}|Dels], Rt) ->
    case Tid > ?MIN_EQU_ID of
        true ->
            case Num > 1 of
                true ->
                    dels_tids_broken([{Tid,Num - 1}|Dels], [{Tid,1}|Rt]);
                false ->
                    dels_tids_broken(Dels, [{Tid,Num}|Rt])
            end;
        false ->
            dels_tids_broken(Dels, [{Tid,Num}|Rt])
    end.

%% forge_attain([], Rs) -> Rs;
%% forge_attain([{Tid,Num}|Tidss], Rs) when Num == 0 ->
%%     case data_equ:get(Tid) of
%%         undefined ->
%%             forge_attain(Tidss, Rs);
%%         Data ->
%%             Pos = util:get_val(pos,Data,0),
%%             Quality = util:get_val(quality,Data,0),
%%             Rs1 = case Pos of
%%                 1 ->
%%                     mod_attain:attain_state(82,1,Rs);
%%                 _ -> Rs
%%             end,
%%             Rs2 = case Pos == 1 andalso Quality == 5 of
%%                 true ->
%%                     mod_attain:attain_state(83,1,Rs1);
%%                 false -> Rs1
%%             end,
%%             Rs3 = case Pos == 1 andalso Quality == 4 of
%%                 true ->
%%                     mod_attain:attain_state(85,1,Rs2);
%%                 false -> Rs2
%%             end,
%%             forge_attain(Tidss, Rs3)
%%     end;
%% forge_attain([_|Tidss], Rs) ->
%%     forge_attain(Tidss, Rs).

%%.

unembed(Item, GemTid, Rs) ->
    case is_record(Item#item.attr, equ) of
        true ->
            Attr = Item#item.attr,
            EmbedL = Attr#equ.embed,
            case lists:keyfind(GemTid, 1, EmbedL) of
                false -> {128, {}, 1, 0, Rs};
                JewelL ->
                    {_GemTid, _AttrId, _AttrVal, Lev, Exp} = JewelL,
                    NewJewelL = lists:delete(JewelL, EmbedL),
                    Equ2 = Attr#equ{embed = NewJewelL},
                    EquItem2 = Item#item{attr = Equ2, changed = 1},
                    Items2 = mod_item:set_item(EquItem2, Rs#role.items),
                    Rs1 = Rs#role{items = Items2, save = [items]},
                    {0, EquItem2, Lev, Exp, Rs1}
            end;
        false -> {129, {}, 1, 0, Rs}
    end.

jewelry_upgrade(Lev,Qua,Exp) ->
    case data_jewel_lev:get({Lev,Qua}) of
        undefined -> {Lev,Exp};
        Data ->
            Exp1 = util:get_val(exp,Data,0),
            case Exp < Exp1 of
                true -> {Lev,Exp};
                false ->
                    Ids = data_jewel_lev:get(ids),
                    case lists:member({Lev + 1, Qua}, Ids) of
                        true ->
                            jewelry_upgrade(Lev + 1,Qua,Exp-Exp1);
                        false -> {Lev,Exp}
                    end
            end
    end.

jewelry_upgrade_exp(Ids, Items) ->
    jewelry_upgrade_exp(lists:flatten(Ids), Items, 0, 0).
jewelry_upgrade_exp([], _Items, Sum1, Sum2) -> {Sum1,Sum2};
jewelry_upgrade_exp([Id|Ids], Items, Sum1, Sum2) ->
    {Sum3,Sum4} = case mod_item:get_item(Id, Items) of
        false -> {0,0};
        Item ->
            Sort = Item#item.sort,
            Attr = Item#item.attr,
            case is_record(Attr,prop) andalso Sort == 4 of
                true ->
                    #prop{
                        quality   = Quality
                        ,level     = Level
                    } = Attr,
                    Data = data_jewel_lev:get({Level,Quality}),
                    {util:get_val(provide,Data,0),
                    util:get_val(expend,Data,0)};
                false -> {0,0}
            end
    end,
    jewelry_upgrade_exp(Ids, Items, Sum1 + Sum3, Sum2 + Sum4).

%%' hero soul
%% 抽取
%% herosoul_cq(HeroSoul) ->
%%     List = data_herosoul:get(ids),
%%     ListProp = lists:foldl(fun(Pos,PosPrList) ->
%%                 %% 抽取过的格子位置要去掉
%%                 {Pos1,_,State1,_} = lists:keyfind(Pos,1,HeroSoul),
%%                 if  Pos1 == Pos andalso State1 == 1  ->
%%                         PosPrList;
%%                     true ->
%%                         case data_herosoul:get(Pos) of
%%                             undefined ->
%%                                 ?WARN("herosoul Pos:~w", [Pos]),
%%                                 [{Pos,0}|PosPrList];
%%                             [_,{rate,Rate}|_] ->
%%                                 [{Pos,Rate}|PosPrList]
%%                         end
%%                 end
%%         end, [], List),
%%     [{Pos2,_}] = util:weight_extract2(ListProp),
%%     Pos2.

%% check_num_can_cq(HeroSoul) ->
%%     List = data_herosoul:get(ids),
%%     lists:foldl(fun(Pos,Num) ->
%%                 %% 抽取过的格子位置要去掉
%%                 {Pos1,_,State1,_} = lists:keyfind(Pos,1,HeroSoul),
%%                 if  Pos1 == Pos andalso State1 == 1  ->
%%                         Num;
%%                     true ->
%%                         Num+1
%%                 end
%%         end, 0, List).

%% 是否已经被全部抽取刷新
%% need_hs_refresh(NewHeroSoul) ->
%%     need_hs_refresh(NewHeroSoul,true).
%%
%% need_hs_refresh([],Ret) ->
%%     Ret;
%% need_hs_refresh([{_,_,State,_}|T],Ret) ->
%%     case State of
%%         0 -> false;
%%         _ ->
%%             need_hs_refresh(T,Ret)
%%     end.

%% 还有几个可以抽取的英雄魂
%% check_num_can_cq([], Rt) -> Rt;
%% check_num_can_cq([{_,_,St,_}|T], Rt) ->
%%     St1 = case St of
%%         1 -> Rt;
%%         _ -> Rt + 1
%%     end,
%%     check_num_can_cq(T,St1).

%% 封装英雄魂数据
pack_herosoul(HeroSoulList) ->
    pack_herosoul2(HeroSoulList, []).

pack_herosoul2([], Ret) ->
    Ret;
pack_herosoul2([Tuple|T], Ret) ->
    List = tuple_to_list(Tuple),
    pack_herosoul2(T, [List|Ret]).

herosoul_cq([], Rt) ->
    case util:weight_extract2(Rt) of
        [] -> [];
        [{PosInfo,_}] -> PosInfo
    end;
herosoul_cq([{Pos,Id,St,Rare}|T], Rt) when St == 0 ->
    case data_herosoul:get(Pos) of
        undefined ->
            herosoul_cq(T, Rt);
        Data ->
            Rate = util:get_val(rate,Data,0),
            herosoul_cq(T,[{{Pos,Id,St,Rare},Rate}|Rt])
    end;
herosoul_cq([_|T],Rt) ->
    herosoul_cq(T, Rt).

%% 英雄魂刷新剩余时间
%% herosoul_lefttime(Cd) ->
%%     case is_integer(Cd) andalso Cd > 0 of
%%         true ->
%%             Time = util:unixtime(),
%%             %% Max = data_config:get(herosoul_cd),
%%             Max = 120,
%%             max(0, Max - (Time - Cd));
%%         false -> 0
%%     end.

%% 英雄魂金币抽取剩余时间
%% herosoul_coin_lefttime(Cd) ->
%%     case is_integer(Cd) andalso Cd > 0 of
%%         true ->
%%             Time = util:unixtime(),
%%             %% Max = data_config:get(herosoul_coin_cd),
%%             Max = 120,
%%             max(0, Max - (Time - Cd));
%%         false -> 0
%%     end.
%%.

%%' 幸运星抽取
%% # 消息代码：
%% # 0=成功
%% # 1=没有幸运星
%% # 3=背包已满
%% # >=127 = 程序异常
%% handle(13040, [], Rs) ->
%%     #role{id = Rid, name = Name, luck = {LuckStar, LuckDia, LuckUsed, ValSum}} = Rs,
%%     case LuckStar >= 1 of
%%         true ->
%%             LuckId = mod_luck:get_luck_id(),
%%             case data_luck:get(LuckId) of
%%                 undefined ->
%%                     ?WARN("luck id is wrong", []),
%%                     {ok, [128, 0, 0]};
%%                 LuckData ->
%%                     Cumulative = data_config:get(starCumulative),
%%                     LastData = lists:last(LuckData),
%%                     RandTop = element(size(LastData) - 1, LastData),
%%                     Rand = util:rand(1, RandTop),
%%                     case luck_process(Rand, LuckData) of
%%                         {1, Num, Quality, Pos, Val} ->
%%                             Rs1 = lib_role:add_attr(gold, Num, Rs),
%%                             Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                             Rs2 = Rs1#role{luck = Luck1},
%%                             lib_role:notice(gold, Rs2),
%%                             lib_role:notice(luck, Rs2),
%%                             {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
%%                             gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, 1, Num, Quality}),
%%                             Rs3 = mod_attain:attain_state(46, 1, Rs2),
%%                             Rs0 = lib_role:add_attr_ok(gold, 9, Rs, Rs3),
%%                             {ok, [0, LuckDia1, Pos], Rs0};
%%                         {2, Num, Quality, Pos, Val} ->
%%                             Rs1 = lib_role:add_attr(diamond, Num, Rs),
%%                             Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                             Rs2 = Rs1#role{luck = Luck1},
%%                             lib_role:notice(luck, Rs2),
%%                             lib_role:notice(diamond, Rs2),
%%                             {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
%%                             gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, 2, Num, Quality}),
%%                             Rs3 = mod_attain:attain_state(46, 1, Rs2),
%%                             Rs0 = lib_role:add_attr_ok(diamond, 9, Rs, Rs3),
%%                             {ok, [0, LuckDia1, Pos], Rs0};
%%                         {3, Num, Quality, Pos, Val} ->
%%                             Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                             Rs1 = Rs#role{luck = Luck1},
%%                             Rs2 = luck_rebate(LuckDia + Cumulative, Rs1),
%%                             lib_role:notice(luck, Rs2),
%%                             {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
%%                             gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, 3, Num, Quality}),
%%                             Rs0 = mod_attain:attain_state(46, 1, Rs2),
%%                             {ok, [0, LuckDia1, Pos], Rs0};
%%                         {5, Num, Quality, Pos, Val} ->
%%                             {HeroTid, HeroQ} = Num,
%%                             {ok, Rs1, NewHero} = mod_hero:add_hero(Rs, HeroTid, HeroQ),
%%                             Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                             Rs2 = Rs1#role{luck = Luck1},
%%                             lib_role:notice(luck, Rs2),
%%                             {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
%%                             gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, 5, 1, Quality}),
%%                             mod_hero:hero_notice(Rs2#role.pid_sender, NewHero),
%%                             Rs0 = mod_attain:attain_state(46, 1, Rs2),
%%                             {ok, [0, LuckDia1, Pos], Rs0#role{save = [heroes]}};
%%                         {RewardTid, Num, Quality, Pos, Val} ->
%%                             case mod_item:add_item(Rs, RewardTid, Num) of
%%                                 {ok, Rs1, PA, EA} ->
%%                                     mod_item:send_notice(Rs#role.pid_sender, PA, EA),
%%                                     Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                                     Rs2 = Rs1#role{luck = Luck1},
%%                                     lib_role:notice(luck, Rs2),
%%                                     {_, LuckDia1, LuckUsed1, ValSum1} = Rs2#role.luck,
%%                                     gen_server:cast(luck, {set_myrank, Rid, Name, LuckUsed1, ValSum1, RewardTid, Num, Quality}),
%%                                     Rs0 = mod_attain:attain_state(46, 1, Rs2),
%%                                     case Quality =:= 2 of
%%                                         true ->
%%                                             Vip = lib_admin:get_vip(Rs),
%%                                             Msg = "恭喜“~s”玩家人品大爆发抽中了[{luck, ~w}],高大上有木有",
%%                                             Msg1 = io_lib:format(Msg, [Rs#role.name, RewardTid]),
%%                                             lib_system:cast_sys_msg(Rs#role.id, Rs#role.name, Msg1, Vip);
%%                                         false -> ok
%%                                     end,
%%                                     {ok, [0, LuckDia1, Pos], Rs0#role{save = [items]}};
%%                                 %% TODO:邮件系统
%%                                 {error, full} ->
%%                                     Title = data_text:get(2),
%%                                     Body = data_text:get(4),
%%                                     mod_mail:new_mail(Rs#role.id, 0, 9, Title, Body, [{RewardTid, Num}]),
%%                                     Luck1 = {LuckStar - 1, LuckDia + Cumulative, LuckUsed + 1, ValSum + Val},
%%                                     Rs1 = Rs#role{luck = Luck1},
%%                                     lib_role:notice(luck, Rs1),
%%                                     {ok, [3, 0, 0], Rs1};
%%                                 {error, Reason} ->
%%                                     ?WARN("Error:~w, Id: ~w", [Reason, RewardTid]),
%%                                     {ok, [127, 0, 0]}
%%                             end
%%                     end
%%             end;
%%         false ->
%%             {ok, [1, 0, 0]}
%%     end;
%%.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
