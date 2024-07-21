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

void DoMessage_battle(char* data)
{
	BEING_DEAL();
		CMD_DEAL(Skillcooldown);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
