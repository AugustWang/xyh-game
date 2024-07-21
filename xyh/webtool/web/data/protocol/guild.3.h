//////////////////////////////////////////////////////////////////////////
//User 2 GameServer
//���˴�������
struct U2GS_RequestCreateGuild ->
{
	int8 			useToken;
	string			strGuildName;
};

//�ͻ��˲�ѯ�����б�
struct U2GS_QueryGuildList ->
{
	//�Ƿ����ߺ��һ��query���ǵ�һ��bFirst=1������=0
	int8			bFirst;
};

//��ѯ���˼�����չ��Ϣ
struct U2GS_QueryGuildShortInfoEx->
{
	vector<int64>		vGuilds;
};

//��ѯ�Լ����˵���Ϣ
struct U2GS_GetMyGuildInfo->
{
	int8			reserve;
};

//��ѯ���������Ա�б�ʵʱ��Ϣ
struct U2GS_GetMyGuildApplicantShortInfo->
{
	int8			reserve;
};

//�޸����˹���
struct U2GS_RequestChangeGuildAffiche->
{
	string			strAffiche;
};

//���׶Ⱦ���
struct U2GS_RequestGuildContribute->
{
	int				nMoney;
	int				nGold;
	int				nItemCount;
};

//ְλ����
struct U2GS_RequestGuildMemberRankChange->
{
	int64			nPlayerID;
	int8			nRank;
};

//�߳�Ա
struct U2GS_RequestGuildKickOutMember->
{
	int64			nPlayerID;
};

//�˳�
struct U2GS_RequestGuildQuit->
{
	int				reserve;
};

//����ѧϰ
struct U2GS_RequestGuildStudySkill->
{
	int				nSkillGroupID;
};

//��������
struct U2GS_RequestJoinGuld->
{
	int64			nGuildID;
};

//��׼����������
struct U2GS_RequestGuildApplicantAllow->
{
	int64			nPlayerID;
};

//�ܾ�����������
struct U2GS_RequestGuildApplicantRefuse->
{
	int64			nPlayerID;
};

//�����б�ȫ������
struct U2GS_RequestGuildApplicantOPAll->
{
	int				nAllowOrRefuse;
};


//////////////////////////////////////////////////////////////////////////
struct GS2U_CreateGuildResult<-
{
	//	GS2U_CreateGuildResult_Type
	int				result;
	int64			guildID;
};

//���˼�����Ϣ
struct GS2U_GuildInfoSmall
{
	//	����ID
	int64			nGuildID;
	//	�᳤ID
	int64			nChairmanPlayerID;
	//	�ȼ�
	int8		nLevel;
	//	����
	int16		nMemberCount;
};
struct GS2U_GuildInfoSmallList<-
{
	vector<GS2U_GuildInfoSmall>	info_list;
};

//���˼�����չ��Ϣ
struct GS2U_GuildShortInfoEx
{
	//	����ID
	int64		nGuildID;
	//	��Ӫ
	int8		nFaction;
	//	��������
	string		strGuildName;
	//	�᳤����
	string		strChairmanPlayerName;
};
struct GS2U_GuildShortInfoExList<-
{
	vector<GS2U_GuildShortInfoEx> info_list;
};

//��һ�β�ѯ�����б�
struct GS2U_GuildAllShortInfo
{
	//	����ID
	int64			nGuildID;
	//	�᳤ID
	int64			nChairmanPlayerID;
	//	�᳤����
	string		strChairmanPlayerName;
	//	�ȼ�
	int8		nLevel;
	//	����
	int16		nMemberCount;
	//	��Ӫ
	int8		nFaction;
	//	��������
	string		strGuildName;
};
struct GS2U_GuildAllShortInfoList<-
{
	vector<GS2U_GuildAllShortInfo>	info_list;
};

//���˻�����Ϣ
struct GS2U_GuildBaseData
{
	//	����ID
	int64		nGuildID;
	//	�᳤ID
	int64		nChairmanPlayerID;

	//	��Ӫ
	int8		nFaction;

	//	�ȼ�
	int8		nLevel;

	//	����
	int16		nExp;
	
	//	��Ա��
	int memberCount;

	//	�᳤����
	string		strChairmanPlayerName;
	//	��������
	string		strGuildName;
	//	����
	string		strAffiche;
};

//���˳�Ա��Ϣ
struct GS2U_GuildMemberData
{
	//	���ID
	int64			nPlayerID;
	//	�������
	string		strPlayerName;
	//	��ҵȼ�
	int16		nPlayerLevel;
	//	ְλ
	int8		nRank;
	//	ְҵ
	int8		nClass;
	//	���׶�
	int			nContribute;
	//	�Ƿ�����
	int8		bOnline;
};

//���������б��Ա��Ϣ
struct GS2U_GuildApplicantData
{
	//	���ID
	int64			nPlayerID;
	//	�������
	string		strPlayerName;
	//	��ҵȼ�
	int16		nPlayerLevel;
	//	ְҵ
	int8		nClass;
	//	ս��
	int			nZhanLi;
};

//����������Ϣ
struct GS2U_GuildFullInfo<-
{
	GS2U_GuildBaseData		stBase;
	vector<GS2U_GuildMemberData>	member_list;
	vector<GS2U_GuildApplicantData>	applicant_list;
};

//���������Աʵʱ��Ϣ
struct GS2U_GuildApplicantShortData
{
	//	���ID
	int64			nPlayerID;
	//	��ҵȼ�
	int16		nPlayerLevel;
	//	ս��
	int			nZhanLi;
};

//���������Աʵʱ��Ϣ�б�
struct GS2U_GuildApplicantShortList<-
{
	vector<GS2U_GuildApplicantShortData> info_list;
};

//���˵ȼ�����仯
struct GS2U_GuildLevelEXPChanged<-
{
	int16		nLevel;
	int			nEXP;
};

//���˹���仯
struct GS2U_GuildAfficheChanged<-
{
	string			strAffiche;
};

//��Ա���׶ȱ仯
struct GS2U_GuildMemberContributeChanged<-
{
	int64				nPlayerID;
	int				nContribute;
};

//��Ա�ȼ��仯
struct GS2U_GuildMemberLevelChanged<-
{
	int64				nPlayerID;
	int16			nLevel;
};

//��Ա�������߱仯
struct GS2U_GuildMemberOnlineChanged<-
{
	int64				nPlayerID;
	int8			nOnline;
};

//��Աְλ�仯
struct GS2U_GuildMemberRankChanged<-
{
	int64				nPlayerID;
	int8			nRank;
};

//�¼����Ա
struct GS2U_GuildMemberAdd<-
{
	GS2U_GuildMemberData stData;
};

//��Ա�˳�
struct GS2U_GuildMemberQuit<-
{
	int64				nPlayerID;
	int8			bKickOut;
};

//�������˳ɹ�
struct GS2U_JoinGuildSuccess<-
{
	int64 guildID;
	string guildName;
};

//��׼�������
struct GS2U_AllowOpComplete<-
{
	int64 playerID;
};