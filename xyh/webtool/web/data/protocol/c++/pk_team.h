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

struct inviteCreateTeam
{
    int64 targetPlayerID;
	void Send();
};
void WriteinviteCreateTeam(char*& buf,inviteCreateTeam& value);
void ReadinviteCreateTeam(char*& buf,inviteCreateTeam& value);

struct teamOPResult
{
    int64 targetPlayerID;
    string targetPlayerName;
    int result;
};
void WriteteamOPResult(char*& buf,teamOPResult& value);
void OnteamOPResult(teamOPResult* value);
void ReadteamOPResult(char*& buf,teamOPResult& value);

struct beenInviteCreateTeam
{
    int64 inviterPlayerID;
    string inviterPlayerName;
};
void WritebeenInviteCreateTeam(char*& buf,beenInviteCreateTeam& value);
void OnbeenInviteCreateTeam(beenInviteCreateTeam* value);
void ReadbeenInviteCreateTeam(char*& buf,beenInviteCreateTeam& value);

struct ackInviteCreateTeam
{
    int64 inviterPlayerID;
    int8 agree;
	void Send();
};
void WriteackInviteCreateTeam(char*& buf,ackInviteCreateTeam& value);
void ReadackInviteCreateTeam(char*& buf,ackInviteCreateTeam& value);

struct teamMemberInfo
{
    int64 playerID;
    string playerName;
    int16 level;
    int16 posx;
    int16 posy;
    int8 map_data_id;
    int8 isOnline;
    int8 camp;
    int8 sex;
    int8 life_percent;
};
void WriteteamMemberInfo(char*& buf,teamMemberInfo& value);
void ReadteamMemberInfo(char*& buf,teamMemberInfo& value);

struct teamInfo
{
    int64 teamID;
    int64 leaderPlayerID;
    vector<teamMemberInfo> info_list;
};
void WriteteamInfo(char*& buf,teamInfo& value);
void OnteamInfo(teamInfo* value);
void ReadteamInfo(char*& buf,teamInfo& value);

struct teamPlayerOffline
{
    int64 playerID;
};
void WriteteamPlayerOffline(char*& buf,teamPlayerOffline& value);
void OnteamPlayerOffline(teamPlayerOffline* value);
void ReadteamPlayerOffline(char*& buf,teamPlayerOffline& value);

struct teamQuitRequest
{
    int8 reserve;
	void Send();
};
void WriteteamQuitRequest(char*& buf,teamQuitRequest& value);
void ReadteamQuitRequest(char*& buf,teamQuitRequest& value);

struct teamPlayerQuit
{
    int64 playerID;
};
void WriteteamPlayerQuit(char*& buf,teamPlayerQuit& value);
void OnteamPlayerQuit(teamPlayerQuit* value);
void ReadteamPlayerQuit(char*& buf,teamPlayerQuit& value);

struct teamKickOutPlayer
{
    int64 playerID;
	void Send();
};
void WriteteamKickOutPlayer(char*& buf,teamKickOutPlayer& value);
void ReadteamKickOutPlayer(char*& buf,teamKickOutPlayer& value);

struct teamPlayerKickOut
{
    int64 playerID;
};
void WriteteamPlayerKickOut(char*& buf,teamPlayerKickOut& value);
void OnteamPlayerKickOut(teamPlayerKickOut* value);
void ReadteamPlayerKickOut(char*& buf,teamPlayerKickOut& value);

struct inviteJoinTeam
{
    int64 playerID;
	void Send();
};
void WriteinviteJoinTeam(char*& buf,inviteJoinTeam& value);
void ReadinviteJoinTeam(char*& buf,inviteJoinTeam& value);

struct beenInviteJoinTeam
{
    int64 playerID;
    string playerName;
};
void WritebeenInviteJoinTeam(char*& buf,beenInviteJoinTeam& value);
void OnbeenInviteJoinTeam(beenInviteJoinTeam* value);
void ReadbeenInviteJoinTeam(char*& buf,beenInviteJoinTeam& value);

struct ackInviteJointTeam
{
    int64 playerID;
    int8 agree;
	void Send();
};
void WriteackInviteJointTeam(char*& buf,ackInviteJointTeam& value);
void ReadackInviteJointTeam(char*& buf,ackInviteJointTeam& value);

struct applyJoinTeam
{
    int64 playerID;
	void Send();
};
void WriteapplyJoinTeam(char*& buf,applyJoinTeam& value);
void ReadapplyJoinTeam(char*& buf,applyJoinTeam& value);

struct queryApplyJoinTeam
{
    int64 playerID;
    string playerName;
};
void WritequeryApplyJoinTeam(char*& buf,queryApplyJoinTeam& value);
void OnqueryApplyJoinTeam(queryApplyJoinTeam* value);
void ReadqueryApplyJoinTeam(char*& buf,queryApplyJoinTeam& value);

struct ackQueryApplyJoinTeam
{
    int64 playerID;
    int8 agree;
	void Send();
};
void WriteackQueryApplyJoinTeam(char*& buf,ackQueryApplyJoinTeam& value);
void ReadackQueryApplyJoinTeam(char*& buf,ackQueryApplyJoinTeam& value);

struct addTeamMember
{
    teamMemberInfo info;
};
void WriteaddTeamMember(char*& buf,addTeamMember& value);
void OnaddTeamMember(addTeamMember* value);
void ReadaddTeamMember(char*& buf,addTeamMember& value);

struct shortTeamMemberInfo
{
    int64 playerID;
    int16 level;
    int16 posx;
    int16 posy;
    int8 map_data_id;
    int8 isOnline;
    int8 life_percent;
};
void WriteshortTeamMemberInfo(char*& buf,shortTeamMemberInfo& value);
void ReadshortTeamMemberInfo(char*& buf,shortTeamMemberInfo& value);

struct updateTeamMemberInfo
{
    vector<shortTeamMemberInfo> info_list;
};
void WriteupdateTeamMemberInfo(char*& buf,updateTeamMemberInfo& value);
void OnupdateTeamMemberInfo(updateTeamMemberInfo* value);
void ReadupdateTeamMemberInfo(char*& buf,updateTeamMemberInfo& value);

struct teamDisbanded
{
    int8 reserve;
};
void WriteteamDisbanded(char*& buf,teamDisbanded& value);
void OnteamDisbanded(teamDisbanded* value);
void ReadteamDisbanded(char*& buf,teamDisbanded& value);

struct teamQueryLeaderInfo
{
    int64 playerID;
    string playerName;
    int16 level;
};
void WriteteamQueryLeaderInfo(char*& buf,teamQueryLeaderInfo& value);
void ReadteamQueryLeaderInfo(char*& buf,teamQueryLeaderInfo& value);

struct teamQueryLeaderInfoOnMyMap
{
    vector<teamQueryLeaderInfo> info_list;
};
void WriteteamQueryLeaderInfoOnMyMap(char*& buf,teamQueryLeaderInfoOnMyMap& value);
void OnteamQueryLeaderInfoOnMyMap(teamQueryLeaderInfoOnMyMap* value);
void ReadteamQueryLeaderInfoOnMyMap(char*& buf,teamQueryLeaderInfoOnMyMap& value);

struct teamQueryLeaderInfoRequest
{
    int64 mapID;
	void Send();
};
void WriteteamQueryLeaderInfoRequest(char*& buf,teamQueryLeaderInfoRequest& value);
void ReadteamQueryLeaderInfoRequest(char*& buf,teamQueryLeaderInfoRequest& value);

struct teamChangeLeader
{
    int64 playerID;
};
void WriteteamChangeLeader(char*& buf,teamChangeLeader& value);
void OnteamChangeLeader(teamChangeLeader* value);
void ReadteamChangeLeader(char*& buf,teamChangeLeader& value);

struct teamChangeLeaderRequest
{
    int64 playerID;
	void Send();
};
void WriteteamChangeLeaderRequest(char*& buf,teamChangeLeaderRequest& value);
void ReadteamChangeLeaderRequest(char*& buf,teamChangeLeaderRequest& value);

struct beenInviteState
{
    int8 state;
	void Send();
};
void WritebeenInviteState(char*& buf,beenInviteState& value);
void ReadbeenInviteState(char*& buf,beenInviteState& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
