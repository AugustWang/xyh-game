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

void DoMessage_toplist(char* data)
{
	BEING_DEAL();
		CMD_DEAL(GS2U_LoadTopPlayerLevelList);
		CMD_DEAL(GS2U_LoadTopPlayerFightingCapacityList);
		CMD_DEAL(GS2U_LoadTopPlayerMoneyList);
		CMD_DEAL(GS2U_AnswerQuestion);
		CMD_DEAL(GS2U_AnswerReady);
		CMD_DEAL(GS2U_AnswerClose);
		CMD_DEAL(GS2U_AnswerTopList);
		CMD_DEAL(U2GS_AnswerCommitRet);
		CMD_DEAL(U2GS_AnswerSpecialRet);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
