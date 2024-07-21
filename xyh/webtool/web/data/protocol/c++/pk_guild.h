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
#include "NetDef.h" 

using namespace std;

namespace pk{

struct U2GS_RequestCreateGuild
{
    int8 useToken;
    string strGuildName;
	void Send();
};
void WriteU2GS_RequestCreateGuild(char*& buf,U2GS_RequestCreateGuild& value);
void ReadU2GS_RequestCreateGuild(char*& buf,U2GS_RequestCreateGuild& value);

struct U2GS_QueryGuildList
{
    int8 bFirst;
	void Send();
};
void WriteU2GS_QueryGuildList(char*& buf,U2GS_QueryGuildList& value);
void ReadU2GS_QueryGuildList(char*& buf,U2GS_QueryGuildList& value);

struct U2GS_QueryGuildShortInfoEx
{
    vector<int64> vGuilds;
	void Send();
};
void WriteU2GS_QueryGuildShortInfoEx(char*& buf,U2GS_QueryGuildShortInfoEx& value);
void ReadU2GS_QueryGuildShortInfoEx(char*& buf,U2GS_QueryGuildShortInfoEx& value);

struct U2GS_GetMyGuildInfo
{
    int8 reserve;
	void Send();
};
void WriteU2GS_GetMyGuildInfo(char*& buf,U2GS_GetMyGuildInfo& value);
void ReadU2GS_GetMyGuildInfo(char*& buf,U2GS_GetMyGuildInfo& value);

struct U2GS_GetMyGuildApplicantShortInfo
{
    int8 reserve;
	void Send();
};
void WriteU2GS_GetMyGuildApplicantShortInfo(char*& buf,U2GS_GetMyGuildApplicantShortInfo& value);
void ReadU2GS_GetMyGuildApplicantShortInfo(char*& buf,U2GS_GetMyGuildApplicantShortInfo& value);

struct U2GS_RequestChangeGuildAffiche
{
    string strAffiche;
	void Send();
};
void WriteU2GS_RequestChangeGuildAffiche(char*& buf,U2GS_RequestChangeGuildAffiche& value);
void ReadU2GS_RequestChangeGuildAffiche(char*& buf,U2GS_RequestChangeGuildAffiche& value);

struct U2GS_RequestGuildContribute
{
    int nMoney;
    int nGold;
    int nItemCount;
	void Send();
};
void WriteU2GS_RequestGuildContribute(char*& buf,U2GS_RequestGuildContribute& value);
void ReadU2GS_RequestGuildContribute(char*& buf,U2GS_RequestGuildContribute& value);

struct U2GS_RequestGuildMemberRankChange
{
    int64 nPlayerID;
    int8 nRank;
	void Send();
};
void WriteU2GS_RequestGuildMemberRankChange(char*& buf,U2GS_RequestGuildMemberRankChange& value);
void ReadU2GS_RequestGuildMemberRankChange(char*& buf,U2GS_RequestGuildMemberRankChange& value);

struct U2GS_RequestGuildKickOutMember
{
    int64 nPlayerID;
	void Send();
};
void WriteU2GS_RequestGuildKickOutMember(char*& buf,U2GS_RequestGuildKickOutMember& value);
void ReadU2GS_RequestGuildKickOutMember(char*& buf,U2GS_RequestGuildKickOutMember& value);

struct U2GS_RequestGuildQuit
{
    int reserve;
	void Send();
};
void WriteU2GS_RequestGuildQuit(char*& buf,U2GS_RequestGuildQuit& value);
void ReadU2GS_RequestGuildQuit(char*& buf,U2GS_RequestGuildQuit& value);

struct U2GS_RequestGuildStudySkill
{
    int nSkillGroupID;
	void Send();
};
void WriteU2GS_RequestGuildStudySkill(char*& buf,U2GS_RequestGuildStudySkill& value);
void ReadU2GS_RequestGuildStudySkill(char*& buf,U2GS_RequestGuildStudySkill& value);

struct U2GS_RequestJoinGuld
{
    int64 nGuildID;
	void Send();
};
void WriteU2GS_RequestJoinGuld(char*& buf,U2GS_RequestJoinGuld& value);
void ReadU2GS_RequestJoinGuld(char*& buf,U2GS_RequestJoinGuld& value);

struct U2GS_RequestGuildApplicantAllow
{
    int64 nPlayerID;
	void Send();
};
void WriteU2GS_RequestGuildApplicantAllow(char*& buf,U2GS_RequestGuildApplicantAllow& value);
void ReadU2GS_RequestGuildApplicantAllow(char*& buf,U2GS_RequestGuildApplicantAllow& value);

struct U2GS_RequestGuildApplicantRefuse
{
    int64 nPlayerID;
	void Send();
};
void WriteU2GS_RequestGuildApplicantRefuse(char*& buf,U2GS_RequestGuildApplicantRefuse& value);
void ReadU2GS_RequestGuildApplicantRefuse(char*& buf,U2GS_RequestGuildApplicantRefuse& value);

struct U2GS_RequestGuildApplicantOPAll
{
    int nAllowOrRefuse;
	void Send();
};
void WriteU2GS_RequestGuildApplicantOPAll(char*& buf,U2GS_RequestGuildApplicantOPAll& value);
void ReadU2GS_RequestGuildApplicantOPAll(char*& buf,U2GS_RequestGuildApplicantOPAll& value);

struct GS2U_CreateGuildResult
{
    int result;
    int64 guildID;
};
void WriteGS2U_CreateGuildResult(char*& buf,GS2U_CreateGuildResult& value);
void OnGS2U_CreateGuildResult(GS2U_CreateGuildResult* value);
void ReadGS2U_CreateGuildResult(char*& buf,GS2U_CreateGuildResult& value);

struct GS2U_GuildInfoSmall
{
    int64 nGuildID;
    int64 nChairmanPlayerID;
    int8 nLevel;
    int16 nMemberCount;
};
void WriteGS2U_GuildInfoSmall(char*& buf,GS2U_GuildInfoSmall& value);
void ReadGS2U_GuildInfoSmall(char*& buf,GS2U_GuildInfoSmall& value);

struct GS2U_GuildInfoSmallList
{
    vector<GS2U_GuildInfoSmall> info_list;
};
void WriteGS2U_GuildInfoSmallList(char*& buf,GS2U_GuildInfoSmallList& value);
void OnGS2U_GuildInfoSmallList(GS2U_GuildInfoSmallList* value);
void ReadGS2U_GuildInfoSmallList(char*& buf,GS2U_GuildInfoSmallList& value);

struct GS2U_GuildShortInfoEx
{
    int64 nGuildID;
    int8 nFaction;
    string strGuildName;
    string strChairmanPlayerName;
};
void WriteGS2U_GuildShortInfoEx(char*& buf,GS2U_GuildShortInfoEx& value);
void ReadGS2U_GuildShortInfoEx(char*& buf,GS2U_GuildShortInfoEx& value);

struct GS2U_GuildShortInfoExList
{
    vector<GS2U_GuildShortInfoEx> info_list;
};
void WriteGS2U_GuildShortInfoExList(char*& buf,GS2U_GuildShortInfoExList& value);
void OnGS2U_GuildShortInfoExList(GS2U_GuildShortInfoExList* value);
void ReadGS2U_GuildShortInfoExList(char*& buf,GS2U_GuildShortInfoExList& value);

struct GS2U_GuildAllShortInfo
{
    int64 nGuildID;
    int64 nChairmanPlayerID;
    string strChairmanPlayerName;
    int8 nLevel;
    int16 nMemberCount;
    int8 nFaction;
    string strGuildName;
};
void WriteGS2U_GuildAllShortInfo(char*& buf,GS2U_GuildAllShortInfo& value);
void ReadGS2U_GuildAllShortInfo(char*& buf,GS2U_GuildAllShortInfo& value);

struct GS2U_GuildAllShortInfoList
{
    vector<GS2U_GuildAllShortInfo> info_list;
};
void WriteGS2U_GuildAllShortInfoList(char*& buf,GS2U_GuildAllShortInfoList& value);
void OnGS2U_GuildAllShortInfoList(GS2U_GuildAllShortInfoList* value);
void ReadGS2U_GuildAllShortInfoList(char*& buf,GS2U_GuildAllShortInfoList& value);

struct GS2U_GuildBaseData
{
    int64 nGuildID;
    int64 nChairmanPlayerID;
    int8 nFaction;
    int8 nLevel;
    int16 nExp;
    int memberCount;
    string strChairmanPlayerName;
    string strGuildName;
    string strAffiche;
};
void WriteGS2U_GuildBaseData(char*& buf,GS2U_GuildBaseData& value);
void ReadGS2U_GuildBaseData(char*& buf,GS2U_GuildBaseData& value);

struct GS2U_GuildMemberData
{
    int64 nPlayerID;
    string strPlayerName;
    int16 nPlayerLevel;
    int8 nRank;
    int8 nClass;
    int nContribute;
    int8 bOnline;
};
void WriteGS2U_GuildMemberData(char*& buf,GS2U_GuildMemberData& value);
void ReadGS2U_GuildMemberData(char*& buf,GS2U_GuildMemberData& value);

struct GS2U_GuildApplicantData
{
    int64 nPlayerID;
    string strPlayerName;
    int16 nPlayerLevel;
    int8 nClass;
    int nZhanLi;
};
void WriteGS2U_GuildApplicantData(char*& buf,GS2U_GuildApplicantData& value);
void ReadGS2U_GuildApplicantData(char*& buf,GS2U_GuildApplicantData& value);

struct GS2U_GuildFullInfo
{
    GS2U_GuildBaseData stBase;
    vector<GS2U_GuildMemberData> member_list;
    vector<GS2U_GuildApplicantData> applicant_list;
};
void WriteGS2U_GuildFullInfo(char*& buf,GS2U_GuildFullInfo& value);
void OnGS2U_GuildFullInfo(GS2U_GuildFullInfo* value);
void ReadGS2U_GuildFullInfo(char*& buf,GS2U_GuildFullInfo& value);

struct GS2U_GuildApplicantShortData
{
    int64 nPlayerID;
    int16 nPlayerLevel;
    int nZhanLi;
};
void WriteGS2U_GuildApplicantShortData(char*& buf,GS2U_GuildApplicantShortData& value);
void ReadGS2U_GuildApplicantShortData(char*& buf,GS2U_GuildApplicantShortData& value);

struct GS2U_GuildApplicantShortList
{
    vector<GS2U_GuildApplicantShortData> info_list;
};
void WriteGS2U_GuildApplicantShortList(char*& buf,GS2U_GuildApplicantShortList& value);
void OnGS2U_GuildApplicantShortList(GS2U_GuildApplicantShortList* value);
void ReadGS2U_GuildApplicantShortList(char*& buf,GS2U_GuildApplicantShortList& value);

struct GS2U_GuildLevelEXPChanged
{
    int16 nLevel;
    int nEXP;
};
void WriteGS2U_GuildLevelEXPChanged(char*& buf,GS2U_GuildLevelEXPChanged& value);
void OnGS2U_GuildLevelEXPChanged(GS2U_GuildLevelEXPChanged* value);
void ReadGS2U_GuildLevelEXPChanged(char*& buf,GS2U_GuildLevelEXPChanged& value);

struct GS2U_GuildAfficheChanged
{
    string strAffiche;
};
void WriteGS2U_GuildAfficheChanged(char*& buf,GS2U_GuildAfficheChanged& value);
void OnGS2U_GuildAfficheChanged(GS2U_GuildAfficheChanged* value);
void ReadGS2U_GuildAfficheChanged(char*& buf,GS2U_GuildAfficheChanged& value);

struct GS2U_GuildMemberContributeChanged
{
    int64 nPlayerID;
    int nContribute;
};
void WriteGS2U_GuildMemberContributeChanged(char*& buf,GS2U_GuildMemberContributeChanged& value);
void OnGS2U_GuildMemberContributeChanged(GS2U_GuildMemberContributeChanged* value);
void ReadGS2U_GuildMemberContributeChanged(char*& buf,GS2U_GuildMemberContributeChanged& value);

struct GS2U_GuildMemberLevelChanged
{
    int64 nPlayerID;
    int16 nLevel;
};
void WriteGS2U_GuildMemberLevelChanged(char*& buf,GS2U_GuildMemberLevelChanged& value);
void OnGS2U_GuildMemberLevelChanged(GS2U_GuildMemberLevelChanged* value);
void ReadGS2U_GuildMemberLevelChanged(char*& buf,GS2U_GuildMemberLevelChanged& value);

struct GS2U_GuildMemberOnlineChanged
{
    int64 nPlayerID;
    int8 nOnline;
};
void WriteGS2U_GuildMemberOnlineChanged(char*& buf,GS2U_GuildMemberOnlineChanged& value);
void OnGS2U_GuildMemberOnlineChanged(GS2U_GuildMemberOnlineChanged* value);
void ReadGS2U_GuildMemberOnlineChanged(char*& buf,GS2U_GuildMemberOnlineChanged& value);

struct GS2U_GuildMemberRankChanged
{
    int64 nPlayerID;
    int8 nRank;
};
void WriteGS2U_GuildMemberRankChanged(char*& buf,GS2U_GuildMemberRankChanged& value);
void OnGS2U_GuildMemberRankChanged(GS2U_GuildMemberRankChanged* value);
void ReadGS2U_GuildMemberRankChanged(char*& buf,GS2U_GuildMemberRankChanged& value);

struct GS2U_GuildMemberAdd
{
    GS2U_GuildMemberData stData;
};
void WriteGS2U_GuildMemberAdd(char*& buf,GS2U_GuildMemberAdd& value);
void OnGS2U_GuildMemberAdd(GS2U_GuildMemberAdd* value);
void ReadGS2U_GuildMemberAdd(char*& buf,GS2U_GuildMemberAdd& value);

struct GS2U_GuildMemberQuit
{
    int64 nPlayerID;
    int8 bKickOut;
};
void WriteGS2U_GuildMemberQuit(char*& buf,GS2U_GuildMemberQuit& value);
void OnGS2U_GuildMemberQuit(GS2U_GuildMemberQuit* value);
void ReadGS2U_GuildMemberQuit(char*& buf,GS2U_GuildMemberQuit& value);

struct GS2U_JoinGuildSuccess
{
    int64 guildID;
    string guildName;
};
void WriteGS2U_JoinGuildSuccess(char*& buf,GS2U_JoinGuildSuccess& value);
void OnGS2U_JoinGuildSuccess(GS2U_JoinGuildSuccess* value);
void ReadGS2U_JoinGuildSuccess(char*& buf,GS2U_JoinGuildSuccess& value);

struct GS2U_AllowOpComplete
{
    int64 playerID;
};
void WriteGS2U_AllowOpComplete(char*& buf,GS2U_AllowOpComplete& value);
void OnGS2U_AllowOpComplete(GS2U_AllowOpComplete* value);
void ReadGS2U_AllowOpComplete(char*& buf,GS2U_AllowOpComplete& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
