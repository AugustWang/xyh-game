%% 版本号定义

-module(version).
-export([
        getMinProtocolVersion/0
        ,getDbVersion/0
        ,getServerVersion/0
    ]).

-include("version.hrl").


getMinProtocolVersion()->
    ?MIN_PROTOCOL_VERSION.

getDbVersion()->
    ?DBVersion.

getServerVersion()->
    ?ServerVersion.

