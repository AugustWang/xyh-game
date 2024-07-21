%% ------------------------------------------------------------------
%% $Id: mod_colosseum.erl 12953 2014-05-22 09:32:28Z piaohua $
%% @doc 新版竞技场
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_colosseum).
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
        ,init_coliseum/1
        ,stores_coliseum/1
        ,get_data/1
        ,set_data/4
        ,zip_heroes/1
        ,unzip_heroes/1
        ,fix_coliseum_pos/1
        ,coliseum_wars_reset/1
        ,get_rank_pos/1
        ,get_rank/1
        ,stop_coliseum/0
        ,export_robot/0
        ,export_robot_test1/0
        ,export_robot_test2/0
        ,init_new_robot/1
        ,import_new_robot/0
        ,update_robot_power/0
        ,update_oldrobot_power/0
        ,test/0
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
%% colosseum = 改版竞技场

-record(state, {
    }).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    State = #state{},
    self() ! init_coliseum_rank, %% (index,id,rid,name,picture,power)
    {ok, State}.

%% 获取排名(默认返回最低)
handle_call({get_rank_pos, Id}, _From, State) ->
    RankList = get(coliseum_rank),
    Index = case lists:keyfind(Id, 2, RankList) of
        false -> 0;
        {Index1, Id, _,_,_,_} ->
            Index1
    end,
    {reply, Index, State};

%% 获取竞技场排行榜(coliseum)(test use)
handle_call({get_coliseum_rank, Id}, _From, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    Pos = case lists:keyfind(Id, 2, Rank) of
        false -> 0;
        {A,_,_,_,_,_} -> A
    end,
    NewLev = get_new_level(Pos),
    List1 = show_rule(Rank, NewLev, Pos),
    List2 = tuple2list(List1),
    List3 = lists:sort(List2),
    {reply, List3, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 新竞技场新用户加入列表(coliseum)
handle_cast({set_coliseum_rank,Pid,Id,Rid,Name,Pic,Power}, State) ->
    Ids = data_coliseum:get(ids),
    F = fun(X) ->
            Data = data_coliseum:get(X),
            util:get_val(num, Data, 0)
    end,
    Num = lists:sum([F(N)||N<-Ids]),
    RankList = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    Index = length(RankList) + 1,
    NewLev = get_new_level(Index),
    Pid ! {pt, 2059, [NewLev]},
    case Index < Num of
        true ->
            put(coliseum_rank, [{Index,Id,Rid,Name,Pic,Power}|RankList]);
        false -> ok
    end,
    {noreply, State};

%% 战斗结束对换排名(Id1=对方, Id2=自己)
%% 如果玩家不是排行榜成员,就替换已有成员
%% 更换名次时给钻石奖励
handle_cast({change_rank_pos,Pid,Id1,RankInfo}, State) ->
    {Id2,Rid,Name,Pic,Combat,HighR} = RankInfo,
    RankList = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    L1 = case lists:keyfind(Id1, 2, RankList) of
        false -> [];
        R1 -> R1
    end,
    L2 = case lists:keyfind(Id2, 2, RankList) of
        false -> [];
        R2 -> R2
    end,
    case L1 == [] of
        true -> ok;
        false ->
            case L2 == [] of
                true ->
                    {Pos1,Id1,_,_,_,_} = L1,
                    List1 = {Pos1,Id2,Rid,Name,Pic,Combat},
                    List2 = lists:keyreplace(Id1, 2, RankList, List1),
                    Diamond = add_diamond(Pos1, HighR),
                    ?DEBUG("Diamond:~w,Pos1:~w,HighR:~w",[Diamond,Pos1,HighR]),
                    Pid ! {pt, 2061, [Diamond,Pos1]},
                    put(coliseum_rank, List2);
                false ->
                    {Pos1,Id1,Rid1,Name1,Picture1,Power1} = L1,
                    {Pos2,Id2,Rid2,Name2,Picture2,_Power2} = L2,
                    if
                        Pos1 < Pos2 ->
                            L3 = {Pos2,Id1,Rid1,Name1,Picture1,Power1},
                            L4 = {Pos1,Id2,Rid2,Name2,Picture2,Combat},
                            List1 = lists:keyreplace(Id1, 2, RankList, L3),
                            List2 = lists:keyreplace(Id2, 2, List1, L4),
                            Diamond = add_diamond(Pos1, HighR),
                            ?DEBUG("Diamond:~w,Pos1:~w,HighR:~w",[Diamond,Pos1,HighR]),
                            Pid ! {pt, 2061, [Diamond,Pos1]},
                            put(coliseum_rank, List2);
                        true -> %% ok
                            L22 = {Pos2,Id2,Rid2,Name2,Picture2,Combat},
                            List2 = lists:keyreplace(Id2,2,RankList,L22),
                            put(coliseum_rank,List2)
                    end
            end
    end,
    {noreply, State};

%% 更新战斗力
handle_cast({change_rank_power,Id,Power},State) ->
    RankList = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    case lists:keyfind(Id, 2, RankList) of
        false -> ok;
        {Pos,Id,Rid,Name,Picture,_Combat} ->
            L1 = {Pos,Id,Rid,Name,Picture,Power},
            List1 = lists:keyreplace(Id,2,RankList,L1),
            put(coliseum_rank,List1),
            ok
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?WARN("undefined msg:~w", [Msg]),
    {noreply, State}.

%% 新竞技场排行榜初始化(coliseum),唯一id战斗,rid查看英雄之家
%% (index, id, rid, name, picture, power)
handle_info(init_coliseum_rank, State) ->
    Ids = data_coliseum:get(ids),
    case check_init_rank_from_db() of
        true ->
            init_coliseum_rank(Ids);
        false ->
            List = init_coliseum_rank(),
            List2 = list2tuple(List),
            List3 = lists:keysort(1,List2),
            List4 = fix_coliseum_rank2(List3),
            put(coliseum_rank, List4)
    end,
    {noreply, State};

%% 新版竞技场排行榜更新(coliseum)
handle_info(update_coliseum_rank, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    %% lib_admin:android_server_active(Rank),
    lib_admin:colosseum_rank_prize(Rank),
    List = lists:keysort(1, Rank),
    Ids2 = data_coliseum:get(ids),
    List1 = update_coliseum_rank_refresh(Ids2, List, 0),
    _List2 = fix_coliseum_rank2(List1),
    %% put(coliseum_rank, List2),
    lib_admin:send_notice(),
    {noreply, State};

%% 获取竞技场排行榜(coliseum)
%% 如果用户不在排行榜内(pos=0),要加上自己
handle_info({get_coliseum_rank,Pid,Sender,Id,Exp,Wars,Chances,Time,MyRank}, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    Pos = case lists:keyfind(Id, 2, Rank) of
        false -> 0;
        {A,_,_,_,_,_} -> A
    end,
    NewLev = get_new_level(Pos),
    Pid ! {pt, 2059, [NewLev]},
    List1 = show_rule(Rank, NewLev, Pos),
    List2 = tuple2list(List1),
    {NewPos,List3} = case Pos == 0 of
        true ->
            [MyId,MyRid,MyName,MyPic,MyCombat] = MyRank,
            MyPos = length(Rank) + 1,
            MyRank1 = [MyPos,MyId,MyRid,MyName,MyPic,MyCombat],
            {MyPos,[MyRank1 | List2]};
        false -> {Pos,List2}
    end,
    List4 = lists:sort(List3),
    sender:pack_send(Sender, 33037, [NewPos,Exp,NewLev,Wars,Chances,Time,List4]),
    {noreply, State};

%% update role record level
handle_info({get_coliseum_level,Pid,Id}, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    Pos = case lists:keyfind(Id, 2, Rank) of
        false -> 0;
        {A,_,_,_,_,_} -> A
    end,
    NewLev = get_new_level(Pos),
    Pid ! {pt, 2059, [NewLev]},
    {noreply, State};

%% 判断是否可以挑战(id1=对方,id2=自己)
handle_info({is_combat,Id1,Id2,PidSender,Type,Index,Pid}, State) ->
    List = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    Pos1 = case lists:keyfind(Id1, 2, List) of
        false -> 0;
        {A,_,_,_,_,_} -> A
    end,
    Pos2 = case lists:keyfind(Id2, 2, List) of
        false -> 0;
        {B,_,_,_,_,_} -> B
    end,
    NewLev = get_new_level(Pos1),
    Pid ! {pt, 2059, [NewLev]},
    Data = data_coliseum:get(NewLev),
    Show = util:get_val(show, Data, 0),
    List2 = is_combat(List, Pos2, Show),
    F = fun({A,_B,_C,_D,_E,_F}) -> A =< 10 end,
    IsCombat = case List2 == [] of
       true -> true;
       false ->
           lists:any(F, List2)
   end,
   if
       Pos1 == 0 andalso Pos2 == 0 ->
           sender:pack_send(PidSender, 33025, [129, 0, []]);
       Pos1 =/= Index ->
           sender:pack_send(PidSender, 33025, [6, 0, []]);
       %% Pos2 < Pos1 andalso Pos2 =/= 0 ->
       %%     sender:pack_send(PidSender, 33025, [4, 0, []]);
       IsCombat == false andalso Pos1 =< 10 ->
           sender:pack_send(PidSender, 33025, [5, 0, []]);
       true ->
           Pid ! {pt, 2068, [Id1, Type]}
   end,
    {noreply, State};

%% 更新排行榜头像
handle_info({set_rank_picture,Id,Picture}, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false -> ok;
        {Pos1,Id1,Rid1,Name1,_Picture1,Power1} ->
            L = {Pos1,Id1,Rid1,Name1,Picture,Power1},
            Rank2 = lists:keyreplace(Id1,2,Rank,L),
            put(coliseum_rank, Rank2)
    end,
    {noreply, State};

%% add exp prize
handle_info({add_exp, Pid, Id}, State) ->
    Rank = case get(coliseum_rank) of
        undefined ->
            Ids = data_coliseum:get(ids),
            init_coliseum_rank(Ids),
            get(coliseum_rank);
        R -> R
    end,
    case lists:keyfind(Id, 2, Rank) of
        false -> ok;
        {Pos,Id,_Rid,_Name,_Picture,_Power} ->
            NewLev = get_new_level(Pos),
            %% F1 = fun(Index, Lev) ->
            %%         if
            %%             Lev == 1 -> util:ceil(1400 - (6   * Index));
            %%             Lev == 2 -> util:ceil(900  - (3   * Index));
            %%             Lev == 3 -> util:ceil(500  - (1   * Index));
            %%             Lev == 4 -> util:ceil(300  - (0.2 * Index));
            %%             Lev == 5 -> util:ceil(200  - (0.1 * Index));
            %%             true -> 100
            %%         end
            %% end,
            %% Num = F1(Pos, NewLev),
            Data = data_coliseum:get(NewLev),
            Num = util:get_val(exp,Data,0),
            Pid ! {pt, 2060, [Num]},
            ok
    end,
    {noreply, State};

%% stores rank index
handle_info(stop_coliseum_store, State) ->
    Rank = case get(coliseum_rank) of
        undefined -> [];
        R -> R
    end,
    spawn(fun() -> stop_coliseum_store(Rank) end),
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
update_rank() ->
    ?SERVER ! update_coliseum_rank.

%% 获取排名
get_rank_pos(Id) ->
    gen_server:call(?SERVER, {get_rank_pos, Id}).

%% 获取排行榜(test use)
get_rank(Id) ->
    gen_server:call(?SERVER, {get_coliseum_rank, Id}).

%% 关闭服务保存排行榜
stop_coliseum() ->
    ?SERVER ! stop_coliseum_store.

%% 新版排行榜更新规则
update_coliseum_rank_refresh([], List, _S) -> List;
update_coliseum_rank_refresh([H|T], List, S) ->
    Data = data_coliseum:get(H),
    Num  = util:get_val(num, Data, 0),
    Down = util:get_val(down, Data, 0),
    {N1,N2} = case Down > 0 of
        true -> {S + Num - Down, Down};
        false -> {0,0}
    end,
    %% ?DEBUG("Listlenght:~w,Num:~w,Down:~w,N1:~w,N2:~w",[length(List),Num,Down,N1,N2]),
    Num2 = case Num < length(List) of
        true -> Num;
        false -> length(List)
    end,
    {A,B} = lists:split(Num2, List),
    N11 = case N1 < length(A) of
        true -> N1;
        false -> length(A)
    end,
    N22 = case N2 < length(B) of
        true -> N2;
        false -> length(B)
    end,
    %% ?DEBUG("lengthA:~w,lengthB:~w", [length(A),length(B)]),
    {C,D} = lists:split(N11, A),
    {E,F} = lists:split(N22, B),
    List1 = C ++ E ++ D ++ F,
    %% update_notice(E ++ D),
    update_coliseum_rank_refresh(T, List1, S + Num).

%% update_notice([]) -> ok;
%% update_notice([{_A,_B,C,D,_E,_F}|Rest]) ->
%%     CL = integer_to_list(C),
%%     Name = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ CL ++ ".$")),
%%     case Name == D of
%%         true -> update_notice(Rest);
%%         false ->
%%             lib_admin:send_newlev(C),
%%             update_notice(Rest)
%%     end.

%% 是否初始化过
check_init_rank_from_db() ->
    Sql = list_to_binary([<<"SELECT count(*) FROM `arena` WHERE `robot` = 0 AND `index` <> 0">>]),
    case db:get_one(Sql) of
        {ok, 0} -> true;
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            false;
        {ok, _Num} -> false
    end.

%% 排行榜初始化
init_coliseum_rank(List) ->
    init_coliseum_rank(List, []).
init_coliseum_rank([], Rt) ->
    Rt1 = lists:reverse(Rt),
    %% ?INFO("==Rt1:~W",[Rt1, 999]),
    Rt2 = fix_coliseum_rank(Rt1),
    put(coliseum_rank, Rt2);
init_coliseum_rank([H | T], Rt) ->
    Data = data_coliseum:get(H),
    Num1 = limit_num(H),
    Num2 = util:get_val(num, Data, 0),
    List = init_coliseum_rank_from_db(Num1, Num2),
    List1 = lists:reverse(List),
    init_coliseum_rank(T, List1 ++ Rt).

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
    Sql = list_to_binary([<<"SELECT `id`, `rid`, `name`, `picture`, `power` FROM `arena` "
            " WHERE `robot` = 0 ORDER BY `newexp` DESC LIMIT ">>,
            integer_to_list(Num1), <<", ">>, integer_to_list(Num2)]),
    case db:get_all(Sql) of
        {ok, Data} -> Data;
        {error, null} -> [];
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            []
    end.

%% 重启服务排行榜初始化
init_coliseum_rank() ->
    Sql = list_to_binary([<<"SELECT `index`, `id`, `rid`, `name`, `picture`, `power` FROM `arena` WHERE `robot` = 0 AND `index` <> 0 ORDER BY `index` ASC">>]),
    case db:get_all(Sql) of
        {ok, Data} -> Data;
        {error, null} -> [];
        {error, Reason} ->
            ?WARN("init coliseum rank error:~w", [Reason]),
            []
    end.

%% 关闭服务保存数据
stop_coliseum_store(Rank) ->
    Sql = list_to_binary([<<"UPDATE `arena` SET `index` = 0 ">>]),
    case db:execute(Sql) of
        {ok, _N} ->
            stop_coliseum_store1(Rank),
            ok;
        {error, Reason} ->
            ?WARN("stop rank store error:~w", [Reason]),
            ok
    end.

stop_coliseum_store1([]) -> ok;
stop_coliseum_store1([{Pos,Id,_,_,_,_}|Rest]) ->
    Sql = list_to_binary([<<"UPDATE `arena` SET `index` = ">>
            ,integer_to_list(Pos),<<" WHERE `id` = ">>
            ,integer_to_list(Id)]),
    case db:execute(Sql) of
        {ok,_} ->
            io:format(".", []),
            %% timer:sleep(100),
            stop_coliseum_store1(Rest);
        {error, Reason} ->
            ?WARN("stop rank store Id:(~w) error:~w", [Id, Reason]),
            stop_coliseum_store1(Rest)
    end.

%% 新版竞技场添加排名字段(coliseum)
fix_coliseum_rank(Data) ->
    fix_coliseum_rank(Data, 0, []).
fix_coliseum_rank([R|T], Key, Rs) ->
    Pos = Key + 1,
    [Id,Rid,Name,Pic,Power] = R,
    fix_coliseum_rank(T, Pos, [{Pos,Id,Rid,Name,Pic,Power}|Rs]);
fix_coliseum_rank([], _, Rs) ->
    lists:reverse(Rs).

%% 新版竞技场重置排名字段(coliseum)
fix_coliseum_rank2(Data) ->
    fix_coliseum_rank2(Data, 0, []).
fix_coliseum_rank2([R|T], Key, Rs) ->
    Pos = Key + 1,
    {_,Id,Rid,Name,Pic,Power} = R,
    fix_coliseum_rank2(T, Pos, [{Pos,Id,Rid,Name,Pic,Power}|Rs]);
fix_coliseum_rank2([], _, Rs) ->
    lists:keysort(1, Rs).

%% 战斗次数每天更新
coliseum_wars_reset(Rs) ->
    case Rs#role.coliseum of
        [] -> Rs;
        [Id,Lev,Exp,Pic,_Num,HighR,PrizeT,Report] ->
            Num2 = data_config:get(arenaBattleMax),
            Rs#role{coliseum = [Id,Lev,Exp,Pic,Num2,HighR,PrizeT,Report], arena_chance = 0};
        R -> ?WARN("coliseum_wars_reset error : ~w", [R]),
            Rs
    end.

%% 新版竞技场数据登录初始化(coliseum)
init_coliseum(Rs) ->
    Sql = list_to_binary([<<"SELECT `id`, `newlev`, `newexp`, `picture`,"
            " `warnum`, `highrank`, `prizetime`, `newreport`, `ctime` "
            " FROM `arena` WHERE `robot` = 0 AND `rid` = ">>
           , integer_to_list(Rs#role.id)]),
    case db:get_row(Sql) of
        {ok, [Id,Lev,Exp,Pic,Num,HighR,PrizeT,Report,Ctime]} ->
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
            {ok, Rs#role{coliseum = [Id,Lev,Exp,Pic,Num1,HighR,PrizeT,Report2], arena_chance = Num2}};
        {error, null} -> {ok, Rs};
        {error, Reason} -> {error, Reason}
    end.

%% 数据存储
stores_coliseum(Rs) ->
    Coliseum = Rs#role.coliseum,
    Ctime = util:unixtime(),
    [Id,Lev,Exp,Pic,Num,HighR,PrizeT,Report] = Coliseum,
    Report2 = ?ESC_SINGLE_QUOTES(zip(Report)),
    Sql = list_to_binary([<<"UPDATE `arena` SET `newreport` = '">>
            ,Report2, <<"', `warnum` = ">>
            ,integer_to_list(Num), <<", `ctime` = ">>
            ,integer_to_list(Ctime), <<", `newlev` = ">>
            ,integer_to_list(Lev), <<", `picture` = ">>
            ,integer_to_list(Pic), <<", `newexp` = ">>
            ,integer_to_list(Exp), <<", `highrank` = ">>
            ,integer_to_list(HighR), <<", `prizetime` = ">>
            ,integer_to_list(PrizeT), <<" WHERE `robot` = 0 AND `id` = ">>
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
    {A,B,C,D,E,F} = H,
    tuple2list(T, [[A,B,C,D,E,F]|Rt]);
tuple2list([], Rt) -> Rt.

list2tuple(List) ->
    list2tuple(List, []).
list2tuple([H|T], Rt) ->
    [A,B,C,D,E,F] = H,
    list2tuple(T, [{A,B,C,D,E,F}|Rt]);
list2tuple([], Rt) -> Rt.

%% 排行榜显示筛选规则
show_rule(List, Lev, Pos) ->
    show_rule(List, Lev, Pos, 20).
show_rule(List, Lev, Pos, Count) ->
    ?DEBUG("Lev:~w, Pos:~w", [Lev, Pos]),
    List1 = lists:keysort(1, List),
    Data = data_coliseum:get(Lev),
    Show = util:get_val(show, Data, 0),
    NewPos = case Pos == 0 of
        true -> length(List1);
        false -> Pos
    end,
    {A, _B} = lists:split(NewPos, List1),
    case Pos =< Count andalso Pos =/= 0 orelse length(List1) =< Count of
        true -> lists:sublist(List1, Count);
        false ->
            {C, D} = lists:split(10, A),
            List2 = show_rule1(D, NewPos, Show, Count - 10),
            List3 = lists:keysort(1, C ++ List2),
            util:del_repeat_element(List3)
    end.
show_rule1(List, Pos, Show, Num) ->
    List1 = lists:reverse(List),
    show_rule1(List1, Pos, Show, Num, []).
show_rule1([], _Pos, _Show, _Num, Rt) -> Rt;
show_rule1([H|T], Pos, Show, Num, Rt) ->
    {Index,_,_,_,_,_} = H,
    N = (Pos - Index) rem Show,
    case Num =< 0 of
        true -> Rt;
        false ->
            case N == 0 of
                true ->
                    show_rule1(T, Pos, Show, Num - 1, [H | Rt]);
                false ->
                    show_rule1(T, Pos, Show, Num, Rt)
            end
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
    {Index,_,_,_,_,_} = H,
    N2 = abs(Pos - Index) rem Show,
    case N2 == 0 of
        true ->
            is_combat(T, Pos, Show, [H | Rt]);
        false ->
            is_combat(T, Pos, Show, Rt)
    end.

get_new_level(Index) ->
    Ids = data_coliseum:get(ids),
    get_new_level(Ids, Index, 0).
get_new_level(_, Index, _Sum) when Index == 0 ->
    Ids = data_coliseum:get(ids),
    length(Ids);
get_new_level([], _Index, _Sum) ->
    Ids = data_coliseum:get(ids),
    length(Ids);
get_new_level([H|T], Index, Sum) ->
    Data = data_coliseum:get(H),
    Num  = util:get_val(num, Data, 0),
    case Index =< (Num + Sum) of
        true -> H;
        false ->
            get_new_level(T, Index, Sum + Num)
    end.

add_diamond(Pos1, Pos2) ->
    case (Pos2 - Pos1) > 0 andalso Pos2 < 1000 of
        true -> Pos2 - Pos1;
        false -> 0
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

update_robot_power() ->
    RobotIds = data_robot_new:get(ids),
    update_robot_power(RobotIds).
update_robot_power([]) -> ok;
update_robot_power([H|T]) ->
    Heroes  = init_new_robot(H),
    PowerL  = mod_hero:calc_power(Heroes),
    IdL     = integer_to_list(H),
    Sql = list_to_binary([<<"UPDATE `arena` SET `power` = ">>
            ,integer_to_list(PowerL),<<" WHERE `rid` = ">>, IdL
            ,<<" AND `robot` = 2">>]),
    case db:execute(Sql) of
        {ok,_} ->
            io:format(".", []),
            %% timer:sleep(100),
            update_robot_power(T);
        {error, Reason} ->
            ?INFO("update_robot_power rid:~w,Reason:~w", [H, Reason]),
            ok
    end.

update_oldrobot_power() ->
    Ids = data_robot:get(ids),
    update_oldrobot_power(Ids).
update_oldrobot_power([]) -> ok;
update_oldrobot_power([Id | Ids]) ->
    Data = data_robot:get(Id),
    Monster = util:get_val(monster, Data),
    Heroes = mod_combat:init_monster(Monster),
    Power = mod_hero:calc_power(Heroes),
    MonBin = ?ESC_SINGLE_QUOTES(term_to_binary(Monster)),
    IdL = integer_to_list(Id),
    PowerL = integer_to_list(Power),
    Sql = list_to_binary([
            <<"update arena set power = ">>, PowerL
            ,<<", s = '">>, MonBin, <<"'">>
            ,<<" where robot = 1 and rid = ">>, IdL]),
    case db:execute(Sql) of
        {ok,_} ->
            io:format(".", []),
            %% timer:sleep(100),
            update_oldrobot_power(Ids);
        {error, Reason} ->
            ?INFO("update_oldrobot_power rid:~w,Reason:~w", [Id, Reason]),
            ok
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
