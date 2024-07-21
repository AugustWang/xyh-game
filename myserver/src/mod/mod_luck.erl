%%----------------------------------------------------
%%
%% $Id: mod_luck.erl 13256 2014-06-18 05:40:49Z rolong $
%%
%% @doc 排行榜服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(mod_luck).
-behaviour(gen_server).
-export([
        start_link/0
        ,update_luck_id/0
        ,update_rank/0
        %% ,update_luck_list/0
        %% ,update_luck_week_list/0
        ,get_luck_id/0
        ,save_data_to_db/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-define(SERVER, luck).

%% ------------------------------------------------------------------
%% EUNIT TEST
%% ------------------------------------------------------------------
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).

data_luck_test() ->
    Ids = data_luck:get(ids),
    ?assert(length(Ids) > 0),
    ?assert(lists:all(fun(Id) -> length(data_luck:get(Id)) =:= 14 end, Ids)),
    data_luck_test1(Ids),
    ok.

data_luck_test1([]) -> ok;
data_luck_test1([Id|Ids]) ->
    Data = data_luck:get(Id),
    lists:foreach(fun({A,B,C,D,E,F,G}) ->
                ?assertMatch(ok,case A < ?MIN_EQU_ID of
                        true ->
                            case A == 5 of
                                true ->
                                    ?assert(is_tuple(C)),
                                    {Hid,_} = C,
                                    ?assert(data_hero:get(Hid) =/= undefined),
                                    ok;
                                false ->
                                    ?assert(C > 0),
                                    ?assert(data_prop:get(A) =/= undefined),
                                    ok
                            end;
                        false ->
                            ?assert(C > 0),
                            ?assert(data_equ:get(A) =/= undefined),
                            ok
                    end),
                ?assert(B > 0),
                ?assert(D > 0),
                ?assert(E > 0),
                ?assert(F > 0),
                ?assert(G > 0)
        end, Data),
    data_luck_test1(Ids).
-endif.

-record(state, {
    }
).

%% 排行榜数据
-record(myrank_data,
    {
        id              = 0     %% 角色ID
        ,name           = <<>>  %% 角色名字
        ,use_sum        = 0
        ,val_sum        = 0
        ,reward_id      = 0
        ,reward_num     = 0
        ,ctime          = 0
    }
).

%% --- 对外接口 ---

%% 新建连接
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

save_data_to_db() ->
    gen_server:call(?SERVER, save).

%% --- 服务器内部实现 ---

init([]) ->
    ?INFO("start ~w...~n", [?MODULE]),
    State = #state{},
    set_rank_from_db(),
    set_recent_from_db(),
	set_week_from_db(),
    put(rank_data, []),
	put(luck_id, 1),
    {ok, State}.

handle_call(save, _From, State) ->
    permanent_stores(),
    {reply, ok, State};

%% 获取期号
handle_call(get_luck_id, _From, State) ->
    Id = get(luck_id),
    {reply, Id, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 获取排名列表
handle_info({rank_list, PidSender}, State) ->
    Data = get(rank),
    sender:pack_send(PidSender, 13044, [Data]),
	%% ?DEBUG("Data:~w", [Data]),
    {noreply, State};

handle_info({recent_list, PidSender}, State) ->
    Data = get(recent),
    case catch sender:pack_send(PidSender, 13042, [Data]) of
        {'EXIT', What} ->
            ?WARN("Error 13042: ~w, ~w", [Data, What]);
        _ -> ok
    end,
    %% ?DEBUG("recent_list:~w", [Data]),
    {noreply, State};

handle_info({week_rank_list, PidSender}, State) ->
    Data = get(week_rank),
    sender:pack_send(PidSender, 13044, [Data]),
    {noreply, State};

%% 更新排行榜
handle_info(update_rank, State) ->
    case permanent_stores() of
        ok ->
            ?INFO("update_luck_rank.....", []),
            set_rank_from_db(),
			set_week_from_db(),
            ok;
        _ ->
            ok
    end,
    {noreply, State};

%% 更新排行榜
handle_info(update_luck_id, State) ->
	%% 幸运星 期号
	Ids = data_luck:get(ids),
	Id = get(luck_id),	%% 期号
	put(week_rank_list,[]),
	case Id + 1 > length(Ids) of
		true ->
			put(luck_id, 1);
		false ->
			put(luck_id, Id + 1)
	end,
	%% ?DEBUG("Id:~w", [Id]),
	{noreply, State};

handle_info(_Info, State) ->
    ?INFO("Not matched info: ~w", [_Info]),
    {noreply, State}.

handle_cast({set_myrank, Rid, Name, UseSum, ValSum, RewardId, RewardNum, Quality}, State) ->
    %% ?DEBUG("set_myrank:~w", [[Rid, Name, UseSum, ValSum, RewardId, RewardNum, Quality]]),
    RewardNum1 = case RewardId == ?CUR_HERO andalso is_tuple(RewardNum) of
        true -> 1;
        false -> RewardNum
    end,
    set_myrank_data(Rid, Name, UseSum, ValSum, RewardId, RewardNum1, Quality),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?ERR("Not matched message: ~w", [_Msg]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --- 私有函数 ---

%% 更新角色信息中的数据 从进程字典中
set_myrank_data(Rid, Name, UseSum, ValSum, RewardId, RewardNum, Quality) ->
    RankData = get(rank_data),
    Ctime = util:unixtime(),
    %% ?DEBUG("RankData:~w", [length(RankData)]),
    case Name =:= <<>> of
        true ->
            %% ?DEBUG("====Name:~w", [Name]),
            ok;
        false ->
            R1 = case lists:keyfind(Rid, 2, RankData) of
                false ->
                    #myrank_data{
                        id              = Rid
                        ,name           = Name
                        ,use_sum        = UseSum
                        ,val_sum        = ValSum
                        ,reward_id      = RewardId
                        ,reward_num     = RewardNum
                        ,ctime          = Ctime
                    };
                R ->
                    R#myrank_data{
                        name            = Name
                        ,use_sum        = UseSum
                        ,val_sum        = ValSum
                        ,reward_id      = RewardId
                        ,reward_num     = RewardNum
                        ,ctime          = Ctime
                    }
            end,
            NewRankData = lists:keystore(Rid, 2, RankData, R1),
            put(rank_data, NewRankData),
            case Quality =:= 2 of
                true ->
                    Recent = get(recent),
                    Recent1 = lists:sublist(Recent, 1, 19),
                    Recent2 = [[Name, RewardId, RewardNum] | Recent1],
                    put(recent, Recent2),
                    ok;
                false -> ok
            end
    end.

%% 更新期号
update_luck_id() ->
	?SERVER ! update_luck_id.

%% 更新排行榜
update_rank() ->
	?SERVER ! update_rank.

%% 获取期号
get_luck_id() ->
	Index = gen_server:call(?SERVER, get_luck_id),
	lists:nth(Index, data_luck:get(ids)).

permanent_stores() ->
    RankData = get(rank_data),
    ?INFO("save luck rank_data:~w", [length(RankData)]),
    permanent_stores(RankData).

permanent_stores([]) ->
    put(rank_data, []),
    ok;
permanent_stores([R|T]) ->
    #myrank_data{
        id              = Id
        ,name           = Name
        ,use_sum        = UseSum
        ,val_sum        = ValSum
        ,reward_id      = RewardId
        ,reward_num     = RewardNum
        ,ctime          = Ctime
    } = R,
    Sql = "UPDATE `rank_luck` SET `name` = ~s, `use_sum` = ~s,"
    " `val_sum` = ~s, `reward_id` = ~s, `reward_num` = ~s,"
    " `ctime` = ~s WHERE `id` =  ~s;",
    case db:execute(Sql, [Name, UseSum, ValSum, RewardId, RewardNum, Ctime, Id]) of
        {ok, 0} ->
            Sql2 = "INSERT INTO `rank_luck` "
            "(`id`, `name`, `use_sum`, `val_sum`, `reward_id`, `reward_num`, `ctime`) "
            "VALUES (~s, ~s, ~s, ~s, ~s, ~s, ~s);",
            db:execute(Sql2, [Id, Name, UseSum, ValSum, RewardId, RewardNum, Ctime]),
            permanent_stores(T);
        {ok, _} ->
            permanent_stores(T);
        {error, Reason} ->
            put(rank_data, [R|T]),
            ?WARN("~w", [Reason]),
            error;
        _ ->
            permanent_stores(T)
    end.

set_rank_from_db() ->
    Sql = lists:concat(["select "
            "name, use_sum, val_sum "
            "from rank_luck order by val_sum desc limit 0, 100"]),
    case db:get_all(Sql) of
        {ok, Data} -> put(rank, Data);
        _ -> put(rank, [])
    end.

set_recent_from_db() ->
    Sql = lists:concat(["select "
            "name, reward_id, reward_num "
            "from rank_luck order by ctime desc limit 0, 50"]),
    case db:get_all(Sql) of
        {ok, Data} -> put(recent, Data);
        _ -> put(recent, [])
    end.

set_week_from_db() ->
    Sql = lists:concat(["select "
            "name, use_sum, val_sum "
            "from rank_luck order by val_sum desc limit 0, 100"]),
    case db:get_all(Sql) of
        {ok, Data} -> put(week_rank, Data);
        _ -> put(week_rank, [])
    end.

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
