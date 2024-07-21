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

-define(CMD_LS2GS_LoginResult, 401).
-define(CMD_LS2GS_QueryUserMaxLevel, 402).
-define(CMD_LS2GS_UserReadyToLogin, 403).
-define(CMD_LS2GS_KickOutUser, 404).
-define(CMD_LS2GS_ActiveCode, 405).
-define(CMD_GS2LS_Request_Login, 406).
-define(CMD_GS2LS_ReadyToAcceptUser, 407).
-define(CMD_GS2LS_OnlinePlayers, 408).
-define(CMD_GS2LS_QueryUserMaxLevelResult, 409).
-define(CMD_GS2LS_UserReadyLoginResult, 410).
-define(CMD_GS2LS_UserLoginGameServer, 411).
-define(CMD_GS2LS_UserLogoutGameServer, 412).
-define(CMD_GS2LS_ActiveCode, 413).
-define(CMD_LS2GS_Announce, 414).
-define(CMD_LS2GS_Command, 415).
-define(CMD_GS2LS_Command, 416).
-define(CMD_LS2GS_Recharge, 417).
-define(CMD_GS2LS_Recharge, 418).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_LS2GS_LoginResult, {
        reserve
	}).
-record(pk_LS2GS_QueryUserMaxLevel, {
        userID
	}).
-record(pk_LS2GS_UserReadyToLogin, {
        userID,
        username,
        identity,
        platId
	}).
-record(pk_LS2GS_KickOutUser, {
        userID,
        identity
	}).
-record(pk_LS2GS_ActiveCode, {
        pidStr,
        activeCode,
        playerName,
        type
	}).
-record(pk_GS2LS_Request_Login, {
        serverID,
        name,
        ip,
        port,
        remmond,
        showInUserGameList,
        hot
	}).
-record(pk_GS2LS_ReadyToAcceptUser, {
        reserve
	}).
-record(pk_GS2LS_OnlinePlayers, {
        playerCount
	}).
-record(pk_GS2LS_QueryUserMaxLevelResult, {
        userID,
        maxLevel
	}).
-record(pk_GS2LS_UserReadyLoginResult, {
        userID,
        result
	}).
-record(pk_GS2LS_UserLoginGameServer, {
        userID
	}).
-record(pk_GS2LS_UserLogoutGameServer, {
        userID,
        identity
	}).
-record(pk_GS2LS_ActiveCode, {
        pidStr,
        activeCode,
        retcode
	}).
-record(pk_LS2GS_Announce, {
        pidStr,
        announceInfo
	}).
-record(pk_LS2GS_Command, {
        pidStr,
        num,
        cmd,
        params
	}).
-record(pk_GS2LS_Command, {
        pidStr,
        num,
        cmd,
        retcode
	}).
-record(pk_LS2GS_Recharge, {
        pidStr,
        orderid,
        platform,
        account,
        userid,
        playerid,
        ammount
	}).
-record(pk_GS2LS_Recharge, {
        pidStr,
        orderid,
        platform,
        retcode
	}).
