%% -------------------------------------------------
%% $Id: game_server.erl 10101 2014-03-15 02:01:41Z rolong $
%% application
%% @author Rolong<rolong@vip.qq.com>
%% -------------------------------------------------

-module(game_server).

-behaviour(application).

-export([
		 start/2,
		 stop/1,
         prep_stop/1
		]).

start(_Type,_StartArgs) ->
    %% 初始化环境变量
    myenv:init(),
	case game_server_sup:start_link() of
        {ok,Pid}->
            %% 初始化日志记录
            LogFileName = "log/game_server_runtime_error.log",
            CustomLogFileName = "log/game_server_custom_error.log",
            error_logger:logfile({open, LogFileName}),
            mylogger:logfile({open, CustomLogFileName}),
            {ok,Pid};
        {error, Error} -> 
            {error, Error}
	end.

prep_stop(_State) ->
	mySqlProcess:saveWorldVarArray(),
	timer:sleep(1000*5),
    ok.

stop(_State)->
	erlang:halt(),
	ok.
	
	

	
		
		
