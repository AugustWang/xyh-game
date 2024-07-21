%%----------------------------------------------------
%% $Id: custom.erl 12032 2014-04-19 07:34:27Z piaohua $
%% @doc 自定义活动
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(custom).
-behaviour(gen_server).
-export([
        start_link/0
        ,get/0
        ,set/5
        ,set_use/2
        %% ,clean/0
        ,save/0
        ,save_custom_ets/0
        ,zip/1
        ,unzip/1
        ,val_zip/1
        ,val_unzip/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-define(CUSTOM_FILE_NAME, "dets/custom").

-record(state, {
    }).

-record(custom, {
        key
        ,val       %% [{fun, arg1..}..]
        ,content
        ,items
        ,start_time
        ,end_time
        ,list = []
        ,save  = 0 %% 0=不需要保存，1=保存当天活动数据
        ,count = 0 %% 当天的引用计数
    }).
%% fun=活动函数名
%% arg1..=活动函数的参数
%% content=邮件内容
%% items=邮件附件奖励
%% start_time=有效开始时间
%% end_time=有效结果时间
%% list=接入活动用户

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set(Val,Content,Items,Start_time,End_time) ->
    Key = ets:info(?MODULE, size),
    NewKey = get_new_key(Key),
    %% ?INFO("NewKey:~w", [NewKey]),
    %% ?INFO("Val:~w,Content:~w,Items:~w, Start_time:~w, End_time:~w", [Val,Content,Items,Start_time,End_time]),
    gen_server:cast(?MODULE, {set_custom, NewKey, Val,Content,Items,Start_time,End_time}).
    %% gen_server:call(?MODULE, {set_custom_2, NewKey, Val,Content,Items,Start_time,End_time}).

get_new_key(Key) ->
    case ets:member(?MODULE, Key) of
        true -> get_new_key(Key + 1);
        false -> Key
    end.

set_use(Key, Rid) ->
    gen_server:cast(?MODULE, {use_custom, Key, Rid}).

get() ->
    {M, C} = case ets:match(?MODULE, '$1', 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C == '$end_of_table' of
        true -> get_custom_val(M, []);
        false ->
            select_ets(C, [])
    end.
select_ets(Cont, Rt) ->
    {M, C} = case ets:match(?MODULE, Cont, 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C == '$end_of_table' of
        true -> get_custom_val(M, Rt);
        false ->
            select_ets(C, Rt)
    end.
get_custom_val([], Rt) -> Rt;
get_custom_val([H|T], Rt) ->
    [#custom{key = Key, val = Val
            ,content = Content, items = Items
            ,start_time = Start, end_time = End
            ,list = List}] = H,
    Time = util:unixtime(),
    case Time >= Start andalso Time =< End of
        true ->
            %% ets:update_counter(?MODULE, Key, {#custom.count, 1}),
            get_custom_val(T, [{Key,Val,Content,Items,List}|Rt]);
        false ->
            get_custom_val(T, Rt)
    end.

%% clean() ->
%%     custom ! clean_custom.

save() ->
    custom ! save_custom.

save_custom_ets() ->
    ?INFO("save_custom_ets(~w)...", [?MODULE]),
    gen_server:call(?MODULE, save_custom_ets).

%% === 服务器内部实现 ===

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    %% case ets:info(?MODULE) of
    %%     undefined ->
    %%         ets:new(?MODULE, [{keypos, #custom.key}, named_table, public, set]),
    %%         ok;
    %%     _ -> ok
    %% end,
    case filelib:is_file(?CUSTOM_FILE_NAME) of
        true ->
            ets:file2tab(?CUSTOM_FILE_NAME),
            ?INFO("Init custom! [size:~w, memory:~w]",
                [ets:info(?MODULE, size),
                    ets:info(?MODULE, memory)]),
            ok;
        false ->
            ets:new(?MODULE,
                [{keypos, #custom.key}, named_table, public, set]),
            ?INFO("New custom!", []),
            ok
    end,
    State = #state{},
    {ok, State}.

handle_call(save_custom_ets, _From, State) ->
    try
        ets:tab2file(?MODULE, ?CUSTOM_FILE_NAME),
        ?INFO("Save custom ets:~p",
            [ets:info(?MODULE, size)]),
        {reply, ok, State}
    catch
        TT:X ->
            ?ERR("[~p:~p]", [TT, X]),
            {reply, error, State}
    end;

handle_call({set_custom_2, Key, Val,Content,Items,Start_time,End_time}, _From, State) ->
    Custom = #custom{
        key = Key
        ,val = Val
        ,content = Content
        ,items = Items
        ,start_time = Start_time
        ,end_time = End_time
    },
    ets:insert(?MODULE, Custom),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    ?INFO("Undefined request:~p", [_Request]),
    {reply, ok, State}.

handle_cast({set_custom, Key, Val,Content,Items,Start_time,End_time}, State) ->
    Custom = #custom{
        key = Key
        ,val = Val
        ,content = Content
        ,items = Items
        ,start_time = Start_time
        ,end_time = End_time
    },
    ets:insert(?MODULE, Custom),
    {noreply, State};

handle_cast({use_custom, Key, Rid}, State) ->
    case ets:lookup(?MODULE, Key) of
        [#custom{val = Val, content = Content
                ,items = Items, list = List
                ,start_time = S, end_time = E
                ,count = Count}] ->
            Custom = #custom{
                key = Key
                ,val = Val
                ,content = Content
                ,items = Items
                ,list = [Rid | List]
                ,start_time = S
                ,end_time = E
                ,count = Count
                ,save = 1
            },
            ets:insert(?MODULE, Custom),
            ets:update_counter(?MODULE, Key, {#custom.count, 1}),
            ok;
        [] -> ok;
        Else ->
            ?WARNING("Undefined add_custom value: ~w", [Else]),
            ok
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    ?INFO("undefined msg:~p", [_Msg]),
    {noreply, State}.

handle_info({save_today_custom, Key}, State) ->
    Ctime = util:unixtime(),
    case ets:lookup(?MODULE, Key) of
        [#custom{val = Val, content = Content
                ,items = Items, list = List
                ,start_time = S, end_time = E
                ,count = Count}] ->
            util:test1(),
            I2 = mod_mail:items_list2(Items, []),
            Sql = list_to_binary([
                    <<"INSERT `log_custom_stat` (`key`, `start_time`, "
                    "`end_time`, `val`, `use_list`, "
                    "`body`, `items`, `count`, `ctime`) VALUES (">>
                    ,integer_to_list(Key),<<",">>
                    ,integer_to_list(S),<<",">>
                    ,integer_to_list(E),<<",'">>
                    ,?ESC_SINGLE_QUOTES(val_zip(Val)),<<"','">>
                    ,?ESC_SINGLE_QUOTES(zip(List)),<<"','">>
                    ,Content,<<"','">>
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
            ets:update_element(?MODULE, Key, {#custom.save, 0}),
            ets:update_element(?MODULE, Key, {#custom.count, 0}),
            util:test2("save_today_custom "),
            ok;
        _ -> ok
    end,
    {noreply, State};

handle_info(save_custom, State) ->
    save_custom(),
    {noreply, State};

%% handle_info(clean_custom, State) ->
%%     clean_custom(),
%%     {noreply, State};

handle_info(_Info, State) ->
    ?INFO("undefined info:~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -- 内部函数 --

save_custom() ->
    util:test1(),
    ets:safe_fixtable(?MODULE,true),
    save_custom(ets:first(?MODULE)),
    ets:safe_fixtable(?MODULE,false),
    util:test2("save custom").

save_custom('$end_of_table') ->
    true;
save_custom(Key) ->
    ?INFO("Key:~w", [Key]),
    case ets:lookup(?MODULE, Key) of
        [#custom{end_time = End, save = Save}] ->
            case Save of
                1 ->
                    self() ! {save_today_custom, Key},
                    Ctime = util:unixtime(),
                    case End < Ctime of
                        true ->
                            ets:delete(?MODULE,Key);
                        false -> ok
                    end;
                _ -> ok
            end;
        _ ->
            ok
    end,
    save_custom(ets:next(?MODULE, Key)).

%% clean_custom() ->
%%     util:test1(),
%%     ets:safe_fixtable(?MODULE,true),
%%     clean_custom(ets:first(?MODULE)),
%%     ets:safe_fixtable(?MODULE,false),
%%     util:test2("clean custom").
%%
%% clean_custom('$end_of_table') ->
%%     true;
%% clean_custom(Key) ->
%%     case ets:lookup(?MODULE, Key) of
%%         [#custom{save = S, count = C}] ->
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
%%                     ets:update_element(?MODULE, Key, {#custom.count, C - 1})
%%             end;
%%         Else ->
%%             ?WARN("Error Cache Data: ~w", [Else])
%%     end,
%%     clean_custom(ets:next(?MODULE, Key)).

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

-define(CUSTOM_ZIP_VERSION, 1).
zip([]) -> <<>>;
zip(List) ->
    Bin = list_to_binary(zip1(List, [])),
    <<?CUSTOM_ZIP_VERSION:8, Bin/binary>>.
zip1([], Rt) -> Rt;
zip1([H|T], Rt) ->
    zip1(T, [<<H:32>>|Rt]).


val_unzip(<<>>) -> [];
val_unzip(Bin) ->
    <<Version:8, Bin1/binary>> = Bin,
    case Version of
        1 ->
            val_unzip1(Bin1, []);
        _ ->
            ?ERR("undefined version: ~w", [Version]),
            undefined
    end.
val_unzip1(<<>>, Rt) -> Rt;
val_unzip1(<<X1_:16, X1:X1_/binary, X2:32, X3:32, RestBin/binary>>, Rt) ->
    X11 = binary_to_atom(X1, utf8),
    val_unzip1(RestBin, [{X11, X2, X3}|Rt]).

-define(CUSTOM_VAL_ZIP_VERSION, 1).
val_zip([]) -> <<>>;
val_zip(Val) ->
    Rt = list_to_binary(val_zip1(Val, [])),
    <<?CUSTOM_VAL_ZIP_VERSION:8, Rt/binary>>.
val_zip1([], Rt) -> Rt;
val_zip1([{Fun,Arg1,Arg2}|T], Rt) ->
    Fun2 = atom_to_binary(Fun, utf8),
    Fun_ = byte_size(Fun2),
    Rt1 = <<Fun_:16, Fun2:Fun_/binary, Arg1:32, Arg2:32>>,
    val_zip1(T, [Rt1|Rt]).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
