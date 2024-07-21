%%---------------------------------------------------------
%% @doc Automatic Generation Of Protocol File
%% 
%% NOTE: 
%%     Please be careful,
%%     if you have manually edited any of protocol file,
%%     do NOT commit to SVN !!!
%%
%% Shenzhen Turbo Technology Co., Ltd. All Rights Reserved.
%% http://www.szturbotech.com
%% Tool Release Time: 2014.3.21
%%
%% @author Rolong<rolong@vip.qq.com>
%%---------------------------------------------------------

%%---------------------------------------------------------
%% define cmd
%%---------------------------------------------------------

-define(CMD_MsgCollectGoods, 1101).
-define(CMD_GMTaskStateChange, 1102).
-define(CMD_GMRefreshAllTask, 1103).
-define(CMD_TaskProgess, 1104).
-define(CMD_AcceptTask, 1105).
-define(CMD_GS2U_AcceptedTaskList, 1106).
-define(CMD_GS2U_CompletedTaskIDList, 1107).
-define(CMD_U2GS_AcceptTaskRequest, 1108).
-define(CMD_GS2U_PlayerTaskProgressChanged, 1109).
-define(CMD_GS2U_AcceptTaskResult, 1110).
-define(CMD_U2GS_TalkToNpc, 1111).
-define(CMD_GS2U_TalkToNpcResult, 1112).
-define(CMD_U2GS_CollectRequest, 1113).
-define(CMD_U2GS_CompleteTaskRequest, 1114).
-define(CMD_GS2U_CompleteTaskResult, 1115).
-define(CMD_U2GS_GiveUpTaskRequest, 1116).
-define(CMD_GS2U_GiveUpTaskResult, 1117).
-define(CMD_GS2U_NoteTask, 1118).
-define(CMD_GS2U_TellRandomDailyInfo, 1119).
-define(CMD_GS2U_TellReputationTask, 1120).

%%---------------------------------------------------------
%% define cmd struct
%%---------------------------------------------------------

-record(pk_MsgCollectGoods, {
        goodsID,
        collectFlag,
        collectTime
	}).
-record(pk_GMTaskStateChange, {
        taskID,
        state
	}).
-record(pk_GMRefreshAllTask, {
        
	}).
-record(pk_TaskProgess, {
        nCurCount
	}).
-record(pk_AcceptTask, {
        nTaskID,
        list_progress
	}).
-record(pk_GS2U_AcceptedTaskList, {
        list_accepted
	}).
-record(pk_GS2U_CompletedTaskIDList, {
        list_completed_id
	}).
-record(pk_U2GS_AcceptTaskRequest, {
        nQuestID,
        nNpcActorID
	}).
-record(pk_GS2U_PlayerTaskProgressChanged, {
        nQuestID,
        list_progress
	}).
-record(pk_GS2U_AcceptTaskResult, {
        nQuestID,
        nResult
	}).
-record(pk_U2GS_TalkToNpc, {
        nNpcActorID
	}).
-record(pk_GS2U_TalkToNpcResult, {
        nResult,
        nNpcDataID
	}).
-record(pk_U2GS_CollectRequest, {
        nObjectActorID,
        nObjectDataID,
        nTaskID
	}).
-record(pk_U2GS_CompleteTaskRequest, {
        nNpcActorID,
        nQuestID
	}).
-record(pk_GS2U_CompleteTaskResult, {
        nQuestID,
        nResult
	}).
-record(pk_U2GS_GiveUpTaskRequest, {
        nQuestID
	}).
-record(pk_GS2U_GiveUpTaskResult, {
        nQuestID,
        nResult
	}).
-record(pk_GS2U_NoteTask, {
        nTaskID
	}).
-record(pk_GS2U_TellRandomDailyInfo, {
        randDailyTaskID,
        finishedTime,
        process
	}).
-record(pk_GS2U_TellReputationTask, {
        taskID,
        process
	}).
