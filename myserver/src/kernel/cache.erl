%%----------------------------------------------------
%% $Id: cache.erl 12474 2014-05-09 02:26:15Z piaohua $
%% @doc 缓存数据
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(cache).
-behaviour(gen_server).
-export([
        start_link/0
        ,get/1
        ,set/2
        ,clean/0
        ,save/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-record(state, {
    }).

-record(cache, {
        key
        ,val
        ,save  = 0 %% 0=不需要保存，1=保存为竞技数据
        ,count = 0 %% 引用计数
    }).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set(Key, Val) ->
    gen_server:cast(?MODULE, {set_cache, Key, Val}).

get(Key) ->
    case ets:lookup(?MODULE, Key) of
        [#cache{val = Val}] ->
            ets:update_counter(?MODULE, Key, {#cache.count, 1}),
            Val;
        [] -> undefined;
        Else ->
            ?WARNING("Undefined cache value: ~w", [Else]),
            undefined
    end.

clean() ->
    cache ! clean_cache.

save() ->
    cache ! save_cache.

%% === 服务器内部实现 ===

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    case ets:info(?MODULE) of
        undefined ->
            ets:new(?MODULE, [{keypos, #cache.key}, named_table, public, set]),
            ok;
        _ -> ok
    end,
    State = #state{},
    {ok, State}.

handle_call(_Request, _From, State) ->
    ?INFO("Undefined request:~p", [_Request]),
    {noreply, State}.

handle_cast({set_cache, Key, Val}, State) ->
    Cache = #cache{
        key = Key,
        val = Val
    },
    ets:insert(?MODULE, Cache),
    {noreply, State};

handle_cast({arena_cache, Rs, Lev, Exp, Heroes}, State) ->
    #role{id = Rid, arena_id = Aid, name = Name} = Rs,
    Cache = #cache{
        key = {arena, Aid},
        val = {0, Rid, Lev, Exp, Name, Heroes},
        save = 1
    },
    ets:insert(?MODULE, Cache),
    {noreply, State};

handle_cast({coliseum_cache, Rs, Lev, Exp, Heroes}, State) ->
    #role{id = Rid, arena_id = Aid, name = Name} = Rs,
    Cache = #cache{
        key = {coliseum, Aid},
        val = {0, Rid, Lev, Exp, Name, Heroes},
        save = 2
    },
    ets:insert(?MODULE, Cache),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?INFO("undefined msg:~p", [_Msg]),
    {noreply, State}.

handle_info({save_arena, Key}, State) ->
    case ets:lookup(?MODULE, Key) of
        [#cache{val = {0, _Rid, Lev, Exp, _Name, Heroes}}] ->
            util:test1(),
            IdL = integer_to_list(element(2, Key)),
            LevL = integer_to_list(Lev),
            ExpL = integer_to_list(Exp),
            Power = mod_hero:calc_power(Heroes),
            PowerL = integer_to_list(Power),
            Bin = ?ESC_SINGLE_QUOTES(mod_arena:zip_heroes(Heroes)),
            Sql = list_to_binary([
                    <<"update arena set lev = ">>, LevL
                    ,<<", exp = ">>, ExpL
                    ,<<", power = ">>, PowerL
                    ,<<", s = '">>, Bin, <<"'">>
                    ,<<" where id = ">>, IdL
                ]),
            db:execute(Sql),
            ets:update_element(?MODULE, Key, {#cache.save, 0}),
            util:test2("save_arena cache"),
            ok;
        _ -> ok
    end,
    {noreply, State};

handle_info({save_coliseum, Key}, State) ->
    case ets:lookup(?MODULE, Key) of
        [#cache{val = {0, _Rid, _Lev, Exp, _Name, Heroes}}] ->
            util:test1(),
            IdL = integer_to_list(element(2, Key)),
            %% LevL = integer_to_list(Lev),
            ExpL = integer_to_list(Exp),
            Power = mod_hero:calc_power(Heroes),
            PowerL = integer_to_list(Power),
            Bin = ?ESC_SINGLE_QUOTES(mod_colosseum:zip_heroes(Heroes)),
            Sql = list_to_binary([
                    %% <<"update arena set newlev = ">>, LevL
                    <<"update arena set newexp = ">>, ExpL
                    ,<<", power = ">>, PowerL
                    ,<<", s = '">>, Bin, <<"'">>
                    ,<<" where id = ">>, IdL
                ]),
            db:execute(Sql),
            ets:update_element(?MODULE, Key, {#cache.save, 0}),
            util:test2("save_coliseum cache"),
            ok;
        _ -> ok
    end,
    {noreply, State};

handle_info(save_cache, State) ->
    save_cache(),
    {noreply, State};

handle_info(clean_cache, State) ->
    clean_cache(),
    {noreply, State};

handle_info(_Info, State) ->
    ?INFO("undefined info:~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -- 内部函数 --

save_cache() ->
    util:test1(),
    ets:safe_fixtable(?MODULE,true),
    save_cache(ets:first(?MODULE)),
    ets:safe_fixtable(?MODULE,false),
    util:test2("save cache").

save_cache('$end_of_table') ->
    true;
save_cache(Key) ->
    case ets:lookup(?MODULE, Key) of
        [#cache{save = Save}] ->
            %% ets:delete(Tab,Key);
            case Save of
                1 -> self() ! {save_arena, Key};
                2 -> self() ! {save_coliseum, Key};
                _ -> ok
            end;
        _ ->
            ok
    end,
    save_cache(ets:next(?MODULE, Key)).

clean_cache() ->
    util:test1(),
    ets:safe_fixtable(?MODULE,true),
    clean_cache(ets:first(?MODULE)),
    ets:safe_fixtable(?MODULE,false),
    util:test2("clean cache").

clean_cache('$end_of_table') ->
    true;
clean_cache(Key) ->
    case ets:lookup(?MODULE, Key) of
        [#cache{save = S, count = C}] ->
            case C =< 0 of
                true ->
                    %% 如果引用计数为0，并且不需要保存，则删除
                    case S of
                        0 -> ets:delete(?MODULE, Key);
                        1 -> self() ! {save_arena, Key};
                        2 -> self() ! {save_coliseum, Key};
                        E -> ?WARN("Error Cache Save: ~w", [E])
                    end;
                false ->
                    %% 计数器减1
                    ets:update_element(?MODULE, Key, {#cache.count, C - 1})
            end;
        Else ->
            ?WARN("Error Cache Data: ~w", [Else])
    end,
    clean_cache(ets:next(?MODULE, Key)).
