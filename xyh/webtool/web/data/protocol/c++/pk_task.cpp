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

#include "package.h" 

#include "message.h" 


namespace pk{

void WriteMsgCollectGoods(char*& buf,MsgCollectGoods& value)
{
    Writeint(buf,value.goodsID);
    Writeint8(buf,value.collectFlag);
    Writeint(buf,value.collectTime);
}
void MsgCollectGoods::Send(){
    BeginSend(MsgCollectGoods);
    WriteMsgCollectGoods(buf,*this);
    EndSend();
}
void ReadMsgCollectGoods(char*& buf,MsgCollectGoods& value)
{
    Readint(buf,value.goodsID);
    Readint8(buf,value.collectFlag);
    Readint(buf,value.collectTime);
}
void WriteGMTaskStateChange(char*& buf,GMTaskStateChange& value)
{
    Writeint(buf,value.taskID);
    Writeint(buf,value.state);
}
void ReadGMTaskStateChange(char*& buf,GMTaskStateChange& value)
{
    Readint(buf,value.taskID);
    Readint(buf,value.state);
}
void WriteGMRefreshAllTask(char*& buf,GMRefreshAllTask& value)
{
}
void ReadGMRefreshAllTask(char*& buf,GMRefreshAllTask& value)
{
}
void WriteTaskProgess(char*& buf,TaskProgess& value)
{
    Writeint(buf,value.nCurCount);
}
void ReadTaskProgess(char*& buf,TaskProgess& value)
{
    Readint(buf,value.nCurCount);
}
void WriteAcceptTask(char*& buf,AcceptTask& value)
{
    Writeint16(buf,value.nTaskID);
    WriteArray(buf,TaskProgess,value.list_progress);
}
void ReadAcceptTask(char*& buf,AcceptTask& value)
{
    Readint16(buf,value.nTaskID);
    ReadArray(buf,TaskProgess,value.list_progress);
}
void WriteGS2U_AcceptedTaskList(char*& buf,GS2U_AcceptedTaskList& value)
{
    WriteArray(buf,AcceptTask,value.list_accepted);
}
void ReadGS2U_AcceptedTaskList(char*& buf,GS2U_AcceptedTaskList& value)
{
    ReadArray(buf,AcceptTask,value.list_accepted);
}
void WriteGS2U_CompletedTaskIDList(char*& buf,GS2U_CompletedTaskIDList& value)
{
    WriteArray(buf,int16,value.list_completed_id);
}
void ReadGS2U_CompletedTaskIDList(char*& buf,GS2U_CompletedTaskIDList& value)
{
    ReadArray(buf,int16,value.list_completed_id);
}
void WriteU2GS_AcceptTaskRequest(char*& buf,U2GS_AcceptTaskRequest& value)
{
    Writeint16(buf,value.nQuestID);
    Writeint64(buf,value.nNpcActorID);
}
void U2GS_AcceptTaskRequest::Send(){
    BeginSend(U2GS_AcceptTaskRequest);
    WriteU2GS_AcceptTaskRequest(buf,*this);
    EndSend();
}
void ReadU2GS_AcceptTaskRequest(char*& buf,U2GS_AcceptTaskRequest& value)
{
    Readint16(buf,value.nQuestID);
    Readint64(buf,value.nNpcActorID);
}
void WriteGS2U_PlayerTaskProgressChanged(char*& buf,GS2U_PlayerTaskProgressChanged& value)
{
    Writeint16(buf,value.nQuestID);
    WriteArray(buf,TaskProgess,value.list_progress);
}
void ReadGS2U_PlayerTaskProgressChanged(char*& buf,GS2U_PlayerTaskProgressChanged& value)
{
    Readint16(buf,value.nQuestID);
    ReadArray(buf,TaskProgess,value.list_progress);
}
void WriteGS2U_AcceptTaskResult(char*& buf,GS2U_AcceptTaskResult& value)
{
    Writeint16(buf,value.nQuestID);
    Writeint(buf,value.nResult);
}
void ReadGS2U_AcceptTaskResult(char*& buf,GS2U_AcceptTaskResult& value)
{
    Readint16(buf,value.nQuestID);
    Readint(buf,value.nResult);
}
void WriteU2GS_TalkToNpc(char*& buf,U2GS_TalkToNpc& value)
{
    Writeint64(buf,value.nNpcActorID);
}
void U2GS_TalkToNpc::Send(){
    BeginSend(U2GS_TalkToNpc);
    WriteU2GS_TalkToNpc(buf,*this);
    EndSend();
}
void ReadU2GS_TalkToNpc(char*& buf,U2GS_TalkToNpc& value)
{
    Readint64(buf,value.nNpcActorID);
}
void WriteGS2U_TalkToNpcResult(char*& buf,GS2U_TalkToNpcResult& value)
{
    Writeint8(buf,value.nResult);
    Writeint(buf,value.nNpcDataID);
}
void ReadGS2U_TalkToNpcResult(char*& buf,GS2U_TalkToNpcResult& value)
{
    Readint8(buf,value.nResult);
    Readint(buf,value.nNpcDataID);
}
void WriteU2GS_CollectRequest(char*& buf,U2GS_CollectRequest& value)
{
    Writeint64(buf,value.nObjectActorID);
    Writeint(buf,value.nObjectDataID);
    Writeint(buf,value.nTaskID);
}
void U2GS_CollectRequest::Send(){
    BeginSend(U2GS_CollectRequest);
    WriteU2GS_CollectRequest(buf,*this);
    EndSend();
}
void ReadU2GS_CollectRequest(char*& buf,U2GS_CollectRequest& value)
{
    Readint64(buf,value.nObjectActorID);
    Readint(buf,value.nObjectDataID);
    Readint(buf,value.nTaskID);
}
void WriteU2GS_CompleteTaskRequest(char*& buf,U2GS_CompleteTaskRequest& value)
{
    Writeint64(buf,value.nNpcActorID);
    Writeint(buf,value.nQuestID);
}
void U2GS_CompleteTaskRequest::Send(){
    BeginSend(U2GS_CompleteTaskRequest);
    WriteU2GS_CompleteTaskRequest(buf,*this);
    EndSend();
}
void ReadU2GS_CompleteTaskRequest(char*& buf,U2GS_CompleteTaskRequest& value)
{
    Readint64(buf,value.nNpcActorID);
    Readint(buf,value.nQuestID);
}
void WriteGS2U_CompleteTaskResult(char*& buf,GS2U_CompleteTaskResult& value)
{
    Writeint(buf,value.nQuestID);
    Writeint(buf,value.nResult);
}
void ReadGS2U_CompleteTaskResult(char*& buf,GS2U_CompleteTaskResult& value)
{
    Readint(buf,value.nQuestID);
    Readint(buf,value.nResult);
}
void WriteU2GS_GiveUpTaskRequest(char*& buf,U2GS_GiveUpTaskRequest& value)
{
    Writeint(buf,value.nQuestID);
}
void U2GS_GiveUpTaskRequest::Send(){
    BeginSend(U2GS_GiveUpTaskRequest);
    WriteU2GS_GiveUpTaskRequest(buf,*this);
    EndSend();
}
void ReadU2GS_GiveUpTaskRequest(char*& buf,U2GS_GiveUpTaskRequest& value)
{
    Readint(buf,value.nQuestID);
}
void WriteGS2U_GiveUpTaskResult(char*& buf,GS2U_GiveUpTaskResult& value)
{
    Writeint(buf,value.nQuestID);
    Writeint(buf,value.nResult);
}
void ReadGS2U_GiveUpTaskResult(char*& buf,GS2U_GiveUpTaskResult& value)
{
    Readint(buf,value.nQuestID);
    Readint(buf,value.nResult);
}
void WriteGS2U_NoteTask(char*& buf,GS2U_NoteTask& value)
{
    Writeint(buf,value.nTaskID);
}
void ReadGS2U_NoteTask(char*& buf,GS2U_NoteTask& value)
{
    Readint(buf,value.nTaskID);
}
void WriteGS2U_TellRandomDailyInfo(char*& buf,GS2U_TellRandomDailyInfo& value)
{
    Writeint(buf,value.randDailyTaskID);
    Writeint8(buf,value.finishedTime);
    Writeint8(buf,value.process);
}
void ReadGS2U_TellRandomDailyInfo(char*& buf,GS2U_TellRandomDailyInfo& value)
{
    Readint(buf,value.randDailyTaskID);
    Readint8(buf,value.finishedTime);
    Readint8(buf,value.process);
}
void WriteGS2U_TellReputationTask(char*& buf,GS2U_TellReputationTask& value)
{
    Writeint(buf,value.taskID);
    Writeint(buf,value.process);
}
void ReadGS2U_TellReputationTask(char*& buf,GS2U_TellReputationTask& value)
{
    Readint(buf,value.taskID);
    Readint(buf,value.process);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
