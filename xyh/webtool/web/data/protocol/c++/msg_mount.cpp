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

void DoMessage_mount(char* data)
{
	BEING_DEAL();
		CMD_DEAL(GS2U_QueryMyMountInfoResult);
		CMD_DEAL(GS2U_MountInfoUpdate);
		CMD_DEAL(GS2U_MountOPResult);
		CMD_DEAL(GS2U_MountUp);
		CMD_DEAL(GS2U_MountDown);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
