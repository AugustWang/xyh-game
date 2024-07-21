%%----------------------------------------------------
%% $Id: listener.erl 7146 2013-12-26 05:16:05Z rolong $
%% @doc Socket监听服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(listener).
-behaviour(gen_server).
-export([start_link/1, start/0, stop/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

-record(state, {
        acceptor_pids = []
        ,acceptor_num = 10
        ,listen_socket
    }).

start_link(Port) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).

start() ->
    supervisor:start_child(myserver_sup, {acceptor_sup, {acceptor_sup, start_link, []}, permanent, 10000, supervisor, [acceptor_sup]}),
    Port = env:get(tcp_port),
    supervisor:start_child(myserver_sup, 
        {listener, {listener, start_link, [Port]}, permanent, 10000, worker, [listener]}
    ).

stop() ->
    ?INFO("stop ~w...", [?MODULE]),
    %% gen_server:cast(?MODULE, stop),
    %% util:sleep(500),
    supervisor:terminate_child(myserver_sup, acceptor_sup),
    %% supervisor:delete_child(myserver_sup, acceptor_sup),
    supervisor:terminate_child(myserver_sup, listener),
    %% supervisor:delete_child(myserver_sup, listener),
    ok.

init([Port]) ->
    ?INFO("start ~w...", [?MODULE]),
    process_flag(trap_exit, true),
    {ok, TcpOptions} = application:get_env(tcp_options),
    {ok, TcpAccpetorNum} = application:get_env(tcp_acceptor_num),
    case gen_tcp:listen(Port, TcpOptions) of
        {ok, LSock} ->
            self() ! start_acceptor,
            State = #state{
                acceptor_num = TcpAccpetorNum
                ,listen_socket = LSock
            },
            {ok, State};
        {error, Reason}->
            ?ERR("Can not listen ~w: ~w", [Port, Reason]),
            {stop, listen_failure, state}
    end.

handle_call(Request, _From, State) ->
    ?INFO("Undefined Request: ~w", [Request]),
    {noreply, State}.

handle_cast(stop, State) ->
    gen_tcp:close(State#state.listen_socket),
    %% F = fun(Pid) ->
    %%         Pid ! stop
    %% end,
    %% lists:map(F, State#state.acceptor_pids),
    %% {noreply, State#state{acceptor_pids = []}};
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(start_acceptor, State) ->
    #state{
        acceptor_num = Num
        ,listen_socket = ListenSock
    } = State,
    Pids = start_acceptor(Num, ListenSock, []),
    Pids1 = Pids ++ State#state.acceptor_pids,
    State1 = State#state{
        acceptor_pids = Pids1
    },
    {noreply, State1};

handle_info(Info, State) ->
    ?INFO("Undefined Info: ~w", [Info]),
    {noreply, State}.

terminate(Reason, _State) ->
    ?INFO("terminate ~w: ~w", [?MODULE, Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

start_acceptor(N, LSock, Rt) when N > 0 ->
    case supervisor:start_child(acceptor_sup, [LSock]) of
        {ok, Pid} -> 
            start_acceptor(N - 1, LSock, [Pid | Rt]);
        Else -> 
            ?WARN("~p", [Else]),
            Rt
    end;
start_acceptor(_Num, _LSock, Rt)->
    Rt.
