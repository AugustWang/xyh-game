%%----------------------------------------------------
%% $Id: simple_sup.erl 10101 2014-03-15 02:01:41Z rolong $
%% @doc 角色Socket监督
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(simple_sup).
-behaviour(supervisor).
-export([start_link/2, init/1]).

start_link(Name, Handle) ->
    supervisor:start_link({local, Name}, ?MODULE, [Handle]).

init([Handle]) ->
    {ok,
        {
            {simple_one_for_one, 10, 3600},
            [
                {Handle, {Handle, start_link, []}, temporary, 10000,  worker, [Handle]}
            ]
        }
    }.
