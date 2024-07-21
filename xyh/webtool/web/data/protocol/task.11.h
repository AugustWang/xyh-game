// -> client to server
// <- server to client
// <-> client & server

//struct AcceptTask ->
//{
//	int 	playerID; 
//	int 	taskID;
//};
//
//
//struct AcceptTaskAck <-
//{
//	int 	playerID; 
//	int 	taskID;
//	int		result;
//};
//
//struct TaskProgess <-
//{
//	int		taskID;
//	int		aimIndex;
//	int		aimCount;
//};
//
//struct	TaskFinish <-
//{
//	int 	taskID;
//};
//
//struct	CompleteTask ->
//{
//	int taskID;
//};
//
//struct	CompleteTaskResult <-
//{
//	int taskID;
//	int result;
//};
//
//struct	DropTask ->
//{
//	int	taskID;
//};


//struct TaskState
//{
//	int taskID;
//	int state;
//}
//
//struct AllTaskState <-
//{
//	int playerID;
//	vector<TaskState> allState;
//};
//
//struct TaskProgressChange <-
//{
//	int taskID;
//	vector<int> progress;
//};

struct MsgCollectGoods ->
{
	int goodsID;
	int8 collectFlag;
	int collectTime;
};

struct GMTaskStateChange <-
{
	int taskID;
	int state;
};

struct GMRefreshAllTask <-
{
};

// ������������
struct TaskProgess
{
	int					nCurCount;
};
// �ѽ���������Ϣ
struct AcceptTask
{
	int16					nTaskID;
	vector<TaskProgess>		list_progress;
};
//	�ѽ��������б�
struct GS2U_AcceptedTaskList <-
{
	vector<AcceptTask>		list_accepted;
};
//	����������б�
struct GS2U_CompletedTaskIDList <-
{
	vector<int16>		list_completed_id;
};
//	������������
struct U2GS_AcceptTaskRequest ->
{
	int16				nQuestID;
	int64				nNpcActorID;
};
//	���������仯֪ͨ
struct GS2U_PlayerTaskProgressChanged<-
{
	int16				nQuestID;
	vector<TaskProgess>	list_progress;
};
//	����������
struct GS2U_AcceptTaskResult<-
{
	int16				nQuestID;
	int					nResult;
};

//	�����Npc�Ի�
struct U2GS_TalkToNpc->
{
	int64				nNpcActorID;
};

//	��npc�Ի��Ľ��
struct GS2U_TalkToNpcResult<-
{
	int8 nResult;
	int nNpcDataID;
};

//	��Ҳɼ�����
struct U2GS_CollectRequest->
{
	int64				nObjectActorID;
	int					nObjectDataID;
	int					nTaskID;
};

//	��ҹ黹��������
struct U2GS_CompleteTaskRequest->
{
	int64				nNpcActorID;
	int					nQuestID;	
};

//	�黹������
struct GS2U_CompleteTaskResult<-
{
	int					nQuestID;
	int					nResult;
};

//	��ҷ�������
struct U2GS_GiveUpTaskRequest->
{
	int					nQuestID;
};

//	����������
struct GS2U_GiveUpTaskResult<-
{
	int					nQuestID;
	int					nResult;
};

//	������ʾ
struct GS2U_NoteTask<-
{
	int					nTaskID;
};

//	��֪�����������
struct GS2U_TellRandomDailyInfo<-
{
	int randDailyTaskID;//���ڱ������������ID
	int8 finishedTime;//��ɴ���
	int8 process;//��ǰ��Ľ���
};

//	��֪������������
struct GS2U_TellReputationTask<-
{
	int taskID;//��������䵽������ID
	int process;
};
