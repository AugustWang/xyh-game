/************************************************************
 * @doc Automatic Generation Of Protocol File
 * 
 * NOTE: 
 *     Please be careful,
 *     if you have manually edited any of protocol file,
 *     do NOT commit to SVN !!!
 *
 * Shenzhen Turbo Technology Co., Ltd. All Rights Reserved.
 * http://www.szturbotech.com
 * Tool Release Time: 2014.3.21
 *
 * @author Rolong<rolong@vip.qq.com>
 ************************************************************/

#pragma  once 

#include <vector> 

using namespace std;

const int MSG_inviteCreateTeam			= 1201;
const int MSG_teamOPResult			= 1202;
const int MSG_beenInviteCreateTeam			= 1203;
const int MSG_ackInviteCreateTeam			= 1204;
const int MSG_teamInfo			= 1206;
const int MSG_teamPlayerOffline			= 1207;
const int MSG_teamQuitRequest			= 1208;
const int MSG_teamPlayerQuit			= 1209;
const int MSG_teamKickOutPlayer			= 1210;
const int MSG_teamPlayerKickOut			= 1211;
const int MSG_inviteJoinTeam			= 1212;
const int MSG_beenInviteJoinTeam			= 1213;
const int MSG_ackInviteJointTeam			= 1214;
const int MSG_applyJoinTeam			= 1215;
const int MSG_queryApplyJoinTeam			= 1216;
const int MSG_ackQueryApplyJoinTeam			= 1217;
const int MSG_addTeamMember			= 1218;
const int MSG_updateTeamMemberInfo			= 1220;
const int MSG_teamDisbanded			= 1221;
const int MSG_teamQueryLeaderInfoOnMyMap			= 1223;
const int MSG_teamQueryLeaderInfoRequest			= 1224;
const int MSG_teamChangeLeader			= 1225;
const int MSG_teamChangeLeaderRequest			= 1226;
const int MSG_beenInviteState			= 1227;

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
