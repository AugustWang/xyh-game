%% $Id: u.erl 10631 2014-03-22 10:45:44Z rolong $
%% @doc == Erlang模块热更新到所有线路（包括server的回调函数，如果对state有影响时慎用） ==
%% ```
%% 检查：u:c()                %% 列出前5分钟内编译过的文件
%%       u:c(N)               %% 列出前N分钟内编译过的文件
%%
%% 更新：u:u()                %% 更新前5分钟内编译过的文件
%%       u:u(N)               %% 更新前N分钟内编译过的文件
%%       u:u([mod_xx, ...])   %% 指定模块（不带后缀名）
%%       u:u(m)               %% 编译并加载文件
%%       u:m()                %% 编译并加载文件
%%
%% Tips: u - update, c - check
%% '''
%% @end
%% @author rolong@vip.qq.com

-module(u).
-export([
    make/0
    ,c/0
    ,c/1
    ,u/0
    ,u/1
    ,m/0
    ,d/0
    ,debug_on/0
    ,debug_off/0
    ,online/0
    ,l/0
    ,l/1
	,ph/0
	,ph/1
    ,show_rs/1
    ,svn/0
    ,update_client_data/0
    ,commit_client_data/0
    ,update_erlang_pt/0
    ,commit_erlang_pt/0
    ,update_erlang_data/0
    ,commit_erlang_data/0
    ,update_client_pt/0
    ,commit_client_pt/0
    ,make_and_update_data/0
    ,update_js/0
    ,commit_js/0
    ,db/0
    ,db_truncate/0
    ,print_map/1
    % -- tracer --
    ,p/1
    ,t/1
    ,t/2
    ,t/3
    ,s/0
    ,stop/0
    ,doc/0
    ,update_pw/0
    ,rr/0
    ,o/1
    ]).

-include("common.hrl").
-include("offline.hrl").
-include("platform.hrl").

%% 两位平台代号定义：
%% a = a_oppo
%% b = i_91
%% c = a_91
%% d = a_uc
%% e = a_wdj
%% f = a_hw
%% g = i_tb
%% h = i_pp
%% i = a_dl
%% j = a_360
%% k = a_lenovo
%% l = a_kp
%% m = a_xm
%% o = a_2funfun

%% 订单规则：
%% 产品ID-服务器Id-角色ID+平台代号-时间(秒,10位)
%% 如：1-10001-a1234-1403258483

%% 非iOS官方平台充值补单
o(Order) when is_list(Order) ->
    o(list_to_binary(Order));

o(Order) when is_binary(Order) ->
    ?INFO("Recv Order Notice:~p", [Order]),
    OrderL = binary_to_list(Order),
    case string:tokens(OrderL, "-") of
        [_ShopId, _ServerId, [P | RidL], _Time] ->
            case catch list_to_integer(RidL) of
                {'EXIT', Error} ->
                    ?INFO("~p", [Error]),
                    error_role_id;
                Rid ->
                    case util:find_platform(P) of
                        false -> error_platform_id;
                        {_, Platform} ->
                            case lib_role:get_role_pid(role_id, Rid) of
                                false -> error_role_id;
                                Pid ->
                                    Pid ! {pt, 2088, [Platform, Order, 1]},
                                    ok
                            end
                    end
            end;
        _ -> error_order
    end;
o(_Order) -> error_order.

rr() ->
    io:format("rr(\"~s\").~n", ["include/common.hrl"]),
    io:format("rr(\"~s\").~n", ["include/s.hrl"]),
    io:format("rr(\"~s\").~n", ["include/hero.hrl"]),
    io:format("rr(\"~s\").~n", ["include/offline.hrl"]),
    ok.

update_pw() ->
    {ok, Ids} = db:get_all("select id, password from role"),
    update_pw(Ids).
update_pw([[Id, undefined] | T]) ->
    db:execute("update role set password = ~s where id = ~s", [util:md5("123456"), Id]),
    update_pw(T);
update_pw([[Id, Pw] | T]) ->
    case byte_size(Pw) < 30 of
        true ->
            db:execute("update role set password = ~s where id = ~s", [util:md5(Pw), Id]);
        false -> ok
    end,
    update_pw(T);
update_pw([]) ->
    ok.

%%' 强制让所有玩家下线
stop() ->
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

print_map(MapId) ->
    Data = data_map:get(MapId),
    {Pos1, Pos2} = util:get_val(pos, Data),
    L1 = io_lib:format("~32.2.0B",[Pos1]),
    L2 = io_lib:format("~32.2.0B",[Pos2]),
    L = lists:flatten(L1 ++ L2),
    lists:foldl(fun(C, Index) ->
                        io:format("~s", [[C]]),
                        case Index rem 12 of
                            0 -> io:format("~n", []);
                            _ -> ok
                        end,
                        Index + 1
                end, 1, L),
    ok.

db_truncate() ->
    db:execute("truncate table role;"),
    db:execute("truncate table item;"),
    db:execute("truncate table hero;").

db() ->
    Sql = <<"alter table role add tollgate_id smallint(5) default 1 comment '关卡ID' after lev">>,
    db:execute(Sql).

%% update_client_data() ->
%%     Rt = os:cmd("svn update /home/default/web/simple_xls --username myserver --password 01 --no-auth-cache"),
%%     os:cmd("chown www:www /home/default/web/simple_xls/*.txt"),
%%     Rt.

svn() ->
    Re1 = update_js(),
    util:print("更新JavaScript："),
    util:print(Re1),
    Re2 = update_client_data(),
    util:print("更新客户端数据："),
    util:print(Re2),
    Re3 = update_client_pt(),
    util:print("更新客户端协议："),
    util:print(Re3),
    Re4 = update_erlang_data(),
    util:print("更新服务端数据："),
    util:print(Re4),
    Re5 = update_erlang_pt(),
    util:print("更新服务端协议："),
    util:print(Re5),
    Rt1 = commit_js(),
    util:print("提交JavaScript："),
    util:print(Rt1),
    Rt2 = commit_client_data(),
    util:print("提交客户端数据："),
    util:print(Rt2),
    Rt3 = commit_client_pt(),
    util:print("提交客户端协议："),
    util:print(Rt3),
    Rt4 = commit_erlang_data(),
    util:print("提交服务端数据："),
    util:print(Rt4),
    Rt5 = commit_erlang_pt(),
    util:print("提交服务端协议："),
    util:print(Rt5),
    ok.

-define(SVN_AUTH, " --username myserver --password 2funfun26076116 --no-auth-cache").
-define(XLS_PATH, "/home/2funfun.dev/web/simple_xls").
-define(JS_PATH, "/home/2funfun.dev/web/admin/js").

%% 更新EXCEL & TXT
update_client_data() ->
    Rt = os:cmd("svn update " ++ ?XLS_PATH ++ ?SVN_AUTH),
    os:cmd("chown www:www " ++ ?XLS_PATH ++ "/*.txt"),
    Rt.

update_js() ->
    Rt = os:cmd("svn update " ++ ?JS_PATH ++ ?SVN_AUTH),
    os:cmd("chown www:www " ++ ?JS_PATH ++ "/data*"),
    Rt.

commit_js() ->
    os:cmd("svn add -q " ++ ?JS_PATH ++ "/data*"),
    os:cmd("svn ci -m 'auto commit' " ++ ?JS_PATH ++ ?SVN_AUTH).

%% 提交 TXT
commit_client_data() ->
    os:cmd("svn add -q " ++ ?XLS_PATH ++ "/*.txt"),
    os:cmd("svn ci -m 'auto commit' " ++ ?XLS_PATH ++ ?SVN_AUTH).

update_client_pt() ->
    Rt = os:cmd("svn update /home/mst_client_data" ++ ?SVN_AUTH),
    os:cmd("chown -R www:www /home/mst_client_data"),
    Rt.

commit_client_pt() ->
    os:cmd("svn add -q /home/mst_client_data/c/* /home/mst_client_data/s/* /home/mst_client_data/vo/*" ++ ?SVN_AUTH),
    os:cmd("svn ci -m 'auto commit' /home/mst_client_data" ++ ?SVN_AUTH).

update_erlang_pt() ->
    Rt = os:cmd("svn update /home/myserver/src/pt" ++ ?SVN_AUTH),
    os:cmd("chown www:www /home/myserver/src/pt/pt_pack.erl"),
    os:cmd("chown www:www /home/myserver/src/pt/pt_unpack.erl"),
    Rt.

commit_erlang_pt() ->
    os:cmd("chown www:www /home/myserver/src/pt/pt_pack*"),
    os:cmd("chown www:www /home/myserver/src/pt/pt_unpack*"),
    os:cmd("svn ci -m 'auto commit' /home/myserver/src/pt" ++ ?SVN_AUTH).

update_erlang_data() ->
    Rt = os:cmd("svn update /home/myserver/src/data" ++ ?SVN_AUTH),
    os:cmd("chown www:www /home/myserver/src/data/*"),
    Rt.

commit_erlang_data() ->
    os:cmd("chown www:www /home/myserver/src/data/*.erl"),
    os:cmd("svn add -q /home/myserver/src/data/*.erl"),
    os:cmd("svn ci -m 'auto commit' /home/myserver/src/data" ++ ?SVN_AUTH).

%% SVN END

show_rs(Id) ->
    case lib_role:get_role_pid(role_id, Id) of
        false -> false;
        Pid -> Pid ! {pt, 1005, []}
    end.

l() -> robot:login(100).
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

make_and_update_data() ->
    StartTime = util:unixtime(),
    c:cd("./src/data"),
    io:format("--------make data--------~n", []),
    make:all(),
    c:cd("../../"),
    EndTime = util:unixtime(),
    Time = EndTime - StartTime,
    io:format("Make Time : ~w s~n", [Time]),
    update:update((Time / 60), "data_").

make() ->
    pt_tool:main(),
    os:cmd("./rebar compile").

%% 调试开关
debug_on() ->
    gen_event:notify(mylogger, {debug, on}),
    debug_on.

debug_off() ->
    gen_event:notify(mylogger, {debug, off}),
    debug_off.

%% 查看在线信息
online() ->
    L = ets:tab2list(online),
    do_online(L, 0),
    io:format("\n\nOnline role num: ~w\n\n", [length(L)]),
    ok.

do_online([O | T], Index) when Index < 30 ->
    io:format("\n#~-5w - ~ts", [O#online.id, O#online.name]),
    do_online(T, Index + 1);
do_online(_, _) -> ok.

doc() ->
    code:add_patha("C:/work/mst/myserver"),
    edoc:application(myserver, [{packages, true}]).

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
