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

void DoMessage_LS2GS(char* data)
{
	BEING_DEAL();
		CMD_DEAL(LS2GS_LoginResult);
		CMD_DEAL(LS2GS_QueryUserMaxLevel);
		CMD_DEAL(LS2GS_UserReadyToLogin);
		CMD_DEAL(LS2GS_KickOutUser);
		CMD_DEAL(LS2GS_ActiveCode);
		CMD_DEAL(GS2LS_Request_Login);
		CMD_DEAL(GS2LS_ReadyToAcceptUser);
		CMD_DEAL(GS2LS_OnlinePlayers);
		CMD_DEAL(GS2LS_QueryUserMaxLevelResult);
		CMD_DEAL(GS2LS_UserReadyLoginResult);
		CMD_DEAL(GS2LS_UserLoginGameServer);
		CMD_DEAL(GS2LS_UserLogoutGameServer);
		CMD_DEAL(GS2LS_ActiveCode);
		CMD_DEAL(LS2GS_Announce);
		CMD_DEAL(LS2GS_Command);
		CMD_DEAL(GS2LS_Command);
		CMD_DEAL(LS2GS_Recharge);
		CMD_DEAL(GS2LS_Recharge);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
