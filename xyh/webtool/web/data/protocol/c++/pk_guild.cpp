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

#include "NetDef.h" 

#include "package.h" 

#include "message.h" 


namespace pk{

void WriteU2GS_RequestCreateGuild(char*& buf,U2GS_RequestCreateGuild& value)
{
    Writeint8(buf,value.useToken);
    Writestring(buf,value.strGuildName);
}
void U2GS_RequestCreateGuild::Send(){
    BeginSend(U2GS_RequestCreateGuild);
    WriteU2GS_RequestCreateGuild(buf,*this);
    EndSend();
}
void ReadU2GS_RequestCreateGuild(char*& buf,U2GS_RequestCreateGuild& value)
{
    Readint8(buf,value.useToken);
    Readstring(buf,value.strGuildName);
}
void WriteU2GS_QueryGuildList(char*& buf,U2GS_QueryGuildList& value)
{
    Writeint8(buf,value.bFirst);
}
void U2GS_QueryGuildList::Send(){
    BeginSend(U2GS_QueryGuildList);
    WriteU2GS_QueryGuildList(buf,*this);
    EndSend();
}
void ReadU2GS_QueryGuildList(char*& buf,U2GS_QueryGuildList& value)
{
    Readint8(buf,value.bFirst);
}
void WriteU2GS_QueryGuildShortInfoEx(char*& buf,U2GS_QueryGuildShortInfoEx& value)
{
    WriteArray(buf,int64,value.vGuilds);
}
void U2GS_QueryGuildShortInfoEx::Send(){
    BeginSend(U2GS_QueryGuildShortInfoEx);
    WriteU2GS_QueryGuildShortInfoEx(buf,*this);
    EndSend();
}
void ReadU2GS_QueryGuildShortInfoEx(char*& buf,U2GS_QueryGuildShortInfoEx& value)
{
    ReadArray(buf,int64,value.vGuilds);
}
void WriteU2GS_GetMyGuildInfo(char*& buf,U2GS_GetMyGuildInfo& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_GetMyGuildInfo::Send(){
    BeginSend(U2GS_GetMyGuildInfo);
    WriteU2GS_GetMyGuildInfo(buf,*this);
    EndSend();
}
void ReadU2GS_GetMyGuildInfo(char*& buf,U2GS_GetMyGuildInfo& value)
{
    Readint8(buf,value.reserve);
}
void WriteU2GS_GetMyGuildApplicantShortInfo(char*& buf,U2GS_GetMyGuildApplicantShortInfo& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_GetMyGuildApplicantShortInfo::Send(){
    BeginSend(U2GS_GetMyGuildApplicantShortInfo);
    WriteU2GS_GetMyGuildApplicantShortInfo(buf,*this);
    EndSend();
}
void ReadU2GS_GetMyGuildApplicantShortInfo(char*& buf,U2GS_GetMyGuildApplicantShortInfo& value)
{
    Readint8(buf,value.reserve);
}
void WriteU2GS_RequestChangeGuildAffiche(char*& buf,U2GS_RequestChangeGuildAffiche& value)
{
    Writestring(buf,value.strAffiche);
}
void U2GS_RequestChangeGuildAffiche::Send(){
    BeginSend(U2GS_RequestChangeGuildAffiche);
    WriteU2GS_RequestChangeGuildAffiche(buf,*this);
    EndSend();
}
void ReadU2GS_RequestChangeGuildAffiche(char*& buf,U2GS_RequestChangeGuildAffiche& value)
{
    Readstring(buf,value.strAffiche);
}
void WriteU2GS_RequestGuildContribute(char*& buf,U2GS_RequestGuildContribute& value)
{
    Writeint(buf,value.nMoney);
    Writeint(buf,value.nGold);
    Writeint(buf,value.nItemCount);
}
void U2GS_RequestGuildContribute::Send(){
    BeginSend(U2GS_RequestGuildContribute);
    WriteU2GS_RequestGuildContribute(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildContribute(char*& buf,U2GS_RequestGuildContribute& value)
{
    Readint(buf,value.nMoney);
    Readint(buf,value.nGold);
    Readint(buf,value.nItemCount);
}
void WriteU2GS_RequestGuildMemberRankChange(char*& buf,U2GS_RequestGuildMemberRankChange& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint8(buf,value.nRank);
}
void U2GS_RequestGuildMemberRankChange::Send(){
    BeginSend(U2GS_RequestGuildMemberRankChange);
    WriteU2GS_RequestGuildMemberRankChange(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildMemberRankChange(char*& buf,U2GS_RequestGuildMemberRankChange& value)
{
    Readint64(buf,value.nPlayerID);
    Readint8(buf,value.nRank);
}
void WriteU2GS_RequestGuildKickOutMember(char*& buf,U2GS_RequestGuildKickOutMember& value)
{
    Writeint64(buf,value.nPlayerID);
}
void U2GS_RequestGuildKickOutMember::Send(){
    BeginSend(U2GS_RequestGuildKickOutMember);
    WriteU2GS_RequestGuildKickOutMember(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildKickOutMember(char*& buf,U2GS_RequestGuildKickOutMember& value)
{
    Readint64(buf,value.nPlayerID);
}
void WriteU2GS_RequestGuildQuit(char*& buf,U2GS_RequestGuildQuit& value)
{
    Writeint(buf,value.reserve);
}
void U2GS_RequestGuildQuit::Send(){
    BeginSend(U2GS_RequestGuildQuit);
    WriteU2GS_RequestGuildQuit(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildQuit(char*& buf,U2GS_RequestGuildQuit& value)
{
    Readint(buf,value.reserve);
}
void WriteU2GS_RequestGuildStudySkill(char*& buf,U2GS_RequestGuildStudySkill& value)
{
    Writeint(buf,value.nSkillGroupID);
}
void U2GS_RequestGuildStudySkill::Send(){
    BeginSend(U2GS_RequestGuildStudySkill);
    WriteU2GS_RequestGuildStudySkill(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildStudySkill(char*& buf,U2GS_RequestGuildStudySkill& value)
{
    Readint(buf,value.nSkillGroupID);
}
void WriteU2GS_RequestJoinGuld(char*& buf,U2GS_RequestJoinGuld& value)
{
    Writeint64(buf,value.nGuildID);
}
void U2GS_RequestJoinGuld::Send(){
    BeginSend(U2GS_RequestJoinGuld);
    WriteU2GS_RequestJoinGuld(buf,*this);
    EndSend();
}
void ReadU2GS_RequestJoinGuld(char*& buf,U2GS_RequestJoinGuld& value)
{
    Readint64(buf,value.nGuildID);
}
void WriteU2GS_RequestGuildApplicantAllow(char*& buf,U2GS_RequestGuildApplicantAllow& value)
{
    Writeint64(buf,value.nPlayerID);
}
void U2GS_RequestGuildApplicantAllow::Send(){
    BeginSend(U2GS_RequestGuildApplicantAllow);
    WriteU2GS_RequestGuildApplicantAllow(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildApplicantAllow(char*& buf,U2GS_RequestGuildApplicantAllow& value)
{
    Readint64(buf,value.nPlayerID);
}
void WriteU2GS_RequestGuildApplicantRefuse(char*& buf,U2GS_RequestGuildApplicantRefuse& value)
{
    Writeint64(buf,value.nPlayerID);
}
void U2GS_RequestGuildApplicantRefuse::Send(){
    BeginSend(U2GS_RequestGuildApplicantRefuse);
    WriteU2GS_RequestGuildApplicantRefuse(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildApplicantRefuse(char*& buf,U2GS_RequestGuildApplicantRefuse& value)
{
    Readint64(buf,value.nPlayerID);
}
void WriteU2GS_RequestGuildApplicantOPAll(char*& buf,U2GS_RequestGuildApplicantOPAll& value)
{
    Writeint(buf,value.nAllowOrRefuse);
}
void U2GS_RequestGuildApplicantOPAll::Send(){
    BeginSend(U2GS_RequestGuildApplicantOPAll);
    WriteU2GS_RequestGuildApplicantOPAll(buf,*this);
    EndSend();
}
void ReadU2GS_RequestGuildApplicantOPAll(char*& buf,U2GS_RequestGuildApplicantOPAll& value)
{
    Readint(buf,value.nAllowOrRefuse);
}
void WriteGS2U_CreateGuildResult(char*& buf,GS2U_CreateGuildResult& value)
{
    Writeint(buf,value.result);
    Writeint64(buf,value.guildID);
}
void ReadGS2U_CreateGuildResult(char*& buf,GS2U_CreateGuildResult& value)
{
    Readint(buf,value.result);
    Readint64(buf,value.guildID);
}
void WriteGS2U_GuildInfoSmall(char*& buf,GS2U_GuildInfoSmall& value)
{
    Writeint64(buf,value.nGuildID);
    Writeint64(buf,value.nChairmanPlayerID);
    Writeint8(buf,value.nLevel);
    Writeint16(buf,value.nMemberCount);
}
void ReadGS2U_GuildInfoSmall(char*& buf,GS2U_GuildInfoSmall& value)
{
    Readint64(buf,value.nGuildID);
    Readint64(buf,value.nChairmanPlayerID);
    Readint8(buf,value.nLevel);
    Readint16(buf,value.nMemberCount);
}
void WriteGS2U_GuildInfoSmallList(char*& buf,GS2U_GuildInfoSmallList& value)
{
    WriteArray(buf,GS2U_GuildInfoSmall,value.info_list);
}
void ReadGS2U_GuildInfoSmallList(char*& buf,GS2U_GuildInfoSmallList& value)
{
    ReadArray(buf,GS2U_GuildInfoSmall,value.info_list);
}
void WriteGS2U_GuildShortInfoEx(char*& buf,GS2U_GuildShortInfoEx& value)
{
    Writeint64(buf,value.nGuildID);
    Writeint8(buf,value.nFaction);
    Writestring(buf,value.strGuildName);
    Writestring(buf,value.strChairmanPlayerName);
}
void ReadGS2U_GuildShortInfoEx(char*& buf,GS2U_GuildShortInfoEx& value)
{
    Readint64(buf,value.nGuildID);
    Readint8(buf,value.nFaction);
    Readstring(buf,value.strGuildName);
    Readstring(buf,value.strChairmanPlayerName);
}
void WriteGS2U_GuildShortInfoExList(char*& buf,GS2U_GuildShortInfoExList& value)
{
    WriteArray(buf,GS2U_GuildShortInfoEx,value.info_list);
}
void ReadGS2U_GuildShortInfoExList(char*& buf,GS2U_GuildShortInfoExList& value)
{
    ReadArray(buf,GS2U_GuildShortInfoEx,value.info_list);
}
void WriteGS2U_GuildAllShortInfo(char*& buf,GS2U_GuildAllShortInfo& value)
{
    Writeint64(buf,value.nGuildID);
    Writeint64(buf,value.nChairmanPlayerID);
    Writestring(buf,value.strChairmanPlayerName);
    Writeint8(buf,value.nLevel);
    Writeint16(buf,value.nMemberCount);
    Writeint8(buf,value.nFaction);
    Writestring(buf,value.strGuildName);
}
void ReadGS2U_GuildAllShortInfo(char*& buf,GS2U_GuildAllShortInfo& value)
{
    Readint64(buf,value.nGuildID);
    Readint64(buf,value.nChairmanPlayerID);
    Readstring(buf,value.strChairmanPlayerName);
    Readint8(buf,value.nLevel);
    Readint16(buf,value.nMemberCount);
    Readint8(buf,value.nFaction);
    Readstring(buf,value.strGuildName);
}
void WriteGS2U_GuildAllShortInfoList(char*& buf,GS2U_GuildAllShortInfoList& value)
{
    WriteArray(buf,GS2U_GuildAllShortInfo,value.info_list);
}
void ReadGS2U_GuildAllShortInfoList(char*& buf,GS2U_GuildAllShortInfoList& value)
{
    ReadArray(buf,GS2U_GuildAllShortInfo,value.info_list);
}
void WriteGS2U_GuildBaseData(char*& buf,GS2U_GuildBaseData& value)
{
    Writeint64(buf,value.nGuildID);
    Writeint64(buf,value.nChairmanPlayerID);
    Writeint8(buf,value.nFaction);
    Writeint8(buf,value.nLevel);
    Writeint16(buf,value.nExp);
    Writeint(buf,value.memberCount);
    Writestring(buf,value.strChairmanPlayerName);
    Writestring(buf,value.strGuildName);
    Writestring(buf,value.strAffiche);
}
void ReadGS2U_GuildBaseData(char*& buf,GS2U_GuildBaseData& value)
{
    Readint64(buf,value.nGuildID);
    Readint64(buf,value.nChairmanPlayerID);
    Readint8(buf,value.nFaction);
    Readint8(buf,value.nLevel);
    Readint16(buf,value.nExp);
    Readint(buf,value.memberCount);
    Readstring(buf,value.strChairmanPlayerName);
    Readstring(buf,value.strGuildName);
    Readstring(buf,value.strAffiche);
}
void WriteGS2U_GuildMemberData(char*& buf,GS2U_GuildMemberData& value)
{
    Writeint64(buf,value.nPlayerID);
    Writestring(buf,value.strPlayerName);
    Writeint16(buf,value.nPlayerLevel);
    Writeint8(buf,value.nRank);
    Writeint8(buf,value.nClass);
    Writeint(buf,value.nContribute);
    Writeint8(buf,value.bOnline);
}
void ReadGS2U_GuildMemberData(char*& buf,GS2U_GuildMemberData& value)
{
    Readint64(buf,value.nPlayerID);
    Readstring(buf,value.strPlayerName);
    Readint16(buf,value.nPlayerLevel);
    Readint8(buf,value.nRank);
    Readint8(buf,value.nClass);
    Readint(buf,value.nContribute);
    Readint8(buf,value.bOnline);
}
void WriteGS2U_GuildApplicantData(char*& buf,GS2U_GuildApplicantData& value)
{
    Writeint64(buf,value.nPlayerID);
    Writestring(buf,value.strPlayerName);
    Writeint16(buf,value.nPlayerLevel);
    Writeint8(buf,value.nClass);
    Writeint(buf,value.nZhanLi);
}
void ReadGS2U_GuildApplicantData(char*& buf,GS2U_GuildApplicantData& value)
{
    Readint64(buf,value.nPlayerID);
    Readstring(buf,value.strPlayerName);
    Readint16(buf,value.nPlayerLevel);
    Readint8(buf,value.nClass);
    Readint(buf,value.nZhanLi);
}
void WriteGS2U_GuildFullInfo(char*& buf,GS2U_GuildFullInfo& value)
{
    WriteGS2U_GuildBaseData(buf,value.stBase);
    WriteArray(buf,GS2U_GuildMemberData,value.member_list);
    WriteArray(buf,GS2U_GuildApplicantData,value.applicant_list);
}
void ReadGS2U_GuildFullInfo(char*& buf,GS2U_GuildFullInfo& value)
{
    ReadGS2U_GuildBaseData(buf,value.stBase);
    ReadArray(buf,GS2U_GuildMemberData,value.member_list);
    ReadArray(buf,GS2U_GuildApplicantData,value.applicant_list);
}
void WriteGS2U_GuildApplicantShortData(char*& buf,GS2U_GuildApplicantShortData& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint16(buf,value.nPlayerLevel);
    Writeint(buf,value.nZhanLi);
}
void ReadGS2U_GuildApplicantShortData(char*& buf,GS2U_GuildApplicantShortData& value)
{
    Readint64(buf,value.nPlayerID);
    Readint16(buf,value.nPlayerLevel);
    Readint(buf,value.nZhanLi);
}
void WriteGS2U_GuildApplicantShortList(char*& buf,GS2U_GuildApplicantShortList& value)
{
    WriteArray(buf,GS2U_GuildApplicantShortData,value.info_list);
}
void ReadGS2U_GuildApplicantShortList(char*& buf,GS2U_GuildApplicantShortList& value)
{
    ReadArray(buf,GS2U_GuildApplicantShortData,value.info_list);
}
void WriteGS2U_GuildLevelEXPChanged(char*& buf,GS2U_GuildLevelEXPChanged& value)
{
    Writeint16(buf,value.nLevel);
    Writeint(buf,value.nEXP);
}
void ReadGS2U_GuildLevelEXPChanged(char*& buf,GS2U_GuildLevelEXPChanged& value)
{
    Readint16(buf,value.nLevel);
    Readint(buf,value.nEXP);
}
void WriteGS2U_GuildAfficheChanged(char*& buf,GS2U_GuildAfficheChanged& value)
{
    Writestring(buf,value.strAffiche);
}
void ReadGS2U_GuildAfficheChanged(char*& buf,GS2U_GuildAfficheChanged& value)
{
    Readstring(buf,value.strAffiche);
}
void WriteGS2U_GuildMemberContributeChanged(char*& buf,GS2U_GuildMemberContributeChanged& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint(buf,value.nContribute);
}
void ReadGS2U_GuildMemberContributeChanged(char*& buf,GS2U_GuildMemberContributeChanged& value)
{
    Readint64(buf,value.nPlayerID);
    Readint(buf,value.nContribute);
}
void WriteGS2U_GuildMemberLevelChanged(char*& buf,GS2U_GuildMemberLevelChanged& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint16(buf,value.nLevel);
}
void ReadGS2U_GuildMemberLevelChanged(char*& buf,GS2U_GuildMemberLevelChanged& value)
{
    Readint64(buf,value.nPlayerID);
    Readint16(buf,value.nLevel);
}
void WriteGS2U_GuildMemberOnlineChanged(char*& buf,GS2U_GuildMemberOnlineChanged& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint8(buf,value.nOnline);
}
void ReadGS2U_GuildMemberOnlineChanged(char*& buf,GS2U_GuildMemberOnlineChanged& value)
{
    Readint64(buf,value.nPlayerID);
    Readint8(buf,value.nOnline);
}
void WriteGS2U_GuildMemberRankChanged(char*& buf,GS2U_GuildMemberRankChanged& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint8(buf,value.nRank);
}
void ReadGS2U_GuildMemberRankChanged(char*& buf,GS2U_GuildMemberRankChanged& value)
{
    Readint64(buf,value.nPlayerID);
    Readint8(buf,value.nRank);
}
void WriteGS2U_GuildMemberAdd(char*& buf,GS2U_GuildMemberAdd& value)
{
    WriteGS2U_GuildMemberData(buf,value.stData);
}
void ReadGS2U_GuildMemberAdd(char*& buf,GS2U_GuildMemberAdd& value)
{
    ReadGS2U_GuildMemberData(buf,value.stData);
}
void WriteGS2U_GuildMemberQuit(char*& buf,GS2U_GuildMemberQuit& value)
{
    Writeint64(buf,value.nPlayerID);
    Writeint8(buf,value.bKickOut);
}
void ReadGS2U_GuildMemberQuit(char*& buf,GS2U_GuildMemberQuit& value)
{
    Readint64(buf,value.nPlayerID);
    Readint8(buf,value.bKickOut);
}
void WriteGS2U_JoinGuildSuccess(char*& buf,GS2U_JoinGuildSuccess& value)
{
    Writeint64(buf,value.guildID);
    Writestring(buf,value.guildName);
}
void ReadGS2U_JoinGuildSuccess(char*& buf,GS2U_JoinGuildSuccess& value)
{
    Readint64(buf,value.guildID);
    Readstring(buf,value.guildName);
}
void WriteGS2U_AllowOpComplete(char*& buf,GS2U_AllowOpComplete& value)
{
    Writeint64(buf,value.playerID);
}
void ReadGS2U_AllowOpComplete(char*& buf,GS2U_AllowOpComplete& value)
{
    Readint64(buf,value.playerID);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
