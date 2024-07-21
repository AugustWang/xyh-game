%% ------------------------------------------------------------------
%% $Id: mod_rank.erl 12367 2014-05-04 10:01:22Z piaohua $
%% @doc 排行服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_rank).
-behaviour(gen_server).
-include("common.hrl").
-include("hero.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(SERVER, rank).


%% API
-export([start_link/0
        ,set_rank_honor/0
        ,set_rank_diamond/0
        ,set_rank_combat/0
        ,set_rank_arena/0
        ,check_rank_diamond2/0
        ,reset_rank/0
        ,diamond_sum/1
    ]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(state, {}).

%% -record(rank_data, {attr, id, name}).

%%%===================================================================
%%% API
%%%===================================================================
%% 排行榜功能
%% 刷新排行榜
reset_rank() ->
    ?SERVER ! reset_rank.
    %% 不能直接调用方法刷新,要在进程服务里面(handle_info)
    %% set_rank_honor(),
    %% set_rank_diamond(),
    %% set_rank_combat(),
    %% set_rank_arena().

%% 幸运星荣耀榜
set_rank_honor() ->
    Sql = lists:concat(["select "
            "val_sum, id, name "
            "from rank_luck where name <> '' order by val_sum desc limit 0, 50"]),
    case db:get_all(Sql) of
        {ok, Data} ->
            Data1 = get_picture(Data),
            put(rank_honor, Data1);
        _ -> put(rank_honor, [])
    end.

%% 战斗力排行榜
set_rank_combat() ->
    Sql = list_to_binary([<<"SELECT `combat`, `id`, `name` FROM `role` WHERE `name` <> '' ORDER BY `combat` DESC LIMIT 0, 50">>]),
    case db:get_all(Sql) of
        {ok, Data} ->
            Data1 = get_picture2(Data),
            put(rank_combat, Data1);
        {error, null} -> put(rank_combat, []);
        {error, Reason} ->
            ?WARN("set combat rank error:~w", [Reason]),
            put(rank_combat, [])
    end.

%% 角斗场排行榜(有机器人)
set_rank_arena() ->
    Sql = list_to_binary([<<"SELECT `newexp`, `rid`, `name`, `picture`, `newlev` FROM `arena` "
            " WHERE `name` <> '' AND `newlev` = 1 ORDER BY `newexp` DESC LIMIT 0, 50">>]),
    case db:get_all(Sql) of
        {ok, Data} -> put(rank_arena, Data);
        {error, null} -> put(rank_arena, []);
        {error, Reason} ->
            ?WARN("set arena rank error:~w", [Reason]),
            put(rank_combat, [])
    end.

%% 钻石排行榜
set_rank_diamond() ->
    Sql = list_to_binary([<<"SELECT `diamond_sum`, `id`, `name` FROM `role` "
            " WHERE `name` <> '' AND `diamond_sum` > 0 ORDER BY `diamond_sum` DESC LIMIT 0, 50">>]),
    case db:get_all(Sql) of
        {ok, Data} ->
            Data1 = get_picture(Data),
            put(rank_diamond, Data1);
        {error, null} ->
            put(rank_diamond, []);
        {error, Reason} ->
            ?WARN("set diamond rank error:~w", [Reason]),
            put(rank_diamond, [])
    end.

diamond_sum(AttainList) ->
    case AttainList == [] of
        true -> 0;
        false ->
            case lists:keyfind(62, 3, AttainList) of
                false -> 0;
                {_,_,62,Num,_} -> Num
            end
    end.

%%' 钻石排行榜功能(不能每次加载整个表,数据过大)
%% set_rank_diamond() ->
%%     set_rank_diamond(0, 2000, []).
%% set_rank_diamond(Num1, Num2, Rt) ->
%%     Sql = list_to_binary([<<"SELECT `id`, `attain` FROM `attain` LIMIT ">>
%%             , integer_to_list(Num1), <<",">>, integer_to_list(Num2)]),
%%     case db:get_all(Sql) of
%%         {ok, Data} ->
%%             Data2 = check_rank_diamond(Data, []),
%%             set_rank_diamond(Num1 + Num2, Num2, Data2 ++ Rt);
%%         %% put(rank_diamond, Data2);
%%         {error, null} ->
%%             %% ?INFO("===Rt:~W", [Rt, 999]),
%%             Rt2 = lists:reverse(lists:sort(Rt)),
%%             Rt3 = lists:sublist(Rt2, 50),
%%             Rt4 = get_picture(Rt3),
%%             put(rank_diamond, Rt4);
%%         {error, Reason} ->
%%             ?WARN("set diamond rank error:~w", [Reason]),
%%             put(rank_diamond, [])
%%     end.
%%
%% check_rank_diamond([[Id, Attain] | T], Rt) ->
%%     Sql = list_to_binary([<<"SELECT `name` FROM `role` WHERE `id` = ">>
%%             , integer_to_list(Id), <<" AND `name` <> '' ">>]),
%%     %% ?INFO("==Id:~w", [Id]),
%%     case mod_attain:unzip(Attain) of
%%         undefined -> check_rank_diamond(T, Rt);
%%         [] -> check_rank_diamond(T, Rt);
%%         At ->
%%             case lists:keyfind(62, 3, At) of
%%                 false -> check_rank_diamond(T, Rt);
%%                 {_, _, 62, Num, _} ->
%%                     case Num >= 10000 of
%%                         true ->
%%                             case db:get_one(Sql) of
%%                                 {ok, Name} ->
%%                                     check_rank_diamond(T, [[Num, Id, Name] | Rt]);
%%                                 _ -> check_rank_diamond(T, Rt)
%%                             end;
%%                         false ->
%%                             check_rank_diamond(T, Rt)
%%                     end
%%             end
%%     end;
%% check_rank_diamond([], Rt) -> Rt.

%% test usr
%% check_rank_diamond([[Id, Attain] | T], Rt, Rt2) ->
%%     Sql = list_to_binary([<<"SELECT `name` FROM `role` WHERE `id` = ">>, integer_to_list(Id)]),
%%     %% ?INFO("==Id:~w", [Id]),
%%     case catch mod_attain:unzip(Attain) of
%%         {'EXIT', _Reason} ->
%%             check_rank_diamond(T, Rt, [Id | Rt2]);
%%         undefined -> check_rank_diamond(T, Rt, Rt2);
%%         [] -> check_rank_diamond(T, Rt, Rt2);
%%         At ->
%%             case lists:keyfind(62, 3, At) of
%%                 false -> check_rank_diamond(T, Rt, Rt2);
%%                 {_, _, 62, Num, _} ->
%%                     case Num >= 10000 of
%%                         true ->
%%                             case db:get_one(Sql) of
%%                                 {ok, Name} ->
%%                                     check_rank_diamond(T, [[Num, Id, Name] | Rt], Rt2);
%%                                 _ -> check_rank_diamond(T, Rt, Rt2)
%%                             end;
%%                         false ->
%%                             check_rank_diamond(T, Rt, Rt2)
%%                     end
%%             end
%%     end;
%% check_rank_diamond([], Rt, Rt2) ->
%%     ?INFO("===Id:~W", [Rt2, 999]),
%%     Rt.
%%.

%%' FINISH: 计算已有diamond+已消耗diamond(log_diamond/role)
%% 更新下一版本时执行,只执行一次
%% FINISH: 不能取整个表,要分段执行
check_rank_diamond2() ->
    %% Sql1 = list_to_binary([<<"SELECT `role_id`, ABS(SUM(`num`)) FROM `log_diamond` WHERE `num` < 0 GROUP BY `role_id`">>]),
    %% Sql2 = list_to_binary([<<"SELECT `id`, `diamond` FROM `role`">>]),
    %% L1 = case db:get_all(Sql1) of
    %%     {ok, List1} -> List1;
    %%     _ -> []
    %% end,
    %% L2 = case db:get_all(Sql2) of
    %%     {ok, List2} -> List2;
    %%     _ -> []
    %% end,
    L1 = check_rank_diamond5(),
    L2 = check_rank_diamond6(),
    %% ?INFO("====L1:~w ===L2:~w", [L1, L2]),
    List3 = util:merge_list(L1 ++ L2),
    check_rank_diamond3(List3).

check_rank_diamond3([]) -> ok;
check_rank_diamond3([{Id, Num} | T]) ->
    %% ?INFO("===::ID:~w", [Id]),
    Sql1 = list_to_binary([<<"SELECT `attain` FROM `attain` WHERE `id` = ">>, integer_to_list(Id)]),
    case db:get_one(Sql1) of
        {ok, Attain} ->
            case mod_attain:unzip(Attain) of
                undefined -> check_rank_diamond3(T);
                [] -> check_rank_diamond3(T);
                At ->
                    case lists:keyfind(62, 3, At) of
                        false ->
                            List2 = lists:keystore(62, 3, At, {224, 225, 62, Num, 0}),
                            check_rank_diamond4(Id, List2),
                            check_rank_diamond3(T);
                        {_A, _B, 62, _Num2, _C} ->
                            %% case Num > Num2 of
                            %%     true ->
                            %%         List3 = lists:keystore(62, 3, At, {A, B, 62, Num, C}),
                            %%         check_rank_diamond4(Id, List3),
                            %%         check_rank_diamond3(T);
                            %%     false ->
                            %%         check_rank_diamond3(T)
                            %% end
                            check_rank_diamond3(T)
                    end
            end;
        _ -> check_rank_diamond3(T)
    end.

check_rank_diamond4(Id, Attain) ->
    Attain2 = ?ESC_SINGLE_QUOTES(mod_attain:zip(Attain)),
    Sql2 = list_to_binary([<<"UPDATE `attain` SET `attain` = '">>, Attain2, <<"' WHERE `id` = ">>, integer_to_list(Id)]),
    io:format(".", []),
    db:execute(Sql2).

check_rank_diamond5() ->
    check_rank_diamond5(0, 2000, []).
check_rank_diamond5(Num1, Num2, Rt) ->
    Sql = list_to_binary([<<"SELECT `role_id`, ABS(SUM(`num`)) FROM `log_diamond` WHERE `num` < 0 GROUP BY `role_id` LIMIT ">>
            , integer_to_list(Num1), <<", ">>, integer_to_list(Num2)]),
    case db:get_all(Sql) of
        {ok, Data} ->
            check_rank_diamond5(Num1 + Num2, Num2, Data ++ Rt);
            %% : 合并相同id,util:merge_list(Data)
        {error, null} -> Rt;
        {error, Reason} ->
            ?WARN("set diamond rank error:~w", [Reason]),
            Rt
    end.
check_rank_diamond6() ->
    check_rank_diamond6(0, 2000, []).
check_rank_diamond6(Num1, Num2, Rt) ->
    Sql = list_to_binary([<<"SELECT `id`, `diamond` FROM `role` LIMIT ">>
            , integer_to_list(Num1), <<", ">>, integer_to_list(Num2)]),
    case db:get_all(Sql) of
        {ok, Data} ->
            check_rank_diamond6(Num1 + Num2, Num2, Data ++ Rt);
        {error, null} -> Rt;
        {error, Reason} ->
            ?WARN("set diamond rank error:~w", [Reason]),
            Rt
    end.
%%.

%% test
%% test_check_attain() ->
%%     Sql = list_to_binary([<<"SELECT `attain` FROM `attain` WHERE id = 3657">>]),
%%     Sql2 = list_to_binary([<<"UPDATE `attain` SET `attain` = ''">>]),
get_picture(List) ->
    get_picture(List, []).
get_picture([], Rt) -> Rt;
get_picture([H|T], Rt) ->
    [Value, Id, Name] = H,
    Sql = list_to_binary([<<"SELECT `picture` FROM `arena` WHERE `rid` = ">>
            ,integer_to_list(Id), <<" AND `robot` = 0">>]),
    case db:get_row(Sql) of
        {ok, [Picture]} ->
            get_picture(T, [[Value, Id, Name, Picture, 0] | Rt]);
        {error, null} ->
            get_picture(T, Rt);
        {error, Reason} ->
            ?WARN("rank get picture error:~w", [Reason]),
            get_picture(T, Rt)
    end.

get_picture2(List) ->
    get_picture2(List, []).
get_picture2([], Rt) -> Rt;
get_picture2([H|T], Rt) ->
    [Value, Id, Name] = H,
    Sql = list_to_binary([<<"SELECT `picture`, `newlev` FROM `arena` WHERE `rid` = ">>
            ,integer_to_list(Id), <<" AND `robot` = 0">>]),
    case db:get_row(Sql) of
        {ok, [Picture, Lev]} ->
            get_picture2(T, [[Value, Id, Name, Picture, Lev] | Rt]);
        {error, null} ->
            get_picture2(T, Rt);
        {error, Reason} ->
            ?WARN("rank get picture error:~w", [Reason]),
            get_picture2(T, Rt)
    end.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    ?INFO("start ~w...~n", [?MODULE]),
    %% reset_rank(),
    set_rank_honor(),
    set_rank_diamond(),
    set_rank_combat(),
    set_rank_arena(),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
%% (1=幸运星,2=财富榜,3=战斗力,4=角斗场)
%% handle_cast({rank_set, Val, Rid, Name, Type}, State) ->
%%     case lists:member(Type, [1,2,3,4]) of
%%         true ->
%%             set_rank_data(Val, Rid, Name, Type);
%%         false -> ok
%%     end,
%%     {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

%% 获取排行榜列表(1=幸运星,2=财富榜,3=战斗力,4=角斗场)
%% 战斗力排行定时更新(1,2实时)
handle_info({rank_list, PidSender, Type, Num, Lev}, State) ->
    Data = case Type of
        1 -> get(rank_honor);
        2 -> get(rank_diamond);
        3 -> get(rank_combat);
        4 -> get(rank_arena);
        _ -> ?WARN("rank list type error:~w", [Type]), []
    end,
    Data1 = lists:reverse(lists:sort(Data)),
    Data2 = lists:sublist(Data1, 1, 50),
    Data3 = fix_rank(Data2),
    %% ?INFO("===Type:~w, Data2:~w, Data3:~w", [Type, Data2, Data3]),
    sender:pack_send(PidSender, 29010, [Type, Num, Lev, Data3]),
    {noreply, State};

%% 更新排行榜
handle_info(reset_rank, State) ->
    set_rank_honor(),
    set_rank_diamond(),
    set_rank_combat(),
    set_rank_arena(),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% set_rank_data(Val, Rid, Name, Type) ->
%%     RankData = case Type of
%%         1 -> get(rank_honor);
%%         2 -> get(rank_diamond);
%%         3 -> get(rank_combat);
%%         4 -> get(rank_arena);
%%         _ -> ?WARN("set rank data error:~w", [Type]), []
%%     end,
%%     RankData1 = list2tuple(RankData),
%%     case Name =:= <<>> of
%%         true -> ok;
%%         false ->
%%             RankData2 = case lists:keyfind(Rid, 2, RankData1) of
%%                 false ->
%%                     lists:keystore(Rid, 2, RankData1, {Val, Rid, Name});
%%                 {N, Rid, _} ->
%%                     case Val > N of
%%                         true ->
%%                             lists:keystore(Rid, 2, RankData1, {Val, Rid, Name});
%%                         false -> RankData1
%%                     end
%%             end,
%%             %% List = case lists:keyfind(Rid, 2, RankData1) of
%%             %%     false ->
%%             %%         #rank_data{
%%             %%             attr = Val
%%             %%             ,id  = Rid
%%             %%             ,name = Name
%%             %%         };
%%             %%     L ->
%%             %%         L#rank_data{
%%             %%             attr = Val
%%             %%         }
%%             %% end,
%%             %% RankData2 = lists:keystore(Rid, 2, RankData1, List),
%%             NewRankData = tuple2list(RankData2),
%%             case Type of
%%                 1 -> put(rank_honor, NewRankData), ok;
%%                 2 -> put(rank_diamond, NewRankData), ok;
%%                 3 -> put(rank_combat, NewRankData), ok;
%%                 4 -> put(rank_arena, NewRankData), ok;
%%                 _ -> ?WARN("set rank data error:~w", [Type]),
%%                     ok
%%             end
%%     end.

%% 添加排名字段
fix_rank(Data) ->
    fix_rank(Data, 0, []).
fix_rank([R|T], Key, Rs) ->
    Pos = Key + 1,
    [A, B, C, D, E] = R,
    fix_rank(T, Pos, [[Pos, A, B, C, D, E]|Rs]);
fix_rank([], _, Rs) ->
    lists:reverse(Rs).

%% list2tuple(List) ->
%%     list2tuple(List, []).
%% list2tuple([H|T], Rt) ->
%%     [A,B,C] = H,
%%     list2tuple(T, [{A,B,C}|Rt]);
%% list2tuple([], Rt) -> Rt.
%%
%% tuple2list(List) ->
%%     tuple2list(List, []).
%% tuple2list([H|T], Rt) ->
%%     {A,B,C} = H,
%%     tuple2list(T, [[A,B,C]|Rt]);
%% tuple2list([], Rt) -> Rt.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
