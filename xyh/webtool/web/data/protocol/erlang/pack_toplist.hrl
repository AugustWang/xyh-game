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

-define(CMD_TopPlayerLevelInfo, 1301).
-define(CMD_TopPlayerFightingCapacityInfo, 1302).
-define(CMD_TopPlayerMoneyInfo, 1303).
-define(CMD_GS2U_LoadTopPlayerLevelList, 1304).
-define(CMD_GS2U_LoadTopPlayerFightingCapacityList, 1305).
-define(CMD_GS2U_LoadTopPlayerMoneyList, 1306).
-define(CMD_U2GS_LoadTopPlayerLevelList, 1307).
-define(CMD_U2GS_LoadTopPlayerFightingCapacityList, 1308).
-define(CMD_U2GS_LoadTopPlayerMoneyList, 1309).
-define(CMD_AnswerTopInfo, 1310).
-define(CMD_GS2U_AnswerQuestion, 1311).
-define(CMD_GS2U_AnswerReady, 1312).
-define(CMD_GS2U_AnswerClose, 1313).
-define(CMD_GS2U_AnswerTopList, 1314).
-define(CMD_U2GS_AnswerCommit, 1315).
-define(CMD_U2GS_AnswerCommitRet, 1316).
-define(CMD_U2GS_AnswerSpecial, 1317).
-define(CMD_U2GS_AnswerSpecialRet, 1318).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_TopPlayerLevelInfo, {
        top,
        playerid,
        name,
        camp,
        level,
        fightingcapacity,
        sex,
        weapon,
        coat
	}).
-record(pk_TopPlayerFightingCapacityInfo, {
        top,
        playerid,
        name,
        camp,
        level,
        fightingcapacity,
        sex,
        weapon,
        coat
	}).
-record(pk_TopPlayerMoneyInfo, {
        top,
        playerid,
        name,
        camp,
        level,
        money,
        sex,
        weapon,
        coat
	}).
-record(pk_GS2U_LoadTopPlayerLevelList, {
        info_list
	}).
-record(pk_GS2U_LoadTopPlayerFightingCapacityList, {
        info_list
	}).
-record(pk_GS2U_LoadTopPlayerMoneyList, {
        info_list
	}).
-record(pk_U2GS_LoadTopPlayerLevelList, {
        
	}).
-record(pk_U2GS_LoadTopPlayerFightingCapacityList, {
        
	}).
-record(pk_U2GS_LoadTopPlayerMoneyList, {
        
	}).
-record(pk_AnswerTopInfo, {
        top,
        playerid,
        name,
        core
	}).
-record(pk_GS2U_AnswerQuestion, {
        id,
        num,
        maxnum,
        core,
        special_double,
        special_right,
        special_exclude,
        a,
        b,
        c,
        d,
        e1,
        e2
	}).
-record(pk_GS2U_AnswerReady, {
        time
	}).
-record(pk_GS2U_AnswerClose, {
        
	}).
-record(pk_GS2U_AnswerTopList, {
        info_list
	}).
-record(pk_U2GS_AnswerCommit, {
        num,
        answer,
        time
	}).
-record(pk_U2GS_AnswerCommitRet, {
        ret,
        score
	}).
-record(pk_U2GS_AnswerSpecial, {
        type
	}).
-record(pk_U2GS_AnswerSpecialRet, {
        ret
	}).
