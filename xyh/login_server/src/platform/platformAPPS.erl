%%----------------------------------------------------
%% $Id$
%% @doc 平台支持
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(platformAPPS).

-include("common.hrl").
-include("platformDefine.hrl").

-export([
        init/1
        ,is_support/0
    ]).

init({IP, Port})->
    ets:insert(platformtable,#platformTable{platformID=?PLATFORM_APPS,isSupport=1,ip=IP,port=Port}),
    ?INFO("~w supported: ~w", [?MODULE, ?PLATFORM_APPS]).

is_support()->
    case ets:lookup(platformtable, ?PLATFORM_APPS) of
        [{_,_,1,_,_} | _] -> yes;
        _ ->no
    end.


