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

void WriteinviteCreateTeam(char*& buf,inviteCreateTeam& value)
{
    Writeint64(buf,value.targetPlayerID);
}
void inviteCreateTeam::Send(){
    BeginSend(inviteCreateTeam);
    WriteinviteCreateTeam(buf,*this);
    EndSend();
}
void ReadinviteCreateTeam(char*& buf,inviteCreateTeam& value)
{
    Readint64(buf,value.targetPlayerID);
}
void WriteteamOPResult(char*& buf,teamOPResult& value)
{
    Writeint64(buf,value.targetPlayerID);
    Writestring(buf,value.targetPlayerName);
    Writeint(buf,value.result);
}
void ReadteamOPResult(char*& buf,teamOPResult& value)
{
    Readint64(buf,value.targetPlayerID);
    Readstring(buf,value.targetPlayerName);
    Readint(buf,value.result);
}
void WritebeenInviteCreateTeam(char*& buf,beenInviteCreateTeam& value)
{
    Writeint64(buf,value.inviterPlayerID);
    Writestring(buf,value.inviterPlayerName);
}
void ReadbeenInviteCreateTeam(char*& buf,beenInviteCreateTeam& value)
{
    Readint64(buf,value.inviterPlayerID);
    Readstring(buf,value.inviterPlayerName);
}
void WriteackInviteCreateTeam(char*& buf,ackInviteCreateTeam& value)
{
    Writeint64(buf,value.inviterPlayerID);
    Writeint8(buf,value.agree);
}
void ackInviteCreateTeam::Send(){
    BeginSend(ackInviteCreateTeam);
    WriteackInviteCreateTeam(buf,*this);
    EndSend();
}
void ReadackInviteCreateTeam(char*& buf,ackInviteCreateTeam& value)
{
    Readint64(buf,value.inviterPlayerID);
    Readint8(buf,value.agree);
}
void WriteteamMemberInfo(char*& buf,teamMemberInfo& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
    Writeint16(buf,value.level);
    Writeint16(buf,value.posx);
    Writeint16(buf,value.posy);
    Writeint8(buf,value.map_data_id);
    Writeint8(buf,value.isOnline);
    Writeint8(buf,value.camp);
    Writeint8(buf,value.sex);
    Writeint8(buf,value.life_percent);
}
void ReadteamMemberInfo(char*& buf,teamMemberInfo& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
    Readint16(buf,value.level);
    Readint16(buf,value.posx);
    Readint16(buf,value.posy);
    Readint8(buf,value.map_data_id);
    Readint8(buf,value.isOnline);
    Readint8(buf,value.camp);
    Readint8(buf,value.sex);
    Readint8(buf,value.life_percent);
}
void WriteteamInfo(char*& buf,teamInfo& value)
{
    Writeint64(buf,value.teamID);
    Writeint64(buf,value.leaderPlayerID);
    WriteArray(buf,teamMemberInfo,value.info_list);
}
void ReadteamInfo(char*& buf,teamInfo& value)
{
    Readint64(buf,value.teamID);
    Readint64(buf,value.leaderPlayerID);
    ReadArray(buf,teamMemberInfo,value.info_list);
}
void WriteteamPlayerOffline(char*& buf,teamPlayerOffline& value)
{
    Writeint64(buf,value.playerID);
}
void ReadteamPlayerOffline(char*& buf,teamPlayerOffline& value)
{
    Readint64(buf,value.playerID);
}
void WriteteamQuitRequest(char*& buf,teamQuitRequest& value)
{
    Writeint8(buf,value.reserve);
}
void teamQuitRequest::Send(){
    BeginSend(teamQuitRequest);
    WriteteamQuitRequest(buf,*this);
    EndSend();
}
void ReadteamQuitRequest(char*& buf,teamQuitRequest& value)
{
    Readint8(buf,value.reserve);
}
void WriteteamPlayerQuit(char*& buf,teamPlayerQuit& value)
{
    Writeint64(buf,value.playerID);
}
void ReadteamPlayerQuit(char*& buf,teamPlayerQuit& value)
{
    Readint64(buf,value.playerID);
}
void WriteteamKickOutPlayer(char*& buf,teamKickOutPlayer& value)
{
    Writeint64(buf,value.playerID);
}
void teamKickOutPlayer::Send(){
    BeginSend(teamKickOutPlayer);
    WriteteamKickOutPlayer(buf,*this);
    EndSend();
}
void ReadteamKickOutPlayer(char*& buf,teamKickOutPlayer& value)
{
    Readint64(buf,value.playerID);
}
void WriteteamPlayerKickOut(char*& buf,teamPlayerKickOut& value)
{
    Writeint64(buf,value.playerID);
}
void ReadteamPlayerKickOut(char*& buf,teamPlayerKickOut& value)
{
    Readint64(buf,value.playerID);
}
void WriteinviteJoinTeam(char*& buf,inviteJoinTeam& value)
{
    Writeint64(buf,value.playerID);
}
void inviteJoinTeam::Send(){
    BeginSend(inviteJoinTeam);
    WriteinviteJoinTeam(buf,*this);
    EndSend();
}
void ReadinviteJoinTeam(char*& buf,inviteJoinTeam& value)
{
    Readint64(buf,value.playerID);
}
void WritebeenInviteJoinTeam(char*& buf,beenInviteJoinTeam& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
}
void ReadbeenInviteJoinTeam(char*& buf,beenInviteJoinTeam& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
}
void WriteackInviteJointTeam(char*& buf,ackInviteJointTeam& value)
{
    Writeint64(buf,value.playerID);
    Writeint8(buf,value.agree);
}
void ackInviteJointTeam::Send(){
    BeginSend(ackInviteJointTeam);
    WriteackInviteJointTeam(buf,*this);
    EndSend();
}
void ReadackInviteJointTeam(char*& buf,ackInviteJointTeam& value)
{
    Readint64(buf,value.playerID);
    Readint8(buf,value.agree);
}
void WriteapplyJoinTeam(char*& buf,applyJoinTeam& value)
{
    Writeint64(buf,value.playerID);
}
void applyJoinTeam::Send(){
    BeginSend(applyJoinTeam);
    WriteapplyJoinTeam(buf,*this);
    EndSend();
}
void ReadapplyJoinTeam(char*& buf,applyJoinTeam& value)
{
    Readint64(buf,value.playerID);
}
void WritequeryApplyJoinTeam(char*& buf,queryApplyJoinTeam& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
}
void ReadqueryApplyJoinTeam(char*& buf,queryApplyJoinTeam& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
}
void WriteackQueryApplyJoinTeam(char*& buf,ackQueryApplyJoinTeam& value)
{
    Writeint64(buf,value.playerID);
    Writeint8(buf,value.agree);
}
void ackQueryApplyJoinTeam::Send(){
    BeginSend(ackQueryApplyJoinTeam);
    WriteackQueryApplyJoinTeam(buf,*this);
    EndSend();
}
void ReadackQueryApplyJoinTeam(char*& buf,ackQueryApplyJoinTeam& value)
{
    Readint64(buf,value.playerID);
    Readint8(buf,value.agree);
}
void WriteaddTeamMember(char*& buf,addTeamMember& value)
{
    WriteteamMemberInfo(buf,value.info);
}
void ReadaddTeamMember(char*& buf,addTeamMember& value)
{
    ReadteamMemberInfo(buf,value.info);
}
void WriteshortTeamMemberInfo(char*& buf,shortTeamMemberInfo& value)
{
    Writeint64(buf,value.playerID);
    Writeint16(buf,value.level);
    Writeint16(buf,value.posx);
    Writeint16(buf,value.posy);
    Writeint8(buf,value.map_data_id);
    Writeint8(buf,value.isOnline);
    Writeint8(buf,value.life_percent);
}
void ReadshortTeamMemberInfo(char*& buf,shortTeamMemberInfo& value)
{
    Readint64(buf,value.playerID);
    Readint16(buf,value.level);
    Readint16(buf,value.posx);
    Readint16(buf,value.posy);
    Readint8(buf,value.map_data_id);
    Readint8(buf,value.isOnline);
    Readint8(buf,value.life_percent);
}
void WriteupdateTeamMemberInfo(char*& buf,updateTeamMemberInfo& value)
{
    WriteArray(buf,shortTeamMemberInfo,value.info_list);
}
void ReadupdateTeamMemberInfo(char*& buf,updateTeamMemberInfo& value)
{
    ReadArray(buf,shortTeamMemberInfo,value.info_list);
}
void WriteteamDisbanded(char*& buf,teamDisbanded& value)
{
    Writeint8(buf,value.reserve);
}
void ReadteamDisbanded(char*& buf,teamDisbanded& value)
{
    Readint8(buf,value.reserve);
}
void WriteteamQueryLeaderInfo(char*& buf,teamQueryLeaderInfo& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
    Writeint16(buf,value.level);
}
void ReadteamQueryLeaderInfo(char*& buf,teamQueryLeaderInfo& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
    Readint16(buf,value.level);
}
void WriteteamQueryLeaderInfoOnMyMap(char*& buf,teamQueryLeaderInfoOnMyMap& value)
{
    WriteArray(buf,teamQueryLeaderInfo,value.info_list);
}
void ReadteamQueryLeaderInfoOnMyMap(char*& buf,teamQueryLeaderInfoOnMyMap& value)
{
    ReadArray(buf,teamQueryLeaderInfo,value.info_list);
}
void WriteteamQueryLeaderInfoRequest(char*& buf,teamQueryLeaderInfoRequest& value)
{
    Writeint64(buf,value.mapID);
}
void teamQueryLeaderInfoRequest::Send(){
    BeginSend(teamQueryLeaderInfoRequest);
    WriteteamQueryLeaderInfoRequest(buf,*this);
    EndSend();
}
void ReadteamQueryLeaderInfoRequest(char*& buf,teamQueryLeaderInfoRequest& value)
{
    Readint64(buf,value.mapID);
}
void WriteteamChangeLeader(char*& buf,teamChangeLeader& value)
{
    Writeint64(buf,value.playerID);
}
void ReadteamChangeLeader(char*& buf,teamChangeLeader& value)
{
    Readint64(buf,value.playerID);
}
void WriteteamChangeLeaderRequest(char*& buf,teamChangeLeaderRequest& value)
{
    Writeint64(buf,value.playerID);
}
void teamChangeLeaderRequest::Send(){
    BeginSend(teamChangeLeaderRequest);
    WriteteamChangeLeaderRequest(buf,*this);
    EndSend();
}
void ReadteamChangeLeaderRequest(char*& buf,teamChangeLeaderRequest& value)
{
    Readint64(buf,value.playerID);
}
void WritebeenInviteState(char*& buf,beenInviteState& value)
{
    Writeint8(buf,value.state);
}
void beenInviteState::Send(){
    BeginSend(beenInviteState);
    WritebeenInviteState(buf,*this);
    EndSend();
}
void ReadbeenInviteState(char*& buf,beenInviteState& value)
{
    Readint8(buf,value.state);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
