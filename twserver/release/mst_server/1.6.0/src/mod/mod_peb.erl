%% ------------------------------------------------------------------
%% $Id$
%% @doc Php Erlang Bridge：Php与Erlang交互通道，简称peb
%% @author Rolong<rolong@vip.qq.com>
%% @end
%% ------------------------------------------------------------------
-module(mod_peb).
-behaviour(gen_server).
-include("common.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-define(SERVER, peb).

-record(state, {
    }).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    State = #state{},
    {ok, State}.

handle_call(_Request, _From, State) ->
    ?INFO("Undefined request:~w", [_Request]),
    {reply, ok, State}.

handle_cast(Msg, State) ->
    ?INFO("Undefined msg:~w", [Msg]),
    {noreply, State}.

handle_info(_Info, State) ->
    ?INFO("Undefined info:~w", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
