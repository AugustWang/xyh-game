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

#include "message.h" 

#include "package.h" 

void DoMessage_team(char* data)
{
	BEING_DEAL();
		CMD_DEAL(teamOPResult);
		CMD_DEAL(beenInviteCreateTeam);
		CMD_DEAL(teamInfo);
		CMD_DEAL(teamPlayerOffline);
		CMD_DEAL(teamPlayerQuit);
		CMD_DEAL(teamPlayerKickOut);
		CMD_DEAL(beenInviteJoinTeam);
		CMD_DEAL(queryApplyJoinTeam);
		CMD_DEAL(addTeamMember);
		CMD_DEAL(updateTeamMemberInfo);
		CMD_DEAL(teamDisbanded);
		CMD_DEAL(teamQueryLeaderInfoOnMyMap);
		CMD_DEAL(teamChangeLeader);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
