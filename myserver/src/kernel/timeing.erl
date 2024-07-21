%%----------------------------------------------------
%% $Id: timeing.erl 12032 2014-04-19 07:34:27Z piaohua $
%% @doc 定时活动
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(timeing).
-behaviour(gen_server).
-export([
        start_link/0
        ,get/0
        ,set/1
        ,set_use/2
        %% ,clean/0
        ,save/0
        ,save_timeing_ets/0
        ,zip/1
        ,unzip/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-define(TIMEING_FILE_NAME, "dets/timeing").

-record(state, {
    }).

-record(timeing, {
        key
        ,val       %% {start_time, end_time, slist, ulist, Title, Body, Items}
        ,save  = 0 %% 0=不需要保存，1=保存当天活动数据
        ,count = 0 %% 当天的引用计数
    }).
%% start_time=活动开始时间
%% end_time=活动结束时间
%% slist=要发送的人
%% ulist=已经发送的人
%% Title=邮件标题
%% Body=邮件内容
%% Items=奖励列表

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set(Val) ->
    Key = ets:info(?MODULE, size),
    NewKey = get_new_key(Key),
    gen_server:cast(?MODULE, {set_timeing, NewKey, Val}).

get_new_key(Key) ->
    case ets:member(?MODULE, Key) of
        true -> get_new_key(Key + 1);
        false -> Key
    end.

set_use(Key, Rid) ->
    gen_server:cast(?MODULE, {use_timeing, Key, Rid}).

get() ->
    {M, C} = case ets:match(?MODULE, '$1', 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C == '$end_of_table' of
        true -> get_timeing_val(M, []);
        false ->
            select_ets(C, [])
    end.
select_ets(Cont, Rt) ->
    {M, C} = case ets:match(?MODULE, Cont, 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C == '$end_of_table' of
        true -> get_timeing_val(M, Rt);
        false ->
            select_ets(C, Rt)
    end.
get_timeing_val([], Rt) -> Rt;
get_timeing_val([H|T], Rt) ->
    [#timeing{key = Key, val = Val}] = H,
    {S,E,_SL,_UL,_T,_B,_I} = Val,
    Time = util:unixtime(),
    case Time >= S andalso Time =< E of
        true ->
            ets:update_counter(?MODULE, Key, {#timeing.count, 1}),
            get_timeing_val(T, [{Key,Val}|Rt]);
        false ->
            get_timeing_val(T, Rt)
    end.

%% clean() ->
%%     timeing ! clean_timeing.

save() ->
    timeing ! save_timeing.

save_timeing_ets() ->
    ?INFO("save_timeing(~w)...", [?MODULE]),
    gen_server:call(?MODULE, save_timeing_ets).

%% === 服务器内部实现 ===

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    %% case ets:info(?MODULE) of
    %%     undefined ->
    %%         ets:new(?MODULE, [{keypos, #timeing.key}, named_table, public, set]),
    %%         ok;
    %%     _ -> ok
    %% end,
    case filelib:is_file(?TIMEING_FILE_NAME) of
        true ->
            ets:file2tab(?TIMEING_FILE_NAME),
            ?INFO("Init timeing! [size:~w, memory:~w]",
                [ets:info(?MODULE, size),
                    ets:info(?MODULE, memory)]),
            ok;
        false ->
            ets:new(?MODULE,
                [{keypos, #timeing.key}, named_table, public, set]),
            ?INFO("New timeing!", []),
            ok
    end,
    State = #state{},
    {ok, State}.

handle_call(save_timeing_ets, _From, State) ->
    try
        ets:tab2file(?MODULE, ?TIMEING_FILE_NAME),
        ?INFO("Save timeing ets:~p",
            [ets:info(?MODULE, size)]),
        {reply, ok, State}
    catch
        TT:X ->
            ?ERR("[~p:~p]", [TT, X]),
            {reply, error, State}
    end;

handle_call(_Request, _From, State) ->
    ?INFO("Undefined request:~p", [_Request]),
    {reply, ok, State}.

handle_cast({set_timeing, Key, Val}, State) ->
    {_S,_E,_SL,UL,_T,_B,_I} = Val,
    Timeing = #timeing{
        key = Key,
        val = Val,
        save = 1,
        count = length(UL)
    },
    ets:insert(?MODULE, Timeing),
    {noreply, State};

handle_cast({use_timeing, Key, Rid}, State) ->
    case ets:lookup(?MODULE, Key) of
        [#timeing{val = Val}] ->
            {S,E,SL,UL,T,B,I} = Val,
            Timeing = #timeing{
                key = Key,
                val = {S,E,SL,[Rid | UL],T,B,I},
                save = 1
            },
            ets:insert(?MODULE, Timeing),
            ok;
        [] -> ok;
        Else ->
            ?WARNING("Undefined add_timeing value: ~w", [Else]),
            ok
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    ?INFO("undefined msg:~p", [_Msg]),
    {noreply, State}.

handle_info({save_today_timeing, Key}, State) ->
    Ctime = util:unixtime(),
    case ets:lookup(?MODULE, Key) of
        [#timeing{val = {S,E,SL,UL,_T,B,I}, count = Count}] ->
            util:test1(),
            I2 = mod_mail:items_list2(I, []),
            Sql = list_to_binary([
                    <<"INSERT `log_activity_stat` (`key`, `start_time`, "
                    "`end_time`, `send_list`, `use_list`, "
                    "`body`, `items`, `count`, `ctime`) VALUES (">>
                    ,integer_to_list(Key),<<",">>
                    ,integer_to_list(S),<<",">>
                    ,integer_to_list(E),<<",'">>
                    ,?ESC_SINGLE_QUOTES(zip(SL)),<<"','">>
                    ,?ESC_SINGLE_QUOTES(zip(UL)),<<"','">>
                    ,B,<<"','">>
                    ,?ESC_SINGLE_QUOTES(mod_mail:mail_zip(I2)),<<"',">>
                    ,integer_to_list(Count),<<",">>
                    ,integer_to_list(Ctime),<<")">>
                ]),
            %% ?INFO("Sql:~w", [Sql]),
            case db:execute(Sql) of
                {ok, _} -> ok;
                {error, Reason} ->
                    ?WARN("Reason:~w", [Reason]),
                    ok
            end,
            ets:update_element(?MODULE, Key, {#timeing.save, 0}),
            ets:update_element(?MODULE, Key, {#timeing.count, 0}),
            util:test2("save_today_timeing "),
            ok;
        _ -> ok
    end,
    {noreply, State};

handle_info(save_timeing, State) ->
    save_timeing(),
    {noreply, State};

%% handle_info(clean_timeing, State) ->
%%     clean_timeing(),
%%     {noreply, State};

handle_info(_Info, State) ->
    ?INFO("undefined info:~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -- 内部函数 --

save_timeing() ->
    util:test1(),
    ets:safe_fixtable(?MODULE,true),
    save_timeing(ets:first(?MODULE)),
    ets:safe_fixtable(?MODULE,false),
    util:test2("save timeing").

save_timeing('$end_of_table') ->
    true;
save_timeing(Key) ->
    ?INFO("Key:~w", [Key]),
    case ets:lookup(?MODULE, Key) of
        [#timeing{val = {_S,E,_SL,_UL,_T,_B,_I}, save = Save}] ->
            case Save of
                1 ->
                    self() ! {save_today_timeing, Key},
                    Ctime = util:unixtime(),
                    case E < Ctime of
                        true ->
                            ets:delete(?MODULE,Key);
                        false -> ok
                    end;
                _ -> ok
            end;
        _ ->
            ok
    end,
    save_timeing(ets:next(?MODULE, Key)).

%% clean_timeing() ->
%%     util:test1(),
%%     ets:safe_fixtable(?MODULE,true),
%%     clean_timeing(ets:first(?MODULE)),
%%     ets:safe_fixtable(?MODULE,false),
%%     util:test2("clean timeing").
%%
%% clean_timeing('$end_of_table') ->
%%     true;
%% clean_timeing(Key) ->
%%     case ets:lookup(?MODULE, Key) of
%%         [#timeing{save = S, count = C}] ->
%%             case C =< 0 of
%%                 true ->
%%                     %% 如果引用计数为0，并且不需要保存，则删除
%%                     case S of
%%                         0 -> ets:delete(?MODULE, Key);
%%                         1 -> self() ! {save_arena, Key};
%%                         2 -> self() ! {save_coliseum, Key};
%%                         E -> ?WARN("Error Cache Save: ~w", [E])
%%                     end;
%%                 false ->
%%                     %% 计数器减1
%%                     ets:update_element(?MODULE, Key, {#timeing.count, C - 1})
%%             end;
%%         Else ->
%%             ?WARN("Error Cache Data: ~w", [Else])
%%     end,
%%     clean_timeing(ets:next(?MODULE, Key)).

unzip(<<>>) -> [];
unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            unzip1(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
unzip1(<<>>, Rt) -> Rt;
unzip1(<<R:32, RestBin/binary>>, Rt) ->
    unzip1(RestBin, [R|Rt]).

-define(TIMEING_ZIP_VERSION, 1).
zip([]) -> <<>>;
zip(List) ->
    Bin = list_to_binary(zip1(List, [])),
    <<?TIMEING_ZIP_VERSION:8, Bin/binary>>.
zip1([], Rt) -> Rt;
zip1([H|T], Rt) ->
    zip1(T, [<<H:32>>|Rt]).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
