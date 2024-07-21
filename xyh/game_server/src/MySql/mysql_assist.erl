-module(mysql_assist).

-include("mysql.hrl").
-include("logdb.hrl").
-include("common.hrl").
-include("db.hrl").

-define(IsJustForTest, false).

-compile(export_all).

startlink() ->
	case ?IsJustForTest of
		false->
            MySQLHostAddress = env:get(mysql_host),
			MySQLUserName = env:get(mysql_user),
			MySQLPassword = env:get(mysql_pass),
			MySQLPort  = env:get(mysql_port),
			MySQLDbName  = env:get(mysql_name),		
			%% start driver and create a gamedb connect to pool
			mysql:start_link(?GAMEDB_CONNECT_POOL,MySQLHostAddress,MySQLPort,MySQLUserName,MySQLPassword,MySQLDbName,fun mysql:log_fun_for_server/4,utf8);
		true->
			%% just for test and create a test connect to pool
    		mysql:start_link(p1, "192.168.1.10", undefined,"root", "bear", "test",fun mysql:log_fun_example/4,utf8)
	end.

add_another_connections(PoolId, Host, Port, User, Password, Database, Encoding,LogFun,NewState) ->
	case ?IsJustForTest of
	false->
		case mysql:add_connects_in_init(PoolId, Host, Port, User, Password, Database, Encoding, true,LogFun,NewState,?GAMEDB_CONNECT_NUM) of
		{ok, NewState1}->
			%% add two log db connects
			LogDbName  = env:get(log_mysql_name),
			case mysql:add_connects_in_init(?LOGDB_CONNECT_POOL, Host, Port, User, Password, LogDbName, Encoding, true,LogFun,NewState1,?LOGDB_CONNECT_NUM) of	
				{ok, NewState2}->
                    PublicDbHostAddress = env:get(mysql_host),
                    PublicDbUserName = env:get(mysql_user),
                    PublicDbPassword = env:get(mysql_pass),
                    PublicDbPort  = env:get(mysql_port),
                    PublicDbName  = env:get(mysql_name),		
					case mysql:add_connects_in_init(?PUBLICDB_CONNECT_POOL, PublicDbHostAddress, PublicDbPort, PublicDbUserName, PublicDbPassword, PublicDbName, Encoding, true,LogFun,NewState2,?PUBLIC_DB_CONNECT_NUM) of
						{ok, NewState3}->				
							NewState4 = mySqlProcess:register_prepared_stats(NewState3),
							NewState5 = logdbProcess:register_prepared_stats(NewState4),
							NewState6 = publicdbProcess:register_prepared_stats(NewState5),
							{ok,NewState6};
						Err->
							Err
					end;
					
					
				Err->
					Err
			end;
			%{ok, NewState1};
		Err->
    		Err
		end;
	true->
		%mysql_test:register_prepared_stats(), %% should write this in this file
		mysql:add_connects_in_init(PoolId, Host, Port, User, Password, Database, Encoding, true,LogFun,NewState,9)	
	end.

