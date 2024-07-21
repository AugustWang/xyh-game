%%---------------------------------------------------
%% $Id$
%% Erlang命令行工具
%% @author rolong@vip.qq.com
%%----------------------------------------------------

-module(user_default).

-export(
    [
        m/0
        ,u/0
        ,update/0
        ,update/1
        ,dt/1
        ,dt/2
        ,dt/3
        ,dp/1
        ,dstop/0
    ]
).

-record(node, {id, name, host, port}).

-include_lib("kernel/include/file.hrl").


%% 编译并更新5分钟内有修改的文件
m() ->
    update(m).

u() ->
    update().

update() -> update(5).

update(A) ->
    update(A, "").

update(m, Prefix) ->
    StartTime = util:unixtime(),
    info("----------makes----------", []),
    make:all(),
    EndTime = util:unixtime(),
    Time = EndTime - StartTime,
    info("Make Time : ~w s", [Time]),
    update(Time / 60, Prefix);

update(S, Prefix) when is_number(S) ->
    Path = get_path(),
    case file:list_dir(Path) of
        {ok, FileList} -> 
            T = util:ceil(S * 60) + 3,
            info("Time:~w s", [T]),
            Files = get_new_file(FileList, T),
            AllZone = [#node{id = 1, name = 'localhost'}],
            info("---------modules---------~n~w~n----------nodes----------", [Files]),
            loads(AllZone, Files, Prefix),
            util:term_to_string(Files);
        Any -> info("Error Dir: ~w", [Any])
    end;
update(Files, Prefix) when is_list(Files) ->
    AllZone = [#node{id = 1, name = 'myserver1@127.0.0.1'}],
    info("---------modules---------~n~w~n"
        "----------nodes----------", [Files]),
    loads(AllZone, Files, Prefix);
update(_, _) -> info("ERROR===> Badarg", []).

%% 更新到所有线路
loads([], _Files, _) -> 
    info("----------- ok ----------"),
    ok;
loads([_H | T], Files, Prefix) ->
    %% info("#~w -> ~s", [H#node.id, H#node.name]),
    %% rpc:cast(H#node.name, update, load, [Files]),
    load(Files, Prefix),
    loads(T, Files, Prefix).

get_new_file(Files, S) -> 
    get_new_file(get_path(), Files, S, []).
get_new_file(_Path, [], _S, Result) -> Result;
get_new_file(Path, [H | T], S, Result) ->
    NewResult = case string:tokens(H, ".") of
        [Left, Right] when Right =:= "beam" ->
            case file:read_file_info(Path ++ H) of
                {ok, FileInfo} -> 
                    Now = calendar:local_time(),
                    case calendar:time_difference(FileInfo#file_info.mtime, Now) of
                        {Days, Times} -> 
                            Seconds = calendar:time_to_seconds(Times), 
                            case Days =:= 0 andalso Seconds < S of
                                true ->
                                    FileName = list_to_atom(Left),
                                    [FileName | Result];
                                false -> Result
                            end;
                        _ -> Result
                    end;
                _ -> Result
            end;
        _ -> Result
    end,
    get_new_file(Path, T, S, NewResult).

load([], _Prefix) -> ok;
load([FileName1 | T], Prefix) ->
    FileName3 = case is_atom(FileName1) of
        true -> atom_to_list(FileName1);
        false -> FileName1
    end,
    case Prefix =/= "" andalso string:str(FileName3, Prefix) =/= 1 of
        true -> ok;
        false ->
            FileName = case is_list(FileName1) of
                true -> list_to_atom(FileName1);
                false -> FileName1
            end,
            {{Y, M, D}, {H, I, S}} = erlang:localtime(),
            TimeString = io_lib:format("[~w-~w-~w ~w:~w:~w]", [Y, M, D, H, I, S]),
            case code:soft_purge(FileName) of
                true -> 
                    case code:load_file(FileName) of
                        {module, _} -> 
                            info("loaded: ~s", [FileName]);
                        {error, What} -> 
                            case filelib:is_dir("update") of
                                false -> file:make_dir("update");
                                true -> skip
                            end,
                            LoadErrorInfo = io_lib:format("~s ERROR===> loading: ~w (~w)\n", [TimeString, FileName, What]),
                            info("~s", [LoadErrorInfo]),
                            file:write_file("update/error.txt", LoadErrorInfo, [append])
                    end;
                false -> 
                    case filelib:is_dir("update") of
                        false -> file:make_dir("update");
                        true -> skip
                    end,
                    PurgeErrorInfo = io_lib:format("~s ERROR===> Processes lingering : ~w \n", [TimeString, FileName]),
                    info("~s", [PurgeErrorInfo]),
                    file:write_file("update/error.txt", PurgeErrorInfo, [append]),
                    ok
            end
    end,
    load(T, Prefix).

get_path() ->
    [Path] = case filelib:is_dir("ebin") of
        true -> 
            %% 开发版ebin目录
            ["ebin"];
        false ->
            %% 发布版ebin目录
            Paths = code:get_path(),
            F = fun(P) ->
                    string:str(P, "/myserver-") > 0
            end,
            lists:filter(F, Paths)
    end,
    Path ++ "/".

info(V) ->
    info(V, []).
info(V, P) ->
    io:format(V ++ "~n", P).

%%  指定要监控的模块，函数，函数的参数个数
dt(Mod)->
    dbg:tpl(Mod,[{'_', [], [{return_trace}]}]).


%%  指定要监控的模块，函数
dt(Mod,Fun)->
    dbg:tpl(Mod,Fun,[{'_', [], [{return_trace}]}]).


%%  指定要监控的模块，函数，函数的参数个数
dt(Mod,Fun,Ari)->
    dbg:tpl(Mod,Fun,Ari,[{'_', [], [{return_trace}]}]).

%%开启tracer。Max是记录多少条数据
dp(Max)->
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

dstop()->
    dbg:stop_clear().
