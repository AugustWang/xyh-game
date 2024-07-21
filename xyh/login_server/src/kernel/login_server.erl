%% -------------------------------------------------
%% $Id: login_server.erl 10102 2014-03-15 02:02:11Z rolong $
%% application
%% @author Rolong<rolong@vip.qq.com>
%% -------------------------------------------------

-module(login_server).

-behaviour(application).

-export([
        start/2,
        stop/1
    ]).

start(_Type, _StartArgs) ->
    %% 初始化环境变量
    myenv:init(),
    case login_server_sup:start_link() of
        {ok,Pid}->
            %% 初始化日志记录
            LogFileName = "log/login_server_runtime_error.log",
            CustomLogFileName = "log/login_server_custom_error.log",
            error_logger:logfile({open, LogFileName}),
            mylogger:logfile({open, CustomLogFileName}),
            {ok,Pid};
        {error, Error} -> 
            {error, Error}
    end.

stop(_State)->
    ok.
