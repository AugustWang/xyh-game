-module(mysql_assist).

-include("mysql.hrl").
%-include("logdb.hrl").
-include("db.hrl").



%%
%% Exported Functions
%%
-compile(export_all).



%% add by wenziyong
startlink() ->
	MySQLHostAddress = env:get(mysql_host),
	MySQLUserName = env:get(mysql_user),
	MySQLPassword  = env:get(mysql_pass),
	MySQLPort  = env:get(mysql_port),
	MySQLDbName  = env:get(mysql_name),		
	%% start driver and create a gamedb connect to pool
	mysql:start_link(?LOGINDB_CONNECT_POOL,MySQLHostAddress,MySQLPort,MySQLUserName,MySQLPassword,MySQLDbName,fun mysql:log_fun_for_server/4,utf8).



add_another_connections(PoolId, Host, Port, User, Password, Database, Encoding,LogFun,NewState) ->
	%% add by wenziyong, add another connections
	case mysql:add_connects_in_init(PoolId, Host, Port, User, Password, Database, Encoding, true,LogFun,NewState,?LOGINDB_CONNECT_NUM) of
		{ok, NewState1}->
			%% add two log db connects
			LogDbName  = env:get(log_mysql_name),
			case mysql:add_connects_in_init(?LOGIN_LOG_DB_CONNECT_POOL, Host, Port, User, Password, LogDbName, Encoding, true,LogFun,NewState1,?LOGIN_LOG_DB_CONNECT_NUM) of	
				{ok, NewState2}->
					NewState3 = loginMysqlProc:register_prepared_stats(NewState2),
					NewState4 = loginLogdbProc:register_prepared_stats(NewState3),
					
					{ok,NewState4};
				Err->
					Err
			end;
		Err->
			Err
	end.

