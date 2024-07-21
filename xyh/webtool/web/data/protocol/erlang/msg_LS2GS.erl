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

-module(msg_LS2GS).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_LS2GS.hrl").

write_LS2GS_LoginResult(#pk_LS2GS_LoginResult{reserve = Vreserve}) ->
    <<Vreserve:32/little>>.

binary_read_LS2GS_LoginResult(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_LS2GS_LoginResult{reserve = Vreserve}, RestBin0, 0}.


write_LS2GS_QueryUserMaxLevel(#pk_LS2GS_QueryUserMaxLevel{userID = VuserID}) ->
    <<VuserID:64/little>>.

binary_read_LS2GS_QueryUserMaxLevel(Bin0) ->
    <<VuserID:64/little, RestBin0/binary>> = Bin0,
    {#pk_LS2GS_QueryUserMaxLevel{userID = VuserID}, RestBin0, 0}.


write_LS2GS_UserReadyToLogin(#pk_LS2GS_UserReadyToLogin{
        userID = VuserID,
        username = Vusername,
        identity = Videntity,
        platId = VplatId
    }) ->
    Lusername = byte_size(Vusername),
    Lidentity = byte_size(Videntity),
    <<
        VuserID:64/little,
        Lusername:16/little, Vusername/binary,
        Lidentity:16/little, Videntity/binary,
        VplatId:32/little
    >>.

binary_read_LS2GS_UserReadyToLogin(Bin0) ->
    <<
        VuserID:64/little,
        Lusername:16/little, Vusername:Lusername/binary,
        Lidentity:16/little, Videntity:Lidentity/binary,
        VplatId:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_LS2GS_UserReadyToLogin{
        userID = VuserID,
        username = Vusername,
        identity = Videntity,
        platId = VplatId
    }, RestBin0, 0}.


write_LS2GS_KickOutUser(#pk_LS2GS_KickOutUser{userID = VuserID, identity = Videntity}) ->
    Lidentity = byte_size(Videntity),
    <<VuserID:64/little, Lidentity:16/little, Videntity/binary>>.

binary_read_LS2GS_KickOutUser(Bin0) ->
    <<VuserID:64/little, Lidentity:16/little, Videntity:Lidentity/binary, RestBin0/binary>> = Bin0,
    {#pk_LS2GS_KickOutUser{userID = VuserID, identity = Videntity}, RestBin0, 0}.


write_LS2GS_ActiveCode(#pk_LS2GS_ActiveCode{
        pidStr = VpidStr,
        activeCode = VactiveCode,
        playerName = VplayerName,
        type = Vtype
    }) ->
    LpidStr = byte_size(VpidStr),
    LactiveCode = byte_size(VactiveCode),
    LplayerName = byte_size(VplayerName),
    <<
        LpidStr:16/little, VpidStr/binary,
        LactiveCode:16/little, VactiveCode/binary,
        LplayerName:16/little, VplayerName/binary,
        Vtype:32/little
    >>.

binary_read_LS2GS_ActiveCode(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        LactiveCode:16/little, VactiveCode:LactiveCode/binary,
        LplayerName:16/little, VplayerName:LplayerName/binary,
        Vtype:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_LS2GS_ActiveCode{
        pidStr = VpidStr,
        activeCode = VactiveCode,
        playerName = VplayerName,
        type = Vtype
    }, RestBin0, 0}.


write_GS2LS_Request_Login(#pk_GS2LS_Request_Login{
        serverID = VserverID,
        name = Vname,
        ip = Vip,
        port = Vport,
        remmond = Vremmond,
        showInUserGameList = VshowInUserGameList,
        hot = Vhot
    }) ->
    LserverID = byte_size(VserverID),
    Lname = byte_size(Vname),
    Lip = byte_size(Vip),
    <<
        LserverID:16/little, VserverID/binary,
        Lname:16/little, Vname/binary,
        Lip:16/little, Vip/binary,
        Vport:32/little,
        Vremmond:32/little,
        VshowInUserGameList:32/little,
        Vhot:32/little
    >>.

binary_read_GS2LS_Request_Login(Bin0) ->
    <<
        LserverID:16/little, VserverID:LserverID/binary,
        Lname:16/little, Vname:Lname/binary,
        Lip:16/little, Vip:Lip/binary,
        Vport:32/little,
        Vremmond:32/little,
        VshowInUserGameList:32/little,
        Vhot:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2LS_Request_Login{
        serverID = VserverID,
        name = Vname,
        ip = Vip,
        port = Vport,
        remmond = Vremmond,
        showInUserGameList = VshowInUserGameList,
        hot = Vhot
    }, RestBin0, 0}.


write_GS2LS_ReadyToAcceptUser(#pk_GS2LS_ReadyToAcceptUser{reserve = Vreserve}) ->
    <<Vreserve:32/little>>.

binary_read_GS2LS_ReadyToAcceptUser(Bin0) ->
    <<Vreserve:32/little, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_ReadyToAcceptUser{reserve = Vreserve}, RestBin0, 0}.


write_GS2LS_OnlinePlayers(#pk_GS2LS_OnlinePlayers{playerCount = VplayerCount}) ->
    <<VplayerCount:32/little>>.

binary_read_GS2LS_OnlinePlayers(Bin0) ->
    <<VplayerCount:32/little, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_OnlinePlayers{playerCount = VplayerCount}, RestBin0, 0}.


write_GS2LS_QueryUserMaxLevelResult(#pk_GS2LS_QueryUserMaxLevelResult{userID = VuserID, maxLevel = VmaxLevel}) ->
    <<VuserID:64/little, VmaxLevel:32/little>>.

binary_read_GS2LS_QueryUserMaxLevelResult(Bin0) ->
    <<VuserID:64/little, VmaxLevel:32/little, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_QueryUserMaxLevelResult{userID = VuserID, maxLevel = VmaxLevel}, RestBin0, 0}.


write_GS2LS_UserReadyLoginResult(#pk_GS2LS_UserReadyLoginResult{userID = VuserID, result = Vresult}) ->
    <<VuserID:64/little, Vresult:32/little>>.

binary_read_GS2LS_UserReadyLoginResult(Bin0) ->
    <<VuserID:64/little, Vresult:32/little, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_UserReadyLoginResult{userID = VuserID, result = Vresult}, RestBin0, 0}.


write_GS2LS_UserLoginGameServer(#pk_GS2LS_UserLoginGameServer{userID = VuserID}) ->
    <<VuserID:64/little>>.

binary_read_GS2LS_UserLoginGameServer(Bin0) ->
    <<VuserID:64/little, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_UserLoginGameServer{userID = VuserID}, RestBin0, 0}.


write_GS2LS_UserLogoutGameServer(#pk_GS2LS_UserLogoutGameServer{userID = VuserID, identity = Videntity}) ->
    Lidentity = byte_size(Videntity),
    <<VuserID:64/little, Lidentity:16/little, Videntity/binary>>.

binary_read_GS2LS_UserLogoutGameServer(Bin0) ->
    <<VuserID:64/little, Lidentity:16/little, Videntity:Lidentity/binary, RestBin0/binary>> = Bin0,
    {#pk_GS2LS_UserLogoutGameServer{userID = VuserID, identity = Videntity}, RestBin0, 0}.


write_GS2LS_ActiveCode(#pk_GS2LS_ActiveCode{
        pidStr = VpidStr,
        activeCode = VactiveCode,
        retcode = Vretcode
    }) ->
    LpidStr = byte_size(VpidStr),
    LactiveCode = byte_size(VactiveCode),
    <<
        LpidStr:16/little, VpidStr/binary,
        LactiveCode:16/little, VactiveCode/binary,
        Vretcode:32/little
    >>.

binary_read_GS2LS_ActiveCode(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        LactiveCode:16/little, VactiveCode:LactiveCode/binary,
        Vretcode:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2LS_ActiveCode{
        pidStr = VpidStr,
        activeCode = VactiveCode,
        retcode = Vretcode
    }, RestBin0, 0}.


write_LS2GS_Announce(#pk_LS2GS_Announce{pidStr = VpidStr, announceInfo = VannounceInfo}) ->
    LpidStr = byte_size(VpidStr),
    LannounceInfo = byte_size(VannounceInfo),
    <<LpidStr:16/little, VpidStr/binary, LannounceInfo:16/little, VannounceInfo/binary>>.

binary_read_LS2GS_Announce(Bin0) ->
    <<LpidStr:16/little, VpidStr:LpidStr/binary, LannounceInfo:16/little, VannounceInfo:LannounceInfo/binary, RestBin0/binary>> = Bin0,
    {#pk_LS2GS_Announce{pidStr = VpidStr, announceInfo = VannounceInfo}, RestBin0, 0}.


write_LS2GS_Command(#pk_LS2GS_Command{
        pidStr = VpidStr,
        num = Vnum,
        cmd = Vcmd,
        params = Vparams
    }) ->
    LpidStr = byte_size(VpidStr),
    Lparams = byte_size(Vparams),
    <<
        LpidStr:16/little, VpidStr/binary,
        Vnum:32/little,
        Vcmd:32/little,
        Lparams:16/little, Vparams/binary
    >>.

binary_read_LS2GS_Command(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        Vnum:32/little,
        Vcmd:32/little,
        Lparams:16/little, Vparams:Lparams/binary,
        RestBin0/binary
    >> = Bin0,
    {#pk_LS2GS_Command{
        pidStr = VpidStr,
        num = Vnum,
        cmd = Vcmd,
        params = Vparams
    }, RestBin0, 0}.


write_GS2LS_Command(#pk_GS2LS_Command{
        pidStr = VpidStr,
        num = Vnum,
        cmd = Vcmd,
        retcode = Vretcode
    }) ->
    LpidStr = byte_size(VpidStr),
    <<
        LpidStr:16/little, VpidStr/binary,
        Vnum:32/little,
        Vcmd:32/little,
        Vretcode:32/little
    >>.

binary_read_GS2LS_Command(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        Vnum:32/little,
        Vcmd:32/little,
        Vretcode:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2LS_Command{
        pidStr = VpidStr,
        num = Vnum,
        cmd = Vcmd,
        retcode = Vretcode
    }, RestBin0, 0}.


write_LS2GS_Recharge(#pk_LS2GS_Recharge{
        pidStr = VpidStr,
        orderid = Vorderid,
        platform = Vplatform,
        account = Vaccount,
        userid = Vuserid,
        playerid = Vplayerid,
        ammount = Vammount
    }) ->
    LpidStr = byte_size(VpidStr),
    Lorderid = byte_size(Vorderid),
    Laccount = byte_size(Vaccount),
    <<
        LpidStr:16/little, VpidStr/binary,
        Lorderid:16/little, Vorderid/binary,
        Vplatform:32/little,
        Laccount:16/little, Vaccount/binary,
        Vuserid:64/little,
        Vplayerid:64/little,
        Vammount:32/little
    >>.

binary_read_LS2GS_Recharge(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        Lorderid:16/little, Vorderid:Lorderid/binary,
        Vplatform:32/little,
        Laccount:16/little, Vaccount:Laccount/binary,
        Vuserid:64/little,
        Vplayerid:64/little,
        Vammount:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_LS2GS_Recharge{
        pidStr = VpidStr,
        orderid = Vorderid,
        platform = Vplatform,
        account = Vaccount,
        userid = Vuserid,
        playerid = Vplayerid,
        ammount = Vammount
    }, RestBin0, 0}.


write_GS2LS_Recharge(#pk_GS2LS_Recharge{
        pidStr = VpidStr,
        orderid = Vorderid,
        platform = Vplatform,
        retcode = Vretcode
    }) ->
    LpidStr = byte_size(VpidStr),
    Lorderid = byte_size(Vorderid),
    <<
        LpidStr:16/little, VpidStr/binary,
        Lorderid:16/little, Vorderid/binary,
        Vplatform:32/little,
        Vretcode:32/little
    >>.

binary_read_GS2LS_Recharge(Bin0) ->
    <<
        LpidStr:16/little, VpidStr:LpidStr/binary,
        Lorderid:16/little, Vorderid:Lorderid/binary,
        Vplatform:32/little,
        Vretcode:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_GS2LS_Recharge{
        pidStr = VpidStr,
        orderid = Vorderid,
        platform = Vplatform,
        retcode = Vretcode
    }, RestBin0, 0}.


%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_LS2GS_LoginResult{} = P) ->
	Bin = write_LS2GS_LoginResult(P),
	pack:send(Socket, ?CMD_LS2GS_LoginResult, Bin);
send(Socket, #pk_LS2GS_QueryUserMaxLevel{} = P) ->
	Bin = write_LS2GS_QueryUserMaxLevel(P),
	pack:send(Socket, ?CMD_LS2GS_QueryUserMaxLevel, Bin);
send(Socket, #pk_LS2GS_UserReadyToLogin{} = P) ->
	Bin = write_LS2GS_UserReadyToLogin(P),
	pack:send(Socket, ?CMD_LS2GS_UserReadyToLogin, Bin);
send(Socket, #pk_LS2GS_KickOutUser{} = P) ->
	Bin = write_LS2GS_KickOutUser(P),
	pack:send(Socket, ?CMD_LS2GS_KickOutUser, Bin);
send(Socket, #pk_LS2GS_ActiveCode{} = P) ->
	Bin = write_LS2GS_ActiveCode(P),
	pack:send(Socket, ?CMD_LS2GS_ActiveCode, Bin);
send(Socket, #pk_GS2LS_Request_Login{} = P) ->
	Bin = write_GS2LS_Request_Login(P),
	pack:send(Socket, ?CMD_GS2LS_Request_Login, Bin);
send(Socket, #pk_GS2LS_ReadyToAcceptUser{} = P) ->
	Bin = write_GS2LS_ReadyToAcceptUser(P),
	pack:send(Socket, ?CMD_GS2LS_ReadyToAcceptUser, Bin);
send(Socket, #pk_GS2LS_OnlinePlayers{} = P) ->
	Bin = write_GS2LS_OnlinePlayers(P),
	pack:send(Socket, ?CMD_GS2LS_OnlinePlayers, Bin);
send(Socket, #pk_GS2LS_QueryUserMaxLevelResult{} = P) ->
	Bin = write_GS2LS_QueryUserMaxLevelResult(P),
	pack:send(Socket, ?CMD_GS2LS_QueryUserMaxLevelResult, Bin);
send(Socket, #pk_GS2LS_UserReadyLoginResult{} = P) ->
	Bin = write_GS2LS_UserReadyLoginResult(P),
	pack:send(Socket, ?CMD_GS2LS_UserReadyLoginResult, Bin);
send(Socket, #pk_GS2LS_UserLoginGameServer{} = P) ->
	Bin = write_GS2LS_UserLoginGameServer(P),
	pack:send(Socket, ?CMD_GS2LS_UserLoginGameServer, Bin);
send(Socket, #pk_GS2LS_UserLogoutGameServer{} = P) ->
	Bin = write_GS2LS_UserLogoutGameServer(P),
	pack:send(Socket, ?CMD_GS2LS_UserLogoutGameServer, Bin);
send(Socket, #pk_GS2LS_ActiveCode{} = P) ->
	Bin = write_GS2LS_ActiveCode(P),
	pack:send(Socket, ?CMD_GS2LS_ActiveCode, Bin);
send(Socket, #pk_LS2GS_Announce{} = P) ->
	Bin = write_LS2GS_Announce(P),
	pack:send(Socket, ?CMD_LS2GS_Announce, Bin);
send(Socket, #pk_LS2GS_Command{} = P) ->
	Bin = write_LS2GS_Command(P),
	pack:send(Socket, ?CMD_LS2GS_Command, Bin);
send(Socket, #pk_GS2LS_Command{} = P) ->
	Bin = write_GS2LS_Command(P),
	pack:send(Socket, ?CMD_GS2LS_Command, Bin);
send(Socket, #pk_LS2GS_Recharge{} = P) ->
	Bin = write_LS2GS_Recharge(P),
	pack:send(Socket, ?CMD_LS2GS_Recharge, Bin);
send(Socket, #pk_GS2LS_Recharge{} = P) ->
	Bin = write_GS2LS_Recharge(P),
	pack:send(Socket, ?CMD_GS2LS_Recharge, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_LS2GS_LoginResult->
            {Data, _, _} = binary_read_LS2GS_LoginResult(Bin),
            messageOn:on_LS2GS_LoginResult(Socket, Data);
        ?CMD_LS2GS_QueryUserMaxLevel->
            {Data, _, _} = binary_read_LS2GS_QueryUserMaxLevel(Bin),
            messageOn:on_LS2GS_QueryUserMaxLevel(Socket, Data);
        ?CMD_LS2GS_UserReadyToLogin->
            {Data, _, _} = binary_read_LS2GS_UserReadyToLogin(Bin),
            messageOn:on_LS2GS_UserReadyToLogin(Socket, Data);
        ?CMD_LS2GS_KickOutUser->
            {Data, _, _} = binary_read_LS2GS_KickOutUser(Bin),
            messageOn:on_LS2GS_KickOutUser(Socket, Data);
        ?CMD_LS2GS_ActiveCode->
            {Data, _, _} = binary_read_LS2GS_ActiveCode(Bin),
            messageOn:on_LS2GS_ActiveCode(Socket, Data);
        ?CMD_GS2LS_Request_Login->
            {Data, _, _} = binary_read_GS2LS_Request_Login(Bin),
            messageOn:on_GS2LS_Request_Login(Socket, Data);
        ?CMD_GS2LS_ReadyToAcceptUser->
            {Data, _, _} = binary_read_GS2LS_ReadyToAcceptUser(Bin),
            messageOn:on_GS2LS_ReadyToAcceptUser(Socket, Data);
        ?CMD_GS2LS_OnlinePlayers->
            {Data, _, _} = binary_read_GS2LS_OnlinePlayers(Bin),
            messageOn:on_GS2LS_OnlinePlayers(Socket, Data);
        ?CMD_GS2LS_QueryUserMaxLevelResult->
            {Data, _, _} = binary_read_GS2LS_QueryUserMaxLevelResult(Bin),
            messageOn:on_GS2LS_QueryUserMaxLevelResult(Socket, Data);
        ?CMD_GS2LS_UserReadyLoginResult->
            {Data, _, _} = binary_read_GS2LS_UserReadyLoginResult(Bin),
            messageOn:on_GS2LS_UserReadyLoginResult(Socket, Data);
        ?CMD_GS2LS_UserLoginGameServer->
            {Data, _, _} = binary_read_GS2LS_UserLoginGameServer(Bin),
            messageOn:on_GS2LS_UserLoginGameServer(Socket, Data);
        ?CMD_GS2LS_UserLogoutGameServer->
            {Data, _, _} = binary_read_GS2LS_UserLogoutGameServer(Bin),
            messageOn:on_GS2LS_UserLogoutGameServer(Socket, Data);
        ?CMD_GS2LS_ActiveCode->
            {Data, _, _} = binary_read_GS2LS_ActiveCode(Bin),
            messageOn:on_GS2LS_ActiveCode(Socket, Data);
        ?CMD_LS2GS_Announce->
            {Data, _, _} = binary_read_LS2GS_Announce(Bin),
            messageOn:on_LS2GS_Announce(Socket, Data);
        ?CMD_LS2GS_Command->
            {Data, _, _} = binary_read_LS2GS_Command(Bin),
            messageOn:on_LS2GS_Command(Socket, Data);
        ?CMD_GS2LS_Command->
            {Data, _, _} = binary_read_GS2LS_Command(Bin),
            messageOn:on_GS2LS_Command(Socket, Data);
        ?CMD_LS2GS_Recharge->
            {Data, _, _} = binary_read_LS2GS_Recharge(Bin),
            messageOn:on_LS2GS_Recharge(Socket, Data);
        ?CMD_GS2LS_Recharge->
            {Data, _, _} = binary_read_GS2LS_Recharge(Bin),
            messageOn:on_GS2LS_Recharge(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
