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

void DoMessage_task(char* data)
{
	BEING_DEAL();
		CMD_DEAL(GMTaskStateChange);
		CMD_DEAL(GMRefreshAllTask);
		CMD_DEAL(GS2U_AcceptedTaskList);
		CMD_DEAL(GS2U_CompletedTaskIDList);
		CMD_DEAL(GS2U_PlayerTaskProgressChanged);
		CMD_DEAL(GS2U_AcceptTaskResult);
		CMD_DEAL(GS2U_TalkToNpcResult);
		CMD_DEAL(GS2U_CompleteTaskResult);
		CMD_DEAL(GS2U_GiveUpTaskResult);
		CMD_DEAL(GS2U_NoteTask);
		CMD_DEAL(GS2U_TellRandomDailyInfo);
		CMD_DEAL(GS2U_TellReputationTask);
 	END_DEAL();
}

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
