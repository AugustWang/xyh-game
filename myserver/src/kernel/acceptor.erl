%%----------------------------------------------------
%% $Id: acceptor.erl 12897 2014-05-20 02:18:27Z piaohua $
%% @doc Socket连接服务
%% @author Rolong<rolong@vip.qq.com>
%% @end
%%----------------------------------------------------

-module(acceptor).

-behaviour(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").

start_link(ListenSock) ->
    gen_server:start_link(?MODULE, [ListenSock], []).

init([LSock]) ->
    ?INFO("start ~w(~w)...", [?MODULE, LSock]),
    Handshaking = <<"ABCDEFGHIJKLMN876543210">>,
    self() ! {event, start},
    {ok, {LSock, Handshaking}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({event, start}, State = {LSock, Handshaking}) ->
    case gen_tcp:accept(LSock) of
        {ok, Socket} ->
            Pid = spawn(fun() -> new_conn(Socket, Handshaking) end),
            io:format(".", []),
            case gen_tcp:controlling_process(Socket, Pid) of
                ok -> Pid ! start;
                _Reason ->
                    ?ERR("Error when controlling_process:~w", [_Reason]),
                    Pid ! exit
            end,
            self() ! {event, start},
            {noreply, State};
        {error, Reason} ->
            ?INFO("Error when starting acceptor: ~p", [Reason]),
            {stop, Reason, State}
    end;

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    ?INFO("Unexpected info: ~w", [_Info]),
    {noreply, State}.

terminate(Reason, _State) ->
    ?INFO("terminate ~w: ~w", [?MODULE, Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --- 私有函数 ------------------------------

%% 开始新连接
new_conn(Socket, Handshaking) ->
    receive
        start ->
            new_conn0(Socket, Handshaking);
        _Else ->
            ?WARN("Unexpected data: ~w", [_Else]),
            gen_tcp:close(Socket)
    end.

%% 开始新连接
new_conn0(Socket, Handshaking) ->
    case gen_tcp:recv(Socket, 23, 6000) of
        %% 客户端握手消息
        {ok, Handshaking} ->
            %% ?INFO("Socket:~w, Handshaking:~w", [Socket, Handshaking]),
            send_version(Socket),
            new_conn1(Socket);
        {ok, Data} ->
            ?INFO("Unexpected Handshaking:~w", [Data]),
            gen_tcp:close(Socket);
        {error, closed} ->
            ?DEBUG("closed:~w", [Socket]),
            gen_tcp:close(Socket);
        _Else ->
            ?INFO("Unexpected message when new_conn: ~w", [_Else]),
            gen_tcp:close(Socket)
    end.

%% 检查在线人数是否达到了上限
new_conn1(Socket) ->
    %% 过载处理
    case overload:request() of
        accept ->
            OnlineMax = env:get(online_max),
            case ets:info(online, size) >= OnlineMax of
                true ->
                    io:format("~n*** Reached Top Online: ~w ***~n", [OnlineMax]),
                    %% 在线人数达到上限，发送限制登陆通知
                    sender:send_error(Socket, 1003),
                    util:sleep(500), %% 等待消息发送完毕后再关闭Socket
                    gen_tcp:close(Socket);
                false -> new_conn2(Socket)
            end;
        reject ->
            io:format("~n*** overload ***~n", []),
            %% 系统繁忙，发送限制登陆通知
            sender:send_error(Socket, 1004),
            util:sleep(500), %% 等待消息发送完毕后再关闭Socket
            gen_tcp:close(Socket)
    end.


%% 创建角色进程
new_conn2(Socket) ->
    case role:create(Socket) of
        {ok, PidRole} ->
            case gen_tcp:controlling_process(Socket, PidRole) of
                ok -> PidRole ! {event, start_client};
                Reason ->
                    ?ERR("error when controlling_process:~w, self():~w, PidRole:~w",
                        [Reason, self(), PidRole]),
                    PidRole ! {event, stop},
                    gen_tcp:close(Socket)
            end;
        Any ->
            ?DEBUG("error when create role process:~w", [Any]),
            gen_tcp:close(Socket)
    end.

send_version(Socket) ->
    V = data_config:get(version),
    Version = list_to_binary(V),
    Url = env:get(update_url),
    {ok, Bin} = pt_pack:p(10000, [Version, Url]),
    ?DEBUG("Version:~s, Url:~s", [Version, Url]),
    gen_tcp:send(Socket, Bin).


%% vim: set ft=erlang foldmethod=marker foldmarker=%%',%%.:
