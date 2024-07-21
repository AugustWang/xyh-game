%%----------------------------------------------------
%% $Id: extra.erl 11115 2014-08-21 11:26:11Z piaohua $
%% @doc 开服活动
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(extra).
-behaviour(gen_server).
-export([
        start_link/0
        ,get/0
        ,get1/0
        ,set/6
        ,set_use/3
        %% ,clean/0
        ,save/0
        ,save_extra_ets/0
        ,zip/1
        ,unzip/1
        ,val_zip/1
        %% ,val_unzip/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-define(EXTRA_FILE_NAME, "dets/extra").

-record(state, {
    }).

-record(extra, {
        key        %%
        ,type      %% 活动类型hero|pay|colosseum|..
        ,val       %% [{cond1, item1..}..]
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
%% val   = (example:[{98,[{7,100},{34,8}]}..],explain:充值98rmb给奖励)
%% cond1 = 条件参数(example:[{98,[{7,100},{34,8}]}..],explain:98为条件)
%% item1 = 奖励列表(example:[{7,100},{34,8}],explain:98对应的奖励)
%% content = 邮件内容(io_lib:format("content", [98,100,8]),
%%         explain:文字会有条件和奖励内容替换,不同的替换可以设置多个活动key)
%% items=邮件附件奖励(暂时没用,为[])
%% start_time=有效开始时间
%% end_time=有效结果时间
%% list=接入活动用户

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

set(Type,Val,Content,Items,Start_time,End_time) ->
    %% Key = ets:info(?MODULE, size),
    %% NewKey = get_new_key(Key),
    %% ?INFO("NewKey:~w", [NewKey]),
    %% ?INFO("Val:~w,Content:~w,Items:~w, Start_time:~w, End_time:~w", [Val,Content,Items,Start_time,End_time]),
    gen_server:cast(?MODULE, {set_extra,Type,Val,Content,Items,Start_time,End_time}).
    %% gen_server:call(?MODULE, {set_extra_2, NewKey, Val,Content,Items,Start_time,End_time}).

get_new_key(Key) ->
    case ets:member(?MODULE, Key) of
        true -> get_new_key(Key + 1);
        false -> Key
    end.

set_use(Type, Val, Rid) ->
    gen_server:cast(?MODULE, {use_extra, Type, Val, Rid}).

get() ->
    ets:foldl(fun get_extra_val1/2, [], ?MODULE).

get_extra_val1(H, Rt) ->
    #extra{key         = Key
            ,type       = Type
            ,val        = Val
            ,content    = Content
            ,items      = Items
            ,start_time = Start
            ,end_time   = End
            ,list       = List} = H,
    Time = util:unixtime(),
    case Time >= Start andalso Time =< End of
        true ->
            [{Key,Type,Val,Content,Items,List}|Rt];
        false -> Rt
    end.

get1() ->
    {M, C} = case ets:match(?MODULE, '$1', 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C of
        '$end_of_table' ->
            get_extra_val(M, []);
        _ ->
            Rt1 = get_extra_val(M,[]),
            select_ets(C, Rt1)
    end.
select_ets(Cont, Rt) ->
    {M, C} = case ets:match(?MODULE, Cont, 10) of
        '$end_of_table' -> {[], '$end_of_table'};
        R -> R
    end,
    case C of
        '$end_of_table' ->
            get_extra_val(M, Rt);
        false ->
            Rt1 = get_extra_val(M, Rt),
            select_ets(C, [Rt1|Rt])
    end.

get_extra_val([], Rt) -> Rt;
get_extra_val([H|T], Rt) ->
    [#extra{key         = Key
            ,type       = Type
            ,val        = Val
            ,content    = Content
            ,items      = Items
            ,start_time = Start
            ,end_time   = End
            ,list       = List}] = H,
    Time = util:unixtime(),
    ?INFO("H:~w",[H]),
    case Time >= Start andalso Time =< End of
        true ->
            %% ets:update_counter(?MODULE, Key, {#extra.count, 1}),
            get_extra_val(T, [{Key,Type,Val,Content,Items,List}|Rt]);
        false ->
            get_extra_val(T, Rt)
    end.

%% clean() ->
%%     extra ! clean_extra.

save() ->
    extra ! save_extra.

save_extra_ets() ->
    ?INFO("save_extra_ets(~w)...", [?MODULE]),
    gen_server:call(?MODULE, save_extra_ets).

%% === 服务器内部实现 ===

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    case filelib:is_file(?EXTRA_FILE_NAME) of
        true ->
            ets:file2tab(?EXTRA_FILE_NAME),
            ?INFO("Init extra! [size:~w, memory:~w]",
                [ets:info(?MODULE, size),
                    ets:info(?MODULE, memory)]),
            ok;
        false ->
            ets:new(?MODULE,
                [{keypos, #extra.key}, named_table, public, set]),
            ?INFO("New extra!", []),
            ok
    end,
    State = #state{},
    {ok, State}.

handle_call(save_extra_ets, _From, State) ->
    try
        ets:tab2file(?MODULE, ?EXTRA_FILE_NAME),
        ?INFO("Save extra ets:~p",
            [ets:info(?MODULE, size)]),
        {reply, ok, State}
    catch
        TT:X ->
            ?ERR("[~p:~p]", [TT, X]),
            {reply, error, State}
    end;

%% handle_call({set_extra_2, Key, Val,Content,Items,Start_time,End_time}, _From, State) ->
%%     Custom = #extra{
%%         key = Key
%%         ,val = Val
%%         ,content = Content
%%         ,items = Items
%%         ,start_time = Start_time
%%         ,end_time = End_time
%%     },
%%     ets:insert(?MODULE, Custom),
%%     {reply, ok, State};

handle_call(_Request, _From, State) ->
    ?INFO("Undefined request:~p", [_Request]),
    {reply, ok, State}.

handle_cast({set_extra,Type,Val,Content,Items,Start_time,End_time}, State) ->
    Key = ets:info(?MODULE, size),
    NewKey = get_new_key(Key),
    Extra = #extra{
        key         = NewKey
        ,type       = Type
        ,val        = Val
        ,content    = Content
        ,items      = Items
        ,start_time = Start_time
        ,end_time   = End_time
    },
    ets:insert(?MODULE, Extra),
    {noreply, State};

handle_cast({use_extra, Arg1, Arg2, Rid}, State) ->
    %% ets:match(?MODULE,{{'_',Type},'$1','$2','$3'}) {key,type}为键
    case extra:get() of
        [] -> ok;
        L ->
            case extra_send(L, Arg1, Arg2, Rid) of
                ok -> ok;
                Key ->
                    case ets:lookup(?MODULE, Key) of
                        [#extra{
                                type        = Type
                                ,val        = Val
                                ,content    = Content
                                ,items      = Items
                                ,list       = List
                                ,start_time = S
                                ,end_time   = E
                                ,count      = Count}] ->
                            Extra = #extra{
                                key         = Key
                                ,type       = Type
                                ,val        = Val
                                ,content    = Content
                                ,items      = Items
                                ,list       = [Rid | List]
                                ,start_time = S
                                ,end_time   = E
                                ,count      = Count
                                ,save       = 1
                            },
                            ets:insert(?MODULE, Extra),
                            ets:update_counter(?MODULE, Key, {#extra.count, 1}),
                            ok;
                        [] -> ok;
                        Else ->
                            ?WARNING("Undefined add_extra value: ~w", [Else]),
                            ok
                    end
            end
    end,
    {noreply, State};

%% handle_cast({use_extra, Key, Rid}, State) ->
%%     case ets:lookup(?MODULE, Key) of
%%         [#extra{val = Val, content = Content
%%                 ,items = Items, list = List
%%                 ,start_time = S, end_time = E
%%                 ,count = Count}] ->
%%             Custom = #extra{
%%                 key = Key
%%                 ,val = Val
%%                 ,content = Content
%%                 ,items = Items
%%                 ,list = [Rid | List]
%%                 ,start_time = S
%%                 ,end_time = E
%%                 ,count = Count
%%                 ,save = 1
%%             },
%%             ets:insert(?MODULE, Custom),
%%             ets:update_counter(?MODULE, Key, {#extra.count, 1}),
%%             ok;
%%         [] -> ok;
%%         Else ->
%%             ?WARNING("Undefined add_extra value: ~w", [Else]),
%%             ok
%%     end,
%%     {noreply, State};

handle_cast(_Msg, State) ->
    ?INFO("undefined msg:~p", [_Msg]),
    {noreply, State}.

handle_info({save_today_extra, Key}, State) ->
    Ctime = util:unixtime(),
    case ets:lookup(?MODULE, Key) of
        [#extra{type        = Type
                ,val        = Val
                ,content    = Content
                ,items      = Items
                ,list       = List
                ,start_time = S
                ,end_time   = E
                ,count      = Count}] ->
            util:test1(),
            I2 = mod_mail:items_list2(Items, []),
            Sql = list_to_binary([
                    <<"INSERT `log_extra_stat` (`key`, `type`, `start_time`, "
                    "`end_time`, `val`, `use_list`, "
                    "`body`, `items`, `count`, `ctime`) VALUES (">>
                    ,integer_to_list(Key),<<",'">>
                    ,atom_to_list(Type),<<"',">>
                    ,integer_to_list(S),<<",">>
                    ,integer_to_list(E),<<",'">>
                    ,?ESC_SINGLE_QUOTES(val_zip(Val)),<<"','">>
                    ,?ESC_SINGLE_QUOTES(zip(List)),<<"','">>
                    ,Content,<<"','">>
                    ,?ESC_SINGLE_QUOTES(mod_mail:mail_zip(I2)),<<"',">>
                    ,integer_to_list(Count),<<",">>
                    ,integer_to_list(Ctime),<<")">>
                ]),
            %% ?INFO("Sql:~W", [Sql,999]),
            case db:execute(Sql) of
                {ok, _} -> ok;
                {error, Reason} ->
                    ?WARN("Reason:~w", [Reason]),
                    ok
            end,
            ets:update_element(?MODULE, Key, {#extra.save, 0}),
            ets:update_element(?MODULE, Key, {#extra.count, 0}),
            util:test2("save_today_extra "),
            ok;
        _ -> ok
    end,
    {noreply, State};

handle_info(save_extra, State) ->
    save_extra(),
    {noreply, State};

%% handle_info(clean_extra, State) ->
%%     clean_extra(),
%%     {noreply, State};

handle_info(_Info, State) ->
    ?INFO("undefined info:~p", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -- 内部函数 --

save_extra() ->
    util:test1(),
    ets:safe_fixtable(?MODULE,true),
    save_extra(ets:first(?MODULE)),
    ets:safe_fixtable(?MODULE,false),
    util:test2("save extra").

save_extra('$end_of_table') ->
    true;
save_extra(Key) ->
    ?INFO("Key:~w", [Key]),
    case ets:lookup(?MODULE, Key) of
        [#extra{end_time = End, save = Save}] ->
            case Save of
                1 ->
                    self() ! {save_today_extra, Key},
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
    save_extra(ets:next(?MODULE, Key)).

%%' extra send
extra_send([], _, _, _) -> ok;
extra_send([{Key,Type,Val,Content,_Items,_List}|T], Arg1, Arg2, Rid) ->
    case Type of
        Arg1 when Arg1 == rmb orelse Arg1 == tollgate orelse Arg1 == hero orelse Arg1 == luck orelse Arg1 == colosseum ->
            case lists:keyfind(Arg2,1,Val) of
                false ->
                    extra_send(T,Arg1,Arg2,Rid);
                {Arg2,Arg3} ->
                    Title = data_text:get(2),
                    %% Body = data_text:get(27),
                    %% Body2 = io_lib:format(Content, [Arg3]),
                    Arg4 = set_format(Arg3,Arg1,Arg2,[]),
                    Body2 = io_lib:format(Content, Arg4),
                    mod_mail:new_mail(Rid, 0, 59, Title, Body2, Arg3),
                    Key
            end;
        Arg1 when Arg1 == coliseum ->
            %% Title = data_text:get(2),
            %% Body = data_text:get(27),
            %% Body2 = io_lib:format(Content, [Arg3]),
            %% mod_mail:new_mail(Rid, 0, 59, Title, Body2, Arg3),
            extra_send_coliseum(Arg2,Content,Val),
            Key;
        _ -> extra_send(T,Arg1,Arg2,Rid)
    end;
extra_send(_, _, _, _) -> ok.

extra_send_coliseum(RankList,Content,Val) ->
    RankList2 = lists:keysort(1,RankList),
    RankList3 = lists:sublist(RankList2, 10),
    F = fun(I,N) ->
            IdL  = integer_to_list(I),
            NaL = ?ESC_SINGLE_QUOTES(list_to_binary("^." ++ IdL ++ ".$")),
            case N == NaL of
                true -> 0;
                false -> 1
            end
    end,
    RankList4 = [{Pos, Rid} || {Pos,_,Rid,Name,_,_} <- RankList3, F(Rid,Name) =/= 0],
    extra_send_coliseum1(RankList4,Content,Val).

extra_send_coliseum1([],_,_) -> ok;
extra_send_coliseum1([{Pos,Rid}|Rest],Content,Val) ->
    case lists:keyfind(Pos,1,Val) of
        false -> extra_send_coliseum1(Rest,Content,Val);
        Prize ->
            Title = data_text:get(2),
            %% Body = data_text:get(28),
            %% Body2 = io_lib:format(Content, Prize),
            Arg4 = set_format(Prize,0,Pos,[]),
            Body2 = io_lib:format(Content, Arg4),
            mod_mail:new_mail(Rid, 0, 59, Title, Body2, Prize),
            ?INFO("[ANDROID COLISEUM TOP RANK SEND PRIZE] RID:~w Pos:~w", [Rid,Pos]),
            extra_send_coliseum1(Rest,Content,Val)
    end.

set_format([], hero, Arg2, Rt) ->
    HName = case Arg2 of
        30015 -> <<"恶魔猎手">>;
        30016 -> <<"枪神女警">>;
        30022 -> <<"寒冰射手">>;
        30024 -> <<"矮人飞机">>;
        30025 -> <<"熊猫">>;
        30012 -> <<"盖哥">>;
        30013 -> <<"山丘之王">>;
        30023 -> <<"黑暗游侠">>;
        _ -> <<>>
    end,
    Rt1 = lists:reverse(Rt),
    [HName|Rt1];
set_format([], rmb, Arg2, Rt) ->
    Rt1 = lists:reverse(Rt),
    [Arg2|Rt1];
set_format([], _Arg1, Arg2, Rt) ->
    Rt1 = lists:reverse(Rt),
    [Arg2|Rt1];
set_format([{_Id,Num}|T],Arg1,Arg2,Rt) ->
    set_format(T,Arg1,Arg2,[Num|Rt]).

%%.

%% clean_extra() ->
%%     util:test1(),
%%     ets:safe_fixtable(?MODULE,true),
%%     clean_extra(ets:first(?MODULE)),
%%     ets:safe_fixtable(?MODULE,false),
%%     util:test2("clean extra").
%%
%% clean_extra('$end_of_table') ->
%%     true;
%% clean_extra(Key) ->
%%     case ets:lookup(?MODULE, Key) of
%%         [#extra{save = S, count = C}] ->
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
%%                     ets:update_element(?MODULE, Key, {#extra.count, C - 1})
%%             end;
%%         Else ->
%%             ?WARN("Error Cache Data: ~w", [Else])
%%     end,
%%     clean_extra(ets:next(?MODULE, Key)).

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

-define(EXTRA_ZIP_VERSION, 1).
zip([]) -> <<>>;
zip(List) ->
    Bin = list_to_binary(zip1(List, [])),
    <<?EXTRA_ZIP_VERSION:8, Bin/binary>>.
zip1([], Rt) -> Rt;
zip1([H|T], Rt) ->
    zip1(T, [<<H:32>>|Rt]).


%% val_unzip(<<>>) -> [];
%% val_unzip(Bin) ->
%%     <<Version:8, Bin1/binary>> = Bin,
%%     case Version of
%%         1 ->
%%             val_unzip1(Bin1, []);
%%         _ ->
%%             ?ERR("undefined version: ~w", [Version]),
%%             undefined
%%     end.
%% val_unzip1(<<>>, Rt) -> Rt;
%% val_unzip1(<<X1_:16, X1:X1_/binary, X2:32, X3:32, RestBin/binary>>, Rt) ->
%%     X11 = binary_to_atom(X1, utf8),
%%     val_unzip1(RestBin, [{X11, X2, X3}|Rt]).

-define(EXTRA_VAL_ZIP_VERSION, 1).
val_zip([]) -> <<>>;
val_zip(Val) ->
    Rt = list_to_binary(val_zip1(Val, [])),
    <<?EXTRA_VAL_ZIP_VERSION:8, Rt/binary>>.
val_zip1([], Rt) -> Rt;
val_zip1([{Arg1,Arg2}|T], Rt) ->
    Rt1 = val_zip2(Arg2, []),
    Rt2 = [<<Arg1:32>>] ++ Rt1,
    val_zip1(T, [Rt2|Rt]).
val_zip2([], Rt) -> Rt;
val_zip2([{Id,Num}|T], Rt) ->
    Rt1 = case Id of
        5 ->
            {H,Q} = Num,
            <<Id:32,H:32,Q:32>>;
        _ -> <<Id:32,Num:32>>
    end,
    val_zip2(T, [Rt1|Rt]).

%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
