%% ------------------------------------------------------------------
%% $Id: mod_coliseum.erl 12897 2014-05-20 02:18:27Z piaohua $
%% @doc 新版竞技场
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_coliseum).
-behaviour(gen_server).
-include("common.hrl").
-include("hero.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(SERVER, coliseum).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([
        start_link/0
        ,update_rank/0
        ,update_exp/0
        ,init_coliseum/1
        ,stores_coliseum/1
        ,get_data/1
        ,set_data/4
        ,zip_heroes/1
        ,unzip_heroes/1
        ,fix_coliseum_pos/1
        ,coliseum_wars_reset/1
        ,get_rank_pos/2
        ,get_rank/1
        ,get_newlev_from_db/1
        ,change_newlev/1
        ,export_robot/0
        ,export_robot_test1/0
        ,export_robot_test2/0
        ,init_new_robot/1
        ,import_new_robot/0
        ,test/0
        ,change_lev4/2
    ]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
data_robot_new_test() ->
    Ids1 = data_robot_new:get(ids),
    Ids2 = data_robot_new2:get(ids),
    ?assert(Ids1 == Ids2),
    lists:foreach(fun(Id) ->
                Data = data_robot_new:get(Id),
                ?assert(Data =/= undefined),
                L = [erlang:tuple_to_list(X) || X <- Data],
                H = [{lists:nth(2, X2), lists:nth(3, X2)} || X2 <- L],
                Data2 = data_robot_new2:get(Id),
                Picture = util:get_val(picture, Data2, undefined),
                Monster = util:get_val(monster, Data2, undefined),
                ?assert(Data2 =/= undefined),
                ?assert(is_integer(Picture)),
                F = fun(H1, H2) -> lists:member(H1, H2) end,
                FL = [F(A, Monster) || A <- H],
                ?assert(lists:all(fun(T) -> T == true end, FL))
        end ,Ids1),
    ok.
-endif.

test() ->
    Ids1 = data_robot_new:get(ids),
    Ids2 = data_robot_new2:get(ids),
    test(Ids1, Ids2).
test([], _L) -> ok;
test([H|T], L) ->
    Data = data_robot_new:get(H),
    case length(Data) =< 4 andalso length(Data) > 0 of
        true -> ok;
        false -> io:format("~w ~n", [H])
    end,
    case lists:member(H, L) of
        true -> test(T, L);
        false ->
            io:format(" ~w ~n", [H]),
            test(T, L)
    end.


%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

%% arena = 旧版本竞技场
%% coliseum = 新版竞技场

-record(state, {
    }).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    State = #state{},
    self() ! init_coliseum_rank, %% (index,id,rid,name,picture,exp,power)
    %% self() ! init_coliseum_rank, %% (index,id,rid,name,picture,power)
    {ok, State}.

%% 获取用户的等级(战斗时不每次都来获取,读cache)stop using
handle_call({get_level2, Id}, _From, State) ->
    Lev = get_level2(Id),
    {reply, Lev, State};

%% 当前最低等级,注册用户加在最后
handle_call({get_level}, _From, State) ->
    Ids = data_coliseum:get(ids),
    Lev = get_level(Ids),
    {reply, Lev, State};

%% 获取排名(默认返回最低)
handle_call({get_rank_pos, Id, Lev}, _From, State) ->
    RankList = get({coliseum_rank, Lev}),
    Index = case lists:keyfind(Id, 2, RankList) of
        false -> 0;
        {Index1, Id, _,_,_,_,_} ->
            Index1
    end,
    {reply, Index, State};

%% 获取竞技场排行榜(coliseum)(test use)
handle_call({get_coliseum_rank, Lev}, _From, State) ->
    List = case get({coliseum_rank, Lev}) of
        undefined ->
            Data = data_coliseum:get(Lev),
            Num = util:get_val(num, Data, 0),
            Data1 = get_coliseum_rank_from_db(Lev, Num),
            put({coliseum_rank, Lev}, Data1),
            Data1;
        R -> R
    end,
    Data3 = data_coliseum:get(Lev),
    Num2 = util:get_val(num, Data3, 0),
    List2 = lists:sublist(List, Num2),
    List3 = tuple2list(List2),
    {reply, List3, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 新竞技场新用户加入列表(coliseum)
handle_cast({set_coliseum_rank, Id, Rid, Name, Picture, Exp, Power}, State) ->
    List = [{Id, Rid, Name, Picture, Exp, Power}],
    set_coliseum_rank(List),
    {noreply, State};

%% 战斗结束对换排名(Id1=对方, Id2=自己)
%% TODO:如果玩家不是排行榜成员,就替换已有成员
handle_cast({change_rank_pos1, Id1, Id2, Lev, Combat}, State) ->
    List = get({coliseum_rank, Lev}),
    L1 = case lists:keyfind(Id1, 2, List) of
        false -> [];
        R1 -> R1
    end,
    L2 = case lists:keyfind(Id2, 2, List) of
        false -> [];
        R2 -> R2
    end,
    case L1 == [] orelse L2 == [] of
        true -> ok;
        false ->
            {Pos1, Id1, Rid1, Name1, Picture1, Exp1, Power1} = L1,
            {Pos2, Id2, Rid2, Name2, Picture2, Exp2, _Power2} = L2,
            if
                Pos1 < Pos2 ->
                    L3 = {Pos2, Id1, Rid1, Name1, Picture1, Exp1, Power1},
                    L4 = {Pos1, Id2, Rid2, Name2, Picture2, Exp2, Combat},
                    List1 = lists:keyreplace(Id1, 2, List, L3),
                    List2 = lists:keyreplace(Id2, 2, List1, L4),
                    put({coliseum_rank, Lev}, List2);
                true -> ok
            end
    end,
    {noreply, State};

%% 自己不在排行中在这里换名次
handle_cast({change_rank_pos2, Id1, List, Lev}, State) ->
    Rank = get({coliseum_rank, Lev}),
    [Id, Rid, Name, Pic, Exp, Combat] = List,
    case lists:keyfind(Id1, 2, Rank) of
        false -> ok;
        {Pos1, _, _, _, _, _, _} ->
            List2 = {Pos1, Id, Rid, Name, Pic, Exp, Combat},
            List3 = lists:keyreplace(Pos1, 1, Rank, List2),
            put({coliseum_rank, Lev}, List3)
    end,
    {noreply, State};

%% 不同等级对换排名(Id1=对方, Id2=自己),对方在线要通知等级变化
handle_cast({change_rank_pos3, Pid, Rid, Id1, Lev1, Id2, Lev2, Combat}, State) ->
    Rank1 = get({coliseum_rank, Lev1}),
    Rank2 = get({coliseum_rank, Lev2}),
    L1 = case lists:keyfind(Id1, 2, Rank1) of
        false -> [];
        R1 -> R1
    end,
    L2 = case lists:keyfind(Id2, 2, Rank2) of
        false -> [];
        R2 -> R2
    end,
    case L1 == [] orelse L2 == [] of
        true -> ok;
        false ->
            {Pos1, Id1, Rid1, Name1, Picture1, Exp1, Power1} = L1,
            {Pos2, Id2, Rid2, Name2, Picture2, Exp2, _Power2} = L2,
            if
                Lev1 < Lev2 ->
                    L3 = {Pos2, Id1, Rid1, Name1, Picture1, Exp1, Power1},
                    L4 = {Pos1, Id2, Rid2, Name2, Picture2, Exp2, Combat},
                    List1 = lists:keyreplace(Pos2, 1, Rank2, L3),
                    List2 = lists:keyreplace(Pos1, 1, Rank1, L4),
                    %% 发送事件更新role,(如果在线改事件,不在线直接写db)
                    %% myevent:send_event(Rid, {change_level, Lev2}),
                    change_lev6(Rid, Lev2),
                    change_lev3(Id1, Lev2),
                    Pid ! {pt, 2069, [Lev1]},
                    put({coliseum_rank, Lev1}, List2),
                    put({coliseum_rank, Lev2}, List1);
                true -> ok
            end
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?WARN("undefined msg:~w", [Msg]),
    {noreply, State}.

%% 新竞技场排行榜初始化(coliseum),唯一id战斗,rid查看英雄之家
%% (index, id, rid, name, picture, exp, power)
handle_info(init_coliseum_rank, State) ->
    Ids = data_coliseum:get(ids),
    case check_init_rank_from_db() of
        true ->
            init_coliseum_rank_from_db(Ids);
        false ->
            set_coliseum_rank_from_db(Ids)
    end,
    {noreply, State};

%% 新版竞技场排行榜更新(coliseum)
%% 先给排行榜奖励再刷新
%% TODO:更新数据库lev同时要更新在线用户role.coliseum
handle_info(update_coliseum_rank, State) ->
    TopRank = case get({coliseum_rank, 1}) of
        undefined -> [];
        R -> R
    end,
    lib_admin:new_server_active2(TopRank), %% 新服活动奖励
    Ids = data_coliseum:get(ids),
    update_coliseum_rank_refresh(Ids),
    {noreply, State};

handle_info(update_exp, State) ->
    F = fun(Lev) ->
            List = case get({coliseum_rank, Lev}) of
                undefined -> [];
                L -> L
            end,
            {List1,List2} = change_exp2(Lev, List),
            List3 = lists:sort(List1 ++ List2),
            put({coliseum_rank, Lev}, List3),
            change_exp3(List1)
    end,
    Ids = data_coliseum:get(ids),
    lists:foreach(F, Ids),
    {noreply, State};

%% 获取竞技场排行榜(coliseum)
handle_info({get_coliseum_rank, Pid, PidSender, Lev, Id, Exp, Wars, Chances, Time}, State) ->
    Rank = case get({coliseum_rank, Lev}) of
        undefined ->
            Data = data_coliseum:get(Lev),
            Num = util:get_val(num, Data, 0),
            Data1 = get_coliseum_rank_from_db(Lev, Num),
            put({coliseum_rank, Lev}, Data1),
            Data1;
        R -> R
    end,
    %% ?INFO("Rank:~w", [Rank]),
    %% List = case lists:keyfind(Id, 2, Rank) of
    %%     false ->
    %%         Level = get_newlev_from_db(Id),
    %%         Level2 = case Level =/= 0 andalso Level =/= Lev of
    %%             true ->
    %%                 Pid ! {pt, 2069, [Level]},
    %%                 Level;
    %%             false -> Lev
    %%         end,
    %%         get({coliseum_rank, Level2});
    %%     _ -> Rank
    %% end,
    List = case lists:keyfind(Id, 2, Rank) of
        false ->
            {Level, RL} = get_coliseum_rank(Id),
            Pid ! {pt, 2069, [Level]},
            RL;
        _ -> Rank
    end,
    Pos = case lists:keyfind(Id, 2, List) of
        false -> 0;
        {A,_,_,_,_,_,_} -> A
    end,
    List1 = show_rule(List, Lev, Pos),
    List2 = lists:keysort(1, List1),
    List3 = lists:sublist(List2, 20),
    List4 = case lists:keyfind(Pos, 1, List) of
        false -> List3;
        R1 -> lists:keystore(Pos, 1, List3, R1)
    end,
    List5 = tuple2list(List4),
    List6 = lists:sort(List5),
    sender:pack_send(PidSender, 33037, [Pos, Exp, Lev, Wars, Chances, Time, List6]),
    {noreply, State};

handle_info({get_coliseum_level, Pid, Id, Lev}, State) ->
    Rank = case get({coliseum_rank, Lev}) of
        undefined -> [];
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false ->
            {Level, _RL} = get_coliseum_rank(Id),
            Pid ! {pt, 2069, [Level]},
            ok;
        _ -> ok
    end,
    {noreply, State};

%% 判断是否可以挑战(id1=对方,id2=自己)
handle_info({is_combat, Id1, Id2, Lev, PidSender, Type, Index, Pid}, State) ->
    Data = data_coliseum:get(Lev),
    Show = util:get_val(show, Data, 0),
    List = get({coliseum_rank, Lev}),
    Pos1 = case lists:keyfind(Id1, 2, List) of
        false -> 0;
        {A,_,_,_,_,_,_} -> A
    end,
    Pos2 = case lists:keyfind(Id2, 2, List) of
        false -> 0;
        {B,_,_,_,_,_,_} -> B
    end,
    List2 = is_combat(List, Pos2, Show),
    F = fun({A,_B,_C,_D,_E,_F,_G}) -> A =< 10 end,
    IsCombat = case List2 == [] of
       true -> true;
       false ->
           lists:any(F, List2)
   end,
   if
       Pos1 == 0 orelse Pos2 == 0 ->
           sender:pack_send(PidSender, 33025, [129, 0, []]);
       Pos1 =/= Index ->
           sender:pack_send(PidSender, 33025, [6, 0, []]);
       Pos2 < Pos1 ->
           sender:pack_send(PidSender, 33025, [4, 0, []]);
       IsCombat == false andalso Pos1 =< 10 ->
           sender:pack_send(PidSender, 33025, [5, 0, []]);
       true ->
           Pid ! {pt, 2068, [Id1, Type]}
   end,
    {noreply, State};

%% 购买物品更新排行榜中的功勋值
handle_info({set_rank_newexp, Id, Lev, Exp}, State) ->
    Rank = case get({coliseum_rank, Lev}) of
        undefined ->
            Data = data_coliseum:get(Lev),
            Num = util:get_val(num, Data, 0),
            Data1 = get_coliseum_rank_from_db(Lev, Num),
            put({coliseum_rank, Lev}, Data1),
            Data1;
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false -> ok;
        {Pos1, Id1, Rid1, Name1, Picture1, _Exp1, Power1} ->
            L = {Pos1, Id1, Rid1, Name1, Picture1, Exp, Power1},
            Rank2 = lists:keyreplace(Id1, 2, Rank, L),
            put({coliseum_rank, Lev}, Rank2)
    end,
    {noreply, State};

%% 更新排行榜头像
handle_info({set_rank_picture, Id, Lev, Picture}, State) ->
    Rank = case get({coliseum_rank, Lev}) of
        undefined ->
            Data = data_coliseum:get(Lev),
            Num = util:get_val(num, Data, 0),
            Data1 = get_coliseum_rank_from_db(Lev, Num),
            put({coliseum_rank, Lev}, Data1),
            Data1;
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false -> ok;
        {Pos1, Id1, Rid1, Name1, _Picture1, Exp1, Power1} ->
            L = {Pos1, Id1, Rid1, Name1, Picture, Exp1, Power1},
            Rank2 = lists:keyreplace(Id1, 2, Rank, L),
            put({coliseum_rank, Lev}, Rank2)
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
%% 定点更新排行榜
%% TODO:要通知在线用户更新role.coliseum(给前端发过期通知)
update_rank() ->
    ?SERVER ! update_coliseum_rank.

update_exp() ->
    ?SERVER ! update_exp.

%% 获取排名
get_rank_pos(Id, Lev) ->
    Ids = data_coliseum:get(ids),
    case lists:member(Lev, Ids) of
        true ->
            gen_server:call(?SERVER, {get_rank_pos, Id, Lev});
        false -> 99999
    end.

%% 获取排行榜(test use)
get_rank(Lev) ->
    Ids = data_coliseum:get(ids),
    case lists:member(Lev, Ids) of
        true ->
            gen_server:call(?SERVER, {get_coliseum_rank, Lev});
        false -> []
    end.

%% TODO:定点回存数据

%% 新版排行榜更新规则
update_coliseum_rank_refresh([Id1, Id2 | Id3]) ->
    update_coliseum_rank_refresh1(Id1, Id2, Id3).

update_coliseum_rank_refresh1(Id1, Id2, []) ->
    Data = data_coliseum:get(Id1),
    Down = util:get_val(down, Data, 0),
    Rank1 = get({coliseum_rank, Id1}),
    Rank2 = get({coliseum_rank, Id2}),
    List1 = lists:keysort(1, Rank1),
    List2 = lists:keysort(1, Rank2),
    L1 = case (length(List1) - Down) > 0 of
        true -> length(List1) - Down;
        false -> 0
    end,
    L2 = case (length(List2) - Down) > 0 of
        true -> Down;
        false -> 0
    end,
    case L1 == 0 orelse L2 == 0 of
        true -> ok;
        false ->
            {A, B} = lists:split(L1, List1),
            {C, D} = lists:split(L2, List2),
            NewList1 = fix_coliseum_rank2(A ++ C),
            NewList2 = fix_coliseum_rank2(B ++ D),
            put({coliseum_rank, Id1}, NewList1),
            put({coliseum_rank, Id2}, NewList2),
            change_lev4(C, Id1),
            change_lev4(B, Id2)
    end;
update_coliseum_rank_refresh1(Id1, Id2, [Id3 | Id4]) ->
    Data = data_coliseum:get(Id1),
    Down = util:get_val(down, Data, 0),
    Rank1 = get({coliseum_rank, Id1}),
    Rank2 = get({coliseum_rank, Id2}),
    List1 = lists:keysort(1, Rank1),
    List2 = lists:keysort(1, Rank2),
    L1 = case (length(List1) - Down) > 0 of
        true -> length(List1) - Down;
        false -> 0
    end,
    L2 = case (length(List2) - Down) > 0 of
        true -> Down;
        false -> 0
    end,
    case L1 == 0 orelse L2 == 0 of
        true ->
            update_coliseum_rank_refresh1(Id2, Id3, Id4);
        false ->
            {A, B} = lists:split(L1, List1),
            {C, D} = lists:split(L2, List2),
            NewList1 = fix_coliseum_rank2(A ++ C),
            NewList2 = fix_coliseum_rank2(B ++ D),
            put({coliseum_rank, Id1}, NewList1),
            put({coliseum_rank, Id2}, NewList2),
            change_lev4(C, Id1),
            change_lev4(B, Id2),
            update_coliseum_rank_refresh1(Id2, Id3, Id4)
    end.

%% 排行榜初始化
init_coliseum_rank_from_db([]) -> ok;
init_coliseum_rank_from_db([H | T]) ->
    case get({coliseum_rank, H}) of
        undefined ->
            Data = data_coliseum:get(H),
            Num1 = limit_num(H),
            Num2 = util:get_val(num, Data, 0),
            List = init_coliseum_rank_from_db(Num1, Num2),
            put({coliseum_rank, H}, List),
            init_lev(List, H),
            init_coliseum_rank_from_db(T);
        _ ->
            init_coliseum_rank_from_db(T)
    end.

limit_num(Lev) ->
    limit_num(Lev - 1, 0).
limit_num(Lev, Rt) ->
    case Lev =< 0 of
        true -> Rt;
        false ->
            Data = data_coliseum:get(Lev),
            Num = util:get_val(num, Data, 0),
            limit_num(Lev - 1, Rt + Num)
    end.

%% 新版竞技场排行榜服务启动时初始化(coliseum)
init_coliseum_rank_from_db(Num1, Num2) ->
    Sql = list_to_binary([<<"SELECT `id`, `rid`, `name`, `picture`, `newexp`, `power` FROM `arena` "
            " ORDER BY `id` ASC LIMIT ">>,
            integer_to_list(Num1), <<", ">>, integer_to_list(Num2)]),
    case db:get_all(Sql) of
        {ok, Data} -> fix_coliseum_rank(Data);
        {error, null} -> [];
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            []
    end.

%% 新版竞技场排行榜初始化(coliseum)
get_coliseum_rank_from_db(NewLev, Num) ->
    Sql = list_to_binary([<<"SELECT `id`, `rid`, `name`, `picture`, `newexp`, `power` FROM `arena` WHERE `newlev` = ">>
            ,integer_to_list(NewLev), <<" ORDER BY `id` ASC LIMIT 0, ">>
            ,integer_to_list(Num)]),
    case db:get_all(Sql) of
        {ok, Data} -> fix_coliseum_rank(Data);
        {error, null} -> [];
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            []
    end.

%% 重启服务排行榜初始化
set_coliseum_rank_from_db([]) -> ok;
set_coliseum_rank_from_db([H | T]) ->
    case get({coliseum_rank, H}) of
        undefined ->
            Data = data_coliseum:get(H),
            Num = util:get_val(num, Data, 0),
            List = set_coliseum_rank_from_db(H, Num),
            put({coliseum_rank, H}, List),
            set_coliseum_rank_from_db(T);
        _ ->
            set_coliseum_rank_from_db(T)
    end.

set_coliseum_rank_from_db(H, Num) ->
    Sql = list_to_binary([<<"SELECT `id`, `rid`, `name`, `picture`, `newexp`, `power` FROM `arena` WHERE `newlev` = ">>
            ,integer_to_list(H), <<" ORDER BY `newexp` DESC LIMIT 0, ">>
            ,integer_to_list(Num)]),
    case db:get_all(Sql) of
        {ok, Data} -> fix_coliseum_rank(Data);
        {error, null} -> [];
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            []
    end.

%% 是否初始化过
check_init_rank_from_db() ->
    Sql = list_to_binary([<<"SELECT count(*) FROM `arena` WHERE `newlev` = 2">>]),
    case db:get_one(Sql) of
        {ok, 0} -> true;
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            false;
        {ok, _Num} -> false
    end.

%% 取最新等级
get_newlev_from_db(Id) ->
    Sql = list_to_binary([<<"SELECT `newlev` FROM `arena` WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:get_one(Sql) of
        {ok, Level} -> Level;
        {error, Reason} ->
            ?WARN("get newlev error:~w", [Reason]),
            0
    end.

%% 获取排行榜
get_coliseum_rank(Id) ->
    Ids = data_coliseum:get(ids),
    get_coliseum_rank(Ids, Id).
get_coliseum_rank([], _Id) -> {6, []};
get_coliseum_rank([H|T], Id) ->
    Rank = case get({coliseum_rank, H}) of
        undefined -> [];
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false ->
            get_coliseum_rank(T, Id);
        RR -> {H,RR}
    end.

%% 新版竞技场添加排名字段(coliseum)
fix_coliseum_rank(Data) ->
    fix_coliseum_rank(Data, 0, []).
fix_coliseum_rank([R|T], Key, Rs) ->
    Pos = Key + 1,
    [Id, Rid, Name, Picture, Exp, Power] = R,
    fix_coliseum_rank(T, Pos, [{Pos, Id, Rid, Name, Picture, Exp, Power}|Rs]);
fix_coliseum_rank([], _, Rs) ->
    lists:reverse(Rs).

%% 新版竞技场重置排名字段(coliseum)
fix_coliseum_rank2(Data) ->
    fix_coliseum_rank2(Data, 0, []).
fix_coliseum_rank2([R|T], Key, Rs) ->
    Pos = Key + 1,
    {_, Id, Rid, Name, Picture, Exp, Power} = R,
    fix_coliseum_rank2(T, Pos, [{Pos, Id, Rid, Name, Picture, Exp, Power}|Rs]);
fix_coliseum_rank2([], _, Rs) ->
    %% lists:reverse(Rs).
    lists:keysort(1, Rs).

%% 添加新成员到列表(注册就加入排行榜)
%% TODO:如果排行榜已满,不加入(pos=0),战斗时取代排行榜成员
set_coliseum_rank(List) ->
    Ids = data_coliseum:get(ids),
    set_coliseum_rank(Ids, List).
set_coliseum_rank([], List) ->
    Ids = data_coliseum:get(ids),
    R = length(Ids),
    RankList = get({coliseum_rank, R}),
    Index = length(RankList) + 1,
    [{A, B, C, D, E, F}] = List,
    put({coliseum_rank, R}, [{Index,A,B,C,D,E,F} | RankList]);
set_coliseum_rank([H | T], List) ->
    Data = data_coliseum:get(H),
    Num  = util:get_val(num, Data, 0),
    RankList = get({coliseum_rank, H}),
    case length(RankList) >= Num of
        true -> set_coliseum_rank(T, List);
        false ->
            Index = length(RankList) + 1,
            [{A, B, C, D, E, F}] = List,
            put({coliseum_rank, H}, [{Index,A,B,C,D,E,F} | RankList])
    end.

%% 战斗次数每天更新
coliseum_wars_reset(Rs) ->
    case Rs#role.coliseum of
        [] -> Rs;
        [Id, Lev, Exp, Pic, _Num, Report] ->
            Num2 = data_config:get(arenaBattleMax),
            Rs#role{coliseum = [Id, Lev, Exp, Pic, Num2, Report], arena_chance = 0};
        R -> ?WARN("coliseum_wars_reset error : ~w", [R]),
            Rs
    end.

%% 新版竞技场数据登录初始化(coliseum)
init_coliseum(Rs) ->
    Sql = list_to_binary([<<"SELECT `id`, `newlev`, `newexp`, `picture`,"
           " `warnum`, `newreport`, `ctime` FROM `arena` WHERE `robot` = 0 AND `rid` = ">>
           , integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Id, Lev, Exp, Pic, Num, Report, Ctime]} ->
            {Num1, Num2} = case Ctime < util:unixtime(today) of
                true ->
                    {data_config:get(arenaBattleMax), 0};
                false -> {Num, Rs#role.arena_chance}
            end,
            Report1 = unzip(Report),
            F = fun({A,B,C}) ->
                    case (util:unixtime() - C) < 86400 of
                        true -> {A,B,C};
                        false -> []
                    end
            end,
            Report2 = [F(L) || L <- Report1, F(L) =/= []],
            {ok, Rs#role{coliseum = [Id, Lev, Exp, Pic, Num1, Report2], arena_chance = Num2}};
        {error, null} -> {ok, Rs};
        {error, Reason} -> {error, Reason}
    end.

%% 数据存储
stores_coliseum(Rs) ->
    Coliseum = Rs#role.coliseum,
    Ctime = util:unixtime(),
    [Id, Lev, Exp, Pic, Num, Report] = Coliseum,
    Report2 = ?ESC_SINGLE_QUOTES(zip(Report)),
    Sql = list_to_binary([<<"UPDATE `arena` SET `newreport` = '">>
            ,Report2, <<"', `warnum` = ">>
            ,integer_to_list(Num), <<", `ctime` = ">>
            ,integer_to_list(Ctime), <<", `newlev` = ">>
            ,integer_to_list(Lev), <<", `picture` = ">>
            ,integer_to_list(Pic), <<", `newexp` = ">>
            ,integer_to_list(Exp), <<" WHERE `robot` = 0 AND `id` = ">>
            ,integer_to_list(Id)]),
    db:execute(Sql).

%% 缓存中获取战斗数据
get_data(Id) ->
    Key = {coliseum, Id},
    %% util:test1(),
    case cache:get(Key) of
        undefined ->
            %% util:test1(),
            Sql = <<"SELECT robot, rid, newlev, newexp, name, s "
            "FROM `arena` WHERE id = ~s">>,
            case db:get_row(Sql, [Id]) of
                {ok, [2, Rid, Lev, Exp, Name, S]} ->
                    Data = {2, Rid, Lev, Exp, Name, S},
                    cache:set(Key, Data),
                    Data;
                {ok, [1, Rid, Lev, Exp, Name, S]} ->
                    Data = {1, Rid, Lev, Exp, Name, binary_to_term(S)},
                    cache:set(Key, Data),
                    Data;
                {ok, [0, Rid, Lev, Exp, Name, S]} ->
                    Data = {0, Rid, Lev, Exp, Name, unzip_heroes(S)},
                    cache:set(Key, Data),
                    Data;
                {error, Reason} ->
                    {error, Reason}
            end;
        Data ->
            Data
    end.

%% 战斗后更新缓存数据
set_data(Rs, Lev, Exp, Heroes) ->
    Heroes1 = do_equ_grids(Heroes, Rs#role.items, []),
    gen_server:cast(cache, {coliseum_cache, Rs, Lev, Exp, Heroes1}).

do_equ_grids([Hero | Heroes], Items, Rt) ->
    EquGrids = id2tid(Hero#hero.equ_grids, Items),
    Hero1 = Hero#hero{equ_grids = EquGrids},
    do_equ_grids(Heroes, Items, [Hero1 | Rt]);
do_equ_grids([], _, Rt) ->
    Rt.

id2tid({Id1, Id2, Id3, Id4, Id5, Id6}, Items) ->
    {
        id2tid(Id1, Items),
        id2tid(Id2, Items),
        id2tid(Id3, Items),
        id2tid(Id4, Items),
        id2tid(Id5, Items),
        id2tid(Id6, Items)
    };
id2tid(0, _Items) -> 0;
id2tid(Id, Items) ->
    case mod_item:get_item(Id, Items) of
        false ->
            ?WARN("Error Equ Id: ~w", [Id]),
            0;
        #item{tid = Tid} ->
            Tid
    end.

zip_heroes(Heroes) ->
    zip_heroes(Heroes, []).

zip_heroes([H | Heroes], Rt) ->
    Bin = mod_hero:zip(H),
    Rt1 = [Bin | Rt],
    zip_heroes(Heroes, Rt1);
zip_heroes([], Rt) ->
    term_to_binary(Rt).

unzip_heroes(Bin) ->
    L = binary_to_term(Bin),
    unzip_heroes(L, []).

unzip_heroes([H | T], Rt) ->
    Hero = mod_hero:unzip([0, H]),
    Rt1 = [Hero | Rt],
    unzip_heroes(T, Rt1);
unzip_heroes([], Rt) -> Rt.

fix_coliseum_pos(Heroes) ->
    Heroes1 = [Hero || Hero <- Heroes, Hero#hero.pos > 0],
    Heroes2 = case Heroes1 =:= [] of
        true -> util:rand_element(4, Heroes);
        false -> Heroes1
    end,
    %% Poses = util:shuffle([11, 12, 13, 14, 15, 16, 17, 18, 19]),
    Poses = [11, 12, 13, 14, 15, 16, 17, 18, 19],
    fix_coliseum_pos1(Heroes2, Poses, []).

fix_coliseum_pos1([H = #hero{pos = Pos} | Heroes], [PosH | PosT], Rt) ->
    Pos1 = if
        Pos >= 11, Pos =< 19 ->
            case lists:member(Pos, [PosH | PosT]) of
                true -> Pos + 10;
                false ->
                    ?DEBUG("Auto Set Pos: ~w -> ~w", [Pos, PosH]),
                    PosH + 10
            end;
        Pos >= 21, Pos =< 29 ->
            Pos;
        true ->
            ?DEBUG("Auto Set Pos: ~w -> ~w", [Pos, PosH]),
            PosH + 10
    end,
    PosL = lists:delete(Pos1 - 10, [PosH | PosT]),
    Rt1 = [H#hero{pos = Pos1} | Rt],
    fix_coliseum_pos1(Heroes, PosL, Rt1);
fix_coliseum_pos1([], _, Rt) ->
    mod_battle:print_hero(Rt),
    Rt.

tuple2list(List) ->
    tuple2list(List, []).
tuple2list([H|T], Rt) ->
    {A,B,C,D,E,F,G} = H,
    tuple2list(T, [[A,B,C,D,E,F,G]|Rt]);
tuple2list([], Rt) -> Rt.

%% 刷新排行榜前给奖励(列表太大,分段写数据库)
%% TODO:给排行榜奖励时不更新排行榜中的荣誉值,荣誉值在下个版本中从排行榜中去掉
%% (index, id, rid, name, picture, exp, power)
change_exp2(_, []) -> ok;
change_exp2(L, List) ->
    F1 = fun(Index, Lev, Exp) ->
            if
                Lev == 1 -> util:ceil(Exp + 1400 - (6   * Index));
                Lev == 2 -> util:ceil(Exp + 900  - (3   * Index));
                Lev == 3 -> util:ceil(Exp + 500  - (1   * Index));
                Lev == 4 -> util:ceil(Exp + 300  - (0.2 * Index));
                Lev == 5 -> util:ceil(Exp + 200  - (0.1 * Index));
                true -> Exp + 100
            end
    end,
    F2 = fun(Id) ->
            IdL = integer_to_list(Id),
            ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$"))
    end,
    Data1 = [{A,B,C,D,E,F1(A,L,F),G} || {A,B,C,D,E,F,G} <- List, F2(C) =/= D],
    Data2 = [{A,B,C,D,E,F,G} || {A,B,C,D,E,F,G} <- List, F2(C) == D],
    {Data1, Data2}.
change_exp3(List) ->
    spawn(fun() -> change_exp4(List) end).
change_exp4([]) -> ok;
change_exp4([{_,Id,Rid,_,_,Exp,_}|Rt]) ->
    Sql = list_to_binary([<<"UPDATE `arena` SET `newexp` = ">>
            ,integer_to_list(Exp), <<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, _} ->
            io:format(".", []),
            %% myevent:send_event(Rid, {change_exp, Exp}),
            change_exp6(Rid, Exp),
            timer:sleep(100),
            change_exp4(Rt);
        {error, Reason} ->
            timer:sleep(10000),
            ?WARN("coliseum change exp error:~w, id:~w, Rid:~w, Exp:~w", [Reason, Id, Rid, Exp]),
            change_exp4(Rt)
    end.
change_exp6(Rid, NewExp) ->
    case lib_role:get_role_pid_from_ets(role_id, Rid) of
        false -> ok;
        {offline, Pid} ->
            Pid ! {pt, 2060, [NewExp]};
        {online, Pid} ->
            Pid ! {pt, 2060, [NewExp]}
    end,
    ok.


change_lev4(List, Lev) ->
    spawn(fun() -> change_lev5(List, Lev) end).
change_lev5([], _Lev) -> ok;
change_lev5([{_,Id,Rid,Name,_,_,_}|T], Lev) ->
    change_lev5(Id, Rid, Name, Lev),
    change_lev5(T, Lev).
change_lev5(Id, Rid, Name, Lev) ->
    %% List1 = string:join(List, ","),
    %% Sql = list_to_binary([<<"UPDATE `arena` SET `newlev` = ">>
    %%         ,integer_to_list(Lev), <<" WHERE `id` in (">>
    %%         ,List1, <<")">>]),
    Sql = list_to_binary([<<"UPDATE `arena` SET `newlev` = ">>
            ,integer_to_list(Lev), <<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, _} ->
            F1 = fun(I) ->
                    IdL = integer_to_list(I),
                    ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$"))
            end,
            case F1(Id) == Name of
                true -> ok;
                false ->
                    change_lev6(Rid, Lev)
            end,
            io:format(".", []),
            timer:sleep(20),
            ok;
        {error, Reason} ->
            timer:sleep(1000),
            ?WARN("coliseum change lev error:~w,Id:~w, Rid:~w, Lev:~w", [Reason, Id, Rid, Lev]),
            ok
    end.
change_lev6(Rid, Lev) ->
    case lib_role:get_role_pid_from_ets(role_id, Rid) of
        false -> ok;
        {offline, Pid} ->
            Pid ! {pt, 2059, [Lev]};
        {online, Pid} ->
            Pid ! {pt, 2059, [Lev]}
    end,
    ok.
    %% myevent:send_event(Rid, {change_level, Lev}),

init_lev(List, Lev) ->
    spawn(fun() -> init_lev1(List, Lev) end).
init_lev1([], _Lev) -> ok;
init_lev1(List, Lev) ->
    Data = [Id || {_,Id,_,_,_,_,_} <- List],
    init_lev2(Data, Lev).
init_lev2([], _Lev) -> ok;
init_lev2([Id|T], Lev) ->
    Sql = list_to_binary([<<"UPDATE `arena` SET `newlev` = ">>
            ,integer_to_list(Lev), <<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, _} ->
            timer:sleep(100),
            init_lev2(T, Lev);
        {error, Reason} ->
            timer:sleep(10000),
            ?WARN("coliseum change lev error:~w, Id:~w", [Reason, Id]),
            ok
    end.

%% 刷新服务后重置在线用户段位
change_newlev(Rs) ->
    #role{coliseum = Coliseum} = Rs,
    case Coliseum == [] of
        true -> Rs;
        false ->
            [Id, Lev, Exp, Pic, Num, Report] = Coliseum,
            Sql = list_to_binary([<<"SELECT `newlev` FROM `arena` WHERE `id` = ">>
                    ,integer_to_list(Id)]),
            Lev2 = case db:get_one(Sql) of
                {ok, NewLev} -> NewLev;
                _ -> Lev
            end,
            self() ! {pt, 2059, []},
            Rs#role{coliseum = [Id, Lev2, Exp, Pic, Num, Report]}
    end.

change_lev3(Id, Lev) ->
    Sql = list_to_binary([<<"UPDATE `arena` SET `newlev` = ">>
            ,integer_to_list(Lev), <<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok, _} -> ok;
        {error, Reason} ->
            ?WARN("coliseum change lev error:~w", [Reason]),
            ok
    end.

%% 排行榜显示筛选规则
show_rule(List, Lev, Pos) ->
    show_rule(List, Lev, Pos, 20).
show_rule(List, Lev, Pos, Count) ->
    ?DEBUG("Lev:~w, Pos:~w", [Lev, Pos]),
    List1 = lists:keysort(1, List),
    {A, B} = case Pos == 0 of
        true -> {List1,[]};
        false -> lists:split(Pos, List1)
    end,
    case Pos =< Count orelse length(List1) =< Count of
        true -> lists:sublist(List1, Count);
        false ->
            Data = data_coliseum:get(Lev),
            Show = util:get_val(show, Data, 0),
            {C, _D} = lists:split(10, A),
            List2 = show_rule1(A, Pos, Show),
            case length(C ++ List2) < Count of
                true ->
                    List3 = show_rule2(B, Pos, Show),
                    util:del_repeat_element(C ++ List2 ++ List3);
                false ->
                    List4 = lists:reverse(lists:keysort(1, List2)),
                    List5 = lists:sublist(List4, Count - 10),
                    util:del_repeat_element(C ++ List5)
            end
    end.
show_rule1(List, Pos, Show) ->
    show_rule1(List, Pos, Show, []).
show_rule1([], _Pos, _Show, Rt) -> Rt;
show_rule1([H|T], Pos, Show, Rt) ->
    {Index,_,_,_,_,_,_} = H,
    N = (Pos - Index) rem Show,
    case N == 0 of
        true ->
            show_rule1(T, Pos, Show, [H | Rt]);
        false ->
            show_rule1(T, Pos, Show, Rt)
    end.
show_rule2(List, Pos, Show) ->
    show_rule2(List, Pos, Show, []).
show_rule2([], _Pos, _Show, Rt) -> Rt;
show_rule2([H|T], Pos, Show, Rt) ->
    {Index,_,_,_,_,_,_} = H,
    N = (Index - Pos) rem Show,
    case N == 0 of
        true ->
            show_rule2(T, Pos, Show, [H | Rt]);
        false ->
            show_rule2(T, Pos, Show, Rt)
    end.

%% 判断是否可以挑战
is_combat(List, Pos, Show) ->
    N = case length(List) >= Pos of
        true -> Pos - 1;
        false -> 0
    end,
    N22 = case N < 0 of
        true -> 0;
        false -> N
    end,
    List11 = lists:sort(List),
    {List1, _List2} = lists:split(N22, List11),
    is_combat(List1, Pos, Show, []).
is_combat([], _Pos, _Show, Rt) ->
    Rt1 = lists:reverse(lists:sort(Rt)),
    lists:sublist(Rt1, 10);
is_combat([H|T], Pos, Show, Rt) ->
    {Index,_,_,_,_,_,_} = H,
    N2 = abs(Pos - Index) rem Show,
    case N2 == 0 of
        true ->
            is_combat(T, Pos, Show, [H | Rt]);
        false ->
            is_combat(T, Pos, Show, Rt)
    end.

%% 用户注册时获取初始化等级
get_level([]) -> 6;
get_level([H|T]) ->
    Data = data_coliseum:get(H),
    Num  = util:get_val(num, Data, 0),
    RankList = get({coliseum_rank, H}),
    case length(RankList) >= Num of
        true -> get_level(T);
        false -> H
    end.

%% 用户注册时获取初始化等级
get_level2(Id) ->
    Ids = data_coliseum:get(ids),
    get_level2(Ids, Id).
get_level2([], _Id) -> 6;
get_level2([H|T], Id) ->
    List = get({coliseum_rank, H}),
    case lists:keymember(Id, 2, List) of
        true -> H;
        false ->
            get_level2(T, Id)
    end.

%%' 新的机器人数据(1500)
export_robot() ->
    Sql = list_to_binary([<<"SELECT `rid`, `s` FROM `robot` WHERE `robot` = 0 ">>]),
    case db:get_all(Sql) of
        {ok, List} ->
            import_robot(List);
        {error, _} -> ok
    end.

export_robot_test1() ->
    Sql = list_to_binary([<<"SELECT `rid`, `s` FROM `robot` WHERE `robot` = 0 AND `id` = 856">>]),
    case db:get_all(Sql) of
        {ok, L} ->
            import_robot(L);
        {error, _} -> ok
    end.

export_robot_test2() ->
    Sql = list_to_binary([<<"SELECT `s` FROM `robot` WHERE `robot` = 0 AND `id` = 856">>]),
    case db:get_one(Sql) of
        {ok, S} ->
            SS = unzip_heroes(S),
            ?INFO("==SS:~w", [SS]),
            ok;
        {error, _} -> ok
    end.

import_robot([]) -> ok;
import_robot([[Rid, H] | T]) ->
    Hero = unzip_heroes(H),
    robot_hero(Hero, Rid),
    import_robot(T).

%% 机器人英雄
robot_hero(Hero, Rid) ->
    robot_hero(Hero, Rid, 1).
robot_hero([], _Rid, _Id) -> ok;
robot_hero([Hero | T], Rid, Id) ->
    #hero{
        %% id  = Id
        tid       = Tid
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
        ,pos       = Pos
        ,exp       = Exp
        ,lev       = Lev
        ,quality   = Quality
        ,equ_grids = {_Pos1, _Pos2, _Pos3, _Pos4, _Pos5, _Pos6}
    } = Hero,
    Data = [Rid, Id ,Tid ,Pos ,Quality ,Lev ,Exp ,Hp ,Atk ,Def ,Pun ,Hit ,Dod ,Crit ,CritNum ,CritAnit ,Tou],
    Sql = list_to_binary([<<"INSERT `robot_hero` "
            "(`rid`, `hid`, `hero_id`, `seat`, `quality`,"
            "`level`, `exp`, `hp`, `attack`, "
            "`defend`, `puncture`, `hit`, `dodge`,"
            "`crit`, `critPercentage`, `anitCrit`, `toughness`) "
            "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)">>]),
    db:execute(Sql, Data),
    robot_hero(T, Rid, Id + 1).
%%.

%%' 战斗初始化机器人英雄
init_new_robot(Id) ->
    Data = case data_robot_new:get(Id) of
        undefined -> [];
        R -> R
    end,
    init_new_robot(Data, []).
init_new_robot([], Rt) -> Rt;
init_new_robot([H | T], Rt) ->
    {Id
    ,Tid
    ,Pos
    ,Quality
    ,Lev
    ,Exp
    ,Hp
    ,Atk
    ,Def
    ,Pun
    ,Hit
    ,Dod
    ,Crit
    ,CritNum
    ,CritAnit
    ,Tou} = H,
    Data = data_hero:get(Tid),
    Job  = util:get_val(job, Data),
    Hero = #hero{
        id         = Id
        ,tid       = Tid
        ,job       = Job
        ,pos       = Pos
        ,quality   = Quality
        ,lev       = Lev
        ,exp       = Exp
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
        ,skills    = lib_role:init_skills(Data)
    },
    init_new_robot(T, [Hero | Rt]).

import_role_robot([], _NewLevL) -> ok;
import_role_robot([H | T], NewLevL) ->
    Heroes  = init_new_robot(H),
    PowerL  = mod_hero:calc_power(Heroes),
    Data    = data_robot_new2:get(H),
    PicL    = util:get_val(picture, Data, 1),
    NewLev  = integer_to_list(NewLevL),
    Power   = integer_to_list(PowerL),
    Picture = integer_to_list(PicL),
    IdL     = integer_to_list(H),
    Name    = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
    Sql = list_to_binary([<<"INSERT `arena` (`robot`, `rid`, `lev`, "
            "`exp`, `newlev`, `newexp`, `warnum`, "
            "`power`, `picture`, `name`) "
            "VALUES (2, ">>, IdL,<<", 1, 0, ">>
            ,NewLev, <<", 0, 0, ">>, Power,<<",">>
            ,Picture, <<", '">>, Name,<<"')">>]),
    case db:execute(Sql) of
        {ok, _} ->
            io:format(".", []),
            import_role_robot(T, NewLevL);
        {error, Reason} ->
            ?WARN("import_role_robot error:~w", [Reason]),
            ok
            %% import_role_robot(T, NewLevL)
    end.

%% 新机器人数据导入(开服执行,执行后重启服务为了初始化coliseum rank)
import_new_robot() ->
    Ids = data_coliseum:get(ids),
    RobotIds = data_robot_new:get(ids),
    import_new_robot(Ids, RobotIds).
import_new_robot([], _RL) -> ok;
import_new_robot([H|T], RL) ->
    Data = data_coliseum:get(H),
    Num  = util:get_val(num, Data, 0),
    Sql = list_to_binary([<<"SELECT count(*) FROM `arena` WHERE `newlev` = ">>
            ,integer_to_list(H)]),
    case T == [] of
        true -> import_role_robot(RL, H);
        false ->
            case db:get_one(Sql) of
                {ok, N} ->
                    case Num > N of
                        true ->
                            S = Num - N,
                            {RL1, RL2} = lists:split(S, RL),
                            import_role_robot(RL1, H),
                            import_new_robot(T, RL2);
                        false ->
                            import_new_robot(T, RL)
                    end;
                {error, Reason} ->
                    ?WARN("import_new_robot error:~w", [Reason]),
                    ok
            end
    end.

%%.

%% zip / unzip
%% 解包#role.coliseum,战报信息
unzip(<<>>) -> [];
unzip(undefined) -> [];
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip1(Bin1, []);
        2 ->
            unzip2(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
unzip1(<<X1:32, X2_:16, X2:X2_/binary, RestBin/binary>>, Rt) ->
    Rt1 = [{X1, X2, 0} | Rt],
    unzip1(RestBin, Rt1);
unzip1(<<>>, Rt) -> Rt.
unzip2(<<X1:32, X2_:16, X2:X2_/binary, X3:32, RestBin/binary>>, Rt) ->
    Rt1 = [{X1, X2, X3} | Rt],
    unzip2(RestBin, Rt1);
unzip2(<<>>, Rt) -> Rt.

%% 打包成binary
-define(COLISEUM_ZIP_VERSION, 2).
zip([]) -> <<>>;
zip(L) ->
    F = fun({Id, Name, Time}) ->
            Name1 = byte_size(Name),
            <<Id:32, Name1:16, Name:Name1/binary, Time:32>>
    end,
    Bin = list_to_binary([F({A, B, C}) || {A, B, C}<- L]),
    <<?COLISEUM_ZIP_VERSION:8, Bin/binary>>.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
