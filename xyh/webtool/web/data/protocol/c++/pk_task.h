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

struct MsgCollectGoods
{
    int goodsID;
    int8 collectFlag;
    int collectTime;
	void Send();
};
void WriteMsgCollectGoods(char*& buf,MsgCollectGoods& value);
void ReadMsgCollectGoods(char*& buf,MsgCollectGoods& value);

struct GMTaskStateChange
{
    int taskID;
    int state;
};
void WriteGMTaskStateChange(char*& buf,GMTaskStateChange& value);
void OnGMTaskStateChange(GMTaskStateChange* value);
void ReadGMTaskStateChange(char*& buf,GMTaskStateChange& value);

struct GMRefreshAllTask
{
};
void WriteGMRefreshAllTask(char*& buf,GMRefreshAllTask& value);
void OnGMRefreshAllTask(GMRefreshAllTask* value);
void ReadGMRefreshAllTask(char*& buf,GMRefreshAllTask& value);

struct TaskProgess
{
    int nCurCount;
};
void WriteTaskProgess(char*& buf,TaskProgess& value);
void ReadTaskProgess(char*& buf,TaskProgess& value);

struct AcceptTask
{
    int16 nTaskID;
    vector<TaskProgess> list_progress;
};
void WriteAcceptTask(char*& buf,AcceptTask& value);
void ReadAcceptTask(char*& buf,AcceptTask& value);

struct GS2U_AcceptedTaskList
{
    vector<AcceptTask> list_accepted;
};
void WriteGS2U_AcceptedTaskList(char*& buf,GS2U_AcceptedTaskList& value);
void OnGS2U_AcceptedTaskList(GS2U_AcceptedTaskList* value);
void ReadGS2U_AcceptedTaskList(char*& buf,GS2U_AcceptedTaskList& value);

struct GS2U_CompletedTaskIDList
{
    vector<int16> list_completed_id;
};
void WriteGS2U_CompletedTaskIDList(char*& buf,GS2U_CompletedTaskIDList& value);
void OnGS2U_CompletedTaskIDList(GS2U_CompletedTaskIDList* value);
void ReadGS2U_CompletedTaskIDList(char*& buf,GS2U_CompletedTaskIDList& value);

struct U2GS_AcceptTaskRequest
{
    int16 nQuestID;
    int64 nNpcActorID;
	void Send();
};
void WriteU2GS_AcceptTaskRequest(char*& buf,U2GS_AcceptTaskRequest& value);
void ReadU2GS_AcceptTaskRequest(char*& buf,U2GS_AcceptTaskRequest& value);

struct GS2U_PlayerTaskProgressChanged
{
    int16 nQuestID;
    vector<TaskProgess> list_progress;
};
void WriteGS2U_PlayerTaskProgressChanged(char*& buf,GS2U_PlayerTaskProgressChanged& value);
void OnGS2U_PlayerTaskProgressChanged(GS2U_PlayerTaskProgressChanged* value);
void ReadGS2U_PlayerTaskProgressChanged(char*& buf,GS2U_PlayerTaskProgressChanged& value);

struct GS2U_AcceptTaskResult
{
    int16 nQuestID;
    int nResult;
};
void WriteGS2U_AcceptTaskResult(char*& buf,GS2U_AcceptTaskResult& value);
void OnGS2U_AcceptTaskResult(GS2U_AcceptTaskResult* value);
void ReadGS2U_AcceptTaskResult(char*& buf,GS2U_AcceptTaskResult& value);

struct U2GS_TalkToNpc
{
    int64 nNpcActorID;
	void Send();
};
void WriteU2GS_TalkToNpc(char*& buf,U2GS_TalkToNpc& value);
void ReadU2GS_TalkToNpc(char*& buf,U2GS_TalkToNpc& value);

struct GS2U_TalkToNpcResult
{
    int8 nResult;
    int nNpcDataID;
};
void WriteGS2U_TalkToNpcResult(char*& buf,GS2U_TalkToNpcResult& value);
void OnGS2U_TalkToNpcResult(GS2U_TalkToNpcResult* value);
void ReadGS2U_TalkToNpcResult(char*& buf,GS2U_TalkToNpcResult& value);

struct U2GS_CollectRequest
{
    int64 nObjectActorID;
    int nObjectDataID;
    int nTaskID;
	void Send();
};
void WriteU2GS_CollectRequest(char*& buf,U2GS_CollectRequest& value);
void ReadU2GS_CollectRequest(char*& buf,U2GS_CollectRequest& value);

struct U2GS_CompleteTaskRequest
{
    int64 nNpcActorID;
    int nQuestID;
	void Send();
};
void WriteU2GS_CompleteTaskRequest(char*& buf,U2GS_CompleteTaskRequest& value);
void ReadU2GS_CompleteTaskRequest(char*& buf,U2GS_CompleteTaskRequest& value);

struct GS2U_CompleteTaskResult
{
    int nQuestID;
    int nResult;
};
void WriteGS2U_CompleteTaskResult(char*& buf,GS2U_CompleteTaskResult& value);
void OnGS2U_CompleteTaskResult(GS2U_CompleteTaskResult* value);
void ReadGS2U_CompleteTaskResult(char*& buf,GS2U_CompleteTaskResult& value);

struct U2GS_GiveUpTaskRequest
{
    int nQuestID;
	void Send();
};
void WriteU2GS_GiveUpTaskRequest(char*& buf,U2GS_GiveUpTaskRequest& value);
void ReadU2GS_GiveUpTaskRequest(char*& buf,U2GS_GiveUpTaskRequest& value);

struct GS2U_GiveUpTaskResult
{
    int nQuestID;
    int nResult;
};
void WriteGS2U_GiveUpTaskResult(char*& buf,GS2U_GiveUpTaskResult& value);
void OnGS2U_GiveUpTaskResult(GS2U_GiveUpTaskResult* value);
void ReadGS2U_GiveUpTaskResult(char*& buf,GS2U_GiveUpTaskResult& value);

struct GS2U_NoteTask
{
    int nTaskID;
};
void WriteGS2U_NoteTask(char*& buf,GS2U_NoteTask& value);
void OnGS2U_NoteTask(GS2U_NoteTask* value);
void ReadGS2U_NoteTask(char*& buf,GS2U_NoteTask& value);

struct GS2U_TellRandomDailyInfo
{
    int randDailyTaskID;
    int8 finishedTime;
    int8 process;
};
void WriteGS2U_TellRandomDailyInfo(char*& buf,GS2U_TellRandomDailyInfo& value);
void OnGS2U_TellRandomDailyInfo(GS2U_TellRandomDailyInfo* value);
void ReadGS2U_TellRandomDailyInfo(char*& buf,GS2U_TellRandomDailyInfo& value);

struct GS2U_TellReputationTask
{
    int taskID;
    int process;
};
void WriteGS2U_TellReputationTask(char*& buf,GS2U_TellReputationTask& value);
void OnGS2U_TellReputationTask(GS2U_TellReputationTask* value);
void ReadGS2U_TellReputationTask(char*& buf,GS2U_TellReputationTask& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
