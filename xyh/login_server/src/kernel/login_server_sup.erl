%%----------------------------------------------------
%% $Id: login_server_sup.erl 10507 2014-03-20 12:04:38Z rolong $
%% @doc 监督树
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------

-module(login_server_sup).
-behaviour(supervisor).
-export([ start_link/0, init/1]).
-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    gen_event:swap_handler(alarm_handler, {alarm_handler, swap}, {myalarm_h, []}), 
    ClientPort = env:get(listen_to_user_port),
    GameServerPort = env:get(listen_to_game_server_port),
	Platform553Port = env:get(background553_port),
    {ok,
        {{one_for_one, 10, 3600},
            [
                %% 日志进程
                {mylogger, {mylogger, start_link, []}, permanent, 10000, worker, [mylogger]}
                %% 随机种子进程
                ,{myrandomseed, {myrandomseed, start_link, []}, permanent, 10000, worker, [myrandomseed]}
                %% MySQL数据库进程
                ,{mysql, {mysql, start_link, []}, permanent, 10000, worker, [mysql]}
                ,{main, {main, start_link, []}, permanent, 2000, worker, [main]}
                %% 面向角色的Socket监听服务
                ,{
                    role_listener, 
                    {listener, start_link, [role_listener, role_sup, ClientPort]}, 
                    permanent, 
                    10000, 
                    worker,  
                    [listener]
                }
                %% 面向游戏服务器的Socket监听服务
                ,{
                    game_server_listener, 
                    {listener, start_link, [game_server_listener, game_server_sup, GameServerPort]}, 
                    permanent,
                    10000,
                    worker,
                    [listener]
                }
                %% 角色Socket监督
                ,{
                    role_sup, 
                    {simple_sup, start_link, [role_sup, role]}, 
                    permanent, 
                    10000, 
                    supervisor, 
                    [simple_sup]
                }
                %% 游戏服务器Socket监督
                ,{
                    game_server_sup, 
                    {simple_sup, start_link, [game_server_sup, game_server]}, 
                    permanent, 
                    10000, 
                    supervisor, 
                    [simple_sup]
                }
                %% Must in the end
                %% 553平台监听服务
                ,{
                    background553_listener, 
                    {listener, start_link, [background553_listener, background553_sup, Platform553Port]}, 
                    permanent,
                    10000,
                    worker,
                    [listener]
                }
                %% 553平台Socket监督
                ,{
                    background553_sup, 
                    {simple_sup, start_link, [background553_sup, background553]}, 
                    permanent, 
                    10000, 
                    supervisor, 
                    [simple_sup]
                }
            ]
        }
    }.
