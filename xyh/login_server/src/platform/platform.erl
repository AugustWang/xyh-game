%%----------------------------------------------------
%% $Id$
%% @doc 平台支持
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(platform).

-include("common.hrl").
-include("platformDefine.hrl").

-export([init/0]).

init()->
	%% 创建支持平台的ets表
	inets:start(),
	ssl:start(),
	httpc:set_options([]),
    ets:new( 'platformtable', [named_table,protected, { keypos, #platformTable.platformID }] ),
	load_platforms(),
	ok.

%%启动平台函数
load_platforms()->
    List = env:get(platforms),
	load_platforms1(List).

load_platforms1([])->
	ok;
load_platforms1([{Id, Ip, Port} | T])->
	load_platform(Id, Ip, Port),
	load_platforms1(T).

load_platform(?PLATFORM_TEST,IP,Port)->
	platform553:init_test({IP, Port}),
	{ok,0};
load_platform(?PLATFORM_553,IP,Port)->
	platform553:init({IP, Port}),
	{ok,0};
load_platform(?PLATFORM_553_android,IP,Port)->
	platform553:init_android({IP, Port}),
	{ok,0};
load_platform(?PLATFORM_APPS,IP,Port)->
	platformAPPS:init({IP, Port}),
	{ok,0};
load_platform(?PLATFORM_360,IP,Port)->
	platform360:init({IP, Port}),
	{ok,0};
load_platform(_, _IP, _Port)->
	{ok,0}.
