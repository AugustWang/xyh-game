%%----------------------------------------------------
%% $Id: acceptor_sup.erl 6604 2013-12-18 11:13:31Z rolong $
%% @doc Acceptor Supervisor
%% @author Rolong<erlang6@qq.com>
%% @end
%%----------------------------------------------------
-module(acceptor_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

-include("common.hrl").

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ?INFO("start ~w...", [?MODULE]),
    {ok, {
            {simple_one_for_one, 5, 1},
            [
                {acceptor, {acceptor, start_link, []}, 
                    transient, 2000, worker, [acceptor]}
            ]
        }
    }.
