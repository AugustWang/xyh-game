%%----------------------------------------------------
%% $Id$
%% @doc 常用的通用Erlang工具包
%% @author rolong@vip.qq.com
%% @end
%%----------------------------------------------------

-module(t).
-export([
        doc/0
        ,sys_info/0
    ]).

-include("common.hrl").

%% @doc 生成文档
doc() ->
    code:add_patha("C:/work/mst/myserver"),
    edoc:application(myserver, [{packages, true}]).

%% @doc 输出系统信息, 具体内容见log/sys_info_xxxx.log文件
sys_info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    Info = io_lib:format( "abormal termination:
        ~n   Scheduler id:                         ~p
        ~n   Num scheduler:                        ~p
        ~n   Process count:                        ~p
        ~n   Process limit:                        ~p
        ~n   Memory used by erlang processes:      ~p
        ~n   Memory allocated by erlang processes: ~p
        ~n   The total amount of memory allocated: ~p
        ~n",
        [SchedId, SchedNum, ProcCount, ProcLimit,
            ProcMemUsed, ProcMemAlloc, MemTot]),
    {{Y, M, D}, {H, M2, S}} = erlang:localtime(),
    F = fun(Int) ->
        case Int < 10 of
            true -> "0" ++integer_to_list(Int);
            false -> integer_to_list(Int)
        end
    end,
    DateStr = lists:concat([[F(X) || X <- [Y, M, D]], "_", [F(X) || X <- [H, M2, S]]]),
    File1 = "log/sys_info_" ++ DateStr ++ ".log",
    A = lists:foldl( fun(P, Acc0) -> [{P, erlang:process_info(P, registered_name), erlang:process_info(P, memory), erlang:process_info(P, message_queue_len), erlang:process_info(P, current_function), erlang:process_info(P, initial_call)} | Acc0] end, [], erlang:processes()),
    B = io_lib:format("~s~n~p", [Info, A]),
    file:write_file(File1, B),
    io:format("~s", [Info]),
    ok.

%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
