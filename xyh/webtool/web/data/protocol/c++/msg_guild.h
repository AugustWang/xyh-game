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

const int MSG_U2GS_RequestCreateGuild			= 301;
const int MSG_U2GS_QueryGuildList			= 302;
const int MSG_U2GS_QueryGuildShortInfoEx			= 303;
const int MSG_U2GS_GetMyGuildInfo			= 304;
const int MSG_U2GS_GetMyGuildApplicantShortInfo			= 305;
const int MSG_U2GS_RequestChangeGuildAffiche			= 306;
const int MSG_U2GS_RequestGuildContribute			= 307;
const int MSG_U2GS_RequestGuildMemberRankChange			= 308;
const int MSG_U2GS_RequestGuildKickOutMember			= 309;
const int MSG_U2GS_RequestGuildQuit			= 310;
const int MSG_U2GS_RequestGuildStudySkill			= 311;
const int MSG_U2GS_RequestJoinGuld			= 312;
const int MSG_U2GS_RequestGuildApplicantAllow			= 313;
const int MSG_U2GS_RequestGuildApplicantRefuse			= 314;
const int MSG_U2GS_RequestGuildApplicantOPAll			= 315;
const int MSG_GS2U_CreateGuildResult			= 316;
const int MSG_GS2U_GuildInfoSmallList			= 318;
const int MSG_GS2U_GuildShortInfoExList			= 320;
const int MSG_GS2U_GuildAllShortInfoList			= 322;
const int MSG_GS2U_GuildFullInfo			= 326;
const int MSG_GS2U_GuildApplicantShortList			= 328;
const int MSG_GS2U_GuildLevelEXPChanged			= 329;
const int MSG_GS2U_GuildAfficheChanged			= 330;
const int MSG_GS2U_GuildMemberContributeChanged			= 331;
const int MSG_GS2U_GuildMemberLevelChanged			= 332;
const int MSG_GS2U_GuildMemberOnlineChanged			= 333;
const int MSG_GS2U_GuildMemberRankChanged			= 334;
const int MSG_GS2U_GuildMemberAdd			= 335;
const int MSG_GS2U_GuildMemberQuit			= 336;
const int MSG_GS2U_JoinGuildSuccess			= 337;
const int MSG_GS2U_AllowOpComplete			= 338;

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
