%% $Id$
%% @doc Shell Default Cmd
%% @author rolong@vip.qq.com
%% @end

-module(user_default).
-export([
    c/0
    ,c/1
    ,u/0
    ,u/1
    ,m/0
    ,d/0
    ,online/0
    ,l/0
    ,l/1
	,ph/0
	,ph/1
    ,show_rs/1
    % -- tracer --
    ,p/1
    ,t/1
    ,t/2
    ,t/3
    ,s/0
    ,stop/0
    ,doc/0
    ,show_rr/0
    ,cast/1
    ,top/0
    ]).

-include("common.hrl").
-include("offline.hrl").

top() ->
    case erlang:whereis(etop_server) of
        undefined ->
            ?INFO("Start top ..."),
            spawn(fun() ->
                        etop:start([
                                {output, text},
                                {interval, 15},
                                {lines, 30},
                                {sort,runtime }
                            ])
                end);
        _ ->
            ?INFO("Stop top!"),
            etop:stop()
    end.

cast(Cmd) ->
    sender:cast_info(world, Cmd, []).

show_rr() ->
    io:format("rr(\"~s\").~n", ["include/common.hrl"]),
    io:format("rr(\"~s\").~n", ["include/s.hrl"]),
    io:format("rr(\"~s\").~n", ["include/hero.hrl"]),
    io:format("rr(\"~s\").~n", ["include/offline.hrl"]),
    ok.

%%' 强制让所有玩家下线
stop() ->
    sender:cast_error(1001),
    listener:stop(),
    Pid = spawn(fun() -> stop_loop(online) end),
    Pid ! logout_ok,
    starting.

stop_loop(Tab) ->
    receive
        logout_ok ->
            case Tab of
                online ->
                    case ets:first(Tab) of
                        '$end_of_table' ->
                            self() ! logout_ok,
                            stop_loop(offline);
                        Rid ->
                            io:format("-~w", [Rid]),
                            send_shutdown1(Rid),
                            stop_loop(Tab)
                    end;
                offline ->
                    case ets:first(Tab) of
                        '$end_of_table' ->
                            lib_role:online_check();
                        Aid ->
                            io:format(">~s", [Aid]),
                            send_shutdown2(Aid),
                            stop_loop(Tab)
                    end
            end
    after 30000 ->
            lib_role:online_check()
    end.

send_shutdown1(Rid) ->
    case ets:lookup(online, Rid) of
        [R] -> R#online.pid ! {shutdown, self()};
        [] -> false
    end.

send_shutdown2(Aid) ->
    case ets:lookup(offline, Aid) of
        [R] -> R#offline.pid ! {shutdown, self()};
        [] -> false
    end.
%%.

%%  指定要监控的模块，函数，函数的参数个数
t(Mod)->
    dbg:tpl(Mod,[{'_', [], [{return_trace}]}]).


%%  指定要监控的模块，函数
t(Mod,Fun)->
    dbg:tpl(Mod,Fun,[{'_', [], [{return_trace}]}]).


%%  指定要监控的模块，函数，函数的参数个数
t(Mod,Fun,Ari)->
    dbg:tpl(Mod,Fun,Ari,[{'_', [], [{return_trace}]}]).

%%开启tracer。Max是记录多少条数据
p(Max)->
    FuncStopTracer =
    fun
        (_, N) when N =:= Max-> % 记录累计到上限值，追踪器自动关闭
            dbg:stop_clear(),
            io:format("#WARNING >>>>>> dbg tracer stopped <<<<<<~n~n",[]);
        (Msg, N) ->
            case Msg of
                {trace, _Pid, call, Trace} ->
                    {M, F, A} = Trace,
                    io:format("###################~n",[]),
                    io:format("call [~p:~p,(~p)]~n", [M, F, A]),
                    io:format("###################~n",[]);
                {trace, _Pid, return_from, Trace, ReturnVal} ->
                    {M, F, A} = Trace,
                    io:format("===================~n",[]),
                    io:format("return [~p:~p(~p)] =====>~p~n", [M, F, A, ReturnVal]),
                    io:format("===================~n",[]);
                _ ->
                    io:format("~n========== TRACER ==========~n",[]),
                    io:format("~p~n", [Msg])

            end,
            N + 1
    end,
    case dbg:tracer(process, {FuncStopTracer, 0}) of
        {ok, _Pid} ->
            dbg:p(new, [m]);
        {error, already_started} ->
            skip

    end.

s()->
    dbg:stop_clear().

d() ->
    case env:get(debug) of
        on -> myenv:set(debug, off), debug_off;
        _ -> myenv:set(debug, on), debug_on
    end.

show_rs(Id) ->
    case lib_role:get_role_pid(role_id, Id) of
        false -> false;
        Pid -> Pid ! {pt, 1005, []}
    end.

l() -> robot:login(1).
l(Id) -> robot:login(Id).

ph() -> robot:login(100, robot_handle_p).
ph(Id) -> robot:login(Id, robot_handle_p).

c() -> update:check().
c(A) -> update:check(A).

u() -> update:update(5).
u(A) -> update:update(A).

m() ->
    %% pt_tool:main(),
    update:update(m).

%% @doc 查看在线信息
-spec online() -> ok.
online() ->
    L1 = ets:info(online),
    L2 = ets:info(offline),
    io:format("~p~n~p", [L1, L2]).

%% @doc 生成文档
-spec doc() -> ok.
doc() ->
    code:add_patha("c:/work/mst/myserver"),
    %% code:add_patha("/data/myserver"),
    edoc:application(myserver, [{packages, true}]),
    ok.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
