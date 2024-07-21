%%----------------------------------------------------
%% $Id$
%% @doc 角色进程
%% @author Rolong<rolong@vip.qq.com>
%%----------------------------------------------------
-module(role).
-behaviour(gen_server).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------
-export([
        init/1
        ,handle_call/3
        ,handle_cast/2
        ,handle_info/2
        ,terminate/2
        ,code_change/3
    ]).

-record(state, {
        socket
        ,half_package = <<>>
    }).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([
        start_link/1
        ,getCurUserSocket/0
        ,getCurUserID/0
        ,getCurUserState/0
        ,setCurUserState/1
        ,getCurUserIP/0
        ,getCurUserSocketRecord/0
        ,send/1
        ,getCurUserSocketTable/0
    ]).


-include("common.hrl").
-include("db.hrl").
-include("userDefine.hrl").
-include("pc_LS2User.hrl").
-include("condition_compile.hrl").
-include("globalDef.hrl").

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Socket) ->
    gen_server:start_link(?MODULE, [Socket], [{timeout,?Start_Link_TimeOut_ms}]).

%%' 角色进程调用的函数

%%返回当前进程的UserSocket
getCurUserSocket()->
    case get("UserSocket") of
        undefined -> 0;
        UserSocket -> UserSocket
    end.

getCurUserIP()->
    get( "UserIP" ).


%%返回当前进程的UserSocketTable
getCurUserSocketTable()->
    case get("TableUserSocket") of
        undefined -> 0;
        TableUserSocket -> TableUserSocket
    end.

%%返回当前进程的userid
getCurUserID()->
    case get("UserID") of
        undefined->0;
        UserID -> UserID
    end.

getCurUserState()->
    case get("UserState") of
        undefined -> 0;
        UserState -> UserState
    end.	

setCurUserState(UserState)->
    OldState = get("UserState"),
    ?INFO( "user socket[~p] ~p change state old ~p new ~p", [getCurUserSocket(), getCurUserID(), OldState, UserState] ),
    put("UserState", UserState).

getCurUserSocketRecord() ->
    SocketTable = getCurUserSocketTable(),
    case SocketTable of
        0->{};
        _->etsBaseFunc:readRecord( getCurUserSocketTable(), getCurUserSocket() )
    end.

%%.


send( Msg )->
    msg_LS2User:send( getCurUserSocket(), Msg ).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([Socket]) ->
    %inet:setopts(Socket, ?TCP_OPTIONS),
    initUser( Socket ),
    %{ok, {IP, _Port}} = inet:peername(Socket),
    %{ok, #state{socket=Socket, addr=IP}}.
    {ok, #state{socket=Socket}}.

handle_call(_Request, _From, State) ->
    {noreply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, #state{socket=Socket}) ->
    logout(0),
    (catch gen_tcp:close(Socket)),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Socket消息处理
handle_info({tcp, Socket, Bin}, State)->
    Bin2 = case State#state.half_package of
        <<>> -> Bin;
        HalfPackge -> list_to_binary([HalfPackge, Bin])
    end,
    case unpack(Socket, Bin2) of
        {ok, RestBin} ->
            State1 = State#state{half_package = RestBin},
            case inet:setopts(Socket,[{active, once}]) of
                ok -> {noreply, State1};
                {error, Reason} -> 
                    ?ERR("inet:setopts, reason:~p ~n",[Reason]),
                    {stop, normal, State1}
            end;
        {error, Reason} ->
            ?ERR("unpack: ~p", [Reason]),
            {stop, normal, State}
    end;

%% STOP
handle_info(stop, State)->
    {stop, normal, State};

handle_info(Info, StateData)->	
    try
        case Info of
            { dbLoginResult, #userDBLoginResult{}=UserDBLoginResult }->
                userHandle:on_dbLoginResult( UserDBLoginResult ),
                ok;
            { kickOutUserComplete }->
                userHandle:onMsgKickOutUserComplete(),
                ok;
            { gameServerClosed, ServerID }->
                userHandle:on_gameServerClosed( ServerID ),
                ok;
            { gameServer_QueryUserMaxLevelResult, ServerID, MaxPlayerLevel }->
                userHandle:on_gameServer_QueryUserMaxLevelResult( ServerID, MaxPlayerLevel ),
                ok;
            { onGS2LS_UserReadyLoginResult, ServerID, Msg }->
                userHandle:on_GS2LS_UserReadyLoginResult( ServerID, Msg );
            { timeOut_WaitUserAskGameServerList }->
                userHandle:on_timeOut_WaitUserAskGameServerList();
            {tcp_error, _Socket, Reason}->
                ?ERR( "user socket[~p] closed reson[~p]", [getCurUserSocket(), Reason] ),
                self() ! stop;
            {tcp_closed,_Socket}->
                ?INFO( "user socket[~p] closed ", [getCurUserSocket()] ),
                self() ! stop
        end,
        {noreply, StateData}
     catch
         T : X ->
             ?ERR("~p:~p", [T, X]),
             {stop, normal, StateData}
     end.

%% receiveUser_ExceptionFunc()->
%% 	?ERR( "netUsers:receiveUser_ExceptionFunc" ),
%% 	logout( 0 ).
%% 	

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

unpack(Socket, BinIn = <<Len:16/little, Code:16/little, RestBin1/binary>>) ->
    DataLen = Len - 4,
    case RestBin1 of
        <<DataBin:DataLen/binary, RestBin/binary>> ->
            RecvPackCount = ( Code band 16#F800 ) bsr 11,
            Cmd = ( Code band 16#7FF ),
            %% 检查包序
            NextRecvPackCount = get("NextRecvPackCount"),
            case RecvPackCount =:= NextRecvPackCount of
                true-> 
                    %% 检查第一个消息是否为登陆命令
                    case get("IsSocketCheckPass") of
                        true -> ok;
                        false ->
                            case Cmd of
                                ?CMD_U2LS_Login_553->ok;
                                ?CMD_U2LS_Login_PP->ok;
                                ?CMD_U2LS_Login_APPS->ok;
                                ?CMD_U2LS_Login_360->ok;
                                ?CMD_U2LS_Login_UC->ok;
                                ?CMD_U2LS_Login_91->ok;
                                _->
                                    %% 第一个包不是登陆命令
                                    ?WARN("recve socket[~p] Cmd[~p] not check pass", 
                                        [getCurUserSocket(), Cmd] ),
                                    self() ! stop
                            end
                    end,
                    %% 更新包序
                    case NextRecvPackCount + 1 > 31 of
                        true -> put("NextRecvPackCount", 0);
                        false -> put("NextRecvPackCount", NextRecvPackCount + 1)
                    end,
                    %% 数据处理
                    case msg_LS2User:dealMsg(Socket, Cmd, DataBin) of
                        noMatch ->
                            ?WARN("undefined cmd:~p data:~w", [Cmd, DataBin]);
                        _ -> ok
                    end,
                    RestLen = byte_size(RestBin),
                    case RestLen > 1048576 of
                        true ->
                            %% 不能解包的数据累积太多了（大于1M），结束进程
                            ?ERR("RestBin too larger: ~w", [RestLen]),
                            {error, rest_binary_too_larger};
                        false ->
                            %% 继续回调处理粘包的情况
                            unpack(Socket, RestBin)
                    end;
                false->
                    %% 包序不正确
                    ?WARN("Cmd[~p] RecvPackCount[~p] =/= NextRecvPackCount[~p]",
                        [Cmd, RecvPackCount, NextRecvPackCount]),
                    {error, error_package_index}
            end;
        _ ->
            ?DEBUG("BinIn:~w", [BinIn]),
            {ok, BinIn}
    end;
unpack(_, HalfPackge) -> 
    ?DEBUG("HalfPackge:~w", [HalfPackge]),
    {ok, HalfPackge}.

initUser( UserSocket )->
    case inet:peername(UserSocket) of
        {ok, {IP, Port}}->
            {A, B, C, D} = IP,
            IPString= integer_to_list(A)
            ++ "." ++ integer_to_list(B)
            ++ "." ++integer_to_list(C)
            ++ "." ++integer_to_list(D),
            ?DEBUG("initUser self[~p] Socket[~p] IP[~p] Port[~p]", [self(), UserSocket, IPString, Port]),
            put( "UserIP", IPString ),
            ok;
        _-> 
            put( "UserIP", "0.0.0.0" ), 
            ok
    end,
    %% 当前进程可直接访问socket
    put( "UserSocket", UserSocket ),
    put( "NextRecvPackCount", 0 ),
    put( "NextSendPackCount", 0 ),
    %% 建立socketData表
    TableUserSocket = ets:new( 'userSocketTable', [protected, { keypos, #userSocketRecord.socket }] ),
    Rand = random:uniform(),
    RandString = io_lib:format( "~w", [Rand] ),
    RandString2 = lists:flatten(RandString),
    etsBaseFunc:insertRecord( TableUserSocket, #userSocketRecord{socket=UserSocket, userName="", userID = 0, randIdentity = RandString2, ip=""} ),
    %%当前进程可直接访问socket表
    put( "TableUserSocket", TableUserSocket ),
    %%当前Socket是否已经通过验证
    put( "IsSocketCheckPass", false ),
    put( "UserID", 0 ),
    put( "UserState", ?UserState_UnCheckPass ),
    put( "GlobalUseSocketTable", main:getGlobalUseSocketTable() ),
    put( "TableGlobalLoginUser", main:getGlobalLoginUserTable() ),
    %%通知主进程，有用户连接进入
    main_PID ! { acceptedUserSocket, UserSocket },
    %% NOTICE: init_ack ???
    %% proc_lib:init_ack(self()),
    %% 发送初始化消息
    sendInitMsg(),
    ?DEBUG("accept user socket[~p] userPID[~p] socketTable[~p]", [getCurUserSocket(), self(), getCurUserSocketTable()]),
    %common:beginTryCatchFunc( netUsers, receiveUser, UserSocket, netUsers, receiveUser_ExceptionFunc ),
    %?DEBUG("procUser process exited socket[~p]", [getCurUserSocket()]),
    ok.

%% 给客户端发送初始化消息
sendInitMsg()->
    LSID=main:getLoginServerID(),
    Socket=getCurUserSocket(),
    msg_LS2User:send(Socket,#pk_LS2U_ServerInfo{lsid=LSID,client_ip=get("UserIP")}),
    ok.

%% user下线处理
logout( Reson )->
    userHandle:onUserOffline(),
    %%通知主进程，用户连接断开
    main_PID ! { closedUserSocket, getCurUserSocket() },
    ?DEBUG( "logout self[~p] socket[~p] userid[~p] Reson[~p]", 
        [self(), getCurUserSocket(), getCurUserID(), Reson] ),
    ok.

%%% vim: set filetype=erlang foldmarker=%%',%%. foldmethod=marker:
