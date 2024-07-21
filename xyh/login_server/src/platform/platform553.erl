%%----------------------------------------------------
%% $Id$
%% @doc 平台支持
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(platform553).

-include("common.hrl").
-include("platformDefine.hrl").

-export([
        init_test/1
        ,init/1
        ,init_android/1
        ,is_test_support/0
        ,is_support/0
        ,is_android_support/0
        ,is_test_check/0
    ]).

init_test({IP, Port})->
    ets:insert(platformtable,#platformTable{platformID=?PLATFORM_TEST,isSupport=1,ip=IP,port=Port}),
    ?INFO("~w supported: ~w", [?MODULE, ?PLATFORM_TEST]).

is_test_support()->
    case ets:lookup(platformtable, ?PLATFORM_TEST) of
        [{_,_,1,_,_} | _] -> yes;
        _ ->no
    end.

is_test_check()->
    env:get(platform_test_check) /= 0.

init({IP, Port})->
    ets:insert(platformtable,#platformTable{platformID=?PLATFORM_553,isSupport=1,ip=IP,port=Port}),
    ?INFO("~w supported: ~w", [?MODULE, ?PLATFORM_553]).


is_support()->
    case ets:lookup(platformtable, ?PLATFORM_553) of
        [{_,_,1,_,_} | _] -> yes;
        _ ->no
    end.

init_android({IP, Port})->
    ets:insert(platformtable,#platformTable{platformID=?PLATFORM_553_android,isSupport=1,ip=IP,port=Port}),
    ?INFO("~w supported: ~w", [?MODULE, ?PLATFORM_553_android]).

is_android_support()->
    case ets:lookup(platformtable, ?PLATFORM_553_android) of
        [{_,_,1,_,_} | _] -> yes;
        _ ->no
    end.
