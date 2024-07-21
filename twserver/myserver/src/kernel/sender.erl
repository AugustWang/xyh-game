%%----------------------------------------------------
%% $Id: sender.erl 6968 2013-12-23 04:22:37Z rolong $
%% @doc 数据发送API
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------
-module(sender).
-export(
    [
        send_info/2
        ,send_info/3
        ,cast_info/2
        ,cast_info/3
        ,pack_send/3
        ,pack_cast/3
        ,send_code/2
        ,send_error/2
        ,cast_code/1
        ,cast_error/1
    ]
).

-include("common.hrl").
-include("offline.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% @equiv send_info(Rid, Cmd, [])
%% @see send_info/3
send_info(Id, Cmd) ->
    send_info(Id, Cmd, []).

%% @doc 发送消息到角色进程(包括没有Socket连接的角色进程)
%% ```
%% Id为角色进程pid()时，直接发送，首选的发送方式。
%% Id为角色Id integer()时:
%%     1、如果角色在线，从ETS表中找到角色进程pid后发送；
%%     2、如果不在线，从数据库加载数据并创建角色进程后发送。
%% '''
-spec send_info(Id, Cmd, Data) -> ok | error when
    Id :: integer() | pid(),
    Cmd :: integer(),
    Data :: list().

send_info(Id, Cmd, Data) ->
    if
        is_integer(Id) ->
            case lib_role:get_role_pid(role_id, Id) of
                false -> error;
                Pid -> 
                    Pid ! {pt, Cmd, Data},
                    ok
            end;
        is_pid(Id) ->
            Id ! {pt, Cmd, Data},
            ok;
        true ->
            ?DEBUG("[SEND INFO] Error Id: ~w, Cmd: ~w, Data: ~w", 
                [Id, Cmd, Data]),
            error
    end.

%% @equiv send_info(Rid, Cmd, [])
%% @see send_info/3
cast_info(Type, Cmd) ->
    cast_info(Type, Cmd, []).

%% @doc 广播消息到角色进程(包括没有Socket连接的角色进程)
-spec cast_info(Type, Cmd, Data) -> any() when
    Type :: world,
    Cmd :: integer(),
    Data :: list().

cast_info(world, Cmd, Data) ->
    info_to_online({pt, Cmd, Data}),
    info_to_offline({pt, Cmd, Data}).

%% @doc 打包并发送消息
%% ```
%% Id为pid()时，通过指定的socket发包进程转发，首选的发送方式。
%% Id为Socket port()时，直接socket发送，速度最快的方式。
%% Id为integer()时，先在[在线表]中找到发送进程的pid后转发。
%% '''
-spec pack_send(Id, Cmd, Data) -> any() when
    Id :: pid() | port() | integer(),
    Cmd :: integer(),
    Data :: list().

pack_send(Id, Cmd, Data) ->
    case pt_pack:p(Cmd, Data) of
        {ok, Bin} ->
            if
                is_pid(Id) -> 
                    ?DEBUG("SEND [Cmd:~w, Data:~w]", [Cmd, Data]),
                    Id ! {data, Bin};
                is_port(Id) -> 
                    ?DEBUG("SEND [Cmd:~w, Data:~w]", [Cmd, Data]),
                    gen_tcp:send(Id, Bin);
                is_integer(Id) -> 
                    case ets:lookup(online, Id) of
                        [#online{pid_sender = Pid}] -> 
                            case is_pid(Pid) of
                                true ->
                                    ?DEBUG("SEND [Cmd:~w, Data:~w]", [Cmd, Data]),
                                    Pid ! {data, Bin};
                                false ->
                                    ok
                            end;
                        [] -> 
                            ok;
                        {error, Error} ->
                            ?WARN("[PACK SEND] Id:~w, Cmd:~w, Data:~w, Error:~w]", 
                                [Id, Cmd, Data, Error])
                    end;
                true ->
                    ?DEBUG("[PACK ERROR] Error Id:~w, Cmd:~w, Data:~w]", [Id, Cmd, Data])
            end;
        {error, Reason} ->
            ?WARN("[PACK ERROR] Cmd:~w, Data:~w, Reason:~w]", [Cmd, Data, Reason])
    end.

%% @doc 打包并广播数据到所有在线玩家
-spec pack_cast(Type, Cmd, Data) -> any() when
    Type :: world,
    Cmd :: integer(),
    Data :: list().

pack_cast(world, Cmd, Data) ->
    case pt_pack:p(Cmd, Data) of
        {ok, Bin} ->
            broadcast_to_online(Bin);
        {error, Reason} ->
            ?WARN("[PACK ERROR] Cmd:~w, Data:~w, Reason:~w]", [Cmd, Data, Reason])
    end.

%% @doc 发送消息代号，详见10001协议
-spec send_code(Id, Code) -> any() when
    Id :: pid() | port() | integer(),
    Code :: integer().

send_code(Id, Code) ->
    pack_send(Id, 10001, [1, Code]).

%% @doc 发送错误代号，详见10001协议
-spec send_error(Id, Code) -> any() when
    Id :: pid() | port() | integer(),
    Code :: integer().

send_error(Id, Code) ->
    pack_send(Id, 10001, [2, Code]).

%% @doc 广播消息代号，详见10001协议
-spec cast_code(Code) -> any() when
    Code :: integer().

cast_code(Code) ->
    pack_cast(world, 10001, [1, Code]).

%% @doc 广播错误代号，详见10001协议
-spec cast_error(Code) -> any() when
    Code :: integer().

cast_error(Code) ->
    pack_cast(world, 10001, [2, Code]).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

broadcast_to_online(Data) ->
    ets:foldl(fun broadcast_to_online1/2, Data, online).

broadcast_to_online1(#online{pid_sender = Pid}, Data) ->
    %% ?DEBUG("broadcast_to_online: ~w", [Pid]),
    case is_pid(Pid) of
        true -> Pid ! {data, Data};
        false -> ok
    end,
    Data.

info_to_online(Info) ->
    ets:foldl(fun info_to_online1/2, Info, online).

info_to_online1(#online{pid = Pid}, Info) ->
    %% ?DEBUG("info_to_online: ~w", [Pid]),
    case is_pid(Pid) of
        true -> Pid ! Info;
        false -> ok
    end,
    Info.

info_to_offline(Info) ->
    ets:foldl(fun info_to_offline1/2, Info, offline).

info_to_offline1(#offline{pid = Pid}, Info) ->
    %% ?DEBUG("info_to_offline: ~w", [Pid]),
    case is_pid(Pid) of
        true -> Pid ! Info;
        false -> ok
    end,
    Info.
