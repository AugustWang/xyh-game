// -> client to server
// <- server to client
// <-> client & server

//�������
struct inviteCreateTeam->
{
	int64	targetPlayerID;
};
//����������
struct teamOPResult<-
{
	int64	targetPlayerID;
	string	targetPlayerName;
	int		result;
};
//ѯ�ʣ��������������
struct beenInviteCreateTeam<-
{
	int64	inviterPlayerID;
	string	inviterPlayerName;
};
//�ظ���������ӽ��
struct ackInviteCreateTeam->
{
	int64	inviterPlayerID;
	int8	agree;
};
//��Ա��Ϣ
struct teamMemberInfo
{
	int64	playerID;
	string  playerName;
	int16	level;
	int16	posx;
	int16	posy;
	int8	map_data_id;
	int8	isOnline;
	int8	camp;
	int8	sex;
	int8	life_percent;
};
//������Ϣ
struct teamInfo<-
{
	int64	teamID;
	int64	leaderPlayerID;
	vector<teamMemberInfo> info_list;
};
//���������������
struct teamPlayerOffline<-
{
	int64	playerID;
};

//�������
struct teamQuitRequest->
{
	int8	reserve;
};
//��������������
struct teamPlayerQuit<-
{
	int64	playerID;
};

//�ӳ���������
struct teamKickOutPlayer->
{
	int64	playerID;
};
//����������ұ���
struct teamPlayerKickOut<-
{
	int64	playerID;
};

//�ӳ�����������
struct inviteJoinTeam->
{
	int64	playerID;
};
//ѯ�ʣ����������
struct beenInviteJoinTeam<-
{
	int64	playerID;
	string  playerName;
};
//�ظ���������ӽ��ܻ��Ǿܾ�
struct ackInviteJointTeam->
{
	int64	playerID;
	int8	agree;
};

//�޶�����������
struct applyJoinTeam->
{
	int64	playerID;
};
//ѯ�ʣ�����Ҫ������Ķ���
struct queryApplyJoinTeam<-
{
	int64	playerID;
	string  playerName;
};
//�ظ�������Ҫ������Ķ���
struct ackQueryApplyJoinTeam->
{
	int64	playerID;
	int8	agree;
};

//����������
struct addTeamMember<-
{
	teamMemberInfo	info;
};

//������ꡢ�ȼ������������ʱ����
struct shortTeamMemberInfo
{
	int64	playerID;
	int16	level;
	int16	posx;
	int16	posy;
	int8	map_data_id;
	int8	isOnline;
	int8	life_percent;
};
struct updateTeamMemberInfo<-
{
	vector<shortTeamMemberInfo>	info_list;
};

//�����ɢ
struct teamDisbanded<-
{
	int8	reserve;
};

//��ѯ����ͼ�ӳ������Ϣ
struct teamQueryLeaderInfo
{
	int64	playerID;
	string  playerName;
	int16	level;
};
struct teamQueryLeaderInfoOnMyMap<-
{
	vector<teamQueryLeaderInfo> info_list;
};

//��ѯ����ͼ�ӳ������Ϣ
struct teamQueryLeaderInfoRequest->
{
	int64	mapID;
}

//�ӳ��л�
struct teamChangeLeader<-
{
	int64	playerID;
};

//�ӳ��ƽ�����
struct teamChangeLeaderRequest->
{
	int64	playerID;
};

//������״̬����
struct beenInviteState->
{
	int8 state;
}

//struct AddTeam ->
//{
//	int64 leaderId;
//	int64 memberId;
//};
//
//struct LeaveTeam ->
//{
//	int64 leaderId,
//};
//
//struct DelTeamMeber ->
//{
//	int64 memberId;
//};
//
//struct AckTeam ->
//{
//	int64 leaderId;
//	int64 memberId;
//	int8 flag;
//};
//
//struct MemberInfo
//{
//	int64	id;
//	int8 	sex;
//	string	name;
//	int     camp;
//	int     faction;
//	int     level;
//	int     life_max;
//	int     life;
//	int     map_id;
//	int     mapdata_id;
//	int     posX;
//	int     posY;
//
//	int linemark;
//	int64 leaderMark;
//};
//
//struct SelfTeamInfo <-
//{
//	vector<MemberInfo> members;
//};
//
//struct Teaminfo
//{
//	int64 teamID;
//	string team_name;
//	int64 leder_level;
//};
//
//struct lookforteam ->
//{
//	int player_level;
//};
//
//struct getALLteam<-
//{
//	vector<Teaminfo> value;
//};
//
//struct ACKjointheteam ->
//{
//	int64 leaderID;
//	int64 memberID;
//	int flag;
//};
//
//struct Requsetjointheteam ->
//{
//	int64 teamID;
//	int64 requseterID;
//};
//
//struct inviteListUpdata <-
//{
//	int flag_DeleteOrAdd;
//	int flag_ListType;
//	int64 inviterID;
//	string inviter_name;
//};
//
//struct abnormal_process<-
//{
//	string receptorName;
//	int    state_Type;
//};
//
//struct upDataMemberHPInfo<-
//{
//	int64 memberID;
//	int   memberlife;
//};
//
//struct upDataMemberMaxHp<-
//{
//	int64 memberID;
//	int   memberlifeMax;
//}
//struct upDataMemberLevel<-
//{
//	int64 memberID;
//	int   memberLevel;
//};
//struct upDataMemberLocInfo<-
//{
//	int64 memberID;
//	int64 mapID;
//	int mapDataID;
//	int loc_x;
//	int loc_y;
//};
//struct upDataMemberLineMark<-
//{
//	int64 memberID;
//	int   flag;
//};