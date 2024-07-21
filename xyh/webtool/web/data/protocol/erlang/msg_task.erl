%%-----------------------------------------------------------
%% @doc Automatic Generation Of Package(read/write/send) File
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
%%-----------------------------------------------------------

-module(msg_task).
-import(pack, [write_array/2, read_array/2]).
-export([send/2,dealMsg/3]).
-include("pack_task.hrl").

binary_read_MsgCollectGoods(Bin0) ->
    <<
        VgoodsID:32/little,
        VcollectFlag:8/little,
        VcollectTime:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_MsgCollectGoods{
        goodsID = VgoodsID,
        collectFlag = VcollectFlag,
        collectTime = VcollectTime
    }, RestBin0, 0}.


write_GMTaskStateChange(#pk_GMTaskStateChange{taskID = VtaskID, state = Vstate}) ->
    <<VtaskID:32/little, Vstate:32/little>>.



write_GMRefreshAllTask(#pk_GMRefreshAllTask{}) ->
    <<>>.



write_TaskProgess(#pk_TaskProgess{nCurCount = VnCurCount}) ->
    <<VnCurCount:32/little>>.

binary_read_TaskProgess(Bin0) ->
    <<VnCurCount:32/little, RestBin0/binary>> = Bin0,
    {#pk_TaskProgess{nCurCount = VnCurCount}, RestBin0, 0}.


write_AcceptTask(#pk_AcceptTask{nTaskID = VnTaskID, list_progress = Vlist_progress}) ->
    Alist_progress = write_array(Vlist_progress, fun(X) -> write_TaskProgess(X) end),
    <<VnTaskID:16/little, Alist_progress/binary>>.

binary_read_AcceptTask(Bin0) ->
    <<VnTaskID:16/little, RestBin0/binary>> = Bin0,
    {Vlist_progress, Bin1} = read_array(RestBin0, fun(X) -> binary_read_TaskProgess(X) end),
    <<RestBin1/binary>> = Bin1,
    {#pk_AcceptTask{nTaskID = VnTaskID, list_progress = Vlist_progress}, RestBin1, 0}.


write_GS2U_AcceptedTaskList(#pk_GS2U_AcceptedTaskList{list_accepted = Vlist_accepted}) ->
    Alist_accepted = write_array(Vlist_accepted, fun(X) -> write_AcceptTask(X) end),
    <<Alist_accepted/binary>>.



write_GS2U_CompletedTaskIDList(#pk_GS2U_CompletedTaskIDList{list_completed_id = Vlist_completed_id}) ->
    Alist_completed_id = write_array(Vlist_completed_id, fun(X) -> <<X:16/little>> end),
    <<Alist_completed_id/binary>>.



binary_read_U2GS_AcceptTaskRequest(Bin0) ->
    <<VnQuestID:16/little, VnNpcActorID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_AcceptTaskRequest{nQuestID = VnQuestID, nNpcActorID = VnNpcActorID}, RestBin0, 0}.


write_GS2U_PlayerTaskProgressChanged(#pk_GS2U_PlayerTaskProgressChanged{nQuestID = VnQuestID, list_progress = Vlist_progress}) ->
    Alist_progress = write_array(Vlist_progress, fun(X) -> write_TaskProgess(X) end),
    <<VnQuestID:16/little, Alist_progress/binary>>.



write_GS2U_AcceptTaskResult(#pk_GS2U_AcceptTaskResult{nQuestID = VnQuestID, nResult = VnResult}) ->
    <<VnQuestID:16/little, VnResult:32/little>>.



binary_read_U2GS_TalkToNpc(Bin0) ->
    <<VnNpcActorID:64/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_TalkToNpc{nNpcActorID = VnNpcActorID}, RestBin0, 0}.


write_GS2U_TalkToNpcResult(#pk_GS2U_TalkToNpcResult{nResult = VnResult, nNpcDataID = VnNpcDataID}) ->
    <<VnResult:8/little, VnNpcDataID:32/little>>.



binary_read_U2GS_CollectRequest(Bin0) ->
    <<
        VnObjectActorID:64/little,
        VnObjectDataID:32/little,
        VnTaskID:32/little,
        RestBin0/binary
    >> = Bin0,
    {#pk_U2GS_CollectRequest{
        nObjectActorID = VnObjectActorID,
        nObjectDataID = VnObjectDataID,
        nTaskID = VnTaskID
    }, RestBin0, 0}.


binary_read_U2GS_CompleteTaskRequest(Bin0) ->
    <<VnNpcActorID:64/little, VnQuestID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_CompleteTaskRequest{nNpcActorID = VnNpcActorID, nQuestID = VnQuestID}, RestBin0, 0}.


write_GS2U_CompleteTaskResult(#pk_GS2U_CompleteTaskResult{nQuestID = VnQuestID, nResult = VnResult}) ->
    <<VnQuestID:32/little, VnResult:32/little>>.



binary_read_U2GS_GiveUpTaskRequest(Bin0) ->
    <<VnQuestID:32/little, RestBin0/binary>> = Bin0,
    {#pk_U2GS_GiveUpTaskRequest{nQuestID = VnQuestID}, RestBin0, 0}.


write_GS2U_GiveUpTaskResult(#pk_GS2U_GiveUpTaskResult{nQuestID = VnQuestID, nResult = VnResult}) ->
    <<VnQuestID:32/little, VnResult:32/little>>.



write_GS2U_NoteTask(#pk_GS2U_NoteTask{nTaskID = VnTaskID}) ->
    <<VnTaskID:32/little>>.



write_GS2U_TellRandomDailyInfo(#pk_GS2U_TellRandomDailyInfo{
        randDailyTaskID = VrandDailyTaskID,
        finishedTime = VfinishedTime,
        process = Vprocess
    }) ->
    <<
        VrandDailyTaskID:32/little,
        VfinishedTime:8/little,
        Vprocess:8/little
    >>.



write_GS2U_TellReputationTask(#pk_GS2U_TellReputationTask{taskID = VtaskID, process = Vprocess}) ->
    <<VtaskID:32/little, Vprocess:32/little>>.



%%-----------------------------------------------------------
%% @doc Send Data To Socket
%%-----------------------------------------------------------
send(Socket, #pk_GMTaskStateChange{} = P) ->
	Bin = write_GMTaskStateChange(P),
	pack:send(Socket, ?CMD_GMTaskStateChange, Bin);
send(Socket, #pk_GMRefreshAllTask{} = P) ->
	Bin = write_GMRefreshAllTask(P),
	pack:send(Socket, ?CMD_GMRefreshAllTask, Bin);
send(Socket, #pk_GS2U_AcceptedTaskList{} = P) ->
	Bin = write_GS2U_AcceptedTaskList(P),
	pack:send(Socket, ?CMD_GS2U_AcceptedTaskList, Bin);
send(Socket, #pk_GS2U_CompletedTaskIDList{} = P) ->
	Bin = write_GS2U_CompletedTaskIDList(P),
	pack:send(Socket, ?CMD_GS2U_CompletedTaskIDList, Bin);
send(Socket, #pk_GS2U_PlayerTaskProgressChanged{} = P) ->
	Bin = write_GS2U_PlayerTaskProgressChanged(P),
	pack:send(Socket, ?CMD_GS2U_PlayerTaskProgressChanged, Bin);
send(Socket, #pk_GS2U_AcceptTaskResult{} = P) ->
	Bin = write_GS2U_AcceptTaskResult(P),
	pack:send(Socket, ?CMD_GS2U_AcceptTaskResult, Bin);
send(Socket, #pk_GS2U_TalkToNpcResult{} = P) ->
	Bin = write_GS2U_TalkToNpcResult(P),
	pack:send(Socket, ?CMD_GS2U_TalkToNpcResult, Bin);
send(Socket, #pk_GS2U_CompleteTaskResult{} = P) ->
	Bin = write_GS2U_CompleteTaskResult(P),
	pack:send(Socket, ?CMD_GS2U_CompleteTaskResult, Bin);
send(Socket, #pk_GS2U_GiveUpTaskResult{} = P) ->
	Bin = write_GS2U_GiveUpTaskResult(P),
	pack:send(Socket, ?CMD_GS2U_GiveUpTaskResult, Bin);
send(Socket, #pk_GS2U_NoteTask{} = P) ->
	Bin = write_GS2U_NoteTask(P),
	pack:send(Socket, ?CMD_GS2U_NoteTask, Bin);
send(Socket, #pk_GS2U_TellRandomDailyInfo{} = P) ->
	Bin = write_GS2U_TellRandomDailyInfo(P),
	pack:send(Socket, ?CMD_GS2U_TellRandomDailyInfo, Bin);
send(Socket, #pk_GS2U_TellReputationTask{} = P) ->
	Bin = write_GS2U_TellReputationTask(P),
	pack:send(Socket, ?CMD_GS2U_TellReputationTask, Bin);

send(_,_)-> 
	noMatch.

%%-----------------------------------------------------------
%% @doc Deal Socket Message
%%-----------------------------------------------------------
dealMsg(Socket, Cmd, Bin) -> 
	case Cmd of
        ?CMD_MsgCollectGoods->
            {Data, _, _} = binary_read_MsgCollectGoods(Bin),
            messageOn:on_MsgCollectGoods(Socket, Data);
        ?CMD_U2GS_AcceptTaskRequest->
            {Data, _, _} = binary_read_U2GS_AcceptTaskRequest(Bin),
            messageOn:on_U2GS_AcceptTaskRequest(Socket, Data);
        ?CMD_U2GS_TalkToNpc->
            {Data, _, _} = binary_read_U2GS_TalkToNpc(Bin),
            messageOn:on_U2GS_TalkToNpc(Socket, Data);
        ?CMD_U2GS_CollectRequest->
            {Data, _, _} = binary_read_U2GS_CollectRequest(Bin),
            messageOn:on_U2GS_CollectRequest(Socket, Data);
        ?CMD_U2GS_CompleteTaskRequest->
            {Data, _, _} = binary_read_U2GS_CompleteTaskRequest(Bin),
            messageOn:on_U2GS_CompleteTaskRequest(Socket, Data);
        ?CMD_U2GS_GiveUpTaskRequest->
            {Data, _, _} = binary_read_U2GS_GiveUpTaskRequest(Bin),
            messageOn:on_U2GS_GiveUpTaskRequest(Socket, Data);
        _-> 
            noMatch
	end.

%%  vim: set foldmethod=marker filetype=erlang foldmarker=%%',%%.:
