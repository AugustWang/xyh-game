%%---------------------------------------------------------
%% @doc Automatic Generation Of Protocol File
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
%%---------------------------------------------------------

%%---------------------------------------------------------
%% define cmd
%%---------------------------------------------------------

-define(CMD_LS2U_LoginResult, 501).
-define(CMD_GameServerInfo, 502).
-define(CMD_LS2U_GameServerList, 503).
-define(CMD_LS2U_SelGameServerResult, 504).
-define(CMD_U2LS_Login_553, 505).
-define(CMD_U2LS_Login_PP, 506).
-define(CMD_U2LS_RequestGameServerList, 507).
-define(CMD_U2LS_RequestSelGameServer, 508).
-define(CMD_LS2U_ServerInfo, 509).
-define(CMD_U2LS_Login_APPS, 510).
-define(CMD_U2LS_Login_360, 511).
-define(CMD_LS2U_Login_360, 512).
-define(CMD_U2LS_Login_UC, 513).
-define(CMD_LS2U_Login_UC, 514).
-define(CMD_U2LS_Login_91, 515).
-define(CMD_LS2U_Login_91, 516).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_LS2U_LoginResult, {
        result,
        userID
	}).
-record(pk_GameServerInfo, {
        serverID,
        name,
        state,
        showIndex,
        remmond,
        maxPlayerLevel,
        isnew,
        begintime,
        hot
	}).
-record(pk_LS2U_GameServerList, {
        gameServers
	}).
-record(pk_LS2U_SelGameServerResult, {
        userID,
        ip,
        port,
        identity,
        errorCode
	}).
-record(pk_U2LS_Login_553, {
        account,
        platformID,
        time,
        sign,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_U2LS_Login_PP, {
        account,
        platformID,
        token1,
        token2,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_U2LS_RequestGameServerList, {
        reserve
	}).
-record(pk_U2LS_RequestSelGameServer, {
        serverID
	}).
-record(pk_LS2U_ServerInfo, {
        lsid,
        client_ip
	}).
-record(pk_U2LS_Login_APPS, {
        account,
        platformID,
        time,
        sign,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_U2LS_Login_360, {
        account,
        platformID,
        authoCode,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_LS2U_Login_360, {
        account,
        userid,
        access_token,
        refresh_token
	}).
-record(pk_U2LS_Login_UC, {
        account,
        platformID,
        authoCode,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_LS2U_Login_UC, {
        account,
        userid,
        nickName
	}).
-record(pk_U2LS_Login_91, {
        account,
        platformID,
        uin,
        sessionID,
        versionRes,
        versionExe,
        versionGame,
        versionPro
	}).
-record(pk_LS2U_Login_91, {
        account,
        userid,
        access_token,
        refresh_token
	}).
