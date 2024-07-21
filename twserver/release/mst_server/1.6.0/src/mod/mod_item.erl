%%----------------------------------------------------
%% $Id: mod_item.erl 13210 2014-06-05 08:41:45Z piaohua $
%%
%% @doc 物品模块
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(mod_item).
-export([
    %% get_equ_ids/0
    init_item/2
    ,init_item/3
    ,init_items/2
    ,get_less_prop/2
    ,get_item/2
    ,get_items/2
    ,set_item/2
    ,del_item/4
    ,del_items/3
    ,del_items_from_db/2
    ,add_item/3
    ,add_items/2
    ,db_init/1
    ,db_update/2
    ,db_insert/2
    ,db_delete/2
    %% ,check_sorts/3
    %% ,check_sorts/2
    %% ,check_sort/3
    %% ,check_sort/2
    ,get_strengthen_rest_time/1
    ,strengthen/5
    ,get_ids_by_sort/1
    ,embed/2
    ,send_notice/2
    ,send_notice/3
    ,pack_prop/1
    ,pack_equ/1
    ,count_unit/2
    ,merge_tid/1
    ,get_produce_ids/2
    ,drop_produce/2
    ,drop_produce_arena/2
    ,client_info_from_db/4
    ,log_item/4
    ,log_item/5
    ,init_fundata/1
    ,update_fundata/1
    ,init_herosoul/1
    ,update_herosoul/1
    ,herosoul_refresh/0
    ,herosoul_give_num/1
]).

-include("common.hrl").
-include("prop.hrl").
-include("equ.hrl").

-define(ITEM_ZIP_VERSION, 3).

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).

data_equ_test() ->
    ?assert(undefined == data_equ:get(0)),
    Ids = data_equ:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_equ:get(Id),
                Sell = util:get_val(sell, Data, 0),
                ?assert(Id > ?MIN_EQU_ID),
                ?assert(util:get_val(sort, Data, 0) >= 0),
                ?assert(util:get_val(pos, Data, 0) >= 0),
                ?assert(util:get_val(quality, Data, 0) >= 0),
                ?assert(util:get_val(enhance_gold_arg, Data, undefined) =/= undefined),
                ?assert(util:get_val(enhance_rate_arg, Data, undefined) =/= undefined),
                ?assert(util:get_val(lev, Data, 0) >= 0),
                ?assert(lists:member(Sell, [0, 1, 2])),
                ?assert(util:get_val(price, Data, 0) >= 0),
                ?assert(util:get_val(price, Data) /= undefined),
                ?assert(util:get_val(atk, Data, 0) >= 0),
                ?assert(util:get_val(hp, Data, 0) >= 0),
                ?assert(util:get_val(def, Data, 0) >= 0),
                ?assert(util:get_val(def, Data) /= undefined),
                ?assert(util:get_val(pun, Data, 0) >= 0),
                ?assert(util:get_val(hit, Data, 0) >= 0),
                ?assert(util:get_val(dod, Data, 0) >= 0),
                ?assert(util:get_val(dod, Data) /= undefined),
                ?assert(util:get_val(crit, Data, 0) >= 0),
                ?assert(util:get_val(crit, Data) /= undefined),
                ?assert(util:get_val(crit_num, Data, 0) >= 0),
                ?assert(util:get_val(crit_anti, Data, 0) >= 0),
                ?assert(util:get_val(tou, Data, undefined) =/= undefined),
                ?assert(util:get_val(sockets, Data, 0) >= 0),
                ?assert(util:get_val(sockets, Data, undefined) =/= undefined)
        end, Ids),
    ok.

data_prop_test() ->
    ?assert(undefined == data_prop:get(0)),
    Ids = data_prop:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_prop:get(Id),
                Tab = util:get_val(tab, Data, 0),
                Sell = util:get_val(sell, Data, 0),
                ?assert(Id > 0 andalso Id < ?MIN_EQU_ID),
                ?assert(lists:member(Tab, [1, 2])),
                ?assert(lists:member(Sell, [0, 1, 2])),
                ?assert(util:get_val(quality, Data, 0) > 0),
                ?assert(util:get_val(sort, Data, 0) > 0),
                ?assert(util:get_val(num_max, Data, 0) > 0),
                ?assert(util:get_val(price, Data, 0) >= 0),
                %% ?assert(util:get_val(price, Data) /= undefined),
                ?assert(case util:get_val(sort,Data) == 4 of
                        true ->
                            util:get_val(num_max,Data) == 1;
                        false ->
                            util:get_val(num_max,Data) > 0
                    end)
        end, Ids),
    ok.

-endif.

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

drop_produce(Rs, ProducePass) ->
    case data_tollgate:get(ProducePass) of
        undefined ->
            ?WARN("Error ProducePass: ~w", [ProducePass]),
            {Rs, [[], []]};
        Data ->
            %% 请求extra produce
            {T, _} = ProducePass,
            ExtraProduce = lib_system:extra_product(T),
            Produce = util:get_val(produce, Data) ++ ExtraProduce,
            Gold = util:get_val(gold, Data, 0),
            Ids = get_produce_ids(Produce, []),
            case mod_item:add_items(Rs, Ids) of
                {ok, Rs1, Prop, Equ} ->
                    Data1 = [mod_item:pack_equ(X) || X <- Equ],
                    Data2 = [mod_item:pack_prop(X) || X <- Prop],
                    Rs2 = lib_role:add_attr(gold, Gold, Rs1),
                    lib_role:notice(gold, Rs2),
                    %% Type = 11 + element(1, Rs#role.produce_pass),
                    Type = 11 + element(1, ProducePass),
                    Rs0 = lib_role:add_attr_ok(gold, Type, Rs, Rs2),
                    mod_item:log_item(add_item,Rs#role.id,1,Ids),
                    {Rs0, [Data1, Data2]};
                {error, full} ->
                    Title = data_text:get(2),
                    Body = data_text:get(4),
                    sender:send_error(Rs#role.pid_sender, 1008),
                    Type = 11 + element(1, ProducePass),
                    mod_mail:new_mail(Rs#role.id, 0,Type, Title, Body, Ids),
                    %% ?DEBUG("bag full", []),
                    F = fun(Tid, {Es, Ps}) ->
                            case Tid >= ?MIN_EQU_ID of
                                true ->
                                    I = init_equ(0,Tid,data_equ:get(Tid)),
                                    {[mod_item:pack_equ(I)|Es], Ps};
                                false ->
                                    I = init_prop(0,Tid,1,data_prop:get(Tid)),
                                    {Es, [mod_item:pack_prop(I)|Ps]}
                            end
                    end,
                    {Data1, Data2} = lists:foldl(F, {[],[]}, Ids),
                    {Rs, [Data1, Data2]};
                {error, Reason} ->
                    ?WARN("produce error: ~w", [Reason]),
                    {Rs, [[], []]}
            end
    end.

%% 掉落产出
get_produce_ids([H | T], Rt) ->
    Rt1 = Rt ++ get_produce_ids1(H),
    get_produce_ids(T, Rt1);
get_produce_ids([], Rt) ->
    Rt.

%% 角斗场掉落
drop_produce_arena(Rs, Lev) ->
    case data_coliseum:get(Lev) of
        undefined ->
            ?WARN("drop_produce_arena Id:~w Error Lev: ~w", [Rs#role.id, Lev]),
            {Rs, [[], []]};
        Data ->
            %% 请求extra produce
            %% ExtraProduce = lib_system:extra_product(T),
            %% Produce = util:get_val(produce, Data) ++ ExtraProduce,
            Produce = case util:get_val(produce,Data) of
                undefined -> [];
                ProducePass1 -> ProducePass1
            end,
            Gold = util:get_val(gold, Data, 0),
            Ids = get_produce_ids(Produce, []),
            case mod_item:add_items(Rs, Ids) of
                {ok, Rs1, Prop, Equ} ->
                    Data1 = [mod_item:pack_equ(X) || X <- Equ],
                    Data2 = [mod_item:pack_prop(X) || X <- Prop],
                    Rs2 = lib_role:add_attr(gold, Gold, Rs1),
                    lib_role:notice(gold, Rs2),
                    %% Type = 11 + element(1, Rs#role.produce_pass),
                    %% Type = 11 + element(1, ProducePass),
                    Rs0 = lib_role:add_attr_ok(gold, 14, Rs, Rs2),
                    mod_item:log_item(add_item,Rs#role.id,1,Ids),
                    {Rs0, [Data1, Data2]};
                {error, full} ->
                    Title = data_text:get(2),
                    Body = data_text:get(4),
                    sender:send_error(Rs#role.pid_sender, 1008),
                    %% Type = 11 + element(1, ProducePass),
                    mod_mail:new_mail(Rs#role.id, 0,14, Title, Body, Ids),
                    %% ?DEBUG("bag full", []),
                    F = fun(Tid, {Es, Ps}) ->
                            case Tid >= ?MIN_EQU_ID of
                                true ->
                                    I = init_equ(0,Tid,data_equ:get(Tid)),
                                    {[mod_item:pack_equ(I)|Es], Ps};
                                false ->
                                    I = init_prop(0,Tid,1,data_prop:get(Tid)),
                                    {Es, [mod_item:pack_prop(I)|Ps]}
                            end
                    end,
                    {Data1, Data2} = lists:foldl(F, {[],[]}, Ids),
                    {Rs, [Data1, Data2]};
                {error, Reason} ->
                    ?WARN("produce error: ~w", [Reason]),
                    {Rs, [[], []]}
            end
    end.

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

%% 计算物品单元格
-spec count_unit(Tab, Items) -> Count when
    Tab :: ?TAB_EQU | ?TAB_PROP | ?TAB_MAT,
    Items :: [#item{}],
    Count :: integer().

count_unit(Tab, Items) ->
    F = fun
        (#item{tab = T, attr = Attr}, Count) when Tab =:= T ->
            case Attr of
                #equ{hero_id = HeroId} ->
                    case HeroId > 0 of
                        true -> Count;
                        false -> Count + 1
                    end;
                _ ->
                    Count + 1
            end;
        (I, Count) ->
            case lists:member(I#item.tab, [?TAB_EQU, ?TAB_PROP, ?TAB_MAT]) of
                true -> ok;
                false -> ?WARN("Tab:~w, Item:~w", [I#item.tab, I])
            end,
            Count
    end,
    lists:foldl(F, 0, Items).

%% 物品删除通知
send_notice(Id, Dels) ->
    sender:pack_send(Id, 13030, [Dels]).

%% 物品更新通知
send_notice(Id, Prop, Equ) ->
    Data1 = [mod_item:pack_equ(X) || X <- Equ],
    Data2 = [mod_item:pack_prop(X) || X <- Prop],
    sender:pack_send(Id, 13001, [3, Data1, Data2]).

pack_prop(#item{id = Id, tid = Tid, attr = Attr}) ->
    #prop{
        num = Num
        ,level = Level
        ,exp = Exp
    } = Attr,
    [Id, Tid, Num, Level, Exp].

pack_equ(#item{id = Id, tid = Tid, attr = Attr}) ->
    #equ{
       hero_id    = HeroId
       ,lev       = Lev
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
       ,sockets   = Sockets
       ,embed     = Embed
      } = Attr,
    EmbedData = [[X1, X2] || {X1, _, X2, _, _} <- Embed],
    [Id, Tid
     ,HeroId
     ,Lev
     ,Sockets
     ,EmbedData
     ,Hp
     ,Atk
     ,Def
     ,Pun
     ,Hit
     ,Dod
     ,Crit
     ,CritNum
     ,CritAnit
     ,Tou
    ].

get_ids_by_sort(Sort) when is_integer(Sort) ->
    get_ids_by_sort([Sort]);

get_ids_by_sort(Sorts) ->
    Ids = data_prop:get(ids),
    get_ids_by_sort(Sorts, Ids, []).

get_ids_by_sort(Sorts, [Tid | Ids], Rt) ->
    Data = data_prop:get(Tid),
    case lists:member(util:get_val(sort, Data, 0), Sorts) of
        true -> get_ids_by_sort(Sorts, Ids, [Tid | Rt]);
        false -> get_ids_by_sort(Sorts, Ids, Rt)
    end;
get_ids_by_sort(_Sorts, [], Rt) ->
    Rt.

%% get_equ_ids() ->
%%     Ids = data_item:get(ids),
%%     get_equ_ids1(Ids, []).
%%
%% get_equ_ids1([Tid | Ids], Rt) ->
%%     Item = data_item:get(Tid),
%%     case lists:member(util:get_val(sort, Item, 0),
%%             [2, 3, 4, 5]) of
%%         true -> get_equ_ids1(Ids, [Tid | Rt]);
%%         false -> get_equ_ids1(Ids, Rt)
%%     end;
%% get_equ_ids1([], Rt) ->
%%     Rt.

%%' init_item
init_items(Rs, Ids) ->
    init_items(Rs, Ids, []).

init_items(Rs, [Tid | Ids], Rt) ->
    {ok, Id, Rs1} = lib_role:get_new_id(item, Rs),
    Item = init_item(Id, Tid, 1),
    Rt1 = [Item | Rt],
    init_items(Rs1, Ids, Rt1);
init_items(Rs, [], Rt) ->
    Rs#role{items = Rt ++ Rs#role.items}.

init_item(Id, Tid) ->
    init_item(Id, Tid, 1).

init_item(Id, Tid, Num) ->
    case Tid >= ?MIN_EQU_ID of
        true -> init_equ(Id, Tid, data_equ:get(Tid));
        false -> init_prop(Id, Tid, Num, data_prop:get(Tid))
    end.

equ_attr1(def      , V, Equ) -> Equ#equ{def       = V};
equ_attr1(pun      , V, Equ) -> Equ#equ{pun       = V};
equ_attr1(hit      , V, Equ) -> Equ#equ{hit       = V};
equ_attr1(dod      , V, Equ) -> Equ#equ{dod       = V};
equ_attr1(crit     , V, Equ) -> Equ#equ{crit      = V};
equ_attr1(crit_num , V, Equ) -> Equ#equ{crit_num  = V};
equ_attr1(crit_anti, V, Equ) -> Equ#equ{crit_anti = V};
equ_attr1(Else     , V, Equ) ->
    ?WARN("undefined equ_attr: ~w, value: ~w", [Else, V]),
    Equ.

equ_attr(Num, Attrs, Data, Equ) when Num > 0 ->
    Num1 = Num - 1,
    Attr = util:rand_element(Attrs),
    Attrs1 = lists:delete(Attr, Attrs),
    V = attr_val(Attr, Data),
    Equ1 = equ_attr1(Attr, V, Equ),
    equ_attr(Num1, Attrs1, Data, Equ1);
equ_attr(_, _, _, Equ) ->
    Equ.

equ_attr2([], _, Equ) -> Equ;
equ_attr2([Attr|Attrs], Data, Equ) ->
    V = util:get_val(Attr, Data, 0),
    Equ1 = equ_attr1(Attr, V, Equ),
    equ_attr2(Attrs, Data, Equ1).

%% 品质
%% 1=0个
%% 2=1个
%% 3=2个
%% 4=3个
%% 5=4个

get_attr_num(1) -> 0;
get_attr_num(2) -> 1;
get_attr_num(3) -> 2;
get_attr_num(4) -> 3;
get_attr_num(5) -> 4;
get_attr_num(_) -> 0.

attr_val(Attr, Data) ->
    V = util:get_val(Attr, Data, 0),
    %% Rand1 = util:rand(1, 100),
    %% Rand2 = util:rand(1, 100),
    %% util:ceil((Rand1*Rand2/10000*0.4*V+0.6*V)).
    util:ceil(V * data_fun:equ_offset()).

init_equ(Id, Tid, Data) ->
    Attrs = [def, pun, hit, dod, crit, crit_num, crit_anti],
    Tou = util:get_val(tou, Data, 0),
    AddTou = case Tou > 0 of
        true -> 1;
        false -> 0
    end,
    Sort     = util:get_val(sort   , Data),
    Hp       = attr_val(hp, Data),
    Atk      = attr_val(atk, Data),
    Sockets  = util:get_val(sockets, Data),
    Quality  = util:get_val(quality, Data),
    %% 如果有韧性(tou)，则一定加上，随机属性数量减1
    AttrNum  = get_attr_num(Quality) - AddTou,
    Equ = #equ{
        quality    = Quality
        ,hp        = Hp
        ,atk       = Atk
        ,sockets   = Sockets
    },
    Equ1 = case Sort == 21 of
        true ->
            equ_attr2(Attrs, Data, Equ);
        false ->
            equ_attr(AttrNum, Attrs, Data, Equ)
    end,
    Equ2 = case AddTou of
        1 -> Equ1#equ{tou = Tou};
        0 -> Equ1
    end,
    #item{
        id = Id
        ,tid = Tid
        ,sort = Sort
        ,tab = ?TAB_EQU
        ,changed = 1
        ,attr = Equ2
    }.

init_prop(Id, Tid, Num, Data) ->
    Sort= util:get_val(sort   , Data),
    Max = util:get_val(num_max, Data, 0),
    Q = util:get_val(quality, Data, 0),
    Tab  = util:get_val(tab    , Data),
    case Num > Max of
        true ->
            ?ERR("[INIT_PROP] Num(~w) > Max(~w), Data:~w", [Num, Max, Data]);
        false -> ok
    end,
    Prop = #prop{
        num = Num
        ,quality = Q
    },
    Item = #item{
        id = Id
        ,tid = Tid
        ,sort = Sort
        ,tab = Tab
        ,changed = 1
        ,attr = Prop
    },
    db_init2(Item).

%%.

%%' 添加物品

%% 合并相同的Tid
%% 5 = 英雄(Num = {Heroid, Quality})
%% TODO:邮件两个英雄不能合并id
merge_tid(Ids) ->
    merge_tid(Ids, []).

merge_tid([{Tid, Num} | Ids], Rt) ->
    Rt1 = case lists:keyfind(Tid, 1, Rt) of
        false -> [{Tid, Num} | Rt];
        {Tid, _} when Tid == 5 ->
            [{Tid, Num} | Rt];
        {_, Num2} ->
            lists:keyreplace(Tid, 1, Rt, {Tid, Num + Num2})
    end,
    merge_tid(Ids, Rt1);
merge_tid([[Tid, Num] | Ids], Rt) ->
    Rt1 = case lists:keyfind(Tid, 1, Rt) of
        false -> [{Tid, Num} | Rt];
        {Tid, _} when Tid == 5 ->
            [{Tid, Num} | Rt];
        {_, Num2} ->
            lists:keyreplace(Tid, 1, Rt, {Tid, Num + Num2})
    end,
    merge_tid(Ids, Rt1);
merge_tid([Tid | Ids], Rt) when is_integer(Tid) ->
    merge_tid([{Tid, 1} | Ids], Rt);
merge_tid([], Rt) ->
    Rt.

%% @doc 批量添加物品(gold/diamond/items/hero)
%% '''
%% Ids有两种可用格式：
%%     1、[Tid1, Tid2, ...] 这种格式等同于 [{Tid1, 1}, {Tid2, 2}, ...]
%%     2、[{Tid1, Num1}, {Tid2, Num2}, ...]
%% '''
-spec add_items(Rs, Ids) ->
    {ok, NewRs, PropAdds, EquAdds} | {error, Reason} when
    Rs :: #role{},
    NewRs :: #role{},
    Ids :: [integer()] | [{integer(), integer()}],
    PropAdds :: list(),
    EquAdds :: list(),
    Reason :: term().

add_items(Rs, Ids) ->
    Ids1 = merge_tid(Ids),
    add_items(Rs, Ids1, [], []).

add_items(Rs, [{Tid, Num} | T], PropAdds, EquAdds) ->
    case add_item(Rs, Tid, Num, PropAdds, EquAdds) of
        {ok, Rs1, PropAdds1, EquAdds1} ->
            add_items(Rs1, T, PropAdds1, EquAdds1);
        {error, Reason} -> {error, Reason}
    end;
add_items(Rs, [], PropAdds, EquAdds) ->
    {ok, Rs, PropAdds, EquAdds}.

-spec add_item(Rs, Tid, Num) ->
    {ok, NewRs, PropAdds, EquAdds} | {error, Error} when
    Rs :: NewRs,
    NewRs :: #role{},
    Tid :: integer(),
    Num :: integer() | list(),
    PropAdds :: EquAdds,
    EquAdds :: [#item{}],
    Error :: full | incorrect_num | undef.

add_item(Rs, Tid, Num) ->
    add_item(Rs, Tid, Num, [], []).
add_item(Rs, Tid, Num, PA, EA) ->
    Items = Rs#role.items,
    if
        Num =< 0 ->
            {error, incorrect_num};
        Tid == ?CUR_GOLD ->
            Rs1 = lib_role:add_attr(gold, Num, Rs),
            lib_role:notice(gold, Rs1),
            {ok, Rs1, PA, EA};
        Tid == ?CUR_DIAMOND ->
            Rs1 = lib_role:add_attr(diamond, Num, Rs),
            lib_role:notice(diamond, Rs1),
            {ok, Rs1, PA, EA};
        Tid == ?CUR_LUCK ->
            Rs1 = lib_role:add_attr(luck, Num, Rs),
            lib_role:notice(luck, Rs1),
            {ok, Rs1, PA, EA};
        Tid == ?CUR_HERO ->
            case length(Rs#role.heroes) < Rs#role.herotab of
                true ->
                    {HeroTid, Quality} = Num,
                    {ok, Rs1, Hero} = mod_hero:add_hero(Rs, HeroTid, Quality),
                    mod_hero:hero_notice(Rs1#role.pid_sender, Hero),
                    {ok, Rs1#role{save = [heroes]}, PA, EA};
                false ->
                    {error, full}
            end;
        Tid == ?CUR_TIRED ->
            #role{power = Power, buy_power = Buys, power_time = Time} = Rs,
            TiredPower = data_config:get(tired_power),
            Rest = case Time == 0 of
                true -> TiredPower;
                false -> util:floor(TiredPower - (util:unixtime() - Time))
            end,
            Rs1 = Rs#role{power = Power + Num},
            sender:pack_send(Rs1#role.pid_sender, 11007, [Power + Num, Buys, Rest]),
            {ok, Rs1, PA, EA};
        Tid == ?CUR_HORN ->
            Rs1 = lib_role:add_attr(horn, Num, Rs),
            lib_role:notice(horn, Rs1),
            {ok, Rs1, PA, EA};
        Tid >= ?MIN_EQU_ID ->
            case count_unit(?TAB_EQU, Items) < Rs#role.bag_equ_max of
                true ->
                    {ok, Id, Rs1} = lib_role:get_new_id(item, Rs),
                    Data = data_equ:get(Tid),
                    Item = init_equ(Id, Tid, Data),
                    EA1 = [Item | EA],
                    RestNum = Num - 1,
                    Rs2 = Rs1#role{items = [Item | Items]},
                    case RestNum > 0 of
                        true ->
                            %% 还有剩余数量，继续添加...
                            add_item(Rs2, Tid, RestNum, PA, EA1);
                        false -> {ok, Rs2, PA, EA1}
                    end;
                false ->
                    ?DEBUG("BAG_EQU:~w", [count_unit(?TAB_EQU, Items)]),
                    {error, full}
            end;
        true ->
            Data = data_prop:get(Tid),
            Max = util:get_val(num_max, Data, 0),
            case is_integer(Max) andalso Max > 0 of
                true ->
                    %% 查找是否有叠堆数未满的道具
                    case find_no_max_prop(Items, Tid, Max, []) of
                        [] ->
                            {ok, Id, Rs1} = lib_role:get_new_id(item, Rs),
                            case Num =< Max of
                                true ->
                                    Item = init_prop(Id, Tid, Num, Data),
                                    PA1 = [Item | PA],
                                    Items1 = [Item | Items],
                                    case count_unit(?TAB_PROP, Items1) > Rs#role.bag_prop_max
                                        orelse count_unit(?TAB_MAT, Items1) > Rs#role.bag_mat_max of
                                        true -> {error, full};
                                        false -> {ok, Rs1#role{items = Items1}, PA1, EA}
                                    end;
                                false ->
                                    Num1 = Num - Max,
                                    Item = init_prop(Id, Tid, Max, Data),
                                    Rs2 = Rs1#role{items = [Item | Items]},
                                    PA1 = [Item | PA],
                                    add_item(Rs2, Tid, Num1, PA1, EA)
                            end;
                        [Item | Os] ->
                            case Os of
                                [] -> ok;
                                _ -> ?WARN("add prop aid:~s~n~p", [Rs#role.account_id, [Item | Os]])
                            end,
                            #item{attr = Prop} = Item,
                            #prop{num = PreNum} = Prop,
                            AcceptNum = Max - PreNum,
                            case Num =< AcceptNum of
                                true ->
                                    Prop1 = Prop#prop{num = PreNum + Num},
                                    Item1 = Item#item{attr = Prop1, changed = 1},
                                    Items2 = set_item(Item1, Items),
                                    PA1 = [Item1 | PA],
                                    case count_unit(?TAB_PROP, Items2) > Rs#role.bag_prop_max
                                        orelse count_unit(?TAB_MAT, Items2) > Rs#role.bag_mat_max of
                                        true ->
                                            ?DEBUG("BAG_PROP:~w, BAG_Mat:~w", [count_unit(?TAB_PROP, Items2), count_unit(?TAB_MAT, Items2)]),
                                            {error, full};
                                        false -> {ok, Rs#role{items = Items2}, PA1, EA}
                                    end;
                                false ->
                                    Prop1 = Prop#prop{num = Max},
                                    Item1 = Item#item{attr = Prop1, changed = 1},
                                    Items2 = set_item(Item1, Items),
                                    Rs1 = Rs#role{items = Items2},
                                    PA1 = [Item1 | PA],
                                    add_item(Rs1, Tid, Num - AcceptNum, PA1, EA)
                            end;
                        _Undef ->
                            ?ERR("Error when add_item: ~w", [_Undef]),
                            {error, undef}
                    end;
                false ->
                    ?ERR("Error Prop Data: ~p", [Data]),
                    {error, undef}
            end
    end.
%%.

find_no_max_prop([Item | Items], Tid, Max, Rt) ->
    #item{tid = Tid1, attr = Attr} = Item,
    case Tid1 =:= Tid andalso Attr#prop.num < Max of
        true ->
            Rt1 = [Item | Rt],
            find_no_max_prop(Items, Tid, Max, Rt1);
        false ->
            find_no_max_prop(Items, Tid, Max, Rt)
    end;
find_no_max_prop([], _Tid, _Max, Rt) ->
    Rt.

%% 用Tid来查找叠堆数最小的一堆道具
-spec get_less_prop(Items, Tid) -> false | #item{} when
    Items :: [#item{}],
    Tid :: integer().

get_less_prop(Items, Tid) ->
    get_min_item(Items, Tid, 0, false).

get_item(Id, MyItems) ->
    lists:keyfind(Id, #item.id, MyItems).

get_items(Tid, MyItems) ->
    get_items(Tid, MyItems, []).
get_items(Tid, MyItems, Rt) ->
    case lists:keyfind(Tid, #item.tid, MyItems) of
        false ->
            case Rt of
                [] -> false;
                _ -> Rt
            end;
        Item ->
            Items1 = lists:keydelete(Item#item.id, #item.id, MyItems),
            get_items(Tid, Items1, [Item|Rt])
    end.

set_item(MyItem, MyItems) ->
    lists:keystore(MyItem#item.id, #item.id, MyItems, MyItem).

%% get_gem_attr([]) -> {0, 0};
%% get_gem_attr([Tid]) -> get_gem_attr(Tid);
%% get_gem_attr(Tid) ->
%%     case data_item:get(Tid) of
%%         undefined ->
%%             {0, 0};
%%         GemData ->
%%             Atk = util:get_val(atk, GemData, 0),
%%             Hp = util:get_val(hp, GemData, 0),
%%             {Atk, Hp}
%%     end.

%% 镶嵌
%% 当SORT为4时
%% 1,攻击
%% 2,血量
%% 3,防御
%% 4,穿刺
%% 5,命中
%% 6,闪避
%% 7,暴击
%% 8,暴强
embed(EquItem, GemItem) ->
    #item{tid = _EquTid, attr = Equ} = EquItem,
    #item{tid = GemTid, attr = Prop} = GemItem,
    %% _EquData = data_prop:get(EquTid),
    GemData = data_prop:get(GemTid),
    AttrId = util:get_val(control1, GemData, 0),
    Control2 = util:get_val(control2, GemData, 0),
    #equ{embed = Embed, sockets = Sockets} = Equ,
    #prop{
        quality = GemQ
        ,level = Level
        ,exp = Exp
    } = Prop,
    %% AttrVal = util:ceil(Control2 * data_fun:jewel_offset()),
    AttrVal = util:ceil(data_fun:jewelry_upgrade(Control2,Level)),
    RestSocket = Sockets - length(Embed),
    Member = lists:keyfind(AttrId, 2, Embed),
    New = {GemTid, AttrId, AttrVal, Level, Exp},
    if
        AttrId == 0; AttrVal == 0 ->
            ?ERR("AttrId:~w, AttrVal:~w", [AttrId, AttrVal]),
            {error, error};
        Sockets == 0 ->
            {error, no_sock};
        Member =/= false ->
            {OldGemTid, _, _, _, _} = Member,
            OldGemData = data_prop:get(OldGemTid),
            OldQ = util:get_val(quality, OldGemData),
            case GemQ >= OldQ of
                true ->
                    Embed1 = lists:delete(Member, Embed),
                    Embed2 = [New | Embed1],
                    Equ1 = Equ#equ{embed = Embed2},
                    EquItem1 = EquItem#item{attr = Equ1, changed = 1},
                    {ok, EquItem1};
                false ->
                    ?WARN("error quality", []),
                    {error, quality}
            end;
        RestSocket =< 0 ->
            XX1 = util:rand_element(Embed),
            Embed1 = lists:delete(XX1, Embed),
            Embed2 = [New | Embed1],
            Equ1 = Equ#equ{embed = Embed2},
            EquItem1 = EquItem#item{attr = Equ1, changed = 1},
            {ok, EquItem1};
        true ->
            Embed1 = [New | Embed],
            Equ1 = Equ#equ{embed = Embed1},
            EquItem1 = EquItem#item{attr = Equ1, changed = 1},
            {ok, EquItem1}
    end.

%% 强化
strengthen(Item, Rate, RateF, Rise, AddTime) ->
    #equ{lev = Lev, atk = Atk, hp = Hp} = Item#item.attr,
    ATime = util:unixtime() + AddTime,
    case util:rate1000(Rate) of
        true ->
            Atk1 = util:ceil(Atk * Rise),
            Hp1 = util:ceil(Hp * Rise),
            Equ = Item#item.attr#equ{lev = Lev + 1, atime = ATime, atk = Atk1, hp = Hp1},
            Item1 = Item#item{attr = Equ, changed = 1},
            {ok, 0, Item1};
        false ->
            case util:rate(RateF) of
                true ->
                    %% 掉级
                    Lev1 = Lev - 1,
                    case data_strengthen:get({Item#item.sort, Lev1}) of
                        [{_, _, _, Rise1}] ->
                            Atk1 = util:ceil(Atk / Rise1),
                            Hp1 = util:ceil(Hp / Rise1),
                            Equ = Item#item.attr#equ{lev = Lev1, atime = ATime, atk = Atk1, hp = Hp1},
                            Item1 = Item#item{attr = Equ, changed = 1},
                            {ok, 1, Item1};
                        Else ->
                            ?WARN("error data_strengthen: ~w", [Else]),
                            {ok, 1, Item}
                    end;
                false ->
                    {ok, 1, Item}
            end
    end.

%% 检查类型(强化幸运石类型检查)
%% check_sorts(Sorts, Id, Items) when is_list(Sorts) ->
%%     case get_item(Id, Items) of
%%         false -> false;
%%         Item -> lists:member(Item#item.sort, Sorts)
%%     end;
%%
%% check_sorts(_Sort, [], _Items) -> true;
%% check_sorts(Sort, [Id | Ids], Items) ->
%%     case check_sort(Sort, Id, Items) of
%%         true -> check_sorts(Sort, Ids, Items);
%%         false -> false
%%     end.
%%
%% check_sorts(Sorts, Item) when is_list(Sorts) ->
%%     lists:member(Item#item.sort, Sorts).
%%
%% check_sort(Sort, Id, Items) ->
%%     case get_item(Id, Items) of
%%         false -> false;
%%         Item -> check_sort(Sort, Item)
%%     end.
%%
%% check_sort(Sort, #item{sort = Sort}) -> true;
%% check_sort(_, _) -> false.

get_strengthen_rest_time(Item) when is_record(Item, item) ->
    get_strengthen_rest_time(Item#item.attr#equ.atime);
get_strengthen_rest_time(0) -> 0;
get_strengthen_rest_time(ATime) ->
    ATime - util:unixtime().

%%' goods log
log_item(TypeL,Rid,Type,Ids,Items) when is_integer(Ids) ->
    log_item(TypeL,Rid,Type,[Ids],Items);
log_item(TypeL,Rid,Type,Ids,Items) when is_list(Ids) ->
    Idss = util:merge_list(Ids),
    Tidss = log_item2(Idss,Items),
    %% ?DEBUG("Tidss:~w", [Tidss]),
    %% log_item1(TypeL,Rid,Type,Tidss);
    log_item(TypeL,Rid,Type,Tidss);
log_item(_,_,_,_,_) -> ok.

log_item(TypeL,Rid,Type,Tids) when is_integer(Tids) ->
    log_item(TypeL,Rid,Type,[Tids]);
log_item(TypeL,Rid,Type,Tids) when is_list(Tids) ->
    Tidss = util:merge_list(Tids),
    log_item1(TypeL,Rid,Type,Tidss);
log_item(_,_,_,_) -> ok.

log_item1(_,_,_,[]) -> ok;
log_item1(TypeL,Rid,Type,[{Tid,Num}|T]) ->
    case lists:member(Tid,[?CUR_GOLD,?CUR_DIAMOND,?CUR_LUCK,?CUR_HERO,?CUR_TIRED,?CUR_HORN]) of
        true -> ok;
        false ->
            ?LOG({TypeL,Rid,Type,Tid,Num})
    end,
    log_item1(TypeL,Rid,Type,T);
log_item1(_,_,_,_) -> ok.

log_item2(Idss,Items) ->
    log_item2(Idss,Items,[]).
log_item2([],_,Rt) -> Rt;
log_item2([{Id,Num}|T],Items,Rt) ->
    case lists:keyfind(Id,#item.id,Items) of
        false ->
            log_item2(T,Items,Rt);
        Item ->
            log_item2(T,Items,[{Item#item.tid,Num}|Rt])
    end.
%%.

%%' 客户端数据存储
%% type=1(存储),=2(获取),=3(删除)
client_info_from_db(1, Key, Value, Rs) ->
    Sql1 = list_to_binary([<<"UPDATE `client_info` SET `key` = ">>
            ,integer_to_list(Key), <<" , `value` = '">>
            ,Value, <<"' WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id)]),
    case db:execute(Sql1) of
        {ok, 0} ->
            client_info_from_db1(Key, Value, Rs);
        {ok, Num} -> {ok, Num};
        {error, Reason} ->
            ?WARN("client_info_from_db 1:~w", [Reason]),
            {error, Reason}
    end;
client_info_from_db(2, Key, _Value, Rs) ->
    Sql1 = list_to_binary([<<"SELECT `value` FROM `client_info` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id), <<" AND `key` = ">>
            ,integer_to_list(Key)]),
    case db:get_row(Sql1) of
        {ok, [V]} -> {ok, V};
        {error, null} -> {ok, <<>>};
        {error, Reason} ->
            ?WARN("client_info_from_db 2:~w", [Reason]),
            {error, Reason}
    end;
client_info_from_db(3, Key, _Value, Rs) ->
    Sql1 = list_to_binary([<<"DELETE FROM `client_info` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id), <<" AND `key` = ">>
            ,integer_to_list(Key)]),
    case db:execute(Sql1) of
        {ok, Num} -> {ok, Num};
        {error, Reason} ->
            ?WARN("client_info_from_db 3:~w", [Reason]),
            {error, Reason}
    end.
client_info_from_db1(Key, Value, Rs) ->
    Sql1 = list_to_binary([<<"SELECT count(*) FROM `client_info` WHERE `role_id` = ">>
            ,integer_to_list(Rs#role.id), <<" AND `key` = ">>
            ,integer_to_list(Key)]),
    Sql2 = list_to_binary([<<"INSERT `client_info` (`role_id`, `key`, `value`) VALUES (">>
            ,integer_to_list(Rs#role.id), <<", ">>
            ,integer_to_list(Key), <<", '">>, Value, <<"')">>]),
    case db:get_one(Sql1) of
        {ok, 0} ->
            case db:execute(Sql2) of
                {ok, Num1} -> {ok, Num1};
                {error, Reason} ->
                    ?WARN("client_info_from_db error:~w", [Reason]),
                    {error, Reason}
            end;
        {ok, Num2} -> {ok, Num2};
        {error, Reason} ->
            ?WARN("client_info_from_db 1:~w", [Reason]),
            {error, Reason}
    end.
%%.

%%' 删除物品

%% @doc 批量删除物品
%% ```
%% Ids有两种可用格式：
%%     1、[Tid1, Tid2, ...] 这种格式等同于 [{Tid1, 1}, {Tid2, 2}, ...]
%%     2、[{Tid1, Num1}, {Tid2, Num2}, ...]
%% Dels为删除结果，格式如下：
%%     Dels   : [{ItemId, NewNum}]
%%     ItemId : 被删除的物品唯一ID
%%     NewNum : 被删除后的物品的新的堆叠数，为0时则完全删除
%% '''
-spec del_items(Type, Ids, Items) ->
    {ok, NewItems, Dels} | {error, Reason} when
    Type :: by_id | by_tid,
    Ids :: [integer()] | [{integer(), integer()}],
    Items :: NewItems,
    Items :: [#item{}],
    Dels :: [{ItemId, NewNum}],
    ItemId :: integer(),
    NewNum :: integer(),
    Reason :: term().

%% Return: {ok, MyItems1} | {error, Reason}
del_items(by_id, Dels, MyItems) ->
    del_items(by_id, Dels, MyItems, []);

del_items(by_tid, Dels, MyItems) ->
    Dels1 = merge_tid(Dels),
    del_items(by_tid, Dels1, MyItems, []).

del_items(by_id, [{Id, Num} | T], MyItems, AccDels) ->
    case del_item(by_id, Id, Num, MyItems) of
        {ok, MyItems1, Dels} ->
            del_items(by_id, T, MyItems1, Dels ++ AccDels);
        {error, Reason} ->
            {error, Reason}
    end;
del_items(by_id, [], MyItems, AccDels) ->
    {ok, MyItems, AccDels};

del_items(by_tid, [{Id, Num} | T], MyItems, AccDels) ->
    case del_item(by_tid, Id, Num, MyItems) of
        {ok, MyItems1, Dels} ->
            del_items(by_tid, T, MyItems1, Dels ++ AccDels);
        {error, Reason} ->
            {error, Reason}
    end;
del_items(by_tid, [], MyItems, AccDels) ->
    {ok, MyItems, AccDels}.

del_item(by_id, Id, Num, MyItems) when Num > 0 ->
    case lists:keyfind(Id, 2, MyItems) of
        false -> {error, no_item};
        MyItem ->
            #item{tid = Tid, attr = Attr} = MyItem,
            case Tid >= ?MIN_EQU_ID of
                true ->
                    %% 删除装备
                    MyItems1 = lists:keydelete(Id, 2, MyItems),
                    {ok, MyItems1, [[Id, 0]]};
                false ->
                    %% 删除道具
                    Num1 = Attr#prop.num,
                    if
                        Num == Num1 ->
                            MyItems1 = lists:keydelete(Id, 2, MyItems),
                            {ok, MyItems1, [[Id, 0]]};
                        Num < Num1 ->
                            NewNum = Num1 - Num,
                            Prop1 = Attr#prop{num = NewNum},
                            MyItem1 = MyItem#item{attr = Prop1, changed = 1},
                            MyItems1 = lists:keyreplace(Id, 2, MyItems, MyItem1),
                            {ok, MyItems1, [[Id, NewNum]]};
                        Num > Num1 ->
                            %% ?INFO("删除数量不正确：~w ! ~w", [Num, MyItem#item.num]),
                            {error, no_item}
                    end
            end
    end;

%% Return: {ok, MyItems1, Dels} | {error, Reason}
%% 只有道具才能用tid删除
del_item(by_tid, Tid, Num, MyItems) when Num > 0 ->
    del_item(by_tid, Tid, Num, MyItems, []).
del_item(by_tid, Tid, Num, MyItems, Dels) ->
    %% case lists:keyfind(Tid, #item.tid, MyItems) of
    case get_min_item(MyItems, Tid, 0, false) of
        false -> {error, no_item};
        MyItem ->
            #item{id = Id, attr = Prop} = MyItem,
            #prop{num = Num1} = Prop,
            ?DEBUG("Id:~w, Tid:~w, Num1:~w", [Id, Tid, Num1]),
            if
                Num == Num1 ->
                    MyItems1 = lists:keydelete(Id, 2, MyItems),
                    Dels1 = [[Id, 0] | Dels],
                    {ok, MyItems1, Dels1};
                Num < Num1 ->
                    NewNum = Num1 - Num,
                    Prop1 = Prop#prop{num = NewNum},
                    MyItem1 = MyItem#item{attr = Prop1, changed = 1},
                    MyItems1 = lists:keyreplace(Id, 2, MyItems, MyItem1),
                    Dels1 = [[Id, NewNum] | Dels],
                    ?DEBUG("Id:~w, NewNum:~w", [Id, NewNum]),
                    {ok, MyItems1, Dels1};
                Num > Num1 ->
                    Num2 = Num - Num1,
                    MyItems1 = lists:keydelete(Id, 2, MyItems),
                    Dels1 = [[Id, 0] | Dels],
                    del_item(by_tid, Tid, Num2, MyItems1, Dels1)
            end
    end.

del_items_from_db(Rid, [[Id, 0] | T]) ->
    db_delete(Rid, Id),
    del_items_from_db(Rid, T);
del_items_from_db(Rid, [_ | T]) ->
    del_items_from_db(Rid, T);
del_items_from_db(_Rid, []) ->
    ok.

get_min_item([Item | Items], Tid, Num, Rt) ->
    if
        Tid > ?MIN_EQU_ID ->
            ?ERR("Can not get_min_item by_tid: ~w", [Tid]),
            false;
        Item#item.tid =/= Tid ->
            get_min_item(Items, Tid, Num, Rt);
        Num =< 0 ->
            get_min_item(Items, Tid, Item#item.attr#prop.num, Item);
        Item#item.attr#prop.num < Num ->
            get_min_item(Items, Tid, Item#item.attr#prop.num, Item);
        true ->
            get_min_item(Items, Tid, Num, Rt)
    end;
get_min_item([], _Tid, _Num, Rt) -> Rt.
%%.

%%' 数据库相关操作

-spec db_init(Rs) -> {ok, NewRs} | {error, Reason} when
    Rs :: #role{},
    NewRs :: #role{},
    Reason :: term().

db_init(Rs) ->
    Rid = Rs#role.id,
    Sql = "select item_id, val from item where role_id = ~s",
    case db:get_all(Sql, [Rid]) of
        {ok, Rows} ->
            {MaxId, Items} = db_init1(Rows, []),
            Rs1 = Rs#role{items = Items, max_item_id = MaxId},
            case jewelry_broken(Rs1) of
                {ok, Rs2} ->
                    {ok, Rs2};
                {error, Reason} -> {error, Reason}
            end;
            %% {ok, Rs#role{items = Items, max_item_id = MaxId}};
        {error, null} ->
            {ok, Rs#role{items = []}};
        {error, Reason} ->
            {error, Reason}
    end.

%% jewelry broken
jewelry_broken(Rs) ->
    #role{items = Items} = Rs,
    {Rt1,_Rt2} = jewelry_broken(Items, [], []),
    case Rt1 == [] of
        true -> {ok, Rs};
        false ->
            Tids = jewelry_add(Rt1, []),
            DelIds  = jewelry_del(Rt1, []),
            case mod_item:del_items(by_id, DelIds, Items) of
                {ok, Items1, Notice} ->
                    Rs1 = Rs#role{items=Items1},
                    %% 物品删除通知
                    mod_item:send_notice(Rs1#role.pid_sender, Notice),
                    case mod_item:add_items(Rs1, Tids) of
                        {ok, Rs2, PA, EA} ->
                            %% 一切都OK后，从数据库中删除物品
                            mod_item:del_items_from_db(Rs#role.id, Notice),
                            mod_item:send_notice(Rs#role.pid_sender,PA,EA),
                            {ok, Rs2};
                        {error, full} ->
                            %% 一切都OK后，从数据库中删除物品
                            mod_item:del_items_from_db(Rs#role.id, Notice),
                            Title = data_text:get(2),
                            Body  = data_text:get(4),
                            mod_mail:new_mail(Rs#role.id,0,62,Title,Body,Tids),
                            {ok, Rs1};
                        {error, Reason} ->
                            ?WARN("jewelry_broken (~w) error:~w", [Rs#role.id, Reason]),
                            {error,Reason}
                    end;
                {error,Reason} ->
                    ?WARN("jewelry_broken (~w) DelIds:~w, error:~w", [Rs#role.id, DelIds, Reason]),
                    {error,Reason}
            end
    end.

jewelry_add([], Rt) -> Rt;
jewelry_add([Item|Rest], Rt) ->
    #item{
        tid = Tid
        ,attr = Attr
    } = Item,
    #prop{num = Num} = Attr,
    jewelry_add(Rest, [{Tid,Num}|Rt]).

jewelry_del([], Rt) -> Rt;
jewelry_del([Item|Rest], Rt) ->
    #item{
        id = Id
        ,attr = Attr
    } = Item,
    #prop{num = Num} = Attr,
    jewelry_del(Rest, [{Id,Num}|Rt]).

jewelry_broken([], Rt1, Rt2) -> {Rt1,Rt2};
jewelry_broken([H|T], Rt1, Rt2) ->
    #item{
        sort = Sort
        ,attr = Attr
    } = H,
    if
        is_record(Attr, prop) andalso Sort == 4 ->
            #prop{
                num = Num
            } = Attr,
            case Num > 1 of
                true ->
                    jewelry_broken(T,[H|Rt1],Rt2);
                false ->
                    jewelry_broken(T,Rt1,[H|Rt2])
            end;
        true ->
            jewelry_broken(T,Rt1,[H|Rt2])
    end.

db_init1([H | T], Result) ->
    Result1 = db_init2(unzip(H)),
    %% db_init1(T, [unzip(H) | Result]);
    db_init1(T, [Result1 | Result]);
db_init1([], Result) ->
    MaxId = lists:max([H#item.id || H <- Result]),
    {MaxId, Result}.

db_init2(Item) when is_record(Item,item) ->
    #item{
        id       = Id
        ,tid     = Tid
        ,sort    = Sort
        ,attr    = Attr
    } = Item,
    if
        is_record(Attr,equ) andalso Sort == 21 ->
            #equ{
                hero_id    = HeroId
                ,etime     = Etime
                ,atime     = Atime
                ,embed     = Embed
            } = Attr,
            Item1 = init_item(Id,Tid),
            Embed1 = init_embed(Embed),
            Attr1 = Item1#item.attr#equ{
                hero_id    = HeroId
                ,etime     = Etime
                ,atime     = Atime
                ,embed     = Embed1
            },
            Item1#item{
                changed = 1
                ,attr = Attr1
            };
        %% is_record(Attr,prop) andalso Sort == 4 ->
        %%     #prop{
        %%         quality   = Quality
        %%         ,level     = Level
        %%         ,exp       = Exp
        %%     } = Attr,
        %%     case Level == 1 andalso Exp == 0 of
        %%         true ->
        %%             case data_jewel_lev:get({Level,Quality}) of
        %%                 undefined -> Item;
        %%                 Data ->
        %%                     Exp1 = util:get_val(exp,Data,0),
        %%                     Attr2 = Item#item.attr#prop{exp = Exp1},
        %%                     Item#item{
        %%                         attr = Attr2
        %%                         ,changed = 1
        %%                     }
        %%             end;
        %%         false -> Item
        %%     end;
        is_record(Attr,equ) ->
            #equ{
                hero_id    = HeroId
                ,etime     = Etime
                ,atime     = Atime
                ,embed     = Embed
            } = Attr,
            Embed1 = init_embed(Embed),
            Attr1 = Item#item.attr#equ{
                hero_id    = HeroId
                ,etime     = Etime
                ,atime     = Atime
                ,embed     = Embed1
            },
            Item#item{
                changed = 1
                ,attr = Attr1
            };
        true -> Item
    end;
db_init2(Item) -> Item.

init_embed([{X1,X2,X3}|T]) ->
    init_embed([{X1,X2,X3}|T],[]);
init_embed(Embed) -> Embed.
init_embed([], Rt) -> Rt;
init_embed([{X1,X2,X3}|T],Rt) ->
    Q = case data_prop:get(X1) of
        undefined -> 1;
        Data ->
            util:get_val(quality,Data,1)
    end,
    {Lev,Exp} = case data_jewel_lev:get({1,Q}) of
        undefined -> {1, 0};
        Data1 ->
            Exp1 = util:get_val(exp,Data1,0),
            {1,Exp1}
    end,
    init_embed(T,[{X1,X2,X3,Lev,Exp}|Rt]).

db_delete(Rid, Tid) when is_integer(Tid) ->
    Sql = list_to_binary([
            <<"delete from item where role_id = ">>
            ,integer_to_list(Rid),<<" and item_id = ">>
            ,integer_to_list(Tid)
        ]),
    db:execute(Sql);
db_delete(Rid, H) ->
    db_delete(Rid, H#item.id).

-spec db_insert(Rid, Item) -> {ok, Num} | {error, Reason} when
    Rid :: integer(),
    Item :: #item{},
    Num :: integer(), %% 影响行数
    Reason :: term().

db_insert(Rid, H) ->
    Val = ?ESC_SINGLE_QUOTES(zip(H)),
    RidL = integer_to_list(Rid),
    HidL = integer_to_list(H#item.id),
    Sql = list_to_binary([
            <<"SELECT count(*) FROM `item` WHERE role_id = ">>
            ,RidL,<<" and item_id = ">>,HidL
        ]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([
                    <<"insert item (role_id, item_id, val) value (">>
                    ,RidL,<<",">>,HidL,<<",'">>,Val,<<"')">>
                ]),
            %% ?INFO("insert item(~w) to db!", [H#item.id]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            %% 记录已存在
            {ok, Num}
    end.

-spec db_update(Rid, Items) -> {true, NewItems} | {false, NewItems} when
    Rid :: integer(),
    Items :: NewItems,
    NewItems :: [#item{}].

db_update(Rid, HL) ->
    db_update(Rid, HL, []).

db_update(Rid, [H | T], Result) ->
    Result1 = [H#item{changed = 0} | Result],
    case H#item.changed of
        1 ->
            Val = ?ESC_SINGLE_QUOTES(zip(H)),
            Sql = list_to_binary([
                    <<"update item set val = '">>,Val,<<"' where ">>
                    ,<<"role_id = ">>,integer_to_list(Rid)
                    ,<<" and item_id = ">>,integer_to_list(H#item.id)
            ]),
            case db:execute(Sql) of
                {ok, 0} ->
                    %% 影响行数为0，可能是记录不存在，进行插入操作
                    case db_insert(Rid, H) of
                        {ok, _} ->
                            db_update(Rid, T, Result1);
                        {error, _} ->
                            {false, Result ++ [H | T]}
                    end;
                {ok, 1} ->
                    db_update(Rid, T, Result1);
                {ok, Num} ->
                    ?WARN("Update Hero Return Rows: ~w", [Num]),
                    db_update(Rid, T, Result1);
                {error, Reason} ->
                    ?WARN("Update Hero Error: ~w", [Reason]),
                    {false, Result ++ [H | T]}
            end;
        0 ->
            db_update(Rid, T, Result1);
        _ ->
            ?ERR("Undefined #item.changed: ~w", [H#item.changed]),
            db_update(Rid, T, Result1)
    end;
db_update(_Rid, [], Result) -> {true, Result}.


unzip([Id, Val]) ->
    <<Version:8, Tid:32, Sort:8, Tab:8, Bin1/binary>> = Val,
    case Version of
        1 ->
            Attr = case Tid >= ?MIN_EQU_ID of
                true ->
                    <<HeroId:32, Etime:32, Atime:32, Lev:8,
                    Hp      :32,
                    Atk     :32,
                    Def     :32,
                    Pun     :32,
                    Hit     :32,
                    Dod     :32,
                    Crit    :32,
                    CritNum :32,
                    CritAnit:32,
                    Tou     :32,
                    Sockets :8,
                    EmbedLen:16, Bin2/binary>> = Bin1,
                    F1 = fun({B_, R_}) ->
                            << X1_:32, X2_:8, X3_:32, RB_/binary >> = B_,
                            {RB_, [{X1_, X2_, X3_}|R_]}
                    end,
                    {_Bin3, Embed} = protocol_fun:for(EmbedLen, F1, {Bin2, []}),
                    #equ{
                        hero_id    = HeroId
                        ,etime     = Etime
                        ,atime     = Atime
                        ,lev       = Lev
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
                        ,sockets   = Sockets
                        ,embed     = Embed
                    };
                false ->
                    <<Num:8, Quality:8>> = Bin1,
                    #prop{
                        num        = Num
                        ,quality   = Quality
                    }
            end,
            #item{
                id       = Id
                ,tid     = Tid
                ,sort    = Sort
                ,tab     = Tab
                ,changed = 0
                ,attr    = Attr
            };
        2 ->
            Attr = case Tid >= ?MIN_EQU_ID of
                true ->
                    <<HeroId:32, Etime:32, Atime:32, Lev:8,
                    Hp      :32,
                    Atk     :32,
                    Def     :32,
                    Pun     :32,
                    Hit     :32,
                    Dod     :32,
                    Crit    :32,
                    CritNum :32,
                    CritAnit:32,
                    Tou     :32,
                    Sockets :8,
                    EmbedLen:16, Bin2/binary>> = Bin1,
                    F1 = fun({B_, R_}) ->
                            << X1_:32, X2_:8, X3_:32, RB_/binary >> = B_,
                            {RB_, [{X1_, X2_, X3_}|R_]}
                    end,
                    {_Bin3, Embed} = protocol_fun:for(EmbedLen, F1, {Bin2, []}),
                    #equ{
                        hero_id    = HeroId
                        ,etime     = Etime
                        ,atime     = Atime
                        ,lev       = Lev
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
                        ,sockets   = Sockets
                        ,embed     = Embed
                    };
                false ->
                    <<Num:8, Quality:8, Level:8, Exp:32>> = Bin1,
                    #prop{
                        num        = Num
                        ,quality   = Quality
                        ,level     = Level
                        ,exp       = Exp
                    }
            end,
            #item{
                id       = Id
                ,tid     = Tid
                ,sort    = Sort
                ,tab     = Tab
                ,changed = 0
                ,attr    = Attr
            };
        3 ->
            Attr = case Tid >= ?MIN_EQU_ID of
                true ->
                    <<HeroId:32, Etime:32, Atime:32, Lev:8,
                    Hp      :32,
                    Atk     :32,
                    Def     :32,
                    Pun     :32,
                    Hit     :32,
                    Dod     :32,
                    Crit    :32,
                    CritNum :32,
                    CritAnit:32,
                    Tou     :32,
                    Sockets :8,
                    EmbedLen:16, Bin2/binary>> = Bin1,
                    F1 = fun({B_, R_}) ->
                            << X1_:32, X2_:8, X3_:32, X4_:8, X5_:32, RB_/binary >> = B_,
                            {RB_, [{X1_, X2_, X3_, X4_, X5_}|R_]}
                    end,
                    {_Bin3, Embed} = protocol_fun:for(EmbedLen, F1, {Bin2, []}),
                    #equ{
                        hero_id    = HeroId
                        ,etime     = Etime
                        ,atime     = Atime
                        ,lev       = Lev
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
                        ,sockets   = Sockets
                        ,embed     = Embed
                    };
                false ->
                    <<Num:8, Quality:8, Level:8, Exp:32>> = Bin1,
                    #prop{
                        num        = Num
                        ,quality   = Quality
                        ,level     = Level
                        ,exp       = Exp
                    }
            end,
            #item{
                id       = Id
                ,tid     = Tid
                ,sort    = Sort
                ,tab     = Tab
                ,changed = 0
                ,attr    = Attr
            };
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

zip(H) ->
    #item{tid = Tid, sort = Sort, tab = Tab, attr = Attr} = H,
    case Tid >= ?MIN_EQU_ID of
        true ->
            #equ{
                hero_id    = HeroId
                ,etime     = Etime
                ,atime     = Atime
                ,lev       = Lev
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
                ,sockets   = Sockets
                ,embed     = Embed
            } = Attr,
            %% ?INFO("Embed:~w", [Embed]),
            EmbedLen = length(Embed),
            EmbedBin = list_to_binary([<<X1:32, X2:8, X3:32, X4:8, X5:32>> || {X1, X2, X3, X4, X5} <- Embed]),
            <<?ITEM_ZIP_VERSION:8, Tid:32, Sort:8, Tab:8,
            HeroId:32, Etime:32, Atime:32, Lev:8,
            Hp      :32,
            Atk     :32,
            Def     :32,
            Pun     :32,
            Hit     :32,
            Dod     :32,
            Crit    :32,
            CritNum :32,
            CritAnit:32,
            Tou     :32,
            Sockets :8,
            EmbedLen:16, EmbedBin/binary>>;
        false ->
            #prop{
                num        = Num
                ,quality   = Quality
                ,level     = Level
                ,exp       = Exp
            } = Attr,
            <<?ITEM_ZIP_VERSION:8, Tid:32, Sort:8, Tab:8, Num:8, Quality:8, Level:8, Exp:32>>
    end.
%%.

%%' 功能开放进度(fundata)
init_fundata(Rs) ->
    Sql = list_to_binary([<<"SELECT `fun_data` FROM `fun_data` WHERE `role_id` = ">>
            , integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Data]} ->
            Data2 = unzip_fundata(Data),
            {ok, Rs#role{fundata = Data2}};
        {error, null} ->
            {ok, Rs};
        {error, Reason} ->
            {error, Reason}
    end.

update_fundata(Rs) ->
    #role{id = Id, fundata = Fundata} = Rs,
    Pic = ?ESC_SINGLE_QUOTES(zip_fundata(Fundata)),
    Sql1 = list_to_binary([<<"UPDATE `fun_data` SET `fun_data` = '">>
            , Pic, <<"' WHERE `role_id` = ">>
            , integer_to_list(Id)]),
    case db:execute(Sql1) of
        {ok, 0} ->
            insert_fundata(Rs);
        {ok, Num} -> {ok, Num};
        {error, Reason} -> {error, Reason}
    end.
insert_fundata(Rs) ->
    #role{id = Id, fundata = Fundata} = Rs,
    FunD = ?ESC_SINGLE_QUOTES(zip_fundata(Fundata)),
    Sql1 = list_to_binary([<<"SELECT count(*) FROM `fun_data` WHERE `role_id` = ">>
            ,integer_to_list(Id)]),
    case db:get_one(Sql1) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `fun_data` (`role_id`, `fun_data`) VALUES (">>
                    , integer_to_list(Id), <<", '">>, FunD, <<"')">>]),
            case db:execute(Sql2) of
                {ok, Num} -> {ok, Num};
                {error, Reason} -> {error, Reason}
            end;
        {error, Reason} -> {error, Reason};
        {ok, Num2} -> {ok, Num2}
    end.

-define(FUNDATA_ZIP_VERSION, 1).

zip_fundata([]) -> <<>>;
zip_fundata(Fundata) ->
    Rt1 = list_to_binary([<<Id:8,Num:8>> || {Id, Num} <- Fundata]),
    <<?FUNDATA_ZIP_VERSION:8, Rt1/binary>>.

unzip_fundata(<<>>) -> [];
unzip_fundata(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            [{Id,Num} || <<Id:8,Num:8>> <= Bin1];
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
%%.

%%' 英雄魂初始化
init_herosoul(Rs) ->
    Sql = list_to_binary([<<"select herosoul from herosoul where role_id = ">>, integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [HeroSoul]} ->
            Rs1 = Rs#role{herosoul = unzip_herosoul(HeroSoul)},
            Rs2 = herosoul_give_num(Rs1),
            {ok, Rs2};
        {error, null} ->
            {ok, Rs};
        {error, Reason} ->
            %% 初始化失败
            {error, Reason}
    end.

%% 保存herosoul数据
update_herosoul(Rs) ->
    #role{id = Rid, herosoul = HeroSoulList} = Rs,
    Val2 = ?ESC_SINGLE_QUOTES(zip_herosoul(HeroSoulList)),
    Sql = list_to_binary([<<"UPDATE `herosoul` SET `herosoul` = '">>
            ,Val2, <<"' WHERE `role_id` = ">>, integer_to_list(Rid)]),
    case db:execute(Sql) of
        {ok, 0} ->
            insert_herosoul(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok,Num} ->
            {ok,Num}
    end.

insert_herosoul(Rs) ->
    #role{id = Rid, herosoul = HeroSoulList} = Rs,
    Sql = list_to_binary([<<"select count(*) FROM `herosoul` WHERE `role_id` = ">>
            , integer_to_list(Rid)]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Val2 = ?ESC_SINGLE_QUOTES(zip_herosoul(HeroSoulList)),
            Sql2 = list_to_binary([<<"INSERT `herosoul` (`role_id`, `herosoul`) VALUES (">>
                    ,integer_to_list(Rid), <<",'">>,Val2
                    ,<<"')">>]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok,Num} ->
            {ok,Num}
    end.

%% 刷新英雄魂9个
herosoul_refresh() ->
    PosList = data_herosoul:get(ids),
    lists:foldl(fun(Pos,List) ->
                case data_herosoul:get(Pos) of
                    undefined ->
                        ?WARN("herosoul undefined Pos:~w", [Pos]),
                        [{Pos,0,0,0}|List];
                    Data ->
                        TupleList = util:get_val(proportion,Data),
                        case util:weight_extract2(TupleList) of
                            [] -> [{Pos,0,0,0} | List];
                            [{Rare,_}] ->
                                Data2 = data_herosoul_id:get(Rare),
                                case util:get_val(id_list,Data2) of
                                    undefined ->
                                        ?WARN("herosoul_id undefined Rare:~w", [Rare]),
                                        [{Pos,0,0,0} | List];
                                    IdList ->
                                        NeedId = util:rand_element(IdList),
                                        [{Pos,NeedId,0,Rare} | List]
                                end
                        end
                end
        end,[], PosList).

herosoul_give_num(Rs) ->
    %% 检测是否为当天第一次登陆
    #role{herosoul = HeroSoul} = Rs,
    case HeroSoul of
        [] -> Rs;
        [Cd1,Cd2,NT,_Num,Soul] ->
            Today = util:unixtime(today),
            case NT < Today of
                true ->
                    Time = util:unixtime(),
                    Rs#role{herosoul = [Cd1,Cd2,Time,0,Soul]};
                false -> Rs
            end
    end.

%% zip_herosoul / unzip_herosoul
-define(HEROSOUL_ZIP_VERSION, 1).
zip_herosoul([]) -> <<>>;
zip_herosoul([Cd1,Cd2,TN,Num,Soul]) ->
    Rt1 = [<<Cd1:32,Cd2:32,TN:32,Num:8>>],
    Rt2 = zip_herosoul1(Soul, []),
    Bin = list_to_binary(Rt1++Rt2),
    <<?HEROSOUL_ZIP_VERSION:8, Bin/binary>>.

zip_herosoul1([], Rt) -> Rt;
zip_herosoul1([{Pos,Id,State,Rare}|T], Rt) ->
    Rt1 = <<Pos:8,Id:32,State:8,Rare:8>>,
    zip_herosoul1(T, [Rt1|Rt]).

unzip_herosoul(<<>>) -> [];
unzip_herosoul(Bin) ->
     <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip_herosoul1(Bin1);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

unzip_herosoul1(<<>>) -> [];
unzip_herosoul1(<<Cd1:32,Cd2:32,TN:32,Num:8,RestBin/binary>>) ->
    List = unzip_herosoul2(RestBin, []),
    [Cd1,Cd2,TN,Num,List].

unzip_herosoul2(<<>>, Ret) ->
    Ret;
unzip_herosoul2(<<Pos:8,Id:32,State:8,Rare:8,RestBin/binary>>, Ret) ->
    unzip_herosoul2(RestBin, [{Pos,Id,State,Rare}|Ret]).

%%.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
