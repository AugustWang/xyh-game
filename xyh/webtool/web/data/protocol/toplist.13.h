// -> client to server
// <- server to client
// <-> client & server
// �ȼ�������Ϣ
struct TopPlayerLevelInfo
{
	int	top;
	int64	playerid;
	string	name;
	int	camp;
	int	level;
	int	fightingcapacity;
	int 	sex;
	int 	weapon;
	int 	coat;
};

// ս����������Ϣ
struct TopPlayerFightingCapacityInfo
{
	int	top;
	int64	playerid;
	string	name;
	int	camp;
	int	level;
	int	fightingcapacity;
	int 	sex;
	int 	weapon;
	int 	coat;
};

// ����������Ϣ
struct TopPlayerMoneyInfo
{
	int	top;
	int64	playerid;
	string	name;
	int	camp;
	int	level;
	int	money;
	int 	sex;
	int 	weapon;
	int 	coat;
};

struct GS2U_LoadTopPlayerLevelList <-
{
	vector<TopPlayerLevelInfo> info_list;
};

struct GS2U_LoadTopPlayerFightingCapacityList <-
{
	vector<TopPlayerFightingCapacityInfo> info_list;
};

struct GS2U_LoadTopPlayerMoneyList <-
{
	vector<TopPlayerMoneyInfo> info_list;
};

struct U2GS_LoadTopPlayerLevelList ->
{
};

struct U2GS_LoadTopPlayerFightingCapacityList ->
{
};

struct U2GS_LoadTopPlayerMoneyList ->
{
};


// answer.h ����ϵͳ�����Ϣ����
// -> client to server
// <- server to client
// <-> client & server
// ����������Ϣ
struct AnswerTopInfo
{
	int	top;
	int64	playerid;
	string	name;
	int	core;
};

// ��Ŀ��Ϣ
struct GS2U_AnswerQuestion <-
{
	int	id;		// ��ĿID
	int8	num;		// ��ǰ��Ŀ����
	int8 	maxnum;		// �����Ŀ����
	int 	core;		// ��ҵ�ǰ�÷�
	int8 	special_double;	// ���⹦��˫������
	int8 	special_right;	// ���⹦����ȷ��
	int8 	special_exclude;// ���⹦���ų�
	int8	a;
	int8	b;
	int8	c;
	int8	d;
	int8	e1;
	int8	e2;
};

// ׼������ʱ
struct GS2U_AnswerReady <-
{
	int time;		// ���⵹��ʱ
};

// �������
struct GS2U_AnswerClose <-
{
	
};

// ��������
struct GS2U_AnswerTopList <-
{
	vector<AnswerTopInfo> info_list;
};

// �ύ��
struct U2GS_AnswerCommit ->
{
	int 	num;		// ��Ŀ���
	int 	answer;		// ��
	int 	time;		// ��ʱ ��
};

// �ύ�𰸷���
struct U2GS_AnswerCommitRet <-
{
	int8 	ret;
	int 	score;
};

// ʹ�����⹦��
struct U2GS_AnswerSpecial ->
{
	int 	type;
};

// ʹ�����⹦�ܷ���
struct U2GS_AnswerSpecialRet <-
{
	int8 	ret;
};