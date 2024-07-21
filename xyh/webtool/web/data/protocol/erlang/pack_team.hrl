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

-define(CMD_inviteCreateTeam, 1201).
-define(CMD_teamOPResult, 1202).
-define(CMD_beenInviteCreateTeam, 1203).
-define(CMD_ackInviteCreateTeam, 1204).
-define(CMD_teamMemberInfo, 1205).
-define(CMD_teamInfo, 1206).
-define(CMD_teamPlayerOffline, 1207).
-define(CMD_teamQuitRequest, 1208).
-define(CMD_teamPlayerQuit, 1209).
-define(CMD_teamKickOutPlayer, 1210).
-define(CMD_teamPlayerKickOut, 1211).
-define(CMD_inviteJoinTeam, 1212).
-define(CMD_beenInviteJoinTeam, 1213).
-define(CMD_ackInviteJointTeam, 1214).
-define(CMD_applyJoinTeam, 1215).
-define(CMD_queryApplyJoinTeam, 1216).
-define(CMD_ackQueryApplyJoinTeam, 1217).
-define(CMD_addTeamMember, 1218).
-define(CMD_shortTeamMemberInfo, 1219).
-define(CMD_updateTeamMemberInfo, 1220).
-define(CMD_teamDisbanded, 1221).
-define(CMD_teamQueryLeaderInfo, 1222).
-define(CMD_teamQueryLeaderInfoOnMyMap, 1223).
-define(CMD_teamQueryLeaderInfoRequest, 1224).
-define(CMD_teamChangeLeader, 1225).
-define(CMD_teamChangeLeaderRequest, 1226).
-define(CMD_beenInviteState, 1227).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_inviteCreateTeam, {
        targetPlayerID
	}).
-record(pk_teamOPResult, {
        targetPlayerID,
        targetPlayerName,
        result
	}).
-record(pk_beenInviteCreateTeam, {
        inviterPlayerID,
        inviterPlayerName
	}).
-record(pk_ackInviteCreateTeam, {
        inviterPlayerID,
        agree
	}).
-record(pk_teamMemberInfo, {
        playerID,
        playerName,
        level,
        posx,
        posy,
        map_data_id,
        isOnline,
        camp,
        sex,
        life_percent
	}).
-record(pk_teamInfo, {
        teamID,
        leaderPlayerID,
        info_list
	}).
-record(pk_teamPlayerOffline, {
        playerID
	}).
-record(pk_teamQuitRequest, {
        reserve
	}).
-record(pk_teamPlayerQuit, {
        playerID
	}).
-record(pk_teamKickOutPlayer, {
        playerID
	}).
-record(pk_teamPlayerKickOut, {
        playerID
	}).
-record(pk_inviteJoinTeam, {
        playerID
	}).
-record(pk_beenInviteJoinTeam, {
        playerID,
        playerName
	}).
-record(pk_ackInviteJointTeam, {
        playerID,
        agree
	}).
-record(pk_applyJoinTeam, {
        playerID
	}).
-record(pk_queryApplyJoinTeam, {
        playerID,
        playerName
	}).
-record(pk_ackQueryApplyJoinTeam, {
        playerID,
        agree
	}).
-record(pk_addTeamMember, {
        info
	}).
-record(pk_shortTeamMemberInfo, {
        playerID,
        level,
        posx,
        posy,
        map_data_id,
        isOnline,
        life_percent
	}).
-record(pk_updateTeamMemberInfo, {
        info_list
	}).
-record(pk_teamDisbanded, {
        reserve
	}).
-record(pk_teamQueryLeaderInfo, {
        playerID,
        playerName,
        level
	}).
-record(pk_teamQueryLeaderInfoOnMyMap, {
        info_list
	}).
-record(pk_teamQueryLeaderInfoRequest, {
        mapID
	}).
-record(pk_teamChangeLeader, {
        playerID
	}).
-record(pk_teamChangeLeaderRequest, {
        playerID
	}).
-record(pk_beenInviteState, {
        state
	}).
