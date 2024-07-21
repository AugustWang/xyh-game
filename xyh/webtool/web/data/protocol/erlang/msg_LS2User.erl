%%-----------------------------------------------------------
%% @doc Automatic Generation Of Package(read/write/send) File
%% 
%% NOTE: 
%%     Please be careful,
%%     if you have manually edited any of protocol file,
%%     do NOT commit to SVN !!!
%%
%% Shenzhen Turbo Technology Co., Ltd. All Rights Reserved.
%% http://www.szturbotech.com
%% Tool Release Time: 2014.3.21
%%
%% @author Rolong<rolong@vip.qq.com>
%%-----------------------------------------------------------

-module(msg_LS2User).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_LS2User.hrl").

write_LS2U_LoginResult(#pk_LS2U_LoginResult{result = Vresult, userID = VuserID}) ->
    <<Vresult:8/little, VuserID:64/little>>.



write_GameServerInfo(#pk_GameServerInfo{
        serverID = VserverID,
        name = Vname,
        state = Vstate,
        showIndex = VshowIndex,
        remmond = Vremmond,
        maxPlayerLevel = VmaxPlayerLevel,
        isnew = Visnew,
        begintime = Vbegintime,
        hot = Vhot
    }) ->
    LserverID = byte_size(VserverID),
    Lname = byte_size(Vname),
    Lbegintime = byte_size(Vbegintime),
    <<
        LserverID:16/little, VserverID/binary,
        Lname:16/little, Vname/binary,
        Vstate:8/little,
        VshowIndex:8/little,
        Vremmond:8/little,
        VmaxPlayerLevel:16/little,
        Visnew:8/little,
        Lbegintime:16/little, Vbegintime/binary,
        Vhot:8/little
    >>.

binary_read_GameServerInfo(Bin0) ->
    <<
        LserverID:16/little, VserverID:LserverID/binary,
        Lname:16/little, Vname:Lname/binary,
        Vstate:8/little,
        VshowIndex:8/little,
        Vremmond:8/little,
        VmaxPlayerLevel:16/little,
        Visnew:8/little,
        Lbegintime:16/little, Vbegintime:Lbegintime/binary,
        Vhot:8/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GameServerInfo{
        serverID = VserverID,
        name = Vname,
        state = Vstate,
        showIndex = VshowIndex,
        remmond = Vremmond,
        maxPlayerLevel = VmaxPlayerLevel,
        isnew = Visnew,
        begintime = Vbegintime,
        hot = Vhot
    }, RestBin0, 0}.


write_LS2U_GameServerList(#pk_LS2U_GameServerList{gameServers = VgameServers}) ->
    AgameServers = write_array(VgameServers, fun(X) -> write_GameServerInfo(X) end),
    <<AgameServers/binary>>.



write_LS2U_SelGameServerResult(#pk_LS2U_SelGameServerResult{
        userID = VuserID,
        ip = Vip,
        port = Vport,
        identity = Videntity,
        errorCode = VerrorCode
    }) ->
    Lip = byte_size(Vip),
    Lidentity = byte_size(Videntity),
    <<
        VuserID:64/little,
        Lip:16/little, Vip/binary,
        Vport:32/little,
        Lidentity:16/little, Videntity/binary,
        VerrorCode:32/little
    >>.



binary_read_U2LS_Login_553(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        Vtime:64/little,
        Lsign:16/little, Vsign:Lsign/binary,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_553{
        account = Vaccount,
        platformID = VplatformID,
        time = Vtime,
        sign = Vsign,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


binary_read_U2LS_Login_PP(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        Vtoken1:64/little,
        Vtoken2:64/little,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_PP{
        account = Vaccount,
        platformID = VplatformID,
        token1 = Vtoken1,
        token2 = Vtoken2,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


binary_read_U2LS_RequestGameServerList(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2LS_RequestGameServerList{reserve = Vreserve}, RestBin0, 0}.


binary_read_U2LS_RequestSelGameServer(Bin0) ->
    <<LserverID:16/little, VserverID:LserverID/binary, RestBin0/binary>> = Bin0,
    {#pk_U2LS_RequestSelGameServer{serverID = VserverID}, RestBin0, 0}.


write_LS2U_ServerInfo(#pk_LS2U_ServerInfo{lsid = Vlsid, client_ip = Vclient_ip}) ->
    Lclient_ip = byte_size(Vclient_ip),
    <<Vlsid:16/little, Lclient_ip:16/little, Vclient_ip/binary>>.



binary_read_U2LS_Login_APPS(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        Vtime:64/little,
        Lsign:16/little, Vsign:Lsign/binary,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_APPS{
        account = Vaccount,
        platformID = VplatformID,
        time = Vtime,
        sign = Vsign,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


binary_read_U2LS_Login_360(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        LauthoCode:16/little, VauthoCode:LauthoCode/binary,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_360{
        account = Vaccount,
        platformID = VplatformID,
        authoCode = VauthoCode,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


write_LS2U_Login_360(#pk_LS2U_Login_360{
        account = Vaccount,
        userid = Vuserid,
        access_token = Vaccess_token,
        refresh_token = Vrefresh_token
    }) ->
    Laccount = byte_size(Vaccount),
    Luserid = byte_size(Vuserid),
    Laccess_token = byte_size(Vaccess_token),
    Lrefresh_token = byte_size(Vrefresh_token),
    <<
        Laccount:16/little, Vaccount/binary,
        Luserid:16/little, Vuserid/binary,
        Laccess_token:16/little, Vaccess_token/binary,
        Lrefresh_token:16/little, Vrefresh_token/binary
    >>.



binary_read_U2LS_Login_UC(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        LauthoCode:16/little, VauthoCode:LauthoCode/binary,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_UC{
        account = Vaccount,
        platformID = VplatformID,
        authoCode = VauthoCode,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


write_LS2U_Login_UC(#pk_LS2U_Login_UC{
        account = Vaccount,
        userid = Vuserid,
        nickName = VnickName
    }) ->
    Laccount = byte_size(Vaccount),
    LnickName = byte_size(VnickName),
    <<
        Laccount:16/little, Vaccount/binary,
        Vuserid:64/little,
        LnickName:16/little, VnickName/binary
    >>.



binary_read_U2LS_Login_91(Bin0) ->
    <<
        Laccount:16/little, Vaccount:Laccount/binary,
        VplatformID:16/little,
        Luin:16/little, Vuin:Luin/binary,
        LsessionID:16/little, VsessionID:LsessionID/binary,
        VversionRes:32/little,
        VversionExe:32/little,
        VversionGame:32/little,
        VversionPro:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2LS_Login_91{
        account = Vaccount,
        platformID = VplatformID,
        uin = Vuin,
        sessionID = VsessionID,
        versionRes = VversionRes,
        versionExe = VversionExe,
        versionGame = VversionGame,
        versionPro = VversionPro
    }, RestBin0, 0}.


write_LS2U_Login_91(#pk_LS2U_Login_91{
        account = Vaccount,
        userid = Vuserid,
        access_token = Vaccess_token,
        refresh_token = Vrefresh_token
    }) ->
    Laccount = byte_size(Vaccount),
    Luserid = byte_size(Vuserid),
    Laccess_token = byte_size(Vaccess_token),
    Lrefresh_token = byte_size(Vrefresh_token),
    <<
        Laccount:16/little, Vaccount/binary,
        Luserid:16/little, Vuserid/binary,
        Laccess_token:16/little, Vaccess_token/binary,
        Lrefresh_token:16/little, Vrefresh_token/binary
    >>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_LS2U_LoginResult{} = P) ->
	Bin = write_LS2U_LoginResult(P),
	pack:send(Socket, ?CMD_LS2U_LoginResult, Bin);
send(Socket, #pk_LS2U_GameServerList{} = P) ->
	Bin = write_LS2U_GameServerList(P),
	pack:send(Socket, ?CMD_LS2U_GameServerList, Bin);
send(Socket, #pk_LS2U_SelGameServerResult{} = P) ->
	Bin = write_LS2U_SelGameServerResult(P),
	pack:send(Socket, ?CMD_LS2U_SelGameServerResult, Bin);
send(Socket, #pk_LS2U_ServerInfo{} = P) ->
	Bin = write_LS2U_ServerInfo(P),
	pack:send(Socket, ?CMD_LS2U_ServerInfo, Bin);
send(Socket, #pk_LS2U_Login_360{} = P) ->
	Bin = write_LS2U_Login_360(P),
	pack:send(Socket, ?CMD_LS2U_Login_360, Bin);
send(Socket, #pk_LS2U_Login_UC{} = P) ->
	Bin = write_LS2U_Login_UC(P),
	pack:send(Socket, ?CMD_LS2U_Login_UC, Bin);
send(Socket, #pk_LS2U_Login_91{} = P) ->
	Bin = write_LS2U_Login_91(P),
	pack:send(Socket, ?CMD_LS2U_Login_91, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_U2LS_Login_553->
            {Data, _, _} = binary_read_U2LS_Login_553(Bin),
            messageOn:on_U2LS_Login_553(Socket, Data);
        ?CMD_U2LS_Login_PP->
            {Data, _, _} = binary_read_U2LS_Login_PP(Bin),
            messageOn:on_U2LS_Login_PP(Socket, Data);
        ?CMD_U2LS_RequestGameServerList->
            {Data, _, _} = binary_read_U2LS_RequestGameServerList(Bin),
            messageOn:on_U2LS_RequestGameServerList(Socket, Data);
        ?CMD_U2LS_RequestSelGameServer->
            {Data, _, _} = binary_read_U2LS_RequestSelGameServer(Bin),
            messageOn:on_U2LS_RequestSelGameServer(Socket, Data);
        ?CMD_U2LS_Login_APPS->
            {Data, _, _} = binary_read_U2LS_Login_APPS(Bin),
            messageOn:on_U2LS_Login_APPS(Socket, Data);
        ?CMD_U2LS_Login_360->
            {Data, _, _} = binary_read_U2LS_Login_360(Bin),
            messageOn:on_U2LS_Login_360(Socket, Data);
        ?CMD_U2LS_Login_UC->
            {Data, _, _} = binary_read_U2LS_Login_UC(Bin),
            messageOn:on_U2LS_Login_UC(Socket, Data);
        ?CMD_U2LS_Login_91->
            {Data, _, _} = binary_read_U2LS_Login_91(Bin),
            messageOn:on_U2LS_Login_91(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
