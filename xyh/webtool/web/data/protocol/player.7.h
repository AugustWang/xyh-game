// -> client to server
// <- server to client
// <-> client & server

//��ɫ����
struct CharProperty
{
	int	attack;
	int	defence;
	int	ph_def;
	int	fire_def;
	int	ice_def;
	int	elec_def;
	int	poison_def; 
	int	max_life;
	int	life_recover;
	int	been_attack_recover;
	int	damage_recover;
	int	coma_def; 
	int	hold_def;
	int	silent_def;
	int	move_def;
	int	hit;
	int	dodge;
	int	block;
	int	crit;
	int	pierce; 
	int	attack_speed;
	int	tough;
	int	crit_damage_rate;
	int	block_dec_damage;
	int	phy_attack_rate;
	int	fire_attack_rate;
	int	ice_attack_rate;
	int	elec_attack_rate;
	int	poison_attack_rate;
	int	phy_def_rate;
	int	fire_def_rate;
	int	ice_def_rate;
	int	elec_def_rate;
	int	poison_def_rate;
	int	treat_rate;
	int	on_treat_rate;
	int	move_speed;
};

struct  ObjectBuff
{
	int16	buff_id;
	int16	allValidTime;
	int8	remainTriggerCount;
};

struct PlayerBaseInfo <-
{
	int64 id;

	string name;

	int16 x;   // in tile
	int16 y;   // in tile

	int8 	sex;
	int8 	face;
	int8 	weapon;

	int16	level;	//�ȼ�
	int8	camp;	//ְҵ
	int8	faction;	//��Ӫ
	int8	vip;	//VIP

	int16	maxEnabledBagCells;	//	������Ч������
	int16	maxEnabledStorageBagCells;	//	�ֿ���Ч������
	string	storageBagPassWord; //�ֿ�����

	int		unlockTimes;//����ʱ�䣬�������ж��������
	int		money;	//ͭ��
	int		moneyBinded;	//��ͭ��
	int		gold;	//Ԫ��
	int		goldBinded;	//��Ԫ��
	int 		rechargeAmmount; // ��ֵ�ܽ��
	int		ticket;	//��ȯ
	int		guildContribute;	//�ﹱ
	int		honor;	//����
	int		credit;	//����
	int		exp;	//����
	int 	bloodPool;	//Ѫ��
	int	petBloodPool;//����Ѫ��

	//////////////////////////////////////////////////////////////////////////
	//battle 
	int		life;	//����
	int		lifeMax;	//�������
	
	int64 	guildID;	//����ID

	int     mountDataID;  //��ǰװ��������ID
	int		pK_Kill_RemainTime;//����ɱ¾ģʽʱ��
	int		exp15Add;	//����ӳ� 1.5�� ��λʱ��
	int		exp20Add;	//����ӳ� 2��
	int		exp30Add;	//����ӳ� 3��

	int		pk_Kill_Value;	//ɱ¾ֵ
	int8    pkFlags; //���ں�����ǣ�ɱ¾ֵ�ﵽһ����ֵ��
	int8	minEquipLevel;	//װ����С�ȼ�
	string	guild_name;	//��������
	int8		guild_rank;	//����ְλ
	string	goldPassWord; //�ֿ�����
};

struct rideInfo
{
	int mountDataID;
	int rideFlage;
};

// ��������Ϣ
struct LookInfoPlayer
{
	int64 id;

	string name;

	int8	lifePercent;
	int16	x;   // in pixel
	int16	y;   // in pixel
	int16	move_target_x;
	int16	move_target_y;
	int8		move_dir;
	int16	move_speed;
//	int8	movestate;

	int16	level;

	//1=faction��2=sex��3-4=camp, 5-8=movestate, 9=battleFriendOrEnemy, 10-14=rideID
	int	value_flags;

//	int8	faction;
//	int8	sex;
//	int8	camp;
//	int8	battleFriendOrEnemy;

	int		charState;

//	rideInfo	rideID;

	int16 	weapon;
	int16	coat;
	vector<ObjectBuff>	buffList;
	int8     convoyFlags;
	int64	guild_id;
	string	guild_name;
	int8		guild_rank;
	int8		vip;
};
struct LookInfoPlayerList    <-
{
	vector<LookInfoPlayer> info_list;
};

//���������Ϣ
struct LookInfoPet
{
	int64 id;
	int64	masterId;
	int16	data_id;
	string name;
	int16	titleid;
	int16	modelId;
	int8	lifePercent;
	int16	level;
	int16	x;   // in pixel
	int16	y;   // in pixel
	int16	move_target_x;
	int16	move_target_y;
	int16	move_speed;
	int		charState;
	vector<ObjectBuff>	buffList;
};

struct LookInfoPetList <- 
{
	vector<LookInfoPet> info_list;
};

// monster�����Ϣ
struct LookInfoMonster
{
	int64	id;
	int16	move_target_x;
	int16	move_target_y;
	int16	move_speed;
	int16	x;   // in pixel
	int16	y;   // in pixel

	int16	monster_data_id;
	int8	lifePercent;
	int8	faction;
	int		charState;
	vector<ObjectBuff>	buffList;
};
struct LookInfoMonsterList    <-
{
	vector<LookInfoMonster> info_list;
};

// npc�����Ϣ
struct LookInfoNpc
{
	int64		id;
	int16	x;   // in pixel
	int16	y;   // in pixel
	int16	npc_data_id;
	int16	move_target_x;
	int16	move_target_y;
};
struct LookInfoNpcList    <-
{
	vector<LookInfoNpc> info_list;
};

// object�����Ϣ
struct LookInfoObject
{
	int64		id;
	int16	x;
	int16	y;
	int16	object_data_id;
	int16	object_type;
	int		param;
};
struct LookInfoObjectList <-
{
	vector<LookInfoObject>	info_list;
};

// �����ʧ
struct ActorDisapearList<-
{
	vector<int64>		info_list;
};

struct PosInfo   
{
	int16 x;
	int16 y;
};

struct PlayerMoveTo    ->
{
	int16 posX;
	int16 posY;
	vector<PosInfo> posInfos;
};

struct PlayerStopMove ->
{
	int16 posX;
	int16 posY;
};

struct PlayerStopMove_S2C <-
{
	int64 id;
	int16 posX;
	int16 posY;
};


struct MoveInfo	
{
	int64 	id;
	int16    posX;
	int16    posY;
	vector<PosInfo> posInfos;
};

struct PlayerMoveInfo    <-
{
	vector<MoveInfo> ids;
};

struct ChangeFlyState ->
{
	int flyState;
};

struct ChangeFlyState_S2C <-
{
	int64 id;
	int flyState;
};


struct MonsterMoveInfo    <-
{
	vector<MoveInfo> ids;
};

struct MonsterStopMove <-
{
	int64 id;
	int16 x;
	int16 y;
};

struct PetMoveInfo    <-
{
	vector<MoveInfo> ids;
};

struct PetStopMove <-
{
	int64 id;
	int16 x;
	int16 y;
};


struct ChangeMap <->
{
	int mapDataID;
	int64 mapId;
	int16 x;
	int16 y;
};

struct CollectFail <-
{
};
//////////////////////////////////////////////////////////////////////////
//Player
struct RequestGM ->
{
	string	strCMD;
};

struct PlayerPropertyChangeValue
{
	int8	proType;
	int		value;
};
struct PlayerPropertyChanged <-
{
	vector<PlayerPropertyChangeValue>	changeValues;
};

struct PlayerMoneyChanged <-
{
	int8	changeReson;
	int8	moneyType;
	int		moneyValue;
};

struct PlayerKickOuted <-
{
	int		reserve;
};

struct ActorStateFlagSet <-
{
	int		nSetStateFlag;
};

struct ActorStateFlagSet_Broad <-
{
	int64	nActorID;
	int		nSetStateFlag;
};

//player skill
struct PlayerSkillInitData
{
	int16	nSkillID;
	int		nCD;
	int16	nActiveBranch1;
	int16	nActiveBranch2;
	int16 	nBindedBranch;
};
struct PlayerSkillInitInfo <-
{
	vector<PlayerSkillInitData>	info_list;
};

struct U2GS_StudySkill ->
{
	int nSkillID;
};

struct GS2U_StudySkillResult <-
{
	int nSkillID;
	int nResult;
};

struct activeBranchID->
{
	int8 nWhichBranch;
	int nSkillID;
	int branchID;
};

struct activeBranchIDResult<-
{
	int result;
	int nSkillID;
	int branckID;
};

struct U2GS_AddSkillBranch->
{
	int nSkillID;
	int nBranchID;
};

struct GS2U_AddSkillBranchAck<-
{
	int result;
	int nSkillID;
	int nBranchID;
};



//	ʹ�ü�������
struct U2GS_UseSkillRequest ->
{
	int					nSkillID;
	vector<int64>	nTargetIDList;
	int					nCombatID;
};

// �����ʹ�ü���
struct GS2U_UseSkillToObject<-
{
	//	�����ͷ���
	int64 nUserActorID;
	//	����ID
	int16	nSkillID;
	//	Ŀ�����ID
	vector<int64>	nTargetActorIDList;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
};

// ��ָ���ص�ʹ�ü���
struct GS2U_UseSkillToPos<-
{
	//	�����ͷ���
 int64  nUserActorID;
	//	����ID
	int16	nSkillID;
	//	Ŀ������X
	int16	x;
	//	Ŀ������Y
	int16	y;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
	//
	vector<int64>  id_list;
};

//	�����˺���Ϣ
struct GS2U_AttackDamage<-
{
	//	�˺�Ŀ��
	int64		nDamageTarget;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
	//	SkillID(������Skill(1---10000)��Ҳ������Buff��SkillID(10001---20000)
	int16	nSkillID;
	//	��Ѫ��ֵ
	int		nDamageLife;
	//	Ŀ�굱ǰѪ���ٷֱ�
	int8	nTargetLifePer100;
	//�Ƿ��
	int8	isBlocked;
	//�Ƿ񱩻�
	int8	isCrited;
};

//	����������Ϣ
struct GS2U_CharactorDead <-
{
	//	������
	int64		nDeadActorID;
	//	ɱ����
	int64		nKiller;
	//�����ͷ�ΨһID
	int			nCombatNumber;
};

//	����δ����
struct GS2U_AttackMiss<-
{
	//	������ID
	int64	nActorID;
	//	Ŀ��ID
	int64 nTargetID;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
};

//	����ʱĿ��������
struct GS2U_AttackDodge<-
{
	//	������ID
	int64	nActorID;
	//	Ŀ��ID
	int64 nTargetID;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
};

//	����ʱĿ�걩����
struct GS2U_AttackCrit<-
{
	//	������ID
	int64	nActorID;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
};

//	����ʱĿ�����
struct GS2U_AttackBlock<-
{
	//	������ID
	int64	nActorID;
	//	�ͻ����ϴ��ļ���ʹ��ʱ��ֵ
	int		nCombatID;
};


struct PlayerAllShortcut <-
{
	int index1ID;
	int index2ID;
	int index3ID;
	int index4ID;
	int index5ID;
	int index6ID;
	int index7ID;
	int index8ID;
	int index9ID;
	int index10ID;
	int index11ID;
	int index12ID;
};

struct ShortcutSet ->
{
	int8 index;
	int data;
};

struct PlayerEXPChanged <-
{
	int		curEXP;
	int8	changeReson;
};

struct ActorLifeUpdate <-
{
	int64	nActorID;
	int		nLife;
	int		nMaxLife;
};

struct	ActorMoveSpeedUpdate<- 
{
	int64	nActorID;
	int		nSpeed;
};

struct PlayerCombatIDInit<-
{
	int		nBeginCombatID;
};

struct GS2U_CharactorRevived<-
{
	int64	nActorID;
	int		nLife;
	int		nMaxLife;
};

//�������
struct U2GS_InteractObject->
{
	int64	nActorID;
};

//�ͻ��˲�ѯ�����������
struct U2GS_QueryHeroProperty->
{
	int8	nReserve;
};

//�������ظ���ɫ��������
struct CharPropertyData
{
	int8	nPropertyType;
	int		nValue;
};

struct GS2U_HeroPropertyResult<-
{
	vector<CharPropertyData>	info_list;
};

//////////////////////////////////////////////////////////////////////////
//PlayerItem
struct ItemInfo
{
	int64		id;
	int8		owner_type;
	int64		owner_id;
	int8	location;
	int16	cell;
	int		amount;
	int		item_data_id;

	int		param1;
	int		param2;
	int8	binded;
	int		remain_time;
};
//������Ʒ��ʼ��
struct PlayerBagInit <-
{
	vector<ItemInfo> items;
};

//�����Ʒ֪ͨ
struct PlayerGetItem <-
{
	ItemInfo	item_info;
};

//��Ʒ����֪ͨ
struct PlayerDestroyItem <-
{
	int64		itemDBID;
	int8		reson;
};

//��Ʒλ�ñ仯
struct PlayerItemLocationCellChanged <-
{
	int64		itemDBID;
	int8		location;
	int16		cell;
};


//��Ʒ��������
struct RequestDestroyItem ->
{
	int64		itemDBID;
};

//GM�����Ʒ����
struct RequestGetItem ->
{
	int			itemDataID;
	int			amount;
};

//�����Ʒ�����仯
struct PlayerItemAmountChanged <-
{
	int64		itemDBID;
	int			amount;
	int			reson;
};

//�����Ʒ�����仯
struct PlayerItemParamChanged <-
{
	int64		itemDBID;
	int			param1;
	int			param2;
	int			reson;
};

struct PlayerBagOrderData
{
	int64		itemDBID;
	int			amount;
	int			cell;
};


//������������
struct RequestPlayerBagOrder ->
{
	int			location;
	//vector<PlayerBagOrderData>	orderDatas; 
};

//���������������
struct PlayerBagOrderResult <-
{
	int		location;
	int		cell;//���Բ��ò�����
};


//	ʹ����Ʒ����
struct PlayerRequestUseItem ->
{
	int16	location;
	int16	cell;
	int16	useCount;
};

//	ʹ����Ʒ���
struct PlayerUseItemResult <-
{
	int16	location;
	int16	cell;
	int		result;
};

//	������������
struct RequestPlayerBagCellOpen ->
{
	int		cell;
	int   location;
};
//����仯����
struct RequestChangeStorageBagPassWord ->
{
	string  oldStorageBagPassWord;
	string  newStorageBagPassWord;
	int status ;
};

struct PlayerStorageBagPassWordChanged <-
{
	int	result; 	
};
//	��Ҹ�����Ч�����仯
struct PlayerBagCellEnableChanged <-
{
	int		cell;
	int		location;
	int		gold;
	int		item_count;
};


//	�����ڳ�����Ʒ
struct RequestPlayerBagSellItem ->
{
	int		cell;
};

//	������ʱ��������Ʒ���
struct RequestClearTempBag ->
{
	int		reserve;
};

//	������ʱ��������Ʒ�ŵ�������
struct RequestMoveTempBagItem ->
{
	int		cell;
};

//	������ʱ��������Ʒȫ���ŵ�������
struct RequestMoveAllTempBagItem ->
{
	int		reserve;
};

//	���󽫲ֿ���ĳ��������Ʒ�ƶ���������
struct RequestMoveStorageBagItem ->
{
	int		cell;
};

//	������������ĳ��������Ʒ�ƶ����ֿ�
struct RequestMoveBagItemToStorage ->
{
	int		cell; 
};
//	����ǿ�ƽ����ֿ���������󣬼�72Сʱ֮��ʼ����
struct RequestUnlockingStorageBagPassWord ->
{
	int		passWordType;
};
//	����ȡ��ǿ�ƽ����ֿ�����
struct RequestCancelUnlockingStorageBagPassWord ->
{
	int		passWordType;
};
//����ǿ�ƽ�����ʣ��ʱ��
struct PlayerUnlockTimesChanged <-
{
	int	unlockTimes;
};

// ������ĳ����λ��������Ϊ
struct ItemBagCellSetData
{
	int		location;
	int		cell;
	int64	itemDBID;
};
struct ItemBagCellSet <-
{
	vector<ItemBagCellSetData> cells;
};

//////////////////////////////////////////////////////////////////////////
//NpcStore
struct NpcStoreItemData
{
	int64		id;					//����������id
	int		item_id;			//��Ʒid
	int		price;				//�ۼ�
	int		isbind;				//�Ƿ�����  1�ǰ󶨣�0�ǲ���
};


//�����̵���Ʒ�б�
struct RequestGetNpcStoreItemList ->
{
	int		store_id;
};

struct GetNpcStoreItemListAck <-
{
	int		store_id;
	vector<NpcStoreItemData>	itemList;
};

struct RequestBuyItem ->   //������Ʒ����
{
	int		item_id;
	int		amount;
	int		store_id;
};
struct BuyItemAck <- //���ǽ��׽�����Ļص������������ۣ����򣬻ع����һ�
{
	int		count;
}
struct RequestSellItem ->   //������Ʒ����
{
	int64		item_cell;
};

struct GetNpcStoreBackBuyItemList ->
{
	int		count;
};
struct GetNpcStoreBackBuyItemListAck <-
{
	vector<ItemInfo>	itemList;
};
struct RequestBackBuyItem ->   //�ع���Ʒ����
{
	int64		item_id;
};

//////////////////////////////////////////////////////////////////////////
// PlayerEquip
struct PlayerEquipNetData
{
	int		dbID;					//������װ��dbID;
	int		nEquip;						//�����ļ�װ��Id;
	int8	type;						//װ������
	int8	nQuality;					//Ʒ��
	int8	isEquiped;					//�Ƿ��Ѿ�װ����
	int16	enhanceLevel;				//ǿ���ȼ�


	int8		property1Type;				//��������1������
	int8		property1FixOrPercent;		//��������1FixOrPercent
	int			property1Value;				//��������1��ֵ
	int8		property2Type;				//��������2������
	int8		property2FixOrPercent;		//��������2FixOrPercent
	int			property2Value;				//��������2��ֵ
	int8		property3Type;				//��������3������
	int8		property3FixOrPercent;		//��������3FixOrPercent
	int			property3Value;				//��������3��ֵ
	int8		property4Type;				//��������4������
	int8		property4FixOrPercent;		//��������4FixOrPercent
	int			property4Value;				//��������4��ֵ
	int8		property5Type;				//��������5������
	int8		property5FixOrPercent;		//��������5FixOrPercent
	int			property5Value;				//��������5��ֵ
	
};

// �������װ����ʼ��
struct PlayerEquipInit <-
{
	vector<PlayerEquipNetData>	equips;
};

//	װ����������
struct RequestPlayerEquipActive ->
{
	int		equip_data_id;				//װ������id
};

//	װ��������
struct PlayerEquipActiveResult <-
{
	PlayerEquipNetData	equip;
};

//	����װ��
struct RequestPlayerEquipPutOn ->
{
	int		equip_dbID;					//	װ��dbID
};

//	����װ�����
struct PlayerEquipPutOnResult <-
{
	int		equip_dbID;					//	װ��dbID
	int8	equiped;
};

//	��ѯ���װ��
struct RequestQueryPlayerEquip ->
{
	int64		playerid;
};

//	��ѯ���װ�����
struct QueryPlayerEquipResult <-
{
	vector<PlayerEquipNetData>	equips;
};

struct StudySkill ->
{
	int id;
	int lvl;
};

struct StudyResult <-
{
	int8 result; // 0. failed 1. ok;
	int id;
	int lvl;
};

struct Reborn ->
{
	int8 type;
};

struct RebornAck <-
{
	int x;
	int y;
};

//chat
struct Chat2Player <-
{
	int8 channel;
	int64 sendID;
	int64 receiveID;
	string sendName;
	string receiveName;
	string content;
	int8	vipLevel;
};

struct Chat2Server ->
{
	int8 channel;
	int64 sendID;
	int64 receiveID;
	string sendName;
	string receiveName;
	string content;
};

struct Chat_Error_Result<-
{
	int reason;
};

//////////////////////////////////////////////////////////////////////////
// Mail
struct RequestSendMail ->
{
	int64		targetPlayerID;
	string  targetPlayerName;
	string	strTitle;
	string	strContent;
	int64		attachItemDBID1;
	int			attachItem1Cnt;
	int64		attachItemDBID2;
	int			attachItem2Cnt;
	int		moneySend;
	int		moneyPay;
};

struct RequestSendMailAck <-
{
	int8 result;
};

struct RequestRecvMail ->
{
	int64		mailID;
	int		deleteMail;
};

struct RequestUnReadMail ->
{
	int64 playerID;
};

struct RequestUnReadMailAck <-
{
	int unReadCount;
};

struct RequestMailList ->
{
	int64 playerID;
};

struct MailInfo
{
	int64 id;
	int type;
	int64 recvPlayerID;
	int isOpen;
	int timeOut;
	int senderType;
	string senderName;
	string title;
	string content;
	int8 haveItem;
	int moneySend;
	int moneyPay;
	int mailTimerType;
	int mailRecTime;
};

struct RequestMailListAck <-
{
	vector<MailInfo> mailList;
};

struct RequestMailItemInfo ->
{
	int64 mailID;
};

struct RequestMailItemInfoAck <-
{
	int64 mailID;
	vector<ItemInfo> mailItem;
};

struct RequestAcceptMailItem ->
{
	int64 mailID;
	int isDeleteMail;
};

struct RequestAcceptMailItemAck <-
{
	int result;
};

struct MailReadNotice ->
{
	int64 mailID;
};

struct RequestDeleteMail ->
{
	int64 mailID;
};

struct InformNewMail <-
{
};

struct RequestDeleteReadMail ->
{
	vector<int64> readMailID;
};

//////����ָ��Ժ�ɾ��
struct RequestSystemMail ->
{
};

//////////////////////////////////////////////////////////////////////////
// User 2 GameServer
struct U2GS_RequestLogin ->
{
	int64		userID;
	string	identity;
	int protocolVer;
};

struct U2GS_SelPlayerEnterGame ->
{
	int64		playerID;
};

struct U2GS_RequestCreatePlayer ->
{
	string	name;
	int8	camp;
	int8	classValue;
	int8	sex;
};

struct U2GS_RequestDeletePlayer ->
{
	int64		playerID;
};

//////////////////////////////////////////////////////////////////////////
// GameServer 2 User
struct GS2U_LoginResult <-
{
	int		result;
};

struct GS2U_SelPlayerResult <-
{
	int result;
};

struct UserPlayerData
{
	int64		playerID;
	string	name;
	int		level;
	int8	classValue;
	int8	sex;
	int8	faction
};

struct GS2U_UserPlayerList <-
{
	vector<UserPlayerData>	info;
};

struct GS2U_CreatePlayerResult <-
{
	int		errorCode;
};

struct GS2U_DeletePlayerResult <-
{
	int64		playerID;
	int		errorCode;
};

//////////////////////////////////////////////////////////////////////////

//////////////////////////////������/////////////////////////////////////

struct ConSales_GroundingItem ->
{
	int64 dbId;
	int count;
	int money;
	int timeType, 
};

struct ConSales_GroundingItem_Result <-
{
	int result;
};

struct ConSales_TakeDown ->
{
	int64 conSalesId;
};

struct ConSales_TakeDown_Result <-
{
	int allTakeDown;
	int result;
    int protectTime; // ��һ������ʱ�䣨�룩��By Rolong��
};

struct ConSales_BuyItem ->
{
	int64 conSalesOderId;
};

struct ConSales_BuyItem_Result <-
{
	int8 result;
};

struct ConSales_FindItems ->
{
	int offsetCount;
	int8 ignoreOption;
	int8 type;
	int8 detType;
	int levelMin;
	int levelMax;
	int occ; 
	int quality; 
	int idLimit;
	vector<int> idList;
};

struct ConSalesItem
{
	int64 conSalesId;
	int conSalesMoney;
	int groundingTime;
	int timeType;
	int playerId; 
	string playerName;
	int itemDBId;
	int itemId; 
	int itemCount;
	int itemType; 
	int itemQuality; 
	int itemLevel; 
	int itemOcc;
};

struct ConSales_FindItems_Result <-
{
	int result;
	int allCount;
	int page;
	vector<ConSalesItem>	 itemList;
};

struct ConSales_TrunPage ->
{
	int mode;
};

struct ConSales_Close ->
{
	int n;
};

struct ConSales_GetSelfSell ->
{
	int n;
};

struct ConSales_GetSelfSell_Result<-
{
	vector<ConSalesItem>	 itemList;
};

//////////////////////////////////////////////////////////////////////////

/////////////////////////////////����/////////////////////////////////////
struct TradeAsk <->
{
	int64 playerID;
	string playerName;
};

struct TradeAskResult <->
{
	int64 playerID;
	string playerName;
	int8 result;
};

struct CreateTrade <-
{
	int64 playerID;
	string playerName;
	int8 result;
};

struct TradeInputItem_C2S->
{
	int cell;
	int64 itemDBID;
	int count;
};

struct  TradeInputItemResult_S2C<-
{
	int64 itemDBID;
	int item_data_id;
	int count;
	int cell;
	int8 result;
};

struct TradeInputItem_S2C<-
{
	int64 itemDBID;
	int item_data_id;
	int count;
};

struct TradeTakeOutItem_C2S->
{
	int64 itemDBID;
};

struct TradeTakeOutItemResult_S2C<-
{
	int cell;
	int64 itemDBID;
	int8 result;
};

struct TradeTakeOutItem_S2C<-
{
	int64 itemDBID;
};

struct TradeChangeMoney_C2S->
{
	int money;
};

struct TradeChangeMoneyResult_S2C<-
{
	int money;
	int8 result;
};

struct TradeChangeMoney_S2C<-
{
	int money;
};

struct TradeLock_C2S->
{
	int8 lock;
};

struct TradeLock_S2C<-
{
	int8 person;
	int8 lock;
};

struct CancelTrade_S2C <-
{
	int8 person;
	int8 reason;
};

struct CancelTrade_C2S ->
{
	int8 reason;
};

struct TradeAffirm_C2S->
{
	int bAffrim;
};

struct TradeAffirm_S2C<-
{
	int8 person;
	int8 bAffirm;
};
//////////////////////////////////////////////////////////////////////////


///////////////////////////////////����//////////////////////////////////

struct	PetSkill 
{
	int64	id;
	int	coolDownTime;
};

struct PetProperty
{
	int64	db_id;
	int	data_id;
	int64	master_id;
	int	level;
	int	exp;
	string	name;
	int	titleId;
	int8	aiState;
	int8	showModel;
	int	exModelId;
	int	soulLevel;
	int	soulRate;
	int	attackGrowUp;
	int	defGrowUp;
	int	lifeGrowUp;
	int8	isWashGrow;
	int	attackGrowUpWash;
	int	defGrowUpWash;
	int	lifeGrowUpWash;
	int	convertRatio;
	int	exerciseLevel;
	int	moneyExrciseNum;
	int	exerciseExp;
	int	maxSkillNum;
	vector<PetSkill>	skills;

	int	life;
	int	maxLife;
	int	attack;
	int	def;
	int	crit;
	int	block;
	int	hit;
	int	dodge;
	int	tough;
	int	pierce;

	int	crit_damage_rate;
	int	attack_speed;
	int	ph_def;
	int	fire_def;
	int	ice_def;
	int	elec_def;
	int	poison_def;
	int	coma_def;
	int	hold_def;
	int	silent_def;
	int	move_def;

	int	atkPowerGrowUp_Max;
	int	defClassGrowUp_Max;
	int	hpGrowUp_Max;
	int	benison_Value;
};

struct PlayerPetInfo <- 
{
	vector<int>		petSkillBag;
	vector<PetProperty>	petInfos;
};

struct UpdatePetProerty<- 
{
	PetProperty		petInfo;
};

struct	DelPet<-
{
	int64	petId;
};

struct  PetOutFight ->
{
	int64	petId;
};

struct  PetOutFight_Result<-
{
	int8	result;
	int64	petId;
};

struct	PetTakeRest -> 
{
	int64	petId;
};

struct	PetTakeRest_Result<-
{
	int8	result;
	int64	petId;
};

struct	PetFreeCaptiveAnimals->
{
	int64	petId;
};

struct	PetFreeCaptiveAnimals_Result<-
{
	int8	result;
	int64	petId;
};


struct	PetCompoundModel-> 
{
	int64	petId;
};

struct	PetCompoundModel_Result<-
{
	int8	result;
	int64	petId;
};

struct	PetWashGrowUpValue-> 
{
	int64	petId;
};

struct	PetWashGrowUpValue_Result <- 
{
	int8	result;
	int64	petId;
	int	attackGrowUp;
	int	defGrowUp;
	int	lifeGrowUp;
};

struct	PetReplaceGrowUpValue -> 
{
	int64	petId;
};

struct	PetReplaceGrowUpValue_Result<-
{
	int8	result;
	int64	petId;
};

struct	PetIntensifySoul	-> 
{
	int64	petId;
};

struct	PetIntensifySoul_Result<- 
{
	int8	result;
	int64	petId;
	int	soulLevel;
	int	soulRate;
	int	benison_Value;
};

struct	PetOneKeyIntensifySoul	-> 
{
	int64	petId;
};

struct	PetOneKeyIntensifySoul_Result	<- 
{
	int64	petId;
	int8	result;
	int	itemCount;
	int	money;
};

struct	PetFuse-> 
{
	int64	petSrcId;
	int64	petDestId;
};

struct	PetFuse_Result<- 
{
	int8	result;
	int64	petSrcId;
	int64	petDestId;
};

struct	PetJumpTo <- 
{
	int64	petId;
	int	x;
	int	y;
};

struct	ActorSetPos<- 
{
	int64	actorId;
	int	x;
	int	y;
};

struct	PetTakeBack<-
{
	int64	petId;
};

struct	ChangePetAIState <-> 
{
	int8	state;
};

struct	PetExpChanged<-
{
	int64	petId;
	int	curExp;
	int8	reason;
};

struct	PetLearnSkill->
{
	int64	petId;
	int		skillId;
};

struct	PetLearnSkill_Result<-
{
	int8		result;
	int64	petId;
	int		oldSkillId;
	int		newSkillId;
};

struct	PetDelSkill-> 
{
	int64	petId;
	int		skillId;
};

struct	PetDelSkill_Result <- 
{
	int8		result;
	int64	petId;
	int		skillid;
};

struct	PetUnLockSkillCell-> 
{
	int64	petId;
};

struct	PetUnLoctSkillCell_Result <- 
{
	int8		result;
	int64	petId;
	int		newSkillCellNum;
};

struct	PetSkillSealAhs->
{
	int64	petId;
	int		skillid;
};

struct	PetSkillSealAhs_Result<-
{
	int8		result;
	int64	petId;
	int		skillid;
};

struct	PetUpdateSealAhsStore<- 
{
	vector<int>		petSkillBag;
};

struct	PetlearnSealAhsSkill-> 
{
	int64	petId;
	int		skillId;
};

struct	PetlearnSealAhsSkill_Result<-
{
	int8		result;
	int64	petId;
	int		oldSkillId;
	int		newSkillId;
};

/////////////////////////////////////////////////////////////////////////





//////////////////////////װ��ǿ��///////////////////////////////////////////////

//����װ��ǿ��������䷵��
struct	RequestGetPlayerEquipEnhanceByType->
{
	int	type;
};
struct	GetPlayerEquipEnhanceByTypeBack <-
{
	int	type;
	int	level;
	int	progress;
	int	blessValue;
};
//ǿ�������䷵��
struct	RequestEquipEnhanceByType ->
{
	int	type;
};

struct	EquipEnhanceByTypeBack <-
{
	int	result;
};
//һ��ǿ�������䷵��
struct	RequestEquipOnceEnhanceByType ->
{
	int	type;
};

struct	EquipOnceEnhanceByTypeBack <-
{
	int	result;
	int	times;
	int	itemnumber;
	int	money;
};

//////////////////////////װ����Ʒ///////////////////////////////////////////////

//����װ��Ʒ�ʼ��䷵��
struct	RequestGetPlayerEquipQualityByType->
{
	int	type;
}��
struct	GetPlayerEquipQualityByTypeBack <-
{
	int type;
	int	quality;
};

//ǿ�������䷵��
struct	RequestEquipQualityUPByType ->
{
	int	type;
};

struct	EquipQualityUPByTypeBack <-
{
	int result;
};


/////////////////////////////////////////////////װ��ϴ��///////////////////////////////////////////////
//���������~���䷵��
struct	RequestEquipOldPropertyByType ->
{
	int	type;
};

struct	GetEquipOldPropertyByType <-
{
	int	type;
	int8		property1Type;				//��������1������
	int8		property1FixOrPercent;		//��������1FixOrPercent
	int			property1Value;				//��������1��ֵ
	int8		property2Type;				//��������2������
	int8		property2FixOrPercent;		//��������2FixOrPercent
	int			property2Value;				//��������2��ֵ
	int8		property3Type;				//��������3������
	int8		property3FixOrPercent;		//��������3FixOrPercent
	int			property3Value;				//��������3��ֵ
	int8		property4Type;				//��������4������
	int8		property4FixOrPercent;		//��������4FixOrPercent
	int			property4Value;				//��������4��ֵ
	int8		property5Type;				//��������5������
	int8		property5FixOrPercent;		//��������5FixOrPercent
	int			property5Value;				//��������5��ֵ
};
//ϴ�������䷵�ص�������
struct	RequestEquipChangePropertyByType ->
{
	int	type;
	int8	property1;//0��ʾ���ı䣨����������1��ʾҪ�ı�
	int8	property2;
	int8	property3;
	int8	property4;
	int8	property5;
};

struct	GetEquipNewPropertyByType <-
{
	int	type;
	int8		property1Type;				//��������1������
	int8		property1FixOrPercent;		//��������1FixOrPercent
	int			property1Value;				//��������1��ֵ
	int8		property2Type;				//��������2������
	int8		property2FixOrPercent;		//��������2FixOrPercent
	int			property2Value;				//��������2��ֵ
	int8		property3Type;				//��������3������
	int8		property3FixOrPercent;		//��������3FixOrPercent
	int			property3Value;				//��������3��ֵ
	int8		property4Type;				//��������4������
	int8		property4FixOrPercent;		//��������4FixOrPercent
	int			property4Value;				//��������4��ֵ
	int8		property5Type;				//��������5������
	int8		property5FixOrPercent;		//��������5FixOrPercent
	int			property5Value;				//��������5��ֵ
};

//����������
struct	RequestEquipSaveNewPropertyByType ->
{
	int	type;

};
//ϴ��ͱ�����
struct	RequestEquipChangeAddSavePropertyByType <-
{
	int	result;
};



//������븱������npc�Ի�
struct U2GS_EnterCopyMapRequest->
{
	int64	npcActorID;
	int		enterMapID;
};
//��ͼ�л����
struct GS2U_EnterMapResult<-
{
	int		result;
};

//��ѯ����CD
struct U2GS_QueryMyCopyMapCD->
{
	int		reserve;
};

//����CD��Ϣ
struct MyCopyMapCDInfo
{
	//��ͼDataID
	int16	mapDataID;
	//�õ�ͼ�Ѿ��������
	int8	mapEnteredCount;
	//ʣ���Ծ����
	int8	mapActiveCount;
};

struct GS2U_MyCopyMapCDInfo<-
{
	vector<MyCopyMapCDInfo>	info_list;
};

//buff
struct	AddBuff<-
{
	int64	actor_id;
	int16	buff_data_id;
	int16	allValidTime;
	int8	remainTriggerCount;
};

struct	DelBuff<-
{
	int64	actor_id;
	int16	buff_data_id;
};

struct	UpdateBuff<-
{
	int64	actor_id;
	int16	buff_data_id;
	int8	remainTriggerCount;
};

struct	HeroBuffList<- 
{
	vector<ObjectBuff>	buffList;
};

//�����ͼ����
struct	U2GS_TransByWorldMap->
{
	int mapDataID;
	int posX;
	int posY;
};

struct	U2GS_TransForSameScence->
{
	int mapDataID;
	int posX;
	int posY;
};

//���������������
struct U2GS_FastTeamCopyMapRequest->
{
	int64	npcActorID;
	int		mapDataID;
	// enterOrQuit=0��ʾ���룬enterOrQuit=1��ʾ�˳�
	int8	enterOrQuit; 
};
//�����������������
struct GS2U_FastTeamCopyMapResult<-
{
	int		mapDataID;
	// ����룬>=0��ʾenterOrQuit��Ч��<0��ʾ��������ֵ���ͼ�EnterMap_Fail_Type
	int		result;
	int8	enterOrQuit; 
};

//��ӽ��븱��ȷ��
struct GS2U_TeamCopyMapQuery<-
{
	int		nReadyEnterMapDataID;
	int		nCurMapID;
	int		nPosX;
	int		nPosY;
	int		nDistanceSQ;
};

//��������
struct U2GS_RestCopyMapRequest->
{
	int64	nNpcID;
	int		nMapDataID;
};

//��޶�����������������ӻ�ɾ��
struct GS2U_AddOrRemoveHatred<-
{
	int64	nActorID;
	int8	nAddOrRemove;
};

//�д�����
struct U2GS_QieCuoInvite->
{
	int64	nActorID;
};
//�д�����ѯ��
struct GS2U_QieCuoInviteQuery<-
{
	int64	nActorID;
	string	strName;
};
//�д�����ظ�
struct U2GS_QieCuoInviteAck->
{
	int64	nActorID;
	int8	agree;		
};
//�д�������
struct GS2U_QieCuoInviteResult<-
{
	int64	nActorID;
	int8	result;
};
//�д���
struct GS2U_QieCuoResult<-
{
	int64	nWinner_ActorID;
	string	strWinner_Name;

	int64	nLoser_ActorID;
	string	strLoser_Name;

	int8	reson;
};

//ɱ¾ģʽ��������
struct U2GS_PK_KillOpenRequest->
{
	int8	reserve;
};
//ɱ¾ģʽ�������
struct GS2U_PK_KillOpenResult<-
{
	int		result;
	int		pK_Kill_RemainTime;
	int		pk_Kill_Value;
};
//��װ��ʱ��ȫͼ�㲥
struct GS2U_Player_ChangeEquipResult<-
{
	int64	playerID;
	int		equipID;
};

//ϵͳ�㲥
struct	SysMessage<- 
{
	int 	type;
	string	text;
};

//��ҩ��Ѫ
struct GS2U_AddLifeByItem<-
{
	int64	actorID;
	int		addLife;
	int8	percent;
};

//���ܼ�Ѫ
struct GS2U_AddLifeBySkill<-
{
	int64	actorID;
	int		addLife;
	int8	percent;
	// �Ƿ񱩻���=0��ʾû�б�����!=0��ʾ����
	int8	crite;
};

//��ƷCD��Ϣ
struct PlayerItemCDInfo
{
	//��ƷCD����ID��ItemData::m_cdTypeID
	int8	cdTypeID;
	//ʣ��ʱ�䣬��λ���룬<= 0��ʾcd����
	int		remainTime;
	//��ʱ�䣬��λ����
	int		allTime;
};

//������߳�ʼ����ƷCD
struct GS2U_PlayerItemCDInit<-
{
	vector<PlayerItemCDInfo>	info_list;
};

//��ƷCD����
struct GS2U_PlayerItemCDUpdate<-
{
	PlayerItemCDInfo	info;
};


struct	U2GS_BloodPoolAddLife->
{
	int64	actorID;
};

struct GS2U_ItemDailyCount<-
{
	int		remainCount;
	int		task_data_id;
};

//���ǩ��
struct U2GS_GetSigninInfo ->
{
};
//���ǩ����Ϣ
struct GS2U_PlayerSigninInfo<-
{
	//�����Ƿ���ǩ����1Ϊ��ǩ��,0Ϊ��û��ǩ��
	int8	isAlreadySign;
	//������ǩ��������(0 ~7)
	int8    days; 
};
//���ǩ��
struct U2GS_Signin ->
{
};

//���ǩ�����
struct GS2U_PlayerSignInResult<-
{
	int	nResult;
	int8   awardDays; 
};


struct	U2GS_LeaveCopyMap -> 
{
	int8 reserve;
};

//����û�
struct	PetChangeModel<-
{
	int64	petId;
	int		modelID;
};

//�������
struct	PetChangeName <->
{
	int64	petId;
	string	newName;
};

struct	PetChangeName_Result<-
{
	int8		result;
	int64	petId;
	string	newName;
};


//�̳�Э��
struct BazzarItem
{
	//��ƷDBID
	int		db_id;
	//	��ƷID
	int16	item_id;
	//���ͣ�ȡֵΪ��0���Żݣ�1�����õ��ߣ�2���������3װ��ǿ��,	
	int8		item_column;
	//	���
	int16	gold;
	//	�󶨽��
	int16	binded_gold;
	//	ʣ������(-1��ʾ���������ƣ�
	int16	remain_count;
	//	ʣ��ʱ�䣨��λ���룩(-1��ʾ��ʱ�����ƣ�
	int		remain_time;
};

//�̳���Ʒ�б�����
struct  BazzarListRequest->
{
	int	seed;		//�ͻ������ӣ������ж��Ƿ����������Ʒ�б���ͻ���
};

//�Ż��̳��б�
struct BazzarPriceItemList<-
{
	vector<BazzarItem> itemList;
};

//�����̳���Ʒ�б�
struct BazzarItemList<-
{
	int	seed;		//�ͻ������ӣ������ж��Ƿ����������Ʒ�б���ͻ���
	vector<BazzarItem> itemList;
};

//���µ�����Ʒ���������Ż��̳���������
struct BazzarItemUpdate<-
{
	BazzarItem item;
};

//��Ʒ��������
struct	BazzarBuyRequest->
{
	int	db_id;
	int16	isBindGold;
	int16	count;
};

//��Ʒ���򷵻�
struct  BazzarBuyResult<- 
{
	int8 result;
};

//�������ӷ���
struct PlayerBagCellOpenResult<-
{
	int8 result;
};

//�Ƴ���֧����
struct U2GS_RemoveSkillBranch->
{
	int nSkillID;
}

//�Ƴ���֧���ܻذ�
struct GS2U_RemoveSkillBranch<-
{
	int result;
	int nSkillID;
}

struct	U2GS_PetBloodPoolAddLife->
{
	int8	n;
};

//���ӻ�Ծ����
struct	U2GS_CopyMapAddActiveCount->
{
	int16 map_data_id;
};

//���ӻ�Ծ��������
struct	U2GS_CopyMapAddActiveCountResult<-
{
	int16 result;
};

//�������
//��ҵ�ǰ�Ļ�����Ϣ
struct GS2U_CurConvoyInfo<-
{
	int8 isDead;
	int convoyType;
	int carriageQuality;
	int remainTime;
	int lowCD;
	int highCD;
	int freeCnt;
};
//�ڳ�Ʒ��ˢ��
struct U2GS_CarriageQualityRefresh->
{
	int isRefreshLegend;
	int isCostGold;
	int curConvoyType;
	int curCarriageQuality;
	int curTaskID;
};
//�ڳ�Ʒ��ˢ�½��
struct GS2U_CarriageQualityRefreshResult<-
{
	int retCode;
	int newConvoyType;
	int newCarriageQuality;
	int freeCnt;
};

//������CD��Ϣ
struct U2GS_ConvoyCDRequst->
{
};
struct GS2U_ConvoyCDResult<-
{
	int8 retCode;
};

//��ʼ����
struct U2GS_BeginConvoy->
{
	int	nTaskID;
	int curConvoyType;
	int curCarriageQuality;
	int64 nNpcActorID;
};
struct GS2U_BeginConvoyResult<-
{
	int retCode;
	int curConvoyType;
	int curCarriageQuality;
	int remainTime;
	int lowCD;
	int highCD;
};
struct GS2U_FinishConvoyResult<-
{
	int curConvoyType;
	int curCarriageQuality;
};
struct GS2U_GiveUpConvoyResult<-
{
	int curConvoyType;
	int curCarriageQuality;
};
struct GS2U_ConvoyNoticeTimerResult<-
{
	int8 isDead;
	int remainTime;
};
struct GS2U_ConvoyState<-
{
	int8 convoyFlags;
	int quality;
	int64 actorID;
};




struct GSWithU_GameSetMenu <->
{
	int8 joinTeamOnoff;
	int8 inviteGuildOnoff;
	int8 tradeOnoff;
	int8 applicateFriendOnoff;
	int8 singleKeyOperateOnoff;
	int8 musicPercent;
	int8 soundEffectPercent;
	int8 shieldEnermyCampPlayer;
	int8 shieldSelfCampPlayer;
	int8 shieldOthersPet;
	int8 shieldOthersName;
	int8 shieldSkillEffect;
	int8 dispPlayerLimit;
};

// ��ȡ��ֵ���
struct U2GS_RequestRechargeGift->
{
	int8 type;
};

// ��ȡ��ֵ�������
struct U2GS_RequestRechargeGift_Ret<-
{
	int8 retcode;
};

// �����ɫս����
struct U2GS_RequestPlayerFightingCapacity->
{

};

// �����ɫս��������
struct U2GS_RequestPlayerFightingCapacity_Ret<-
{
	int fightingcapacity;
};

// �������ս����
struct U2GS_RequestPetFightingCapacity->
{
	int petid;
};

// �������ս��������
struct U2GS_RequestPetFightingCapacity_Ret<-
{
	int fightingcapacity;
};

// ��������ս����
struct U2GS_RequestMountFightingCapacity->
{
	int mountid;
};

// ��������ս��������
struct U2GS_RequestMountFightingCapacity_Ret<-
{
	int fightingcapacity;
};

//��������
struct VariantData
{
	int16	index;
	int		value;
};
struct GS2U_VariantDataSet<-
{
	int8	variant_type;
	vector<VariantData>	info_list;
};


// world boss
struct U2GS_GetRankList->
{
	int mapDataID;
};

struct GS2U_RankList<-

{
	
	int mapID;
	int rankNum;
	string name1;
	int harm1;
	string name2;
	int harm2;
	string name3;
	int harm3;

	string	name4;
	int harm4;
	string name5;
	int harm5;
	string name6;
	int harm6;

	string name7;
	int harm7;
	string name8;
	int harm8;
	string name9;
	int harm9;
	string name10;
	
	int harm10;

};



struct GS2U_WordBossCmd<-
{
	int m_iCmd;
	int m_iParam;
};



//��ɫ����
struct U2GS_ChangePlayerName->
{
	int64 id;
	string name;
};
struct GS2U_ChangePlayerNameResult<-
{
	int retCode;
};


struct U2GS_SetProtectPwd->
{
	int64 id;
	string oldpwd;
	string pwd;
};
struct GS2U_SetProtectPwdResult<-
{
	int retCode;
};

struct U2GS_HeartBeat->
{
};

struct GS2U_CopyProgressUpdate<-
{
	int8	progress;
};

struct U2GS_QequestGiveGoldCheck->
{
};
struct U2GS_StartGiveGold->
{
};
struct U2GS_StartGiveGoldResult<-
{
	int8 goldType;
	int8 useCnt;
	int  exp;
	int  level;
	int  awardMoney;
	int  retCode;
};
struct U2GS_GoldLineInfo<-
{
	int8 useCnt;
	int  exp;
	int  level;
};
struct U2GS_GoldResetTimer<-
{
	int8 useCnt;
};

//����������Ϣ
struct GS2U_CopyMapSAData<-
{
	int  map_id;
	int  killed_count;
	int8 finish_rate;
	int  cost_time;
	int   exp;
	int   money;
	int8 level;
	int8 is_perfect;
};

//tokenStore �����̵�
struct TokenStoreItemData
{
	int64		id;					//����������id
	int		item_id;			//��Ʒid
	int		price;				//�ۼ�
	int		tokenType;			//��������
	int		isbind;				//�Ƿ�����  1�ǰ󶨣�0�ǲ���
};

struct GetTokenStoreItemListAck <-
{
	int store_id;
	vector<TokenStoreItemData>	itemList;
};

//����鿴���
struct	RequestLookPlayer->
{
	int64 playerID;
};

//�鿴������󷵻أ�
struct	RequestLookPlayer_Result<-
{
	PlayerBaseInfo		baseInfo;			//��������
	vector<CharPropertyData>	propertyList;	//�����б�	 
	vector<PetProperty>	petList;		//�����б�
	vector<PlayerEquipNetData>	equipList; //װ���б�
	int	fightCapacity;	//ս����
};

//�鿴�������ʧ�ܷ���
struct	RequestLookPlayerFailed_Result<-
{
	int8 result;
};

struct U2GS_PlayerClientInfo->
{
	int64 playerid;
	string platform;
	string machine;
};

//������һ�Ծ��Ϣ
struct U2GS_RequestActiveCount->
{
	int8	n;
};

struct	ActiveCountData 
{
	int	daily_id;
	int	count;
};

//��������Ծ�ȵķ���
struct GS2U_ActiveCount<-
{
	int	activeValue;			//��Ծֵ
	vector<ActiveCountData>	dailyList;
};

//�������һ���Ծֵ
struct	U2GS_RequestConvertActive->
{
	int	n;
};


//ѯ���Ƿ����ǰ�ĳ�ֵת��ĳһ��ɫ
struct GS2U_WhetherTransferOldRecharge<-
{
	int64		playerID;
	string name;
	int rechargeRmb;
};
//����ǰ�ĳ�ֵת��ĳһ��ɫ
struct	U2GS_TransferOldRechargeToPlayer->
{
	int64 playerId;
	int8 isTransfer; //0:��ת��1��ת��Щ��ɫ
};
//ת���ϵĳ�ֵ�Ľ��
struct GS2U_TransferOldRechargeResult<-
{
	int errorCode;
};

//	װ������ʧ��ԭ��
struct PlayerEquipActiveFailReason <-
{
	int reason;
};

//	װ���ȼ��仯�㲥
struct PlayerEquipMinLevelChange<-
{
	int64		playerid;
	int8		minEquipLevel;
};
//����ֿ�����
struct PlayerImportPassWord ->
{
	string passWord;
	int passWordType;
};

//����ֿ�������
struct PlayerImportPassWordResult <-
{
	int result;
};

struct  GS2U_UpdatePlayerGuildInfo<-
{
	int64	player_id;
	int64	guild_id;
	string	guild_name;
	int8		guild_rank;
};

struct U2GS_RequestBazzarItemPrice->
{
	int	item_id;
};

struct U2GS_RequestBazzarItemPrice_Result<-
{
	vector<BazzarItem> item;
};

//Ԫ������仯����
struct RequestChangeGoldPassWord ->
{
	string  oldGoldPassWord;
	string  newGoldPassWord;
	int status ;
};

//Ԫ������仯���
struct PlayerGoldPassWordChanged <-
{
	int	result; 	
};
//����Ԫ��������
struct PlayerImportGoldPassWordResult <-
{
	int result;
};
//����ǿ�ƽ�����ʣ��ʱ��
struct PlayerGoldUnlockTimesChanged <-
{
	int	unlockTimes;
};

struct GS2U_LeftSmallMonsterNumber <-
{
	int16 leftMonsterNum;
};

//VIP��Ϣ
struct GS2U_VipInfo <-
{
	int vipLevel;
	int vipTime;
	int vipTimeExpire;
	int vipTimeBuy;
};

//������ң���ǰ������ǵڼ���
struct GS2U_TellMapLineID <-
{
	int8 iLineID;
};

//�����Զ���̵꣬VIP���
struct VIPPlayerOpenVIPStoreRequest ->
{
	int request;
};

struct VIPPlayerOpenVIPStoreFail <-
{
	int fail;
}

//ͬ��VIP�ȼ������
struct UpdateVIPLevelInfo<-
{
	int64	playerID;
	int8		vipLevel;
};

//����������
struct ActiveCodeRequest->
{
	string	active_code;
};

//������������
struct ActiveCodeResult<-
{
	int		result;
};

//�����ս����ľ�������
struct  U2GS_RequestOutFightPetPropetry->
{
	int8	n;
};

//�����ս����ľ�������
struct  GS2U_RequestOutFightPetPropetryResult<-
{
	int64	pet_id;

	int	attack;
	int	defence;
	int	hit;
	int	dodge;
	int	block;
	int	tough;
	int	crit;
	int	crit_damage_rate;
	int	attack_speed;
	int	pierce;
	int	ph_def;
	int	fire_def;
	int	ice_def;
	int	elec_def;
	int	poison_def;
	int	coma_def;
	int	hold_def;
	int	silent_def;
	int	move_def;
	int	max_life;
};


//�������ҡ���ƶ�
struct	PlayerDirMove->
{
	int16	pos_x;
	int16	pos_y;
	int8		dir;
}

//���ҡ���ƶ�
struct	PlayerDirMove_S2C<-
{
	int64	player_id;
	int16	pos_x;
	int16	pos_y;
	int8		dir;
};

//����Э��
struct  U2GS_EnRollCampusBattle->
{
	int64 npcID;//������npc id
	int16 battleID;//������ս��ID
};

struct GSWithU_GameSetMenu_3 <->
{
	int8 joinTeamOnoff;
	int8 inviteGuildOnoff;
	int8 tradeOnoff;
	int8 applicateFriendOnoff;
	int8 singleKeyOperateOnoff;
	int8 musicPercent;
	int8 soundEffectPercent;
	int8 shieldEnermyCampPlayer;
	int8 shieldSelfCampPlayer;
	int8 shieldOthersPet;
	int8 shieldOthersName;
	int8 shieldSkillEffect;
	int8 dispPlayerLimit;
	int8 shieldOthersSoundEff;
	int8 noAttackGuildMate;
	int8 reserve1;
	int8 reserve2;
};

//�ϳ����
struct StartCompound->
{
	int makeItemID;
	int8 compounBindedType;
	int8 isUseDoubleRule;
}

//������
struct StartCompoundResult<-
{
	int8 retCode;
};

struct CompoundBaseInfo<-
{
	int exp;
	int level;
	int makeItemID;
};

struct RequestEquipFastUpQuality ->
{
	int equipId;
};

struct	EquipQualityFastUPByTypeBack <-
{
	int result;
};

struct	PlayerTeleportMove->
{
	int16	pos_x;
	int16	pos_y;
};

struct	PlayerTeleportMove_S2C<-
{
	int64	player_id;
	int16	pos_x;
	int16	pos_y;
};


//�����뿪����
struct  U2GS_leaveCampusBattle->
{
	int8 unUsed;//ûɶ��Ч����
};

//�����뿪ս��
struct  U2GS_LeaveBattleScene->
{
	int8 unUsed;//ûɶ��Ч����
};

struct  battleResult
{
	string name;//����
	int8 campus;//��Ӫ
	int16 killPlayerNum;//��ɱ��
	int16 beenKiiledNum;//����ɱ���� 
	int64 playerID;
	int harm;
	int harmed;
};

//ս�����㣬������ɱ��Ϣ
struct	BattleResultList<- 
{
	vector<battleResult>	resultList;
};

//�����Ľ��
struct	GS2U_BattleEnrollResult<- 
{
	int8 enrollResult;//�������
	int16 mapDataID;
};

//�ͻ��˸�֪���������Ҫ�������
struct U2GS_requestEnrollInfo->
{
	int8 unUsed;//ûɶ��Ч����
};

//��֪�ͻ��˱�������
struct GS2U_sendEnrollInfo <- 
{
	int16 enrollxuanzong;//�������
	int16 enrolltianji;//�������
};

//��֪�ͻ��ˣ�������ڿ��Խ���ս����
struct GS2U_NowCanEnterBattle <- 
{
	int16 battleID;
};

//��ҵ�ȷ�Ͻ���ս��
struct U2GS_SureEnterBattle->
{
	int8 unUsed;//ûɶ��Ч����
};

//�����ͼ���
struct GS2U_EnterBattleResult<-
{
	int8 faileReason;//����ʧ��ԭ��
};

//ս������
struct GS2U_BattleScore<-
{
	int16 xuanzongScore;
	int16 tianjiScore;
};

//����ս��������ɱ�����
struct U2GS_RequestBattleResultList->
{
	int8 unUsed;//ûɶ��Ч����
};


//ս������
struct GS2U_BattleEnd<-
{
	int8 unUsed;//ûɶ��Ч����
};

//ս��ʣ�࿪��ʱ��
struct GS2U_LeftOpenTime<-
{
	int leftOpenTime;
};

//���������أ����������ӳ�
struct  GS2U_HeartBeatAck<-
{
};
