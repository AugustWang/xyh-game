%%---------------------------------------------------
%% $Id$
%% 常用宏定义
%% @author rolong@vip.qq.com
%%----------------------------------------------------

-ifndef(ERR).

-define(INFO(Msg), util:info(Msg, [], ?MODULE, ?LINE)).
-define(INFO(F, A), util:info(F, A, ?MODULE, ?LINE)).

-define(DEBUG(Msg), util:debug(Msg, [], ?MODULE, ?LINE)).
-define(DEBUG(F, A), util:debug(F, A, ?MODULE, ?LINE)).

-define(WARN(F), mylogger:notify(warning, F, [], ?MODULE, ?LINE)).
-define(WARN(F, A), mylogger:notify(warning, F, A, ?MODULE, ?LINE)).

-define(ERR(F), mylogger:notify(error, F, [], ?MODULE, ?LINE)).
-define(ERR(F, A), mylogger:notify(error, F, A, ?MODULE, ?LINE)).

-endif.
