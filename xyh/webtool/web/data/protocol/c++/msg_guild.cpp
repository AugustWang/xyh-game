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

void DoMessage_guild(char* data)
{
	BEING_DEAL();
		CMD_DEAL(GS2U_CreateGuildResult);
		CMD_DEAL(GS2U_GuildInfoSmallList);
		CMD_DEAL(GS2U_GuildShortInfoExList);
		CMD_DEAL(GS2U_GuildAllShortInfoList);
		CMD_DEAL(GS2U_GuildFullInfo);
		CMD_DEAL(GS2U_GuildApplicantShortList);
		CMD_DEAL(GS2U_GuildLevelEXPChanged);
		CMD_DEAL(GS2U_GuildAfficheChanged);
		CMD_DEAL(GS2U_GuildMemberContributeChanged);
		CMD_DEAL(GS2U_GuildMemberLevelChanged);
		CMD_DEAL(GS2U_GuildMemberOnlineChanged);
		CMD_DEAL(GS2U_GuildMemberRankChanged);
		CMD_DEAL(GS2U_GuildMemberAdd);
		CMD_DEAL(GS2U_GuildMemberQuit);
		CMD_DEAL(GS2U_JoinGuildSuccess);
		CMD_DEAL(GS2U_AllowOpComplete);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
