%% -------------------------------------------------
%% $Id$
%% @doc 游戏引擎启动器
%% @author Rolong<rolong@vip.qq.com>
%% -------------------------------------------------

-module(server).
-export([start/0, stop/0, restart/0]).

-define(APPS, [login_server]).

start() ->
    try
        ok = start_applications(?APPS) 
    after
        timer:sleep(100)
    end.

stop() ->
    stop_applications(?APPS),
    erlang:halt().

restart() ->
    stop_applications(?APPS),
    start_applications(?APPS),
    ok.

manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
    F = fun (App, Acc) ->
                case Do(App) of
                    ok -> [App | Acc];
                    {error, {SkipError, _}} -> Acc;
                    {error, Reason} ->
                        lists:foreach(Undo, Acc),
                        throw({error, {ErrorTag, App, Reason}})
                end
        end,
    Iterate(F, [], Apps),
    ok.

start_applications(Apps) ->
    manage_applications(
        fun lists:foldl/3,
        fun application:start/1,
        fun application:stop/1,
        already_started,
        cannot_start_application,
        Apps
    ).

stop_applications(Apps) ->
    manage_applications(
      fun lists:foldr/3,
      fun application:stop/1,
      fun application:start/1,
      not_started,
      cannot_stop_application,
      Apps
     ).
