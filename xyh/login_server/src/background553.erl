-module(background553).

-include("db.hrl").
-include("userDefine.hrl").
-include("package.hrl").
-include("common.hrl").
-include("condition_compile.hrl").
-include("platformDefine.hrl").
-include("gameServerDefine.hrl").
-include("globalDef.hrl").
-include_lib("stdlib/include/ms_transform.hrl").


-compile(export_all).

start_link(Socket) ->
    %% Pid = proc_lib:spawn( background553, procBackground553, [CliSocket] ),
    Pid = proc_lib:spawn(?MODULE, procBackground553, [Socket]),
    {ok, Pid}.


%% 检查连接IP地址是否正常
checkSocket(PlatformSocket)->
    Platform553IP = env:get(background553_ip),
    IPTokens=string:tokens(Platform553IP,"."),
    [IP_S0,IP_S1,IP_S2,IP_S3]=IPTokens,
    {IP_0,_}=string:to_integer(IP_S0),
    {IP_1,_}=string:to_integer(IP_S1),
    {IP_2,_}=string:to_integer(IP_S2),
    {IP_3,_}=string:to_integer(IP_S3),
    IPCheck={IP_0,IP_1,IP_2,IP_3},
    {ok, {IP, _Port}} = inet:peername(PlatformSocket),
    ?DEBUG( "IPCheck[~p],IP[~p] ", [IPCheck, IP] ),
    case IP =:= IPCheck of
        true-> yes;
        false -> no
    end.	

procBackground553(PlatformSocket)->
    ?INFO("start ~w ...", [procBackground553]),
    %% 当前进程可直接访问socket
    put("PlatformSocket", PlatformSocket),
    %% 当前连接是否已经通过验证
    put("IsPlatformSocketChecked", false),
    %% 通知父进程
    proc_lib:init_ack(self()),
    inet:setopts(PlatformSocket, ?TCP_OPTIONS),
    ?DEBUG( "accept Background 553 socket[~p] PID[~p] ", [PlatformSocket, self()] ),
    try
        %%  not check ip now
        %% 	case checkSocket(PlatformSocket) of
        %% 		yes->ok;
        %% 		_->throw(-9)
        %% 	end,
        receiveBackground553(PlatformSocket)
    catch
        -9->
            {ok, {IP, _Port}} = inet:peername(PlatformSocket),
            ?ERR("Background 553 invalid ip[~p] connect .",[IP]),
            gen_tcp:close( PlatformSocket );
        _:Why->
            ?ERR("Background 553 exception .why:~p",[Why]),
            gen_tcp:close( PlatformSocket )
    end,
    ?DEBUG("Background 553 process exited .",[]),
    ok.


%%553平台的recieve
receiveBackground553( PlatformSocket )->
    put( "receivePlatform553", true ),
    receive
        {tcp,PlatformSocket,Data}->
            inet:setopts(PlatformSocket,[{active,once}]),
            ?DEBUG("####### receive Platform553 data[~w].",[Data]),
            doMsg(PlatformSocket,Data);
        {tcp_error, _Socket, Reason}->
            ?ERR( "Background 553 socket error[~p] reson[~p]", [PlatformSocket, Reason] ),
            put( "receivePlatform553", false ),
            gen_tcp:close( PlatformSocket );
        {tcp_closed,_Socket}->
            ?DEBUG( "Background 553 socket[~p] closed ", [PlatformSocket] ),
            put( "receivePlatform553", false ),
            gen_tcp:close( PlatformSocket );
        %% 激活码处理完成
        {activeCodeProcComplete,Pk_GS2LS_ActiveCode}->
            ?INFO( "------activeCodeProcComplete"),
            PlatformSocket = get( "PlatformSocket" ),
            Pkt = #pk_LS2Platform553_Active_Code_Ret{ len=string:len(Pk_GS2LS_ActiveCode#pk_GS2LS_ActiveCode.activeCode)+12+2,commmand=?CMD_PLATFORM_553_ACTIVE_CODE_RET,
                activecode=Pk_GS2LS_ActiveCode#pk_GS2LS_ActiveCode.activeCode,
                retcode=Pk_GS2LS_ActiveCode#pk_GS2LS_ActiveCode.retcode},
            msg_LS2Platform:sendMsg(PlatformSocket, Pkt);
        %% 执行平台发送的命令处理完成响应
        {commandComplete, Pk_GS2LS_Command}->
            PlatformSocket = get( "PlatformSocket" ),
            Pkt = #pk_LS2Platform553_Command_Ret{ len=20,commmand=?CMD_PLATFORM_553_COMMAND_RET,
                num=Pk_GS2LS_Command#pk_GS2LS_Command.num,
                cmd=Pk_GS2LS_Command#pk_GS2LS_Command.cmd,
                retcode=Pk_GS2LS_Command#pk_GS2LS_Command.retcode},
            ?INFO( "------commandComplete------[~p]",[Pkt]),
            msg_LS2Platform:sendMsg(PlatformSocket,Pkt);
        %% 充值处理完成响应
        {rechargeComplete,Pk_GS2LS_Recharge}->
            ?DEBUG( "------rechargeComplete------"),
            PlatformSocket = get( "PlatformSocket" ),
            Pkt = #pk_LS2Platform553_Recharge_Ret{ len=string:len(Pk_GS2LS_Recharge#pk_GS2LS_Recharge.orderid)+16+2,
                commmand=?CMD_PLATFORM_553_RECHARGE_RET,
                orderid=Pk_GS2LS_Recharge#pk_GS2LS_Recharge.orderid,
                platform=Pk_GS2LS_Recharge#pk_GS2LS_Recharge.platform,
                retcode=Pk_GS2LS_Recharge#pk_GS2LS_Recharge.retcode},
            ?INFO( "------rechargeComplete------[~p]",[Pkt]),
            msg_LS2Platform:sendMsg(PlatformSocket,Pkt)
    end,
    case get( "receivePlatform553" ) of
        true->receiveBackground553( PlatformSocket );
        false->ok
    end.


doMsg(_S, <<>>) ->
    ok;

doMsg(S, Data) ->
    HEADER_SIZE=8,
    MAX_PACKET_SIZE=1024,
    DataSize = binary:referenced_byte_size(Data),
    case DataSize < HEADER_SIZE of
        true->throw( {'Error Data',Data} );
        false->ok
    end,
    case msg_LS2Platform:readMsg(Data) of
        {ok,Len,Cmd,Data1}->
            ?INFO( "recve platform 553 socket[~p] MSG:Len[~p],Cmd[~p],Data[~p]", [S,Len,Cmd,Data1] ),
            msg_LS2Platform:dealMsg(S,Len,Cmd,Data1),
            LenLeft = DataSize - Len,
            if LenLeft >= HEADER_SIZE ->
                    {_,<<Data2/binary>>} = split_binary(Data,Len),
                    doMsg(S, Data2);
                true -> ok
            end;
        {error,0,0,0}->
            throw( {'Error Packet',Data} )
    end.
