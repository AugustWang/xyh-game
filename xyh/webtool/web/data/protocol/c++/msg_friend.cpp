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

void DoMessage_friend(char* data)
{
	BEING_DEAL();
		CMD_DEAL(GS2U_LoadFriend);
		CMD_DEAL(GS2U_FriendTips);
		CMD_DEAL(GS2U_LoadBlack);
		CMD_DEAL(GS2U_LoadTemp);
		CMD_DEAL(GS2U_FriendInfo);
		CMD_DEAL(GS2U_AddAcceptResult);
		CMD_DEAL(GS2U_DeteFriendBack);
		CMD_DEAL(GS2U_Net_Message);
		CMD_DEAL(GS2U_OnHookSet_Mess);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
