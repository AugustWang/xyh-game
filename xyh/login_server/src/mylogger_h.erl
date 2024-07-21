%%----------------------------------------------------
%% $Id$
%% 日志处理回调模块
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(mylogger_h).

-behaviour(gen_event).
-export([init/1,
        handle_event/2, handle_call/2, handle_info/2,
        terminate/2, code_change/3]).

%% This one is used when we are started directly.
init(File) ->
    process_flag(trap_exit, true),
    %% case file:open(File, [append, raw, {encoding, utf8}]) of
    case file:open(File, [append, {encoding, utf8}]) of
        {ok,Fd} ->
            {ok, {Fd, File, []}};
        Error ->
            io:format("\nmylogger file:open/2 error:~p", [Error]),
            Error
    end.

handle_event({error, _GL, Pid, Format, Arg, Module, Line}, {Fd, File, PrevHandler}) ->
    Event = io_format("~n~s ####~n ** Node == ~p~n" ++ Format
        ,[add_header(error, Pid, Module, Line), node(Pid)] ++ Arg
    ),
    io:format(Fd, Event, []),
    {ok, {Fd, File, PrevHandler}};

handle_event({warning, _GL, Pid, Format, Arg, Module, Line}, {Fd, File, PrevHandler}) ->
    Event = io_format("~s " ++ Format
        ,[add_header(warning, Pid, Module, Line) | Arg]
    ),
    io:format(Fd, Event, []),
    {ok, {Fd, File, PrevHandler}};

handle_event(_Msg, State) ->
    %% io:format("********** Unmatch event: ~w~n", [_Msg]),
    {ok, State}.

handle_info({'EXIT', Fd, _Reason}, {Fd, _File, PrevHandler}) ->
    case PrevHandler of
        [] ->
            remove_handler;
        _ ->
            {swap_handler, install_prev, [], PrevHandler, go_back}
    end;

handle_info(_Msg, State) ->
    %% io:format("********** Unmatch info: ~w~n", [_Msg]),
    {ok, State}.

handle_call(filename, {Fd, File, Prev}) ->
    {ok, File, {Fd, File, Prev}};

handle_call(_Query, State) ->
    {ok, {error, bad_query}, State}.

terminate(_Reason, State) ->
    case State of
        {Fd, _File, _Prev} ->
            ok = file:close(Fd);
        _ ->
            ok
    end,
    [].

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%% ------------------------------------------------------
%%% Misc. functions.
%%% ------------------------------------------------------

io_format(F, A) ->
    try io_lib:format(F, A) catch
        T:W ->
            error_logger:format(
                " ** ~p:~p~n ** ~p~n"
                ,[T, W, erlang:get_stacktrace()]
            )
    end.

add_header(Type, Pid, Module, Line) ->
    {{Y,Mo,D},{H,Mi,S}} = erlang:localtime(),
    io_lib:format(
        "## ~p ~p-~p-~p ~s:~s:~s[~p:~p] ~p"
		,[Type, Y, Mo, D, t(H), t(Mi), t(S), Module, Line, Pid]
    ).

t(X) when is_integer(X) ->
    t1(integer_to_list(X));
t(_) ->
    "".
t1([X]) -> [$0,X];
t1(X)   -> X.
