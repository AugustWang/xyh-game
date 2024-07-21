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

-define(CMD_mountInfo, 601).
-define(CMD_U2GS_QueryMyMountInfo, 602).
-define(CMD_GS2U_QueryMyMountInfoResult, 603).
-define(CMD_GS2U_MountInfoUpdate, 604).
-define(CMD_GS2U_MountOPResult, 605).
-define(CMD_U2GS_MountEquipRequest, 606).
-define(CMD_U2GS_Cancel_MountEquipRequest, 607).
-define(CMD_U2GS_MountUpRequest, 608).
-define(CMD_GS2U_MountUp, 609).
-define(CMD_U2GS_MountDownRequest, 610).
-define(CMD_GS2U_MountDown, 611).
-define(CMD_U2GS_LevelUpRequest, 612).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_mountInfo, {
        mountDataID,
        level,
        equiped,
        progress,
        benison_Value
	}).
-record(pk_U2GS_QueryMyMountInfo, {
        reserve
	}).
-record(pk_GS2U_QueryMyMountInfoResult, {
        mounts
	}).
-record(pk_GS2U_MountInfoUpdate, {
        mounts
	}).
-record(pk_GS2U_MountOPResult, {
        mountDataID,
        result
	}).
-record(pk_U2GS_MountEquipRequest, {
        mountDataID
	}).
-record(pk_U2GS_Cancel_MountEquipRequest, {
        reserve
	}).
-record(pk_U2GS_MountUpRequest, {
        reserve
	}).
-record(pk_GS2U_MountUp, {
        actorID,
        mount_data_id
	}).
-record(pk_U2GS_MountDownRequest, {
        reserve
	}).
-record(pk_GS2U_MountDown, {
        actorID
	}).
-record(pk_U2GS_LevelUpRequest, {
        mountDataID,
        isAuto
	}).
