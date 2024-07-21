%%----------------------------------------------------
%% $Id: listener.erl 10102 2014-03-15 02:02:11Z rolong $
%% @doc Socket监听服务
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(listener).
-behaviour(gen_server).
-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
        listener, %% 监听SOCKET
        acceptor,
        handle
    }).

-include("common.hrl").
-include("condition_compile.hrl").
-include("globalDef.hrl").

start_link(Name, Handle, Port) ->
    ?INFO("start ~w(~w, ~w, ~w)...", [?MODULE, Name, Handle, Port]),
    gen_server:start_link({local, Name}, ?MODULE, [Handle, Port], []).

init([Handle, Port]) ->
    process_flag(trap_exit, true),
    case gen_tcp:listen(Port, ?LISTEN_TCP_OPTIONS) of
        {ok, ListenSocket} ->
            {ok, Ref} = prim_inet:async_accept(ListenSocket, -1),
            {ok, #state{
                    listener = ListenSocket,
                    acceptor = Ref,
                    handle   = Handle
                }
            };
        {error, Reason} ->
            ?ERR("listener error:~p", [Reason]),
            {stop, Reason}
    end.

handle_call(Request, _From, State) ->
    ?WARN("Undefined Request: ~w", [Request]),
    {reply, error, State}.

handle_cast(Msg, State) ->
    ?WARN("Undefined Msg: ~w", [Msg]),
    {noreply, State}.

handle_info({inet_async, LSocket, Ref, {ok, CSocket}}, #state{
        listener = LSocket, 
        acceptor = Ref,
        handle = Handle
    } = State) ->
    try
        case set_sockopt(LSocket, CSocket) of
            ok -> ok;
            {error, Reason} -> exit({set_sockopt, Reason})
        end,
        {ok, Pid} = supervisor:start_child(Handle, [CSocket]),
        case gen_tcp:controlling_process(CSocket, Pid) of
            ok-> ok;
            {error, Reason2}->
                ?ERR("controlling_process error:~p",[Reason2])
        end,
        case inet:setopts(CSocket, ?TCP_OPTIONS) of
            ok-> ok;
            {error, Reason3} ->
                ?ERR("setopts error:~p",[Reason3])
        end,
        case prim_inet:async_accept(LSocket, -1) of
            {ok, NewRef} -> 
                {noreply, State#state{acceptor=NewRef}};
            {error, Reason4} -> 
                ?ERR("async_accept error: ~w", [Reason4]),
                {noreply, State}
        end
    catch 
        T : X ->
            ?ERR("Error in async accept. ~w:~w",[T, X]),
            {noreply, State}
    end;

handle_info({inet_async, LSocket, Ref, Error}, #state{listener = LSocket, acceptor = Ref} = State) ->
    ?ERR("inet_async error: ~w",[Error]),
    {stop, Error, State};

handle_info(Info, State) ->
    ?INFO("Undefined Info: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, State) ->
    gen_tcp:close(State#state.listener),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

set_sockopt(LSocket, CSocket) ->
    true = inet_db:register_socket(CSocket, inet_tcp),
    case prim_inet:getopts(LSocket, [active, nodelay, keepalive, delay_send, priority, tos]) of
        {ok, Opts} ->
            case prim_inet:setopts(CSocket, Opts) of
                ok -> ok;
                Error -> 
                    gen_tcp:close(CSocket), 
                    Error
            end;
        Error ->
            gen_tcp:close(CSocket), 
            Error
    end.
