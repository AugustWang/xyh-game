%%----------------------------------------------------
%% $Id: mod_attain.erl 13109 2014-06-03 07:32:41Z piaohua $
%% @doc 成就模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(mod_attain).
-export([
        attain_state/3
        ,attain_state2/3
        ,attain_init/1
        ,attain_today/1
        ,attain_today9/1
        ,attain_condition/1
        ,attain_stores/1
        ,combat_attain/2
        ,hero_attain/3
        ,item_attain/2
        ,attain_refresh/1
        ,unzip/1
        ,zip/1
    ]
).

-include("common.hrl").
-include("prop.hrl").
-include("equ.hrl").
-include("hero.hrl").


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_attain_test() ->
    Ids = data_attain:get(ids),
    ?assert(length(Ids) > 0),
    lists:foreach(fun(Id) ->
                Data = data_attain:get(Id),
                Tid = util:get_val(tid, Data, 0),
                ?assert(util:get_val(type, Data, 0) > 0),
                ?assert(util:get_val(title, Data, 0) > 0),
                ?assert(util:get_val(tid, Data, 0) > 0),
                ?assertMatch(ok,case Tid < ?MIN_EQU_ID of
                        true ->
                            case Tid == 5 of
                                true -> ok;
                                false ->
                                    ?assert(data_prop:get(Tid) =/= undefined),
                                    ok
                            end;
                        false ->
                            ?assert(data_equ:get(Tid) =/= undefined),
                            ok
                    end),
                ?assert(util:get_val(condition, Data, 0) > 0),
                ?assert(case util:get_val(num, Data) of
                        {_, _} -> true;
                        Num when is_integer(Num) -> true;
                        _ -> false
                    end),
                ?assert(case util:get_val(title,Data) of
                        9 ->
                            {Toll1,Toll2} = case util:get_val(tollgate,Data) of
                                undefined -> {0, 0};
                                RR -> RR
                            end,
                            Toll1 > 0 andalso Toll2 > 0;
                        _ -> true
                    end)
        end, Ids),
    ok.
-endif.


%% 成就是否达到条件,更新完成状态,
attain_state(Type, Num, Rs) ->
    MyAttain = Rs#role.attain,
    case MyAttain of
        [] ->
            ?WARN("MyAttain is null:", []),
            Rs;
        _ ->
            case lists:keyfind(Type, 3, MyAttain) of
                false ->
                    Rs1 = attain_add_new(Type, Rs),
                    MyAttain2 = Rs1#role.attain,
                    attain_state_send(MyAttain2, Type, Num, Rs1);
                _ -> attain_state_send(MyAttain, Type, Num, Rs)
            end
    end.

%% Type == Type
attain_state_send([{Id, NextId, Type, Condition, State}|T], Type, Num, Rs) ->
    MyAttain = Rs#role.attain,
    Data1 = data_attain:get(Id),
    S1 = util:get_val(condition, Data1),
    S2 = util:get_val(title, Data1),
    %% State:0=未完成, 1=可领取, 2=全部完成
    Condition1 = Condition + Num,
    %% 每日任务推送
    case State == 0 andalso S2 == 9 of
        true ->
            sender:pack_send(Rs#role.pid_sender, 24002, [Id,Condition1]);
        false -> ok
    end,
    case State == 0 andalso Condition1 >= S1 of
        true ->
            %% 处理未完成的成就
            Lists1 = {Id,NextId, Type, Condition + Num, 1},
            Lists2 = lists:keyreplace(Id, 1, MyAttain, Lists1),
            sender:pack_send(Rs#role.pid_sender, 24001, [Id]),
            Rs1 = Rs#role{attain = Lists2},
            attain_state_send(T, Type, Num, Rs1);
        false ->
            %% 已完成的成就，只做Condition累加处理
            Lists1 = {Id, NextId, Type, Condition + Num, State},
            Lists2 = lists:keyreplace(Id, 1, MyAttain, Lists1),
            Rs1 = Rs#role{attain = Lists2},
            attain_state_send(T, Type, Num, Rs1)
    end;

attain_state_send([_|T], Type, Num, Rs) ->
    attain_state_send(T, Type, Num, Rs);

attain_state_send([], _Type, _Num, Rs) ->
    Rs.
    %% 如果是钻石成就,设置排行榜服务
    %% case Type =:= 62 of
    %%     true ->
    %%         gen_server:cast(rank, {rank_set, Num, Rs#role.id, Rs#role.name, 2}),
    %%         Rs;
    %%     false -> Rs
    %% end.

%% 英雄级别成就(统帅..)
attain_state2(Type, Num, Rs) ->
    MyAttain = Rs#role.attain,
    case MyAttain of
        [] -> ?WARN("==MyAttain is null:", []),
            Rs;
        _ ->
            case lists:keyfind(Type, 3, MyAttain) of
                false ->
                    Rs1 = attain_add_new(Type, Rs),
                    MyAttain2 = Rs1#role.attain,
                    attain_state_send2(MyAttain2, Type, Num, Rs1);
                _ -> attain_state_send2(MyAttain, Type, Num, Rs)
            end
    end.

attain_state_send2([{Id, NextId, Type, Condition, State}|T], Type, Num, Rs) ->
    MyAttain = Rs#role.attain,
    Data1 = data_attain:get(Id),
    Num1 = util:get_val(condition, Data1),
    Num2 = util:get_val(title, Data1),
    NewCondition = case Num > Condition of
        true -> Num;
        false -> Condition
    end,
    %% 每日任务推送
    case State == 0 andalso Num2 == 9 of
        true ->
            sender:pack_send(Rs#role.pid_sender, 24002, [Id,NewCondition]);
        false -> ok
    end,
    case State =:= 0 andalso Num >= Num1 of
        true ->
            Lists1 = {Id, NextId, Type, NewCondition, 1},
            Lists2 = lists:keyreplace(Id, 1, MyAttain, Lists1),
            sender:pack_send(Rs#role.pid_sender, 24001, [Id]),
            Rs1 = Rs#role{attain = Lists2},
            attain_state_send2(T, Type, Num, Rs1);
        false ->
            Lists1 = {Id, NextId, Type, NewCondition, State},
            Lists2 = lists:keyreplace(Id, 1, MyAttain, Lists1),
            Rs1 = Rs#role{attain = Lists2},
            attain_state_send2(T, Type, Num, Rs1)
    end;

attain_state_send2([_|T], Type, Num, Rs) ->
    attain_state_send2(T, Type, Num, Rs);

attain_state_send2([], _Type, _Num, Rs) -> Rs.

%% 添加新成就(只针对非日常成就,日常成就是动态加载)
attain_add_new(Type, Rs) ->
    Ids = data_attain:get(ids),
    Attain = attain_init2(Ids, []),
    MyAttain = Rs#role.attain,
    NewAttain = case lists:keyfind(Type, 3, Attain) of
        false -> [];
        L -> L
    end,
    case lists:keyfind(Type, 3, Attain) of
        false -> Rs; %% 是日常成就
        _ ->
            Lists = lists:keystore(Type, 3, MyAttain, NewAttain),
            Rs#role{attain = Lists}
    end.

%% @doc 初始化成就，日常成就数据隔天重置
-spec attain_init(Rs) -> {ok, Rs} | {error, Reason} when
    Rs :: #role{},
    Reason :: term().

attain_init(Rs) ->
    MyId = Rs#role.id,
    Sql = list_to_binary([<<"SELECT `ctime`, `attain` FROM `attain` WHERE `id` = ">>, integer_to_list(MyId), <<";">>]),
    case db:get_row(Sql) of
        {ok, [Time, Bin]} ->
            case unzip(Bin) of
                [] ->
                    Attain_init2 = attain_init1(Rs),
                    {ok, Rs#role{
                            attain_time = util:unixtime()
                            ,attain = Attain_init2
                        }};
                Attain ->
                    Rs1 = Rs#role{
                        attain_time = Time
                        ,attain = Attain
                    },
                    {ok, attain_refresh(Rs1)}
            end;
        {error, null} ->
            Attain_init2 = attain_init1(Rs),
            {ok, Rs#role{
                    attain_time = util:unixtime()
                    ,attain = Attain_init2
                }};
        {error, Reason} ->
            {error, Reason}
    end.

%% 初始化成就
attain_init1(Rs) ->
    Ids = data_attain:get(ids),
    Attain = attain_init2(Ids, []),
    attain_today(Rs) ++ Attain.

%% 初始化非日常成就
attain_init2([Id | Ids], Rt) ->
    Team = data_attain:get(Id),
    Type = util:get_val(type, Team),
    case util:get_val(start, Team, 0) of
        1 ->
            Attain = case util:get_val(next, Team, 0) of
                0 -> {Id, 0, Type, 0, 0};
                NextId -> {Id, NextId, Type, 0, 0}
            end,
            attain_init2(Ids, [Attain | Rt]);
        0 ->
            attain_init2(Ids, Rt)
    end;
attain_init2([], Rt) ->
    Rt.

%% 日常成就抽取
attain_today(Rs) ->
    Ids = data_attain:get(ids),
    attain_today1(Ids, Rs, [], [], [], []).

attain_today1([Id | Ids], Rs, A6, A7, A8, A9) ->
    Data = data_attain:get(Id),
    case util:get_val(title, Data) of
        %% 6 ->
        %%     Type = util:get_val(type, Data, 0),
        %%     NewA6 = [{Id, 0, Type, 0, 0} | A6],
        %%     attain_today1(Ids, Rs, NewA6, A7, A8, A9);
        %% 7 ->
        %%     Type = util:get_val(type, Data, 0),
        %%     NewA7 = [{Id, 0, Type, 0, 0} | A7],
        %%     attain_today1(Ids, Rs, A6, NewA7, A8, A9);
        %% 8 ->
        %%     Type = util:get_val(type, Data, 0),
        %%     NewA8 = [{Id, 0, Type, 0, 0} | A8],
        %%     attain_today1(Ids, Rs, A6, A7, NewA8, A9);
        9 ->
            Type = util:get_val(type, Data, 0),
            {Tollgate1,Tollgate2} = case util:get_val(tollgate, Data) of
                undefined -> {0, 0};
                TR -> TR
            end,
            #role{tollgate_newid = TollgateId} = Rs,
            NewA9 = case TollgateId >= Tollgate1 andalso TollgateId =< Tollgate2 of
                true -> [{Id, 0, Type, 0, 0} | A9];
                false -> A9
            end,
            attain_today1(Ids, Rs, A6, A7, A8, NewA9);
        _ ->
            %% 其它类型为非日常成就
            attain_today1(Ids, Rs, A6, A7, A8, A9)
    end;
attain_today1([], _Rs, A6, A7, A8, A9) ->
    util:rand_element(2, A6)
    ++ util:rand_element(2, A7)
    ++ util:rand_element(1, A8)
    ++ A9.

%% @doc 刷新成就
-spec attain_refresh(Rs) -> NewRs when
    Rs :: NewRs,
    NewRs :: #role{}.

attain_refresh(Rs) ->
    case Rs#role.attain_time < util:unixtime(today) of
        true ->
            %% ?DEBUG("attain_refresh: ~w", [Rs#role.id]),
            NotDaily = get_not_daily_attain(Rs#role.attain, []),
            Daily = attain_today(Rs),
            Attain = Daily ++ NotDaily,
            Rs#role{
                attain_time = util:unixtime(),
                attain = Attain
            };
        false ->
            %% 今天已经刷新过了，不需要再处理
            Rs
    end.

%% 抽取非日常成就
get_not_daily_attain([Attain | Attains], Rt) ->
    Id = element(1, Attain),
    case data_attain:get(Id) of
        undefined ->
            ?DEBUG("Error Attain Id(~w) When Calling [attain_refresh1/2] !", [Id]),
            get_not_daily_attain(Attains, Rt);
        Data ->
            case util:get_val(title, Data) >= 6 of
                true ->
                    %% title大于6为日常成就，过滤掉
                    get_not_daily_attain(Attains, Rt);
                false ->
                    Attain = try_next_attain(Attain, Data),
                    get_not_daily_attain(Attains, [Attain | Rt])
            end
    end;
get_not_daily_attain([], Rt) ->
    Rt.

%% 检测当前已完成的成就是否有新增的后继成就
try_next_attain({Id, NextId, Type, Condition, State}, Data) ->
    case State =:= 2 of
        true ->
            Nid = util:get_val(next, Data, 0),
            case Nid > 0 of
                true ->
                    S = util:get_val(condition, Data, 0),
                    case Condition >= S of
                        true -> {Id, Nid, Type, Condition, 1};
                        false -> {Id, Nid, Type, Condition, 0}
                    end;
                false ->
                    {Id, 0, Type, Condition, 2}
            end;
        false ->
            {Id, NextId, Type, Condition, State}
    end.

%% 每日必做任务实时开户通知
attain_today9(Rs) ->
    Ids = data_attain:get(ids),
    attain_today9(Ids, Rs).

attain_today9([], Rs) -> Rs;
attain_today9([Id|T], Rs) ->
    Data = data_attain:get(Id),
    case util:get_val(title,Data) of
        9 ->
            Rs1 = attain_condition1(Id,Rs),
            attain_today9(T, Rs1);
        _ ->
            attain_today9(T, Rs)
    end.

attain_condition(Rs) ->
    Ids = data_attain:get(ids),
    attain_condition(Ids, Rs).

attain_condition([], Rs) -> Rs;
attain_condition([Id|T], Rs) ->
    #role{attain = Attain} = Rs,
    Data = data_attain:get(Id),
    case util:get_val(title,Data) of
        %% 9 ->
        %%     Rs1 = attain_condition1(Id,Rs),
        %%     attain_condition(T, Rs1);
        10 ->
            case lists:keymember(Id,1,Attain) of
                true ->
                    attain_condition(T, Rs);
                false ->
                    CL = [tollgate,vip,exp
                        ,quality,time,pre
                        ,proplimit,herolev
                        ,heroquality,heroes
                        ,jewel,jewelquality
                        ,equ,eququality,equlev],
                    F = fun(L1, L2) ->
                            case util:get_val(L1,Data) of
                                undefined -> L2;
                                _ -> [L1|L2]
                            end
                    end,
                    List = lists:foldl(F, [], CL),
                    List2 = lists:reverse(List),
                    Num = case util:get_val(number,Data) of
                        undefined -> length(List2);
                        N ->
                            case N > length(List2) of
                                true -> length(List2);
                                false -> N
                            end
                    end,
                    Rs2 = attain_condition2(List2, Id, Num, Rs),
                    attain_condition(T, Rs2)
            end;
        _ ->
            attain_condition(T, Rs)
    end.

attain_condition1(Id,Rs) ->
    #role{tollgate_newid = GateId, attain = Attain} = Rs,
    Data = data_attain:get(Id),
    {Tollgate1,Tollgate2} = case util:get_val(tollgate, Data) of
        undefined -> {0, 0};
        TR -> TR
    end,
    Rs1 = case GateId >= Tollgate1 of
        true ->
            case lists:keymember(Id,1,Attain) of
                true -> Rs;
                false ->
                    Type = util:get_val(type, Data, 0),
                    sender:pack_send(Rs#role.pid_sender, 24003, [Id,1]),
                    Rs#role{attain = [{Id, 0, Type, 0, 0} | Attain], save = [attain]}
            end;
        false ->
            Rs
    end,
    case GateId > Tollgate2 andalso Tollgate2 =/= 0 of
        true ->
            case lists:keyfind(Id,1,Rs1#role.attain) of
                false -> Rs1;
                {Id,_,_,_,St} when St == 0 ->
                    sender:pack_send(Rs#role.pid_sender, 24003, [Id,2]),
                    NewAttain = lists:keydelete(Id,1,Rs1#role.attain),
                    Rs1#role{attain = NewAttain, save = [attain]};
                _ -> Rs1
            end;
        false ->
            Rs1
    end.

attain_condition2(_,Id,0,Rs) ->
    #role{attain = Attain} = Rs,
    Data = data_attain:get(Id),
    Type = util:get_val(type, Data, 0),
    Next = util:get_val(next, Data, 0),
    sender:pack_send(Rs#role.pid_sender, 24008, [Id]),
    Rs#role{attain = [{Id, Next, Type, 0, 0} | Attain], save = [attain]};
attain_condition2([],_,_,Rs) -> Rs;
attain_condition2([CL|CLS],Id,Num,Rs) ->
    Num1 = case attain_condition3(CL,Id,Rs) of
        true -> Num - 1;
        false -> Num
    end,
    attain_condition2(CLS,Id,Num1,Rs).

attain_condition3(tollgate,Id,Rs) ->
    #role{tollgate_newid = GateId} = Rs,
    Data = data_attain:get(Id),
    Tollgate = util:get_val(tollgate,Data,0),
    GateId >= Tollgate andalso Tollgate /= 0;

attain_condition3(vip,Id,Rs) ->
    #role{vip = Vip} = Rs,
    Data = data_attain:get(Id),
    VipC = util:get_val(Vip,Data,0),
    Vip1 = case Vip of
        [] -> 0;
        [N,_,_] -> N - 1
    end,
    Vip1 >= VipC;

attain_condition3(time,Id,Rs) ->
    #role{loginsign_time = LoginTime} = Rs,
    Now = util:unixtime(),
    Data = data_attain:get(Id),
    Time = util:get_val(time,Data,0),
    (Now - LoginTime) > Time;

attain_condition3(pre,Id,Rs) ->
    #role{attain = Attain} = Rs,
    Data = data_attain:get(Id),
    Pre = util:get_val(pre,Data,0),
    case lists:keyfind(Pre,1,Attain) of
        false -> false;
        {Pre,_,_,_,S} ->
            S == 2
    end;

attain_condition3(herolev,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(herolev,Data,0),
    Num = count_hero(Rs#role.heroes, S, 0),
    Num > 0;

attain_condition3(heroquality,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(heroquality,Data,0),
    count_hero_quality(Rs#role.heroes, S);

attain_condition3(heroes,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(heroes,Data,0),
    length(Rs#role.heroes) >= S;

attain_condition3(jewel,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(jewel,Data,0),
    Num = count_jewel(Rs#role.items, 0),
    Num >= S;

attain_condition3(jewelquality,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(jewelquality,Data,0),
    count_jewel_quality(Rs#role.items, S);

attain_condition3(equ,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(equ,Data,0),
    Num = count_equ(Rs#role.items, 0),
    Num >= S;

attain_condition3(eququality,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(eququality,Data,0),
    count_equ_quality(Rs#role.items, S);

attain_condition3(equlev,Id,Rs) ->
    Data = data_attain:get(Id),
    S = util:get_val(equlev,Data,0),
    count_equ_lev(Rs#role.items, S).

%% 数据库相关操作

attain_stores(Rs) ->
    #role{
        id	=	Id
        ,attain_time = Ctime
        ,attain = Attain
    } = Rs,
    %% ?DEBUG("==attain stores : ~w", [Attain]),
    Val = ?ESC_SINGLE_QUOTES(zip(Attain)),
    Sql = list_to_binary([<<"UPDATE `attain` SET `attain` = '">>
            , Val,<<"',">>, <<"`ctime` = ">>, integer_to_list(Ctime)
            , <<" WHERE `id` = ">>, integer_to_list(Id), <<";">>]),
    case db:execute(Sql) of
        {ok, 0} ->
            attain_stores2(Rs);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

attain_stores2(Rs) ->
    #role{
        id	=	Id
        ,attain_time = Ctime
        ,attain = Attain
    } = Rs,
    %% ?DEBUG("==attain stores : ~w", [Attain]),
    Val = ?ESC_SINGLE_QUOTES(zip(Attain)),
    Sql = list_to_binary([
            <<"SELECT count(*) FROM `attain` WHERE id = ">>,integer_to_list(Id),<<";">>]),
    case db:get_one(Sql) of
        {ok, 0} ->
            Sql2 = list_to_binary([<<"INSERT `attain` (`id`, `ctime`, `attain`) VALUES (">>
                    , integer_to_list(Id), <<",">>, integer_to_list(Ctime), <<",'">>, Val, <<"');">>]),
            db:execute(Sql2);
        {error, Reason} ->
            {error, Reason};
        {ok, Num} ->
            {ok, Num}
    end.

%% zip / unzip
%% 解包binary
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip1(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.

unzip1(<<X1:32, X2:32, X3:32, X4:32, X5:32, RestBin/binary>>, Rt) ->
    Rt1 = [{X1, X2, X3, X4, X5} | Rt],
    unzip1(RestBin, Rt1);
unzip1(<<>>, Rt) ->
    Rt.

%% 打包成binary
-define(ATTAIN_ZIP_VERSION, 1).
zip(L) ->
    Bin = list_to_binary([<<X1:32, X2:32, X3:32, X4:32, X5:32>> || {X1, X2, X3, X4, X5} <- L]),
    <<?ATTAIN_ZIP_VERSION:8, Bin/binary>>.

%% --- 私有函数 ---

%% 战斗成就推送
combat_attain(Id, Rs) ->
    if
        Id == 1301 ->
            attain_state(2, 1, Rs);
        Id == 2301 ->
            attain_state(3, 1, Rs);
        Id == 3301 ->
            attain_state(4, 1, Rs);
        Id == 4301 ->
            attain_state(5, 1, Rs);
        Id == 5301 ->
            attain_state(6, 1, Rs);
        Id == 6301 ->
            attain_state(7, 1, Rs);
        true -> Rs
    end.

%% 英雄成就推送
hero_attain(Type, S, Rs) ->
    Num = count_hero(Rs#role.heroes, S, 0),
    case Num > 0 of
        true -> attain_state2(Type, Num, Rs);
        false -> Rs
    end.

%% 装备穿戴
item_attain(Items,Rs) ->
    item_attain(Items,Rs,0).
item_attain([], Rs, _) -> Rs;
item_attain([#item{attr = Attr}|Items], Rs, N) when is_record(Attr,equ) ->
    case N of
        4 ->
            mod_attain:attain_state(84,1,Rs);
        _ ->
            case Attr#equ.hero_id > 0 of
                true -> item_attain(Items,Rs,N+1);
                false -> item_attain(Items,Rs,N)
            end
    end;
item_attain([_|Items],Rs,N) ->
    item_attain(Items,Rs,N).

count_hero([#hero{lev = Lev1} | Heros], Lev, Count) when Lev1 >= Lev ->
    count_hero(Heros, Lev, Count + 1);
count_hero([_ | Heros], Lev, Count) ->
    count_hero(Heros, Lev, Count);
count_hero([], _Lev, Count) ->
    Count.

count_hero_quality([#hero{quality = Quality1} | _Heros], Quality) when Quality1 >= Quality ->
    true;
count_hero_quality([_ | Heros], Quality) ->
    count_hero_quality(Heros, Quality);
count_hero_quality([], _Quality) ->
    false.

count_jewel([#item{sort = Sort} | Items], Count) when Sort == 4 ->
    count_jewel(Items, Count + 1);
count_jewel([_ | Items], Count) ->
    count_jewel(Items, Count);
count_jewel([], Count) ->
    Count.

count_jewel_quality([#item{attr = Attr} | Items], Quality) when is_record(Attr,prop) ->
    case Attr#prop.quality >= Quality of
        true -> true;
        false -> count_jewel_quality(Items, Quality)
    end;
count_jewel_quality([_ | Items], Quality) ->
    count_jewel_quality(Items, Quality);
count_jewel_quality([], _Quality) ->
    false.

count_equ([#item{attr = Attr} | Items], Count) when is_record(Attr,equ) ->
    count_equ(Items, Count + 1);
count_equ([_ | Items], Count) ->
    count_equ(Items, Count);
count_equ([], Count) ->
    Count.

count_equ_quality([#item{attr = Attr} | Items], Quality) when is_record(Attr,equ) ->
    case Attr#equ.quality >= Quality of
        true -> true;
        false -> count_equ_quality(Items, Quality)
    end;
count_equ_quality([_ | Items], Quality) ->
    count_equ_quality(Items, Quality);
count_equ_quality([], _Quality) ->
    false.

count_equ_lev([#item{attr = Attr} | Items], Lev) when is_record(Attr,equ) ->
    case Attr#equ.lev >= Lev of
        true -> true;
        false -> count_equ_lev(Items, Lev)
    end;
count_equ_lev([_ | Items], Lev) ->
    count_equ_lev(Items, Lev);
count_equ_lev([], _Lev) ->
    false.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
