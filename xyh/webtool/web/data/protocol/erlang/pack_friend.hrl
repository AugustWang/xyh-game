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

-define(CMD_FriendInfo, 201).
-define(CMD_GS2U_LoadFriend, 202).
-define(CMD_U2GS_QueryFriend, 203).
-define(CMD_GS2U_FriendTips, 204).
-define(CMD_GS2U_LoadBlack, 205).
-define(CMD_U2GS_QueryBlack, 206).
-define(CMD_GS2U_LoadTemp, 207).
-define(CMD_U2GS_QueryTemp, 208).
-define(CMD_GS2U_FriendInfo, 209).
-define(CMD_U2GS_AddFriend, 210).
-define(CMD_GS2U_AddAcceptResult, 211).
-define(CMD_U2GS_DeleteFriend, 212).
-define(CMD_U2GS_AcceptFriend, 213).
-define(CMD_GS2U_DeteFriendBack, 214).
-define(CMD_GS2U_Net_Message, 215).
-define(CMD_GS2U_OnHookSet_Mess, 216).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_FriendInfo, {
        friendType,
        friendID,
        friendName,
        friendSex,
        friendFace,
        friendClassType,
        friendLevel,
        friendVip,
        friendValue,
        friendOnline
	}).
-record(pk_GS2U_LoadFriend, {
        info_list
	}).
-record(pk_U2GS_QueryFriend, {
        playerid
	}).
-record(pk_GS2U_FriendTips, {
        type,
        tips
	}).
-record(pk_GS2U_LoadBlack, {
        info_list
	}).
-record(pk_U2GS_QueryBlack, {
        playerid
	}).
-record(pk_GS2U_LoadTemp, {
        info_list
	}).
-record(pk_U2GS_QueryTemp, {
        playerid
	}).
-record(pk_GS2U_FriendInfo, {
        friendInfo
	}).
-record(pk_U2GS_AddFriend, {
        friendID,
        friendName,
        type
	}).
-record(pk_GS2U_AddAcceptResult, {
        isSuccess,
        type,
        fname
	}).
-record(pk_U2GS_DeleteFriend, {
        friendID,
        type
	}).
-record(pk_U2GS_AcceptFriend, {
        result,
        friendID
	}).
-record(pk_GS2U_DeteFriendBack, {
        type,
        friendID
	}).
-record(pk_GS2U_Net_Message, {
        mswerHead,
        skno,
        rel
	}).
-record(pk_GS2U_OnHookSet_Mess, {
        playerHP,
        petHP,
        skillID1,
        skillID2,
        skillID3,
        skillID4,
        skillID5,
        skillID6,
        getThing,
        hpThing,
        other,
        isAutoDrug
	}).
