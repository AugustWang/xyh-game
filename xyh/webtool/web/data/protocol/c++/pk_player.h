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

struct CharProperty
{
    int attack;
    int defence;
    int ph_def;
    int fire_def;
    int ice_def;
    int elec_def;
    int poison_def;
    int max_life;
    int life_recover;
    int been_attack_recover;
    int damage_recover;
    int coma_def;
    int hold_def;
    int silent_def;
    int move_def;
    int hit;
    int dodge;
    int block;
    int crit;
    int pierce;
    int attack_speed;
    int tough;
    int crit_damage_rate;
    int block_dec_damage;
    int phy_attack_rate;
    int fire_attack_rate;
    int ice_attack_rate;
    int elec_attack_rate;
    int poison_attack_rate;
    int phy_def_rate;
    int fire_def_rate;
    int ice_def_rate;
    int elec_def_rate;
    int poison_def_rate;
    int treat_rate;
    int on_treat_rate;
    int move_speed;
};
void WriteCharProperty(char*& buf,CharProperty& value);
void ReadCharProperty(char*& buf,CharProperty& value);

struct ObjectBuff
{
    int16 buff_id;
    int16 allValidTime;
    int8 remainTriggerCount;
};
void WriteObjectBuff(char*& buf,ObjectBuff& value);
void ReadObjectBuff(char*& buf,ObjectBuff& value);

struct PlayerBaseInfo
{
    int64 id;
    string name;
    int16 x;
    int16 y;
    int8 sex;
    int8 face;
    int8 weapon;
    int16 level;
    int8 camp;
    int8 faction;
    int8 vip;
    int16 maxEnabledBagCells;
    int16 maxEnabledStorageBagCells;
    string storageBagPassWord;
    int unlockTimes;
    int money;
    int moneyBinded;
    int gold;
    int goldBinded;
    int rechargeAmmount;
    int ticket;
    int guildContribute;
    int honor;
    int credit;
    int exp;
    int bloodPool;
    int petBloodPool;
    int life;
    int lifeMax;
    int64 guildID;
    int mountDataID;
    int pK_Kill_RemainTime;
    int exp15Add;
    int exp20Add;
    int exp30Add;
    int pk_Kill_Value;
    int8 pkFlags;
    int8 minEquipLevel;
    string guild_name;
    int8 guild_rank;
    string goldPassWord;
};
void WritePlayerBaseInfo(char*& buf,PlayerBaseInfo& value);
void OnPlayerBaseInfo(PlayerBaseInfo* value);
void ReadPlayerBaseInfo(char*& buf,PlayerBaseInfo& value);

struct rideInfo
{
    int mountDataID;
    int rideFlage;
};
void WriterideInfo(char*& buf,rideInfo& value);
void ReadrideInfo(char*& buf,rideInfo& value);

struct LookInfoPlayer
{
    int64 id;
    string name;
    int8 lifePercent;
    int16 x;
    int16 y;
    int16 move_target_x;
    int16 move_target_y;
    int8 move_dir;
    int16 move_speed;
    int16 level;
    int value_flags;
    int charState;
    int16 weapon;
    int16 coat;
    vector<ObjectBuff> buffList;
    int8 convoyFlags;
    int64 guild_id;
    string guild_name;
    int8 guild_rank;
    int8 vip;
};
void WriteLookInfoPlayer(char*& buf,LookInfoPlayer& value);
void ReadLookInfoPlayer(char*& buf,LookInfoPlayer& value);

struct LookInfoPlayerList
{
    vector<LookInfoPlayer> info_list;
};
void WriteLookInfoPlayerList(char*& buf,LookInfoPlayerList& value);
void OnLookInfoPlayerList(LookInfoPlayerList* value);
void ReadLookInfoPlayerList(char*& buf,LookInfoPlayerList& value);

struct LookInfoPet
{
    int64 id;
    int64 masterId;
    int16 data_id;
    string name;
    int16 titleid;
    int16 modelId;
    int8 lifePercent;
    int16 level;
    int16 x;
    int16 y;
    int16 move_target_x;
    int16 move_target_y;
    int16 move_speed;
    int charState;
    vector<ObjectBuff> buffList;
};
void WriteLookInfoPet(char*& buf,LookInfoPet& value);
void ReadLookInfoPet(char*& buf,LookInfoPet& value);

struct LookInfoPetList
{
    vector<LookInfoPet> info_list;
};
void WriteLookInfoPetList(char*& buf,LookInfoPetList& value);
void OnLookInfoPetList(LookInfoPetList* value);
void ReadLookInfoPetList(char*& buf,LookInfoPetList& value);

struct LookInfoMonster
{
    int64 id;
    int16 move_target_x;
    int16 move_target_y;
    int16 move_speed;
    int16 x;
    int16 y;
    int16 monster_data_id;
    int8 lifePercent;
    int8 faction;
    int charState;
    vector<ObjectBuff> buffList;
};
void WriteLookInfoMonster(char*& buf,LookInfoMonster& value);
void ReadLookInfoMonster(char*& buf,LookInfoMonster& value);

struct LookInfoMonsterList
{
    vector<LookInfoMonster> info_list;
};
void WriteLookInfoMonsterList(char*& buf,LookInfoMonsterList& value);
void OnLookInfoMonsterList(LookInfoMonsterList* value);
void ReadLookInfoMonsterList(char*& buf,LookInfoMonsterList& value);

struct LookInfoNpc
{
    int64 id;
    int16 x;
    int16 y;
    int16 npc_data_id;
    int16 move_target_x;
    int16 move_target_y;
};
void WriteLookInfoNpc(char*& buf,LookInfoNpc& value);
void ReadLookInfoNpc(char*& buf,LookInfoNpc& value);

struct LookInfoNpcList
{
    vector<LookInfoNpc> info_list;
};
void WriteLookInfoNpcList(char*& buf,LookInfoNpcList& value);
void OnLookInfoNpcList(LookInfoNpcList* value);
void ReadLookInfoNpcList(char*& buf,LookInfoNpcList& value);

struct LookInfoObject
{
    int64 id;
    int16 x;
    int16 y;
    int16 object_data_id;
    int16 object_type;
    int param;
};
void WriteLookInfoObject(char*& buf,LookInfoObject& value);
void ReadLookInfoObject(char*& buf,LookInfoObject& value);

struct LookInfoObjectList
{
    vector<LookInfoObject> info_list;
};
void WriteLookInfoObjectList(char*& buf,LookInfoObjectList& value);
void OnLookInfoObjectList(LookInfoObjectList* value);
void ReadLookInfoObjectList(char*& buf,LookInfoObjectList& value);

struct ActorDisapearList
{
    vector<int64> info_list;
};
void WriteActorDisapearList(char*& buf,ActorDisapearList& value);
void OnActorDisapearList(ActorDisapearList* value);
void ReadActorDisapearList(char*& buf,ActorDisapearList& value);

struct PosInfo
{
    int16 x;
    int16 y;
};
void WritePosInfo(char*& buf,PosInfo& value);
void ReadPosInfo(char*& buf,PosInfo& value);

struct PlayerMoveTo
{
    int16 posX;
    int16 posY;
    vector<PosInfo> posInfos;
	void Send();
};
void WritePlayerMoveTo(char*& buf,PlayerMoveTo& value);
void ReadPlayerMoveTo(char*& buf,PlayerMoveTo& value);

struct PlayerStopMove
{
    int16 posX;
    int16 posY;
	void Send();
};
void WritePlayerStopMove(char*& buf,PlayerStopMove& value);
void ReadPlayerStopMove(char*& buf,PlayerStopMove& value);

struct PlayerStopMove_S2C
{
    int64 id;
    int16 posX;
    int16 posY;
};
void WritePlayerStopMove_S2C(char*& buf,PlayerStopMove_S2C& value);
void OnPlayerStopMove_S2C(PlayerStopMove_S2C* value);
void ReadPlayerStopMove_S2C(char*& buf,PlayerStopMove_S2C& value);

struct MoveInfo
{
    int64 id;
    int16 posX;
    int16 posY;
    vector<PosInfo> posInfos;
};
void WriteMoveInfo(char*& buf,MoveInfo& value);
void ReadMoveInfo(char*& buf,MoveInfo& value);

struct PlayerMoveInfo
{
    vector<MoveInfo> ids;
};
void WritePlayerMoveInfo(char*& buf,PlayerMoveInfo& value);
void OnPlayerMoveInfo(PlayerMoveInfo* value);
void ReadPlayerMoveInfo(char*& buf,PlayerMoveInfo& value);

struct ChangeFlyState
{
    int flyState;
	void Send();
};
void WriteChangeFlyState(char*& buf,ChangeFlyState& value);
void ReadChangeFlyState(char*& buf,ChangeFlyState& value);

struct ChangeFlyState_S2C
{
    int64 id;
    int flyState;
};
void WriteChangeFlyState_S2C(char*& buf,ChangeFlyState_S2C& value);
void OnChangeFlyState_S2C(ChangeFlyState_S2C* value);
void ReadChangeFlyState_S2C(char*& buf,ChangeFlyState_S2C& value);

struct MonsterMoveInfo
{
    vector<MoveInfo> ids;
};
void WriteMonsterMoveInfo(char*& buf,MonsterMoveInfo& value);
void OnMonsterMoveInfo(MonsterMoveInfo* value);
void ReadMonsterMoveInfo(char*& buf,MonsterMoveInfo& value);

struct MonsterStopMove
{
    int64 id;
    int16 x;
    int16 y;
};
void WriteMonsterStopMove(char*& buf,MonsterStopMove& value);
void OnMonsterStopMove(MonsterStopMove* value);
void ReadMonsterStopMove(char*& buf,MonsterStopMove& value);

struct PetMoveInfo
{
    vector<MoveInfo> ids;
};
void WritePetMoveInfo(char*& buf,PetMoveInfo& value);
void OnPetMoveInfo(PetMoveInfo* value);
void ReadPetMoveInfo(char*& buf,PetMoveInfo& value);

struct PetStopMove
{
    int64 id;
    int16 x;
    int16 y;
};
void WritePetStopMove(char*& buf,PetStopMove& value);
void OnPetStopMove(PetStopMove* value);
void ReadPetStopMove(char*& buf,PetStopMove& value);

struct ChangeMap
{
    int mapDataID;
    int64 mapId;
    int16 x;
    int16 y;
	void Send();
};
void WriteChangeMap(char*& buf,ChangeMap& value);
void OnChangeMap(ChangeMap* value);
void ReadChangeMap(char*& buf,ChangeMap& value);

struct CollectFail
{
};
void WriteCollectFail(char*& buf,CollectFail& value);
void OnCollectFail(CollectFail* value);
void ReadCollectFail(char*& buf,CollectFail& value);

struct RequestGM
{
    string strCMD;
	void Send();
};
void WriteRequestGM(char*& buf,RequestGM& value);
void ReadRequestGM(char*& buf,RequestGM& value);

struct PlayerPropertyChangeValue
{
    int8 proType;
    int value;
};
void WritePlayerPropertyChangeValue(char*& buf,PlayerPropertyChangeValue& value);
void ReadPlayerPropertyChangeValue(char*& buf,PlayerPropertyChangeValue& value);

struct PlayerPropertyChanged
{
    vector<PlayerPropertyChangeValue> changeValues;
};
void WritePlayerPropertyChanged(char*& buf,PlayerPropertyChanged& value);
void OnPlayerPropertyChanged(PlayerPropertyChanged* value);
void ReadPlayerPropertyChanged(char*& buf,PlayerPropertyChanged& value);

struct PlayerMoneyChanged
{
    int8 changeReson;
    int8 moneyType;
    int moneyValue;
};
void WritePlayerMoneyChanged(char*& buf,PlayerMoneyChanged& value);
void OnPlayerMoneyChanged(PlayerMoneyChanged* value);
void ReadPlayerMoneyChanged(char*& buf,PlayerMoneyChanged& value);

struct PlayerKickOuted
{
    int reserve;
};
void WritePlayerKickOuted(char*& buf,PlayerKickOuted& value);
void OnPlayerKickOuted(PlayerKickOuted* value);
void ReadPlayerKickOuted(char*& buf,PlayerKickOuted& value);

struct ActorStateFlagSet
{
    int nSetStateFlag;
};
void WriteActorStateFlagSet(char*& buf,ActorStateFlagSet& value);
void OnActorStateFlagSet(ActorStateFlagSet* value);
void ReadActorStateFlagSet(char*& buf,ActorStateFlagSet& value);

struct ActorStateFlagSet_Broad
{
    int64 nActorID;
    int nSetStateFlag;
};
void WriteActorStateFlagSet_Broad(char*& buf,ActorStateFlagSet_Broad& value);
void OnActorStateFlagSet_Broad(ActorStateFlagSet_Broad* value);
void ReadActorStateFlagSet_Broad(char*& buf,ActorStateFlagSet_Broad& value);

struct PlayerSkillInitData
{
    int16 nSkillID;
    int nCD;
    int16 nActiveBranch1;
    int16 nActiveBranch2;
    int16 nBindedBranch;
};
void WritePlayerSkillInitData(char*& buf,PlayerSkillInitData& value);
void ReadPlayerSkillInitData(char*& buf,PlayerSkillInitData& value);

struct PlayerSkillInitInfo
{
    vector<PlayerSkillInitData> info_list;
};
void WritePlayerSkillInitInfo(char*& buf,PlayerSkillInitInfo& value);
void OnPlayerSkillInitInfo(PlayerSkillInitInfo* value);
void ReadPlayerSkillInitInfo(char*& buf,PlayerSkillInitInfo& value);

struct U2GS_StudySkill
{
    int nSkillID;
	void Send();
};
void WriteU2GS_StudySkill(char*& buf,U2GS_StudySkill& value);
void ReadU2GS_StudySkill(char*& buf,U2GS_StudySkill& value);

struct GS2U_StudySkillResult
{
    int nSkillID;
    int nResult;
};
void WriteGS2U_StudySkillResult(char*& buf,GS2U_StudySkillResult& value);
void OnGS2U_StudySkillResult(GS2U_StudySkillResult* value);
void ReadGS2U_StudySkillResult(char*& buf,GS2U_StudySkillResult& value);

struct activeBranchID
{
    int8 nWhichBranch;
    int nSkillID;
    int branchID;
	void Send();
};
void WriteactiveBranchID(char*& buf,activeBranchID& value);
void ReadactiveBranchID(char*& buf,activeBranchID& value);

struct activeBranchIDResult
{
    int result;
    int nSkillID;
    int branckID;
};
void WriteactiveBranchIDResult(char*& buf,activeBranchIDResult& value);
void OnactiveBranchIDResult(activeBranchIDResult* value);
void ReadactiveBranchIDResult(char*& buf,activeBranchIDResult& value);

struct U2GS_AddSkillBranch
{
    int nSkillID;
    int nBranchID;
	void Send();
};
void WriteU2GS_AddSkillBranch(char*& buf,U2GS_AddSkillBranch& value);
void ReadU2GS_AddSkillBranch(char*& buf,U2GS_AddSkillBranch& value);

struct GS2U_AddSkillBranchAck
{
    int result;
    int nSkillID;
    int nBranchID;
};
void WriteGS2U_AddSkillBranchAck(char*& buf,GS2U_AddSkillBranchAck& value);
void OnGS2U_AddSkillBranchAck(GS2U_AddSkillBranchAck* value);
void ReadGS2U_AddSkillBranchAck(char*& buf,GS2U_AddSkillBranchAck& value);

struct U2GS_UseSkillRequest
{
    int nSkillID;
    vector<int64> nTargetIDList;
    int nCombatID;
	void Send();
};
void WriteU2GS_UseSkillRequest(char*& buf,U2GS_UseSkillRequest& value);
void ReadU2GS_UseSkillRequest(char*& buf,U2GS_UseSkillRequest& value);

struct GS2U_UseSkillToObject
{
    int64 nUserActorID;
    int16 nSkillID;
    vector<int64> nTargetActorIDList;
    int nCombatID;
};
void WriteGS2U_UseSkillToObject(char*& buf,GS2U_UseSkillToObject& value);
void OnGS2U_UseSkillToObject(GS2U_UseSkillToObject* value);
void ReadGS2U_UseSkillToObject(char*& buf,GS2U_UseSkillToObject& value);

struct GS2U_UseSkillToPos
{
    int64 nUserActorID;
    int16 nSkillID;
    int16 x;
    int16 y;
    int nCombatID;
    vector<int64> id_list;
};
void WriteGS2U_UseSkillToPos(char*& buf,GS2U_UseSkillToPos& value);
void OnGS2U_UseSkillToPos(GS2U_UseSkillToPos* value);
void ReadGS2U_UseSkillToPos(char*& buf,GS2U_UseSkillToPos& value);

struct GS2U_AttackDamage
{
    int64 nDamageTarget;
    int nCombatID;
    int16 nSkillID;
    int nDamageLife;
    int8 nTargetLifePer100;
    int8 isBlocked;
    int8 isCrited;
};
void WriteGS2U_AttackDamage(char*& buf,GS2U_AttackDamage& value);
void OnGS2U_AttackDamage(GS2U_AttackDamage* value);
void ReadGS2U_AttackDamage(char*& buf,GS2U_AttackDamage& value);

struct GS2U_CharactorDead
{
    int64 nDeadActorID;
    int64 nKiller;
    int nCombatNumber;
};
void WriteGS2U_CharactorDead(char*& buf,GS2U_CharactorDead& value);
void OnGS2U_CharactorDead(GS2U_CharactorDead* value);
void ReadGS2U_CharactorDead(char*& buf,GS2U_CharactorDead& value);

struct GS2U_AttackMiss
{
    int64 nActorID;
    int64 nTargetID;
    int nCombatID;
};
void WriteGS2U_AttackMiss(char*& buf,GS2U_AttackMiss& value);
void OnGS2U_AttackMiss(GS2U_AttackMiss* value);
void ReadGS2U_AttackMiss(char*& buf,GS2U_AttackMiss& value);

struct GS2U_AttackDodge
{
    int64 nActorID;
    int64 nTargetID;
    int nCombatID;
};
void WriteGS2U_AttackDodge(char*& buf,GS2U_AttackDodge& value);
void OnGS2U_AttackDodge(GS2U_AttackDodge* value);
void ReadGS2U_AttackDodge(char*& buf,GS2U_AttackDodge& value);

struct GS2U_AttackCrit
{
    int64 nActorID;
    int nCombatID;
};
void WriteGS2U_AttackCrit(char*& buf,GS2U_AttackCrit& value);
void OnGS2U_AttackCrit(GS2U_AttackCrit* value);
void ReadGS2U_AttackCrit(char*& buf,GS2U_AttackCrit& value);

struct GS2U_AttackBlock
{
    int64 nActorID;
    int nCombatID;
};
void WriteGS2U_AttackBlock(char*& buf,GS2U_AttackBlock& value);
void OnGS2U_AttackBlock(GS2U_AttackBlock* value);
void ReadGS2U_AttackBlock(char*& buf,GS2U_AttackBlock& value);

struct PlayerAllShortcut
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
void WritePlayerAllShortcut(char*& buf,PlayerAllShortcut& value);
void OnPlayerAllShortcut(PlayerAllShortcut* value);
void ReadPlayerAllShortcut(char*& buf,PlayerAllShortcut& value);

struct ShortcutSet
{
    int8 index;
    int data;
	void Send();
};
void WriteShortcutSet(char*& buf,ShortcutSet& value);
void ReadShortcutSet(char*& buf,ShortcutSet& value);

struct PlayerEXPChanged
{
    int curEXP;
    int8 changeReson;
};
void WritePlayerEXPChanged(char*& buf,PlayerEXPChanged& value);
void OnPlayerEXPChanged(PlayerEXPChanged* value);
void ReadPlayerEXPChanged(char*& buf,PlayerEXPChanged& value);

struct ActorLifeUpdate
{
    int64 nActorID;
    int nLife;
    int nMaxLife;
};
void WriteActorLifeUpdate(char*& buf,ActorLifeUpdate& value);
void OnActorLifeUpdate(ActorLifeUpdate* value);
void ReadActorLifeUpdate(char*& buf,ActorLifeUpdate& value);

struct ActorMoveSpeedUpdate
{
    int64 nActorID;
    int nSpeed;
};
void WriteActorMoveSpeedUpdate(char*& buf,ActorMoveSpeedUpdate& value);
void OnActorMoveSpeedUpdate(ActorMoveSpeedUpdate* value);
void ReadActorMoveSpeedUpdate(char*& buf,ActorMoveSpeedUpdate& value);

struct PlayerCombatIDInit
{
    int nBeginCombatID;
};
void WritePlayerCombatIDInit(char*& buf,PlayerCombatIDInit& value);
void OnPlayerCombatIDInit(PlayerCombatIDInit* value);
void ReadPlayerCombatIDInit(char*& buf,PlayerCombatIDInit& value);

struct GS2U_CharactorRevived
{
    int64 nActorID;
    int nLife;
    int nMaxLife;
};
void WriteGS2U_CharactorRevived(char*& buf,GS2U_CharactorRevived& value);
void OnGS2U_CharactorRevived(GS2U_CharactorRevived* value);
void ReadGS2U_CharactorRevived(char*& buf,GS2U_CharactorRevived& value);

struct U2GS_InteractObject
{
    int64 nActorID;
	void Send();
};
void WriteU2GS_InteractObject(char*& buf,U2GS_InteractObject& value);
void ReadU2GS_InteractObject(char*& buf,U2GS_InteractObject& value);

struct U2GS_QueryHeroProperty
{
    int8 nReserve;
	void Send();
};
void WriteU2GS_QueryHeroProperty(char*& buf,U2GS_QueryHeroProperty& value);
void ReadU2GS_QueryHeroProperty(char*& buf,U2GS_QueryHeroProperty& value);

struct CharPropertyData
{
    int8 nPropertyType;
    int nValue;
};
void WriteCharPropertyData(char*& buf,CharPropertyData& value);
void ReadCharPropertyData(char*& buf,CharPropertyData& value);

struct GS2U_HeroPropertyResult
{
    vector<CharPropertyData> info_list;
};
void WriteGS2U_HeroPropertyResult(char*& buf,GS2U_HeroPropertyResult& value);
void OnGS2U_HeroPropertyResult(GS2U_HeroPropertyResult* value);
void ReadGS2U_HeroPropertyResult(char*& buf,GS2U_HeroPropertyResult& value);

struct ItemInfo
{
    int64 id;
    int8 owner_type;
    int64 owner_id;
    int8 location;
    int16 cell;
    int amount;
    int item_data_id;
    int param1;
    int param2;
    int8 binded;
    int remain_time;
};
void WriteItemInfo(char*& buf,ItemInfo& value);
void ReadItemInfo(char*& buf,ItemInfo& value);

struct PlayerBagInit
{
    vector<ItemInfo> items;
};
void WritePlayerBagInit(char*& buf,PlayerBagInit& value);
void OnPlayerBagInit(PlayerBagInit* value);
void ReadPlayerBagInit(char*& buf,PlayerBagInit& value);

struct PlayerGetItem
{
    ItemInfo item_info;
};
void WritePlayerGetItem(char*& buf,PlayerGetItem& value);
void OnPlayerGetItem(PlayerGetItem* value);
void ReadPlayerGetItem(char*& buf,PlayerGetItem& value);

struct PlayerDestroyItem
{
    int64 itemDBID;
    int8 reson;
};
void WritePlayerDestroyItem(char*& buf,PlayerDestroyItem& value);
void OnPlayerDestroyItem(PlayerDestroyItem* value);
void ReadPlayerDestroyItem(char*& buf,PlayerDestroyItem& value);

struct PlayerItemLocationCellChanged
{
    int64 itemDBID;
    int8 location;
    int16 cell;
};
void WritePlayerItemLocationCellChanged(char*& buf,PlayerItemLocationCellChanged& value);
void OnPlayerItemLocationCellChanged(PlayerItemLocationCellChanged* value);
void ReadPlayerItemLocationCellChanged(char*& buf,PlayerItemLocationCellChanged& value);

struct RequestDestroyItem
{
    int64 itemDBID;
	void Send();
};
void WriteRequestDestroyItem(char*& buf,RequestDestroyItem& value);
void ReadRequestDestroyItem(char*& buf,RequestDestroyItem& value);

struct RequestGetItem
{
    int itemDataID;
    int amount;
	void Send();
};
void WriteRequestGetItem(char*& buf,RequestGetItem& value);
void ReadRequestGetItem(char*& buf,RequestGetItem& value);

struct PlayerItemAmountChanged
{
    int64 itemDBID;
    int amount;
    int reson;
};
void WritePlayerItemAmountChanged(char*& buf,PlayerItemAmountChanged& value);
void OnPlayerItemAmountChanged(PlayerItemAmountChanged* value);
void ReadPlayerItemAmountChanged(char*& buf,PlayerItemAmountChanged& value);

struct PlayerItemParamChanged
{
    int64 itemDBID;
    int param1;
    int param2;
    int reson;
};
void WritePlayerItemParamChanged(char*& buf,PlayerItemParamChanged& value);
void OnPlayerItemParamChanged(PlayerItemParamChanged* value);
void ReadPlayerItemParamChanged(char*& buf,PlayerItemParamChanged& value);

struct PlayerBagOrderData
{
    int64 itemDBID;
    int amount;
    int cell;
};
void WritePlayerBagOrderData(char*& buf,PlayerBagOrderData& value);
void ReadPlayerBagOrderData(char*& buf,PlayerBagOrderData& value);

struct RequestPlayerBagOrder
{
    int location;
	void Send();
};
void WriteRequestPlayerBagOrder(char*& buf,RequestPlayerBagOrder& value);
void ReadRequestPlayerBagOrder(char*& buf,RequestPlayerBagOrder& value);

struct PlayerBagOrderResult
{
    int location;
    int cell;
};
void WritePlayerBagOrderResult(char*& buf,PlayerBagOrderResult& value);
void OnPlayerBagOrderResult(PlayerBagOrderResult* value);
void ReadPlayerBagOrderResult(char*& buf,PlayerBagOrderResult& value);

struct PlayerRequestUseItem
{
    int16 location;
    int16 cell;
    int16 useCount;
	void Send();
};
void WritePlayerRequestUseItem(char*& buf,PlayerRequestUseItem& value);
void ReadPlayerRequestUseItem(char*& buf,PlayerRequestUseItem& value);

struct PlayerUseItemResult
{
    int16 location;
    int16 cell;
    int result;
};
void WritePlayerUseItemResult(char*& buf,PlayerUseItemResult& value);
void OnPlayerUseItemResult(PlayerUseItemResult* value);
void ReadPlayerUseItemResult(char*& buf,PlayerUseItemResult& value);

struct RequestPlayerBagCellOpen
{
    int cell;
    int location;
	void Send();
};
void WriteRequestPlayerBagCellOpen(char*& buf,RequestPlayerBagCellOpen& value);
void ReadRequestPlayerBagCellOpen(char*& buf,RequestPlayerBagCellOpen& value);

struct RequestChangeStorageBagPassWord
{
    string oldStorageBagPassWord;
    string newStorageBagPassWord;
    int status;
	void Send();
};
void WriteRequestChangeStorageBagPassWord(char*& buf,RequestChangeStorageBagPassWord& value);
void ReadRequestChangeStorageBagPassWord(char*& buf,RequestChangeStorageBagPassWord& value);

struct PlayerStorageBagPassWordChanged
{
    int result;
};
void WritePlayerStorageBagPassWordChanged(char*& buf,PlayerStorageBagPassWordChanged& value);
void OnPlayerStorageBagPassWordChanged(PlayerStorageBagPassWordChanged* value);
void ReadPlayerStorageBagPassWordChanged(char*& buf,PlayerStorageBagPassWordChanged& value);

struct PlayerBagCellEnableChanged
{
    int cell;
    int location;
    int gold;
    int item_count;
};
void WritePlayerBagCellEnableChanged(char*& buf,PlayerBagCellEnableChanged& value);
void OnPlayerBagCellEnableChanged(PlayerBagCellEnableChanged* value);
void ReadPlayerBagCellEnableChanged(char*& buf,PlayerBagCellEnableChanged& value);

struct RequestPlayerBagSellItem
{
    int cell;
	void Send();
};
void WriteRequestPlayerBagSellItem(char*& buf,RequestPlayerBagSellItem& value);
void ReadRequestPlayerBagSellItem(char*& buf,RequestPlayerBagSellItem& value);

struct RequestClearTempBag
{
    int reserve;
	void Send();
};
void WriteRequestClearTempBag(char*& buf,RequestClearTempBag& value);
void ReadRequestClearTempBag(char*& buf,RequestClearTempBag& value);

struct RequestMoveTempBagItem
{
    int cell;
	void Send();
};
void WriteRequestMoveTempBagItem(char*& buf,RequestMoveTempBagItem& value);
void ReadRequestMoveTempBagItem(char*& buf,RequestMoveTempBagItem& value);

struct RequestMoveAllTempBagItem
{
    int reserve;
	void Send();
};
void WriteRequestMoveAllTempBagItem(char*& buf,RequestMoveAllTempBagItem& value);
void ReadRequestMoveAllTempBagItem(char*& buf,RequestMoveAllTempBagItem& value);

struct RequestMoveStorageBagItem
{
    int cell;
	void Send();
};
void WriteRequestMoveStorageBagItem(char*& buf,RequestMoveStorageBagItem& value);
void ReadRequestMoveStorageBagItem(char*& buf,RequestMoveStorageBagItem& value);

struct RequestMoveBagItemToStorage
{
    int cell;
	void Send();
};
void WriteRequestMoveBagItemToStorage(char*& buf,RequestMoveBagItemToStorage& value);
void ReadRequestMoveBagItemToStorage(char*& buf,RequestMoveBagItemToStorage& value);

struct RequestUnlockingStorageBagPassWord
{
    int passWordType;
	void Send();
};
void WriteRequestUnlockingStorageBagPassWord(char*& buf,RequestUnlockingStorageBagPassWord& value);
void ReadRequestUnlockingStorageBagPassWord(char*& buf,RequestUnlockingStorageBagPassWord& value);

struct RequestCancelUnlockingStorageBagPassWord
{
    int passWordType;
	void Send();
};
void WriteRequestCancelUnlockingStorageBagPassWord(char*& buf,RequestCancelUnlockingStorageBagPassWord& value);
void ReadRequestCancelUnlockingStorageBagPassWord(char*& buf,RequestCancelUnlockingStorageBagPassWord& value);

struct PlayerUnlockTimesChanged
{
    int unlockTimes;
};
void WritePlayerUnlockTimesChanged(char*& buf,PlayerUnlockTimesChanged& value);
void OnPlayerUnlockTimesChanged(PlayerUnlockTimesChanged* value);
void ReadPlayerUnlockTimesChanged(char*& buf,PlayerUnlockTimesChanged& value);

struct ItemBagCellSetData
{
    int location;
    int cell;
    int64 itemDBID;
};
void WriteItemBagCellSetData(char*& buf,ItemBagCellSetData& value);
void ReadItemBagCellSetData(char*& buf,ItemBagCellSetData& value);

struct ItemBagCellSet
{
    vector<ItemBagCellSetData> cells;
};
void WriteItemBagCellSet(char*& buf,ItemBagCellSet& value);
void OnItemBagCellSet(ItemBagCellSet* value);
void ReadItemBagCellSet(char*& buf,ItemBagCellSet& value);

struct NpcStoreItemData
{
    int64 id;
    int item_id;
    int price;
    int isbind;
};
void WriteNpcStoreItemData(char*& buf,NpcStoreItemData& value);
void ReadNpcStoreItemData(char*& buf,NpcStoreItemData& value);

struct RequestGetNpcStoreItemList
{
    int store_id;
	void Send();
};
void WriteRequestGetNpcStoreItemList(char*& buf,RequestGetNpcStoreItemList& value);
void ReadRequestGetNpcStoreItemList(char*& buf,RequestGetNpcStoreItemList& value);

struct GetNpcStoreItemListAck
{
    int store_id;
    vector<NpcStoreItemData> itemList;
};
void WriteGetNpcStoreItemListAck(char*& buf,GetNpcStoreItemListAck& value);
void OnGetNpcStoreItemListAck(GetNpcStoreItemListAck* value);
void ReadGetNpcStoreItemListAck(char*& buf,GetNpcStoreItemListAck& value);

struct RequestBuyItem
{
    int item_id;
    int amount;
    int store_id;
	void Send();
};
void WriteRequestBuyItem(char*& buf,RequestBuyItem& value);
void ReadRequestBuyItem(char*& buf,RequestBuyItem& value);

struct BuyItemAck
{
    int count;
};
void WriteBuyItemAck(char*& buf,BuyItemAck& value);
void OnBuyItemAck(BuyItemAck* value);
void ReadBuyItemAck(char*& buf,BuyItemAck& value);

struct RequestSellItem
{
    int64 item_cell;
	void Send();
};
void WriteRequestSellItem(char*& buf,RequestSellItem& value);
void ReadRequestSellItem(char*& buf,RequestSellItem& value);

struct GetNpcStoreBackBuyItemList
{
    int count;
	void Send();
};
void WriteGetNpcStoreBackBuyItemList(char*& buf,GetNpcStoreBackBuyItemList& value);
void ReadGetNpcStoreBackBuyItemList(char*& buf,GetNpcStoreBackBuyItemList& value);

struct GetNpcStoreBackBuyItemListAck
{
    vector<ItemInfo> itemList;
};
void WriteGetNpcStoreBackBuyItemListAck(char*& buf,GetNpcStoreBackBuyItemListAck& value);
void OnGetNpcStoreBackBuyItemListAck(GetNpcStoreBackBuyItemListAck* value);
void ReadGetNpcStoreBackBuyItemListAck(char*& buf,GetNpcStoreBackBuyItemListAck& value);

struct RequestBackBuyItem
{
    int64 item_id;
	void Send();
};
void WriteRequestBackBuyItem(char*& buf,RequestBackBuyItem& value);
void ReadRequestBackBuyItem(char*& buf,RequestBackBuyItem& value);

struct PlayerEquipNetData
{
    int dbID;
    int nEquip;
    int8 type;
    int8 nQuality;
    int8 isEquiped;
    int16 enhanceLevel;
    int8 property1Type;
    int8 property1FixOrPercent;
    int property1Value;
    int8 property2Type;
    int8 property2FixOrPercent;
    int property2Value;
    int8 property3Type;
    int8 property3FixOrPercent;
    int property3Value;
    int8 property4Type;
    int8 property4FixOrPercent;
    int property4Value;
    int8 property5Type;
    int8 property5FixOrPercent;
    int property5Value;
};
void WritePlayerEquipNetData(char*& buf,PlayerEquipNetData& value);
void ReadPlayerEquipNetData(char*& buf,PlayerEquipNetData& value);

struct PlayerEquipInit
{
    vector<PlayerEquipNetData> equips;
};
void WritePlayerEquipInit(char*& buf,PlayerEquipInit& value);
void OnPlayerEquipInit(PlayerEquipInit* value);
void ReadPlayerEquipInit(char*& buf,PlayerEquipInit& value);

struct RequestPlayerEquipActive
{
    int equip_data_id;
	void Send();
};
void WriteRequestPlayerEquipActive(char*& buf,RequestPlayerEquipActive& value);
void ReadRequestPlayerEquipActive(char*& buf,RequestPlayerEquipActive& value);

struct PlayerEquipActiveResult
{
    PlayerEquipNetData equip;
};
void WritePlayerEquipActiveResult(char*& buf,PlayerEquipActiveResult& value);
void OnPlayerEquipActiveResult(PlayerEquipActiveResult* value);
void ReadPlayerEquipActiveResult(char*& buf,PlayerEquipActiveResult& value);

struct RequestPlayerEquipPutOn
{
    int equip_dbID;
	void Send();
};
void WriteRequestPlayerEquipPutOn(char*& buf,RequestPlayerEquipPutOn& value);
void ReadRequestPlayerEquipPutOn(char*& buf,RequestPlayerEquipPutOn& value);

struct PlayerEquipPutOnResult
{
    int equip_dbID;
    int8 equiped;
};
void WritePlayerEquipPutOnResult(char*& buf,PlayerEquipPutOnResult& value);
void OnPlayerEquipPutOnResult(PlayerEquipPutOnResult* value);
void ReadPlayerEquipPutOnResult(char*& buf,PlayerEquipPutOnResult& value);

struct RequestQueryPlayerEquip
{
    int64 playerid;
	void Send();
};
void WriteRequestQueryPlayerEquip(char*& buf,RequestQueryPlayerEquip& value);
void ReadRequestQueryPlayerEquip(char*& buf,RequestQueryPlayerEquip& value);

struct QueryPlayerEquipResult
{
    vector<PlayerEquipNetData> equips;
};
void WriteQueryPlayerEquipResult(char*& buf,QueryPlayerEquipResult& value);
void OnQueryPlayerEquipResult(QueryPlayerEquipResult* value);
void ReadQueryPlayerEquipResult(char*& buf,QueryPlayerEquipResult& value);

struct StudySkill
{
    int id;
    int lvl;
	void Send();
};
void WriteStudySkill(char*& buf,StudySkill& value);
void ReadStudySkill(char*& buf,StudySkill& value);

struct StudyResult
{
    int8 result;
    int id;
    int lvl;
};
void WriteStudyResult(char*& buf,StudyResult& value);
void OnStudyResult(StudyResult* value);
void ReadStudyResult(char*& buf,StudyResult& value);

struct Reborn
{
    int8 type;
	void Send();
};
void WriteReborn(char*& buf,Reborn& value);
void ReadReborn(char*& buf,Reborn& value);

struct RebornAck
{
    int x;
    int y;
};
void WriteRebornAck(char*& buf,RebornAck& value);
void OnRebornAck(RebornAck* value);
void ReadRebornAck(char*& buf,RebornAck& value);

struct Chat2Player
{
    int8 channel;
    int64 sendID;
    int64 receiveID;
    string sendName;
    string receiveName;
    string content;
    int8 vipLevel;
};
void WriteChat2Player(char*& buf,Chat2Player& value);
void OnChat2Player(Chat2Player* value);
void ReadChat2Player(char*& buf,Chat2Player& value);

struct Chat2Server
{
    int8 channel;
    int64 sendID;
    int64 receiveID;
    string sendName;
    string receiveName;
    string content;
	void Send();
};
void WriteChat2Server(char*& buf,Chat2Server& value);
void ReadChat2Server(char*& buf,Chat2Server& value);

struct Chat_Error_Result
{
    int reason;
};
void WriteChat_Error_Result(char*& buf,Chat_Error_Result& value);
void OnChat_Error_Result(Chat_Error_Result* value);
void ReadChat_Error_Result(char*& buf,Chat_Error_Result& value);

struct RequestSendMail
{
    int64 targetPlayerID;
    string targetPlayerName;
    string strTitle;
    string strContent;
    int64 attachItemDBID1;
    int attachItem1Cnt;
    int64 attachItemDBID2;
    int attachItem2Cnt;
    int moneySend;
    int moneyPay;
	void Send();
};
void WriteRequestSendMail(char*& buf,RequestSendMail& value);
void ReadRequestSendMail(char*& buf,RequestSendMail& value);

struct RequestSendMailAck
{
    int8 result;
};
void WriteRequestSendMailAck(char*& buf,RequestSendMailAck& value);
void OnRequestSendMailAck(RequestSendMailAck* value);
void ReadRequestSendMailAck(char*& buf,RequestSendMailAck& value);

struct RequestRecvMail
{
    int64 mailID;
    int deleteMail;
	void Send();
};
void WriteRequestRecvMail(char*& buf,RequestRecvMail& value);
void ReadRequestRecvMail(char*& buf,RequestRecvMail& value);

struct RequestUnReadMail
{
    int64 playerID;
	void Send();
};
void WriteRequestUnReadMail(char*& buf,RequestUnReadMail& value);
void ReadRequestUnReadMail(char*& buf,RequestUnReadMail& value);

struct RequestUnReadMailAck
{
    int unReadCount;
};
void WriteRequestUnReadMailAck(char*& buf,RequestUnReadMailAck& value);
void OnRequestUnReadMailAck(RequestUnReadMailAck* value);
void ReadRequestUnReadMailAck(char*& buf,RequestUnReadMailAck& value);

struct RequestMailList
{
    int64 playerID;
	void Send();
};
void WriteRequestMailList(char*& buf,RequestMailList& value);
void ReadRequestMailList(char*& buf,RequestMailList& value);

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
void WriteMailInfo(char*& buf,MailInfo& value);
void ReadMailInfo(char*& buf,MailInfo& value);

struct RequestMailListAck
{
    vector<MailInfo> mailList;
};
void WriteRequestMailListAck(char*& buf,RequestMailListAck& value);
void OnRequestMailListAck(RequestMailListAck* value);
void ReadRequestMailListAck(char*& buf,RequestMailListAck& value);

struct RequestMailItemInfo
{
    int64 mailID;
	void Send();
};
void WriteRequestMailItemInfo(char*& buf,RequestMailItemInfo& value);
void ReadRequestMailItemInfo(char*& buf,RequestMailItemInfo& value);

struct RequestMailItemInfoAck
{
    int64 mailID;
    vector<ItemInfo> mailItem;
};
void WriteRequestMailItemInfoAck(char*& buf,RequestMailItemInfoAck& value);
void OnRequestMailItemInfoAck(RequestMailItemInfoAck* value);
void ReadRequestMailItemInfoAck(char*& buf,RequestMailItemInfoAck& value);

struct RequestAcceptMailItem
{
    int64 mailID;
    int isDeleteMail;
	void Send();
};
void WriteRequestAcceptMailItem(char*& buf,RequestAcceptMailItem& value);
void ReadRequestAcceptMailItem(char*& buf,RequestAcceptMailItem& value);

struct RequestAcceptMailItemAck
{
    int result;
};
void WriteRequestAcceptMailItemAck(char*& buf,RequestAcceptMailItemAck& value);
void OnRequestAcceptMailItemAck(RequestAcceptMailItemAck* value);
void ReadRequestAcceptMailItemAck(char*& buf,RequestAcceptMailItemAck& value);

struct MailReadNotice
{
    int64 mailID;
	void Send();
};
void WriteMailReadNotice(char*& buf,MailReadNotice& value);
void ReadMailReadNotice(char*& buf,MailReadNotice& value);

struct RequestDeleteMail
{
    int64 mailID;
	void Send();
};
void WriteRequestDeleteMail(char*& buf,RequestDeleteMail& value);
void ReadRequestDeleteMail(char*& buf,RequestDeleteMail& value);

struct InformNewMail
{
};
void WriteInformNewMail(char*& buf,InformNewMail& value);
void OnInformNewMail(InformNewMail* value);
void ReadInformNewMail(char*& buf,InformNewMail& value);

struct RequestDeleteReadMail
{
    vector<int64> readMailID;
	void Send();
};
void WriteRequestDeleteReadMail(char*& buf,RequestDeleteReadMail& value);
void ReadRequestDeleteReadMail(char*& buf,RequestDeleteReadMail& value);

struct RequestSystemMail
{
	void Send();
};
void WriteRequestSystemMail(char*& buf,RequestSystemMail& value);
void ReadRequestSystemMail(char*& buf,RequestSystemMail& value);

struct U2GS_RequestLogin
{
    int64 userID;
    string identity;
    int protocolVer;
	void Send();
};
void WriteU2GS_RequestLogin(char*& buf,U2GS_RequestLogin& value);
void ReadU2GS_RequestLogin(char*& buf,U2GS_RequestLogin& value);

struct U2GS_SelPlayerEnterGame
{
    int64 playerID;
	void Send();
};
void WriteU2GS_SelPlayerEnterGame(char*& buf,U2GS_SelPlayerEnterGame& value);
void ReadU2GS_SelPlayerEnterGame(char*& buf,U2GS_SelPlayerEnterGame& value);

struct U2GS_RequestCreatePlayer
{
    string name;
    int8 camp;
    int8 classValue;
    int8 sex;
	void Send();
};
void WriteU2GS_RequestCreatePlayer(char*& buf,U2GS_RequestCreatePlayer& value);
void ReadU2GS_RequestCreatePlayer(char*& buf,U2GS_RequestCreatePlayer& value);

struct U2GS_RequestDeletePlayer
{
    int64 playerID;
	void Send();
};
void WriteU2GS_RequestDeletePlayer(char*& buf,U2GS_RequestDeletePlayer& value);
void ReadU2GS_RequestDeletePlayer(char*& buf,U2GS_RequestDeletePlayer& value);

struct GS2U_LoginResult
{
    int result;
};
void WriteGS2U_LoginResult(char*& buf,GS2U_LoginResult& value);
void OnGS2U_LoginResult(GS2U_LoginResult* value);
void ReadGS2U_LoginResult(char*& buf,GS2U_LoginResult& value);

struct GS2U_SelPlayerResult
{
    int result;
};
void WriteGS2U_SelPlayerResult(char*& buf,GS2U_SelPlayerResult& value);
void OnGS2U_SelPlayerResult(GS2U_SelPlayerResult* value);
void ReadGS2U_SelPlayerResult(char*& buf,GS2U_SelPlayerResult& value);

struct UserPlayerData
{
    int64 playerID;
    string name;
    int level;
    int8 classValue;
    int8 sex;
    int8 faction;
};
void WriteUserPlayerData(char*& buf,UserPlayerData& value);
void ReadUserPlayerData(char*& buf,UserPlayerData& value);

struct GS2U_UserPlayerList
{
    vector<UserPlayerData> info;
};
void WriteGS2U_UserPlayerList(char*& buf,GS2U_UserPlayerList& value);
void OnGS2U_UserPlayerList(GS2U_UserPlayerList* value);
void ReadGS2U_UserPlayerList(char*& buf,GS2U_UserPlayerList& value);

struct GS2U_CreatePlayerResult
{
    int errorCode;
};
void WriteGS2U_CreatePlayerResult(char*& buf,GS2U_CreatePlayerResult& value);
void OnGS2U_CreatePlayerResult(GS2U_CreatePlayerResult* value);
void ReadGS2U_CreatePlayerResult(char*& buf,GS2U_CreatePlayerResult& value);

struct GS2U_DeletePlayerResult
{
    int64 playerID;
    int errorCode;
};
void WriteGS2U_DeletePlayerResult(char*& buf,GS2U_DeletePlayerResult& value);
void OnGS2U_DeletePlayerResult(GS2U_DeletePlayerResult* value);
void ReadGS2U_DeletePlayerResult(char*& buf,GS2U_DeletePlayerResult& value);

struct ConSales_GroundingItem
{
    int64 dbId;
    int count;
    int money;
    int timeType,;
	void Send();
};
void WriteConSales_GroundingItem(char*& buf,ConSales_GroundingItem& value);
void ReadConSales_GroundingItem(char*& buf,ConSales_GroundingItem& value);

struct ConSales_GroundingItem_Result
{
    int result;
};
void WriteConSales_GroundingItem_Result(char*& buf,ConSales_GroundingItem_Result& value);
void OnConSales_GroundingItem_Result(ConSales_GroundingItem_Result* value);
void ReadConSales_GroundingItem_Result(char*& buf,ConSales_GroundingItem_Result& value);

struct ConSales_TakeDown
{
    int64 conSalesId;
	void Send();
};
void WriteConSales_TakeDown(char*& buf,ConSales_TakeDown& value);
void ReadConSales_TakeDown(char*& buf,ConSales_TakeDown& value);

struct ConSales_TakeDown_Result
{
    int allTakeDown;
    int result;
    int protectTime;
};
void WriteConSales_TakeDown_Result(char*& buf,ConSales_TakeDown_Result& value);
void OnConSales_TakeDown_Result(ConSales_TakeDown_Result* value);
void ReadConSales_TakeDown_Result(char*& buf,ConSales_TakeDown_Result& value);

struct ConSales_BuyItem
{
    int64 conSalesOderId;
	void Send();
};
void WriteConSales_BuyItem(char*& buf,ConSales_BuyItem& value);
void ReadConSales_BuyItem(char*& buf,ConSales_BuyItem& value);

struct ConSales_BuyItem_Result
{
    int8 result;
};
void WriteConSales_BuyItem_Result(char*& buf,ConSales_BuyItem_Result& value);
void OnConSales_BuyItem_Result(ConSales_BuyItem_Result* value);
void ReadConSales_BuyItem_Result(char*& buf,ConSales_BuyItem_Result& value);

struct ConSales_FindItems
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
	void Send();
};
void WriteConSales_FindItems(char*& buf,ConSales_FindItems& value);
void ReadConSales_FindItems(char*& buf,ConSales_FindItems& value);

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
void WriteConSalesItem(char*& buf,ConSalesItem& value);
void ReadConSalesItem(char*& buf,ConSalesItem& value);

struct ConSales_FindItems_Result
{
    int result;
    int allCount;
    int page;
    vector<ConSalesItem> itemList;
};
void WriteConSales_FindItems_Result(char*& buf,ConSales_FindItems_Result& value);
void OnConSales_FindItems_Result(ConSales_FindItems_Result* value);
void ReadConSales_FindItems_Result(char*& buf,ConSales_FindItems_Result& value);

struct ConSales_TrunPage
{
    int mode;
	void Send();
};
void WriteConSales_TrunPage(char*& buf,ConSales_TrunPage& value);
void ReadConSales_TrunPage(char*& buf,ConSales_TrunPage& value);

struct ConSales_Close
{
    int n;
	void Send();
};
void WriteConSales_Close(char*& buf,ConSales_Close& value);
void ReadConSales_Close(char*& buf,ConSales_Close& value);

struct ConSales_GetSelfSell
{
    int n;
	void Send();
};
void WriteConSales_GetSelfSell(char*& buf,ConSales_GetSelfSell& value);
void ReadConSales_GetSelfSell(char*& buf,ConSales_GetSelfSell& value);

struct ConSales_GetSelfSell_Result
{
    vector<ConSalesItem> itemList;
};
void WriteConSales_GetSelfSell_Result(char*& buf,ConSales_GetSelfSell_Result& value);
void OnConSales_GetSelfSell_Result(ConSales_GetSelfSell_Result* value);
void ReadConSales_GetSelfSell_Result(char*& buf,ConSales_GetSelfSell_Result& value);

struct TradeAsk
{
    int64 playerID;
    string playerName;
	void Send();
};
void WriteTradeAsk(char*& buf,TradeAsk& value);
void OnTradeAsk(TradeAsk* value);
void ReadTradeAsk(char*& buf,TradeAsk& value);

struct TradeAskResult
{
    int64 playerID;
    string playerName;
    int8 result;
	void Send();
};
void WriteTradeAskResult(char*& buf,TradeAskResult& value);
void OnTradeAskResult(TradeAskResult* value);
void ReadTradeAskResult(char*& buf,TradeAskResult& value);

struct CreateTrade
{
    int64 playerID;
    string playerName;
    int8 result;
};
void WriteCreateTrade(char*& buf,CreateTrade& value);
void OnCreateTrade(CreateTrade* value);
void ReadCreateTrade(char*& buf,CreateTrade& value);

struct TradeInputItem_C2S
{
    int cell;
    int64 itemDBID;
    int count;
	void Send();
};
void WriteTradeInputItem_C2S(char*& buf,TradeInputItem_C2S& value);
void ReadTradeInputItem_C2S(char*& buf,TradeInputItem_C2S& value);

struct TradeInputItemResult_S2C
{
    int64 itemDBID;
    int item_data_id;
    int count;
    int cell;
    int8 result;
};
void WriteTradeInputItemResult_S2C(char*& buf,TradeInputItemResult_S2C& value);
void OnTradeInputItemResult_S2C(TradeInputItemResult_S2C* value);
void ReadTradeInputItemResult_S2C(char*& buf,TradeInputItemResult_S2C& value);

struct TradeInputItem_S2C
{
    int64 itemDBID;
    int item_data_id;
    int count;
};
void WriteTradeInputItem_S2C(char*& buf,TradeInputItem_S2C& value);
void OnTradeInputItem_S2C(TradeInputItem_S2C* value);
void ReadTradeInputItem_S2C(char*& buf,TradeInputItem_S2C& value);

struct TradeTakeOutItem_C2S
{
    int64 itemDBID;
	void Send();
};
void WriteTradeTakeOutItem_C2S(char*& buf,TradeTakeOutItem_C2S& value);
void ReadTradeTakeOutItem_C2S(char*& buf,TradeTakeOutItem_C2S& value);

struct TradeTakeOutItemResult_S2C
{
    int cell;
    int64 itemDBID;
    int8 result;
};
void WriteTradeTakeOutItemResult_S2C(char*& buf,TradeTakeOutItemResult_S2C& value);
void OnTradeTakeOutItemResult_S2C(TradeTakeOutItemResult_S2C* value);
void ReadTradeTakeOutItemResult_S2C(char*& buf,TradeTakeOutItemResult_S2C& value);

struct TradeTakeOutItem_S2C
{
    int64 itemDBID;
};
void WriteTradeTakeOutItem_S2C(char*& buf,TradeTakeOutItem_S2C& value);
void OnTradeTakeOutItem_S2C(TradeTakeOutItem_S2C* value);
void ReadTradeTakeOutItem_S2C(char*& buf,TradeTakeOutItem_S2C& value);

struct TradeChangeMoney_C2S
{
    int money;
	void Send();
};
void WriteTradeChangeMoney_C2S(char*& buf,TradeChangeMoney_C2S& value);
void ReadTradeChangeMoney_C2S(char*& buf,TradeChangeMoney_C2S& value);

struct TradeChangeMoneyResult_S2C
{
    int money;
    int8 result;
};
void WriteTradeChangeMoneyResult_S2C(char*& buf,TradeChangeMoneyResult_S2C& value);
void OnTradeChangeMoneyResult_S2C(TradeChangeMoneyResult_S2C* value);
void ReadTradeChangeMoneyResult_S2C(char*& buf,TradeChangeMoneyResult_S2C& value);

struct TradeChangeMoney_S2C
{
    int money;
};
void WriteTradeChangeMoney_S2C(char*& buf,TradeChangeMoney_S2C& value);
void OnTradeChangeMoney_S2C(TradeChangeMoney_S2C* value);
void ReadTradeChangeMoney_S2C(char*& buf,TradeChangeMoney_S2C& value);

struct TradeLock_C2S
{
    int8 lock;
	void Send();
};
void WriteTradeLock_C2S(char*& buf,TradeLock_C2S& value);
void ReadTradeLock_C2S(char*& buf,TradeLock_C2S& value);

struct TradeLock_S2C
{
    int8 person;
    int8 lock;
};
void WriteTradeLock_S2C(char*& buf,TradeLock_S2C& value);
void OnTradeLock_S2C(TradeLock_S2C* value);
void ReadTradeLock_S2C(char*& buf,TradeLock_S2C& value);

struct CancelTrade_S2C
{
    int8 person;
    int8 reason;
};
void WriteCancelTrade_S2C(char*& buf,CancelTrade_S2C& value);
void OnCancelTrade_S2C(CancelTrade_S2C* value);
void ReadCancelTrade_S2C(char*& buf,CancelTrade_S2C& value);

struct CancelTrade_C2S
{
    int8 reason;
	void Send();
};
void WriteCancelTrade_C2S(char*& buf,CancelTrade_C2S& value);
void ReadCancelTrade_C2S(char*& buf,CancelTrade_C2S& value);

struct TradeAffirm_C2S
{
    int bAffrim;
	void Send();
};
void WriteTradeAffirm_C2S(char*& buf,TradeAffirm_C2S& value);
void ReadTradeAffirm_C2S(char*& buf,TradeAffirm_C2S& value);

struct TradeAffirm_S2C
{
    int8 person;
    int8 bAffirm;
};
void WriteTradeAffirm_S2C(char*& buf,TradeAffirm_S2C& value);
void OnTradeAffirm_S2C(TradeAffirm_S2C* value);
void ReadTradeAffirm_S2C(char*& buf,TradeAffirm_S2C& value);

struct PetSkill
{
    int64 id;
    int coolDownTime;
};
void WritePetSkill(char*& buf,PetSkill& value);
void ReadPetSkill(char*& buf,PetSkill& value);

struct PetProperty
{
    int64 db_id;
    int data_id;
    int64 master_id;
    int level;
    int exp;
    string name;
    int titleId;
    int8 aiState;
    int8 showModel;
    int exModelId;
    int soulLevel;
    int soulRate;
    int attackGrowUp;
    int defGrowUp;
    int lifeGrowUp;
    int8 isWashGrow;
    int attackGrowUpWash;
    int defGrowUpWash;
    int lifeGrowUpWash;
    int convertRatio;
    int exerciseLevel;
    int moneyExrciseNum;
    int exerciseExp;
    int maxSkillNum;
    vector<PetSkill> skills;
    int life;
    int maxLife;
    int attack;
    int def;
    int crit;
    int block;
    int hit;
    int dodge;
    int tough;
    int pierce;
    int crit_damage_rate;
    int attack_speed;
    int ph_def;
    int fire_def;
    int ice_def;
    int elec_def;
    int poison_def;
    int coma_def;
    int hold_def;
    int silent_def;
    int move_def;
    int atkPowerGrowUp_Max;
    int defClassGrowUp_Max;
    int hpGrowUp_Max;
    int benison_Value;
};
void WritePetProperty(char*& buf,PetProperty& value);
void ReadPetProperty(char*& buf,PetProperty& value);

struct PlayerPetInfo
{
    vector<int> petSkillBag;
    vector<PetProperty> petInfos;
};
void WritePlayerPetInfo(char*& buf,PlayerPetInfo& value);
void OnPlayerPetInfo(PlayerPetInfo* value);
void ReadPlayerPetInfo(char*& buf,PlayerPetInfo& value);

struct UpdatePetProerty
{
    PetProperty petInfo;
};
void WriteUpdatePetProerty(char*& buf,UpdatePetProerty& value);
void OnUpdatePetProerty(UpdatePetProerty* value);
void ReadUpdatePetProerty(char*& buf,UpdatePetProerty& value);

struct DelPet
{
    int64 petId;
};
void WriteDelPet(char*& buf,DelPet& value);
void OnDelPet(DelPet* value);
void ReadDelPet(char*& buf,DelPet& value);

struct PetOutFight
{
    int64 petId;
	void Send();
};
void WritePetOutFight(char*& buf,PetOutFight& value);
void ReadPetOutFight(char*& buf,PetOutFight& value);

struct PetOutFight_Result
{
    int8 result;
    int64 petId;
};
void WritePetOutFight_Result(char*& buf,PetOutFight_Result& value);
void OnPetOutFight_Result(PetOutFight_Result* value);
void ReadPetOutFight_Result(char*& buf,PetOutFight_Result& value);

struct PetTakeRest
{
    int64 petId;
	void Send();
};
void WritePetTakeRest(char*& buf,PetTakeRest& value);
void ReadPetTakeRest(char*& buf,PetTakeRest& value);

struct PetTakeRest_Result
{
    int8 result;
    int64 petId;
};
void WritePetTakeRest_Result(char*& buf,PetTakeRest_Result& value);
void OnPetTakeRest_Result(PetTakeRest_Result* value);
void ReadPetTakeRest_Result(char*& buf,PetTakeRest_Result& value);

struct PetFreeCaptiveAnimals
{
    int64 petId;
	void Send();
};
void WritePetFreeCaptiveAnimals(char*& buf,PetFreeCaptiveAnimals& value);
void ReadPetFreeCaptiveAnimals(char*& buf,PetFreeCaptiveAnimals& value);

struct PetFreeCaptiveAnimals_Result
{
    int8 result;
    int64 petId;
};
void WritePetFreeCaptiveAnimals_Result(char*& buf,PetFreeCaptiveAnimals_Result& value);
void OnPetFreeCaptiveAnimals_Result(PetFreeCaptiveAnimals_Result* value);
void ReadPetFreeCaptiveAnimals_Result(char*& buf,PetFreeCaptiveAnimals_Result& value);

struct PetCompoundModel
{
    int64 petId;
	void Send();
};
void WritePetCompoundModel(char*& buf,PetCompoundModel& value);
void ReadPetCompoundModel(char*& buf,PetCompoundModel& value);

struct PetCompoundModel_Result
{
    int8 result;
    int64 petId;
};
void WritePetCompoundModel_Result(char*& buf,PetCompoundModel_Result& value);
void OnPetCompoundModel_Result(PetCompoundModel_Result* value);
void ReadPetCompoundModel_Result(char*& buf,PetCompoundModel_Result& value);

struct PetWashGrowUpValue
{
    int64 petId;
	void Send();
};
void WritePetWashGrowUpValue(char*& buf,PetWashGrowUpValue& value);
void ReadPetWashGrowUpValue(char*& buf,PetWashGrowUpValue& value);

struct PetWashGrowUpValue_Result
{
    int8 result;
    int64 petId;
    int attackGrowUp;
    int defGrowUp;
    int lifeGrowUp;
};
void WritePetWashGrowUpValue_Result(char*& buf,PetWashGrowUpValue_Result& value);
void OnPetWashGrowUpValue_Result(PetWashGrowUpValue_Result* value);
void ReadPetWashGrowUpValue_Result(char*& buf,PetWashGrowUpValue_Result& value);

struct PetReplaceGrowUpValue
{
    int64 petId;
	void Send();
};
void WritePetReplaceGrowUpValue(char*& buf,PetReplaceGrowUpValue& value);
void ReadPetReplaceGrowUpValue(char*& buf,PetReplaceGrowUpValue& value);

struct PetReplaceGrowUpValue_Result
{
    int8 result;
    int64 petId;
};
void WritePetReplaceGrowUpValue_Result(char*& buf,PetReplaceGrowUpValue_Result& value);
void OnPetReplaceGrowUpValue_Result(PetReplaceGrowUpValue_Result* value);
void ReadPetReplaceGrowUpValue_Result(char*& buf,PetReplaceGrowUpValue_Result& value);

struct PetIntensifySoul
{
    int64 petId;
	void Send();
};
void WritePetIntensifySoul(char*& buf,PetIntensifySoul& value);
void ReadPetIntensifySoul(char*& buf,PetIntensifySoul& value);

struct PetIntensifySoul_Result
{
    int8 result;
    int64 petId;
    int soulLevel;
    int soulRate;
    int benison_Value;
};
void WritePetIntensifySoul_Result(char*& buf,PetIntensifySoul_Result& value);
void OnPetIntensifySoul_Result(PetIntensifySoul_Result* value);
void ReadPetIntensifySoul_Result(char*& buf,PetIntensifySoul_Result& value);

struct PetOneKeyIntensifySoul
{
    int64 petId;
	void Send();
};
void WritePetOneKeyIntensifySoul(char*& buf,PetOneKeyIntensifySoul& value);
void ReadPetOneKeyIntensifySoul(char*& buf,PetOneKeyIntensifySoul& value);

struct PetOneKeyIntensifySoul_Result
{
    int64 petId;
    int8 result;
    int itemCount;
    int money;
};
void WritePetOneKeyIntensifySoul_Result(char*& buf,PetOneKeyIntensifySoul_Result& value);
void OnPetOneKeyIntensifySoul_Result(PetOneKeyIntensifySoul_Result* value);
void ReadPetOneKeyIntensifySoul_Result(char*& buf,PetOneKeyIntensifySoul_Result& value);

struct PetFuse
{
    int64 petSrcId;
    int64 petDestId;
	void Send();
};
void WritePetFuse(char*& buf,PetFuse& value);
void ReadPetFuse(char*& buf,PetFuse& value);

struct PetFuse_Result
{
    int8 result;
    int64 petSrcId;
    int64 petDestId;
};
void WritePetFuse_Result(char*& buf,PetFuse_Result& value);
void OnPetFuse_Result(PetFuse_Result* value);
void ReadPetFuse_Result(char*& buf,PetFuse_Result& value);

struct PetJumpTo
{
    int64 petId;
    int x;
    int y;
};
void WritePetJumpTo(char*& buf,PetJumpTo& value);
void OnPetJumpTo(PetJumpTo* value);
void ReadPetJumpTo(char*& buf,PetJumpTo& value);

struct ActorSetPos
{
    int64 actorId;
    int x;
    int y;
};
void WriteActorSetPos(char*& buf,ActorSetPos& value);
void OnActorSetPos(ActorSetPos* value);
void ReadActorSetPos(char*& buf,ActorSetPos& value);

struct PetTakeBack
{
    int64 petId;
};
void WritePetTakeBack(char*& buf,PetTakeBack& value);
void OnPetTakeBack(PetTakeBack* value);
void ReadPetTakeBack(char*& buf,PetTakeBack& value);

struct ChangePetAIState
{
    int8 state;
	void Send();
};
void WriteChangePetAIState(char*& buf,ChangePetAIState& value);
void OnChangePetAIState(ChangePetAIState* value);
void ReadChangePetAIState(char*& buf,ChangePetAIState& value);

struct PetExpChanged
{
    int64 petId;
    int curExp;
    int8 reason;
};
void WritePetExpChanged(char*& buf,PetExpChanged& value);
void OnPetExpChanged(PetExpChanged* value);
void ReadPetExpChanged(char*& buf,PetExpChanged& value);

struct PetLearnSkill
{
    int64 petId;
    int skillId;
	void Send();
};
void WritePetLearnSkill(char*& buf,PetLearnSkill& value);
void ReadPetLearnSkill(char*& buf,PetLearnSkill& value);

struct PetLearnSkill_Result
{
    int8 result;
    int64 petId;
    int oldSkillId;
    int newSkillId;
};
void WritePetLearnSkill_Result(char*& buf,PetLearnSkill_Result& value);
void OnPetLearnSkill_Result(PetLearnSkill_Result* value);
void ReadPetLearnSkill_Result(char*& buf,PetLearnSkill_Result& value);

struct PetDelSkill
{
    int64 petId;
    int skillId;
	void Send();
};
void WritePetDelSkill(char*& buf,PetDelSkill& value);
void ReadPetDelSkill(char*& buf,PetDelSkill& value);

struct PetDelSkill_Result
{
    int8 result;
    int64 petId;
    int skillid;
};
void WritePetDelSkill_Result(char*& buf,PetDelSkill_Result& value);
void OnPetDelSkill_Result(PetDelSkill_Result* value);
void ReadPetDelSkill_Result(char*& buf,PetDelSkill_Result& value);

struct PetUnLockSkillCell
{
    int64 petId;
	void Send();
};
void WritePetUnLockSkillCell(char*& buf,PetUnLockSkillCell& value);
void ReadPetUnLockSkillCell(char*& buf,PetUnLockSkillCell& value);

struct PetUnLoctSkillCell_Result
{
    int8 result;
    int64 petId;
    int newSkillCellNum;
};
void WritePetUnLoctSkillCell_Result(char*& buf,PetUnLoctSkillCell_Result& value);
void OnPetUnLoctSkillCell_Result(PetUnLoctSkillCell_Result* value);
void ReadPetUnLoctSkillCell_Result(char*& buf,PetUnLoctSkillCell_Result& value);

struct PetSkillSealAhs
{
    int64 petId;
    int skillid;
	void Send();
};
void WritePetSkillSealAhs(char*& buf,PetSkillSealAhs& value);
void ReadPetSkillSealAhs(char*& buf,PetSkillSealAhs& value);

struct PetSkillSealAhs_Result
{
    int8 result;
    int64 petId;
    int skillid;
};
void WritePetSkillSealAhs_Result(char*& buf,PetSkillSealAhs_Result& value);
void OnPetSkillSealAhs_Result(PetSkillSealAhs_Result* value);
void ReadPetSkillSealAhs_Result(char*& buf,PetSkillSealAhs_Result& value);

struct PetUpdateSealAhsStore
{
    vector<int> petSkillBag;
};
void WritePetUpdateSealAhsStore(char*& buf,PetUpdateSealAhsStore& value);
void OnPetUpdateSealAhsStore(PetUpdateSealAhsStore* value);
void ReadPetUpdateSealAhsStore(char*& buf,PetUpdateSealAhsStore& value);

struct PetlearnSealAhsSkill
{
    int64 petId;
    int skillId;
	void Send();
};
void WritePetlearnSealAhsSkill(char*& buf,PetlearnSealAhsSkill& value);
void ReadPetlearnSealAhsSkill(char*& buf,PetlearnSealAhsSkill& value);

struct PetlearnSealAhsSkill_Result
{
    int8 result;
    int64 petId;
    int oldSkillId;
    int newSkillId;
};
void WritePetlearnSealAhsSkill_Result(char*& buf,PetlearnSealAhsSkill_Result& value);
void OnPetlearnSealAhsSkill_Result(PetlearnSealAhsSkill_Result* value);
void ReadPetlearnSealAhsSkill_Result(char*& buf,PetlearnSealAhsSkill_Result& value);

struct RequestGetPlayerEquipEnhanceByType
{
    int type;
	void Send();
};
void WriteRequestGetPlayerEquipEnhanceByType(char*& buf,RequestGetPlayerEquipEnhanceByType& value);
void ReadRequestGetPlayerEquipEnhanceByType(char*& buf,RequestGetPlayerEquipEnhanceByType& value);

struct GetPlayerEquipEnhanceByTypeBack
{
    int type;
    int level;
    int progress;
    int blessValue;
};
void WriteGetPlayerEquipEnhanceByTypeBack(char*& buf,GetPlayerEquipEnhanceByTypeBack& value);
void OnGetPlayerEquipEnhanceByTypeBack(GetPlayerEquipEnhanceByTypeBack* value);
void ReadGetPlayerEquipEnhanceByTypeBack(char*& buf,GetPlayerEquipEnhanceByTypeBack& value);

struct RequestEquipEnhanceByType
{
    int type;
	void Send();
};
void WriteRequestEquipEnhanceByType(char*& buf,RequestEquipEnhanceByType& value);
void ReadRequestEquipEnhanceByType(char*& buf,RequestEquipEnhanceByType& value);

struct EquipEnhanceByTypeBack
{
    int result;
};
void WriteEquipEnhanceByTypeBack(char*& buf,EquipEnhanceByTypeBack& value);
void OnEquipEnhanceByTypeBack(EquipEnhanceByTypeBack* value);
void ReadEquipEnhanceByTypeBack(char*& buf,EquipEnhanceByTypeBack& value);

struct RequestEquipOnceEnhanceByType
{
    int type;
	void Send();
};
void WriteRequestEquipOnceEnhanceByType(char*& buf,RequestEquipOnceEnhanceByType& value);
void ReadRequestEquipOnceEnhanceByType(char*& buf,RequestEquipOnceEnhanceByType& value);

struct EquipOnceEnhanceByTypeBack
{
    int result;
    int times;
    int itemnumber;
    int money;
};
void WriteEquipOnceEnhanceByTypeBack(char*& buf,EquipOnceEnhanceByTypeBack& value);
void OnEquipOnceEnhanceByTypeBack(EquipOnceEnhanceByTypeBack* value);
void ReadEquipOnceEnhanceByTypeBack(char*& buf,EquipOnceEnhanceByTypeBack& value);

struct RequestGetPlayerEquipQualityByType
{
    int type;
	void Send();
};
void WriteRequestGetPlayerEquipQualityByType(char*& buf,RequestGetPlayerEquipQualityByType& value);
void ReadRequestGetPlayerEquipQualityByType(char*& buf,RequestGetPlayerEquipQualityByType& value);

struct GetPlayerEquipQualityByTypeBack
{
    int type;
    int quality;
};
void WriteGetPlayerEquipQualityByTypeBack(char*& buf,GetPlayerEquipQualityByTypeBack& value);
void OnGetPlayerEquipQualityByTypeBack(GetPlayerEquipQualityByTypeBack* value);
void ReadGetPlayerEquipQualityByTypeBack(char*& buf,GetPlayerEquipQualityByTypeBack& value);

struct RequestEquipQualityUPByType
{
    int type;
	void Send();
};
void WriteRequestEquipQualityUPByType(char*& buf,RequestEquipQualityUPByType& value);
void ReadRequestEquipQualityUPByType(char*& buf,RequestEquipQualityUPByType& value);

struct EquipQualityUPByTypeBack
{
    int result;
};
void WriteEquipQualityUPByTypeBack(char*& buf,EquipQualityUPByTypeBack& value);
void OnEquipQualityUPByTypeBack(EquipQualityUPByTypeBack* value);
void ReadEquipQualityUPByTypeBack(char*& buf,EquipQualityUPByTypeBack& value);

struct RequestEquipOldPropertyByType
{
    int type;
	void Send();
};
void WriteRequestEquipOldPropertyByType(char*& buf,RequestEquipOldPropertyByType& value);
void ReadRequestEquipOldPropertyByType(char*& buf,RequestEquipOldPropertyByType& value);

struct GetEquipOldPropertyByType
{
    int type;
    int8 property1Type;
    int8 property1FixOrPercent;
    int property1Value;
    int8 property2Type;
    int8 property2FixOrPercent;
    int property2Value;
    int8 property3Type;
    int8 property3FixOrPercent;
    int property3Value;
    int8 property4Type;
    int8 property4FixOrPercent;
    int property4Value;
    int8 property5Type;
    int8 property5FixOrPercent;
    int property5Value;
};
void WriteGetEquipOldPropertyByType(char*& buf,GetEquipOldPropertyByType& value);
void OnGetEquipOldPropertyByType(GetEquipOldPropertyByType* value);
void ReadGetEquipOldPropertyByType(char*& buf,GetEquipOldPropertyByType& value);

struct RequestEquipChangePropertyByType
{
    int type;
    int8 property1;
    int8 property2;
    int8 property3;
    int8 property4;
    int8 property5;
	void Send();
};
void WriteRequestEquipChangePropertyByType(char*& buf,RequestEquipChangePropertyByType& value);
void ReadRequestEquipChangePropertyByType(char*& buf,RequestEquipChangePropertyByType& value);

struct GetEquipNewPropertyByType
{
    int type;
    int8 property1Type;
    int8 property1FixOrPercent;
    int property1Value;
    int8 property2Type;
    int8 property2FixOrPercent;
    int property2Value;
    int8 property3Type;
    int8 property3FixOrPercent;
    int property3Value;
    int8 property4Type;
    int8 property4FixOrPercent;
    int property4Value;
    int8 property5Type;
    int8 property5FixOrPercent;
    int property5Value;
};
void WriteGetEquipNewPropertyByType(char*& buf,GetEquipNewPropertyByType& value);
void OnGetEquipNewPropertyByType(GetEquipNewPropertyByType* value);
void ReadGetEquipNewPropertyByType(char*& buf,GetEquipNewPropertyByType& value);

struct RequestEquipSaveNewPropertyByType
{
    int type;
	void Send();
};
void WriteRequestEquipSaveNewPropertyByType(char*& buf,RequestEquipSaveNewPropertyByType& value);
void ReadRequestEquipSaveNewPropertyByType(char*& buf,RequestEquipSaveNewPropertyByType& value);

struct RequestEquipChangeAddSavePropertyByType
{
    int result;
};
void WriteRequestEquipChangeAddSavePropertyByType(char*& buf,RequestEquipChangeAddSavePropertyByType& value);
void OnRequestEquipChangeAddSavePropertyByType(RequestEquipChangeAddSavePropertyByType* value);
void ReadRequestEquipChangeAddSavePropertyByType(char*& buf,RequestEquipChangeAddSavePropertyByType& value);

struct U2GS_EnterCopyMapRequest
{
    int64 npcActorID;
    int enterMapID;
	void Send();
};
void WriteU2GS_EnterCopyMapRequest(char*& buf,U2GS_EnterCopyMapRequest& value);
void ReadU2GS_EnterCopyMapRequest(char*& buf,U2GS_EnterCopyMapRequest& value);

struct GS2U_EnterMapResult
{
    int result;
};
void WriteGS2U_EnterMapResult(char*& buf,GS2U_EnterMapResult& value);
void OnGS2U_EnterMapResult(GS2U_EnterMapResult* value);
void ReadGS2U_EnterMapResult(char*& buf,GS2U_EnterMapResult& value);

struct U2GS_QueryMyCopyMapCD
{
    int reserve;
	void Send();
};
void WriteU2GS_QueryMyCopyMapCD(char*& buf,U2GS_QueryMyCopyMapCD& value);
void ReadU2GS_QueryMyCopyMapCD(char*& buf,U2GS_QueryMyCopyMapCD& value);

struct MyCopyMapCDInfo
{
    int16 mapDataID;
    int8 mapEnteredCount;
    int8 mapActiveCount;
};
void WriteMyCopyMapCDInfo(char*& buf,MyCopyMapCDInfo& value);
void ReadMyCopyMapCDInfo(char*& buf,MyCopyMapCDInfo& value);

struct GS2U_MyCopyMapCDInfo
{
    vector<MyCopyMapCDInfo> info_list;
};
void WriteGS2U_MyCopyMapCDInfo(char*& buf,GS2U_MyCopyMapCDInfo& value);
void OnGS2U_MyCopyMapCDInfo(GS2U_MyCopyMapCDInfo* value);
void ReadGS2U_MyCopyMapCDInfo(char*& buf,GS2U_MyCopyMapCDInfo& value);

struct AddBuff
{
    int64 actor_id;
    int16 buff_data_id;
    int16 allValidTime;
    int8 remainTriggerCount;
};
void WriteAddBuff(char*& buf,AddBuff& value);
void OnAddBuff(AddBuff* value);
void ReadAddBuff(char*& buf,AddBuff& value);

struct DelBuff
{
    int64 actor_id;
    int16 buff_data_id;
};
void WriteDelBuff(char*& buf,DelBuff& value);
void OnDelBuff(DelBuff* value);
void ReadDelBuff(char*& buf,DelBuff& value);

struct UpdateBuff
{
    int64 actor_id;
    int16 buff_data_id;
    int8 remainTriggerCount;
};
void WriteUpdateBuff(char*& buf,UpdateBuff& value);
void OnUpdateBuff(UpdateBuff* value);
void ReadUpdateBuff(char*& buf,UpdateBuff& value);

struct HeroBuffList
{
    vector<ObjectBuff> buffList;
};
void WriteHeroBuffList(char*& buf,HeroBuffList& value);
void OnHeroBuffList(HeroBuffList* value);
void ReadHeroBuffList(char*& buf,HeroBuffList& value);

struct U2GS_TransByWorldMap
{
    int mapDataID;
    int posX;
    int posY;
	void Send();
};
void WriteU2GS_TransByWorldMap(char*& buf,U2GS_TransByWorldMap& value);
void ReadU2GS_TransByWorldMap(char*& buf,U2GS_TransByWorldMap& value);

struct U2GS_TransForSameScence
{
    int mapDataID;
    int posX;
    int posY;
	void Send();
};
void WriteU2GS_TransForSameScence(char*& buf,U2GS_TransForSameScence& value);
void ReadU2GS_TransForSameScence(char*& buf,U2GS_TransForSameScence& value);

struct U2GS_FastTeamCopyMapRequest
{
    int64 npcActorID;
    int mapDataID;
    int8 enterOrQuit;
	void Send();
};
void WriteU2GS_FastTeamCopyMapRequest(char*& buf,U2GS_FastTeamCopyMapRequest& value);
void ReadU2GS_FastTeamCopyMapRequest(char*& buf,U2GS_FastTeamCopyMapRequest& value);

struct GS2U_FastTeamCopyMapResult
{
    int mapDataID;
    int result;
    int8 enterOrQuit;
};
void WriteGS2U_FastTeamCopyMapResult(char*& buf,GS2U_FastTeamCopyMapResult& value);
void OnGS2U_FastTeamCopyMapResult(GS2U_FastTeamCopyMapResult* value);
void ReadGS2U_FastTeamCopyMapResult(char*& buf,GS2U_FastTeamCopyMapResult& value);

struct GS2U_TeamCopyMapQuery
{
    int nReadyEnterMapDataID;
    int nCurMapID;
    int nPosX;
    int nPosY;
    int nDistanceSQ;
};
void WriteGS2U_TeamCopyMapQuery(char*& buf,GS2U_TeamCopyMapQuery& value);
void OnGS2U_TeamCopyMapQuery(GS2U_TeamCopyMapQuery* value);
void ReadGS2U_TeamCopyMapQuery(char*& buf,GS2U_TeamCopyMapQuery& value);

struct U2GS_RestCopyMapRequest
{
    int64 nNpcID;
    int nMapDataID;
	void Send();
};
void WriteU2GS_RestCopyMapRequest(char*& buf,U2GS_RestCopyMapRequest& value);
void ReadU2GS_RestCopyMapRequest(char*& buf,U2GS_RestCopyMapRequest& value);

struct GS2U_AddOrRemoveHatred
{
    int64 nActorID;
    int8 nAddOrRemove;
};
void WriteGS2U_AddOrRemoveHatred(char*& buf,GS2U_AddOrRemoveHatred& value);
void OnGS2U_AddOrRemoveHatred(GS2U_AddOrRemoveHatred* value);
void ReadGS2U_AddOrRemoveHatred(char*& buf,GS2U_AddOrRemoveHatred& value);

struct U2GS_QieCuoInvite
{
    int64 nActorID;
	void Send();
};
void WriteU2GS_QieCuoInvite(char*& buf,U2GS_QieCuoInvite& value);
void ReadU2GS_QieCuoInvite(char*& buf,U2GS_QieCuoInvite& value);

struct GS2U_QieCuoInviteQuery
{
    int64 nActorID;
    string strName;
};
void WriteGS2U_QieCuoInviteQuery(char*& buf,GS2U_QieCuoInviteQuery& value);
void OnGS2U_QieCuoInviteQuery(GS2U_QieCuoInviteQuery* value);
void ReadGS2U_QieCuoInviteQuery(char*& buf,GS2U_QieCuoInviteQuery& value);

struct U2GS_QieCuoInviteAck
{
    int64 nActorID;
    int8 agree;
	void Send();
};
void WriteU2GS_QieCuoInviteAck(char*& buf,U2GS_QieCuoInviteAck& value);
void ReadU2GS_QieCuoInviteAck(char*& buf,U2GS_QieCuoInviteAck& value);

struct GS2U_QieCuoInviteResult
{
    int64 nActorID;
    int8 result;
};
void WriteGS2U_QieCuoInviteResult(char*& buf,GS2U_QieCuoInviteResult& value);
void OnGS2U_QieCuoInviteResult(GS2U_QieCuoInviteResult* value);
void ReadGS2U_QieCuoInviteResult(char*& buf,GS2U_QieCuoInviteResult& value);

struct GS2U_QieCuoResult
{
    int64 nWinner_ActorID;
    string strWinner_Name;
    int64 nLoser_ActorID;
    string strLoser_Name;
    int8 reson;
};
void WriteGS2U_QieCuoResult(char*& buf,GS2U_QieCuoResult& value);
void OnGS2U_QieCuoResult(GS2U_QieCuoResult* value);
void ReadGS2U_QieCuoResult(char*& buf,GS2U_QieCuoResult& value);

struct U2GS_PK_KillOpenRequest
{
    int8 reserve;
	void Send();
};
void WriteU2GS_PK_KillOpenRequest(char*& buf,U2GS_PK_KillOpenRequest& value);
void ReadU2GS_PK_KillOpenRequest(char*& buf,U2GS_PK_KillOpenRequest& value);

struct GS2U_PK_KillOpenResult
{
    int result;
    int pK_Kill_RemainTime;
    int pk_Kill_Value;
};
void WriteGS2U_PK_KillOpenResult(char*& buf,GS2U_PK_KillOpenResult& value);
void OnGS2U_PK_KillOpenResult(GS2U_PK_KillOpenResult* value);
void ReadGS2U_PK_KillOpenResult(char*& buf,GS2U_PK_KillOpenResult& value);

struct GS2U_Player_ChangeEquipResult
{
    int64 playerID;
    int equipID;
};
void WriteGS2U_Player_ChangeEquipResult(char*& buf,GS2U_Player_ChangeEquipResult& value);
void OnGS2U_Player_ChangeEquipResult(GS2U_Player_ChangeEquipResult* value);
void ReadGS2U_Player_ChangeEquipResult(char*& buf,GS2U_Player_ChangeEquipResult& value);

struct SysMessage
{
    int type;
    string text;
};
void WriteSysMessage(char*& buf,SysMessage& value);
void OnSysMessage(SysMessage* value);
void ReadSysMessage(char*& buf,SysMessage& value);

struct GS2U_AddLifeByItem
{
    int64 actorID;
    int addLife;
    int8 percent;
};
void WriteGS2U_AddLifeByItem(char*& buf,GS2U_AddLifeByItem& value);
void OnGS2U_AddLifeByItem(GS2U_AddLifeByItem* value);
void ReadGS2U_AddLifeByItem(char*& buf,GS2U_AddLifeByItem& value);

struct GS2U_AddLifeBySkill
{
    int64 actorID;
    int addLife;
    int8 percent;
    int8 crite;
};
void WriteGS2U_AddLifeBySkill(char*& buf,GS2U_AddLifeBySkill& value);
void OnGS2U_AddLifeBySkill(GS2U_AddLifeBySkill* value);
void ReadGS2U_AddLifeBySkill(char*& buf,GS2U_AddLifeBySkill& value);

struct PlayerItemCDInfo
{
    int8 cdTypeID;
    int remainTime;
    int allTime;
};
void WritePlayerItemCDInfo(char*& buf,PlayerItemCDInfo& value);
void ReadPlayerItemCDInfo(char*& buf,PlayerItemCDInfo& value);

struct GS2U_PlayerItemCDInit
{
    vector<PlayerItemCDInfo> info_list;
};
void WriteGS2U_PlayerItemCDInit(char*& buf,GS2U_PlayerItemCDInit& value);
void OnGS2U_PlayerItemCDInit(GS2U_PlayerItemCDInit* value);
void ReadGS2U_PlayerItemCDInit(char*& buf,GS2U_PlayerItemCDInit& value);

struct GS2U_PlayerItemCDUpdate
{
    PlayerItemCDInfo info;
};
void WriteGS2U_PlayerItemCDUpdate(char*& buf,GS2U_PlayerItemCDUpdate& value);
void OnGS2U_PlayerItemCDUpdate(GS2U_PlayerItemCDUpdate* value);
void ReadGS2U_PlayerItemCDUpdate(char*& buf,GS2U_PlayerItemCDUpdate& value);

struct U2GS_BloodPoolAddLife
{
    int64 actorID;
	void Send();
};
void WriteU2GS_BloodPoolAddLife(char*& buf,U2GS_BloodPoolAddLife& value);
void ReadU2GS_BloodPoolAddLife(char*& buf,U2GS_BloodPoolAddLife& value);

struct GS2U_ItemDailyCount
{
    int remainCount;
    int task_data_id;
};
void WriteGS2U_ItemDailyCount(char*& buf,GS2U_ItemDailyCount& value);
void OnGS2U_ItemDailyCount(GS2U_ItemDailyCount* value);
void ReadGS2U_ItemDailyCount(char*& buf,GS2U_ItemDailyCount& value);

struct U2GS_GetSigninInfo
{
	void Send();
};
void WriteU2GS_GetSigninInfo(char*& buf,U2GS_GetSigninInfo& value);
void ReadU2GS_GetSigninInfo(char*& buf,U2GS_GetSigninInfo& value);

struct GS2U_PlayerSigninInfo
{
    int8 isAlreadySign;
    int8 days;
};
void WriteGS2U_PlayerSigninInfo(char*& buf,GS2U_PlayerSigninInfo& value);
void OnGS2U_PlayerSigninInfo(GS2U_PlayerSigninInfo* value);
void ReadGS2U_PlayerSigninInfo(char*& buf,GS2U_PlayerSigninInfo& value);

struct U2GS_Signin
{
	void Send();
};
void WriteU2GS_Signin(char*& buf,U2GS_Signin& value);
void ReadU2GS_Signin(char*& buf,U2GS_Signin& value);

struct GS2U_PlayerSignInResult
{
    int nResult;
    int8 awardDays;
};
void WriteGS2U_PlayerSignInResult(char*& buf,GS2U_PlayerSignInResult& value);
void OnGS2U_PlayerSignInResult(GS2U_PlayerSignInResult* value);
void ReadGS2U_PlayerSignInResult(char*& buf,GS2U_PlayerSignInResult& value);

struct U2GS_LeaveCopyMap
{
    int8 reserve;
	void Send();
};
void WriteU2GS_LeaveCopyMap(char*& buf,U2GS_LeaveCopyMap& value);
void ReadU2GS_LeaveCopyMap(char*& buf,U2GS_LeaveCopyMap& value);

struct PetChangeModel
{
    int64 petId;
    int modelID;
};
void WritePetChangeModel(char*& buf,PetChangeModel& value);
void OnPetChangeModel(PetChangeModel* value);
void ReadPetChangeModel(char*& buf,PetChangeModel& value);

struct PetChangeName
{
    int64 petId;
    string newName;
	void Send();
};
void WritePetChangeName(char*& buf,PetChangeName& value);
void OnPetChangeName(PetChangeName* value);
void ReadPetChangeName(char*& buf,PetChangeName& value);

struct PetChangeName_Result
{
    int8 result;
    int64 petId;
    string newName;
};
void WritePetChangeName_Result(char*& buf,PetChangeName_Result& value);
void OnPetChangeName_Result(PetChangeName_Result* value);
void ReadPetChangeName_Result(char*& buf,PetChangeName_Result& value);

struct BazzarItem
{
    int db_id;
    int16 item_id;
    int8 item_column;
    int16 gold;
    int16 binded_gold;
    int16 remain_count;
    int remain_time;
};
void WriteBazzarItem(char*& buf,BazzarItem& value);
void ReadBazzarItem(char*& buf,BazzarItem& value);

struct BazzarListRequest
{
    int seed;
	void Send();
};
void WriteBazzarListRequest(char*& buf,BazzarListRequest& value);
void ReadBazzarListRequest(char*& buf,BazzarListRequest& value);

struct BazzarPriceItemList
{
    vector<BazzarItem> itemList;
};
void WriteBazzarPriceItemList(char*& buf,BazzarPriceItemList& value);
void OnBazzarPriceItemList(BazzarPriceItemList* value);
void ReadBazzarPriceItemList(char*& buf,BazzarPriceItemList& value);

struct BazzarItemList
{
    int seed;
    vector<BazzarItem> itemList;
};
void WriteBazzarItemList(char*& buf,BazzarItemList& value);
void OnBazzarItemList(BazzarItemList* value);
void ReadBazzarItemList(char*& buf,BazzarItemList& value);

struct BazzarItemUpdate
{
    BazzarItem item;
};
void WriteBazzarItemUpdate(char*& buf,BazzarItemUpdate& value);
void OnBazzarItemUpdate(BazzarItemUpdate* value);
void ReadBazzarItemUpdate(char*& buf,BazzarItemUpdate& value);

struct BazzarBuyRequest
{
    int db_id;
    int16 isBindGold;
    int16 count;
	void Send();
};
void WriteBazzarBuyRequest(char*& buf,BazzarBuyRequest& value);
void ReadBazzarBuyRequest(char*& buf,BazzarBuyRequest& value);

struct BazzarBuyResult
{
    int8 result;
};
void WriteBazzarBuyResult(char*& buf,BazzarBuyResult& value);
void OnBazzarBuyResult(BazzarBuyResult* value);
void ReadBazzarBuyResult(char*& buf,BazzarBuyResult& value);

struct PlayerBagCellOpenResult
{
    int8 result;
};
void WritePlayerBagCellOpenResult(char*& buf,PlayerBagCellOpenResult& value);
void OnPlayerBagCellOpenResult(PlayerBagCellOpenResult* value);
void ReadPlayerBagCellOpenResult(char*& buf,PlayerBagCellOpenResult& value);

struct U2GS_RemoveSkillBranch
{
    int nSkillID;
	void Send();
};
void WriteU2GS_RemoveSkillBranch(char*& buf,U2GS_RemoveSkillBranch& value);
void ReadU2GS_RemoveSkillBranch(char*& buf,U2GS_RemoveSkillBranch& value);

struct GS2U_RemoveSkillBranch
{
    int result;
    int nSkillID;
};
void WriteGS2U_RemoveSkillBranch(char*& buf,GS2U_RemoveSkillBranch& value);
void OnGS2U_RemoveSkillBranch(GS2U_RemoveSkillBranch* value);
void ReadGS2U_RemoveSkillBranch(char*& buf,GS2U_RemoveSkillBranch& value);

struct U2GS_PetBloodPoolAddLife
{
    int8 n;
	void Send();
};
void WriteU2GS_PetBloodPoolAddLife(char*& buf,U2GS_PetBloodPoolAddLife& value);
void ReadU2GS_PetBloodPoolAddLife(char*& buf,U2GS_PetBloodPoolAddLife& value);

struct U2GS_CopyMapAddActiveCount
{
    int16 map_data_id;
	void Send();
};
void WriteU2GS_CopyMapAddActiveCount(char*& buf,U2GS_CopyMapAddActiveCount& value);
void ReadU2GS_CopyMapAddActiveCount(char*& buf,U2GS_CopyMapAddActiveCount& value);

struct U2GS_CopyMapAddActiveCountResult
{
    int16 result;
};
void WriteU2GS_CopyMapAddActiveCountResult(char*& buf,U2GS_CopyMapAddActiveCountResult& value);
void OnU2GS_CopyMapAddActiveCountResult(U2GS_CopyMapAddActiveCountResult* value);
void ReadU2GS_CopyMapAddActiveCountResult(char*& buf,U2GS_CopyMapAddActiveCountResult& value);

struct GS2U_CurConvoyInfo
{
    int8 isDead;
    int convoyType;
    int carriageQuality;
    int remainTime;
    int lowCD;
    int highCD;
    int freeCnt;
};
void WriteGS2U_CurConvoyInfo(char*& buf,GS2U_CurConvoyInfo& value);
void OnGS2U_CurConvoyInfo(GS2U_CurConvoyInfo* value);
void ReadGS2U_CurConvoyInfo(char*& buf,GS2U_CurConvoyInfo& value);

struct U2GS_CarriageQualityRefresh
{
    int isRefreshLegend;
    int isCostGold;
    int curConvoyType;
    int curCarriageQuality;
    int curTaskID;
	void Send();
};
void WriteU2GS_CarriageQualityRefresh(char*& buf,U2GS_CarriageQualityRefresh& value);
void ReadU2GS_CarriageQualityRefresh(char*& buf,U2GS_CarriageQualityRefresh& value);

struct GS2U_CarriageQualityRefreshResult
{
    int retCode;
    int newConvoyType;
    int newCarriageQuality;
    int freeCnt;
};
void WriteGS2U_CarriageQualityRefreshResult(char*& buf,GS2U_CarriageQualityRefreshResult& value);
void OnGS2U_CarriageQualityRefreshResult(GS2U_CarriageQualityRefreshResult* value);
void ReadGS2U_CarriageQualityRefreshResult(char*& buf,GS2U_CarriageQualityRefreshResult& value);

struct U2GS_ConvoyCDRequst
{
	void Send();
};
void WriteU2GS_ConvoyCDRequst(char*& buf,U2GS_ConvoyCDRequst& value);
void ReadU2GS_ConvoyCDRequst(char*& buf,U2GS_ConvoyCDRequst& value);

struct GS2U_ConvoyCDResult
{
    int8 retCode;
};
void WriteGS2U_ConvoyCDResult(char*& buf,GS2U_ConvoyCDResult& value);
void OnGS2U_ConvoyCDResult(GS2U_ConvoyCDResult* value);
void ReadGS2U_ConvoyCDResult(char*& buf,GS2U_ConvoyCDResult& value);

struct U2GS_BeginConvoy
{
    int nTaskID;
    int curConvoyType;
    int curCarriageQuality;
    int64 nNpcActorID;
	void Send();
};
void WriteU2GS_BeginConvoy(char*& buf,U2GS_BeginConvoy& value);
void ReadU2GS_BeginConvoy(char*& buf,U2GS_BeginConvoy& value);

struct GS2U_BeginConvoyResult
{
    int retCode;
    int curConvoyType;
    int curCarriageQuality;
    int remainTime;
    int lowCD;
    int highCD;
};
void WriteGS2U_BeginConvoyResult(char*& buf,GS2U_BeginConvoyResult& value);
void OnGS2U_BeginConvoyResult(GS2U_BeginConvoyResult* value);
void ReadGS2U_BeginConvoyResult(char*& buf,GS2U_BeginConvoyResult& value);

struct GS2U_FinishConvoyResult
{
    int curConvoyType;
    int curCarriageQuality;
};
void WriteGS2U_FinishConvoyResult(char*& buf,GS2U_FinishConvoyResult& value);
void OnGS2U_FinishConvoyResult(GS2U_FinishConvoyResult* value);
void ReadGS2U_FinishConvoyResult(char*& buf,GS2U_FinishConvoyResult& value);

struct GS2U_GiveUpConvoyResult
{
    int curConvoyType;
    int curCarriageQuality;
};
void WriteGS2U_GiveUpConvoyResult(char*& buf,GS2U_GiveUpConvoyResult& value);
void OnGS2U_GiveUpConvoyResult(GS2U_GiveUpConvoyResult* value);
void ReadGS2U_GiveUpConvoyResult(char*& buf,GS2U_GiveUpConvoyResult& value);

struct GS2U_ConvoyNoticeTimerResult
{
    int8 isDead;
    int remainTime;
};
void WriteGS2U_ConvoyNoticeTimerResult(char*& buf,GS2U_ConvoyNoticeTimerResult& value);
void OnGS2U_ConvoyNoticeTimerResult(GS2U_ConvoyNoticeTimerResult* value);
void ReadGS2U_ConvoyNoticeTimerResult(char*& buf,GS2U_ConvoyNoticeTimerResult& value);

struct GS2U_ConvoyState
{
    int8 convoyFlags;
    int quality;
    int64 actorID;
};
void WriteGS2U_ConvoyState(char*& buf,GS2U_ConvoyState& value);
void OnGS2U_ConvoyState(GS2U_ConvoyState* value);
void ReadGS2U_ConvoyState(char*& buf,GS2U_ConvoyState& value);

struct GSWithU_GameSetMenu
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
	void Send();
};
void WriteGSWithU_GameSetMenu(char*& buf,GSWithU_GameSetMenu& value);
void OnGSWithU_GameSetMenu(GSWithU_GameSetMenu* value);
void ReadGSWithU_GameSetMenu(char*& buf,GSWithU_GameSetMenu& value);

struct U2GS_RequestRechargeGift
{
    int8 type;
	void Send();
};
void WriteU2GS_RequestRechargeGift(char*& buf,U2GS_RequestRechargeGift& value);
void ReadU2GS_RequestRechargeGift(char*& buf,U2GS_RequestRechargeGift& value);

struct U2GS_RequestRechargeGift_Ret
{
    int8 retcode;
};
void WriteU2GS_RequestRechargeGift_Ret(char*& buf,U2GS_RequestRechargeGift_Ret& value);
void OnU2GS_RequestRechargeGift_Ret(U2GS_RequestRechargeGift_Ret* value);
void ReadU2GS_RequestRechargeGift_Ret(char*& buf,U2GS_RequestRechargeGift_Ret& value);

struct U2GS_RequestPlayerFightingCapacity
{
	void Send();
};
void WriteU2GS_RequestPlayerFightingCapacity(char*& buf,U2GS_RequestPlayerFightingCapacity& value);
void ReadU2GS_RequestPlayerFightingCapacity(char*& buf,U2GS_RequestPlayerFightingCapacity& value);

struct U2GS_RequestPlayerFightingCapacity_Ret
{
    int fightingcapacity;
};
void WriteU2GS_RequestPlayerFightingCapacity_Ret(char*& buf,U2GS_RequestPlayerFightingCapacity_Ret& value);
void OnU2GS_RequestPlayerFightingCapacity_Ret(U2GS_RequestPlayerFightingCapacity_Ret* value);
void ReadU2GS_RequestPlayerFightingCapacity_Ret(char*& buf,U2GS_RequestPlayerFightingCapacity_Ret& value);

struct U2GS_RequestPetFightingCapacity
{
    int petid;
	void Send();
};
void WriteU2GS_RequestPetFightingCapacity(char*& buf,U2GS_RequestPetFightingCapacity& value);
void ReadU2GS_RequestPetFightingCapacity(char*& buf,U2GS_RequestPetFightingCapacity& value);

struct U2GS_RequestPetFightingCapacity_Ret
{
    int fightingcapacity;
};
void WriteU2GS_RequestPetFightingCapacity_Ret(char*& buf,U2GS_RequestPetFightingCapacity_Ret& value);
void OnU2GS_RequestPetFightingCapacity_Ret(U2GS_RequestPetFightingCapacity_Ret* value);
void ReadU2GS_RequestPetFightingCapacity_Ret(char*& buf,U2GS_RequestPetFightingCapacity_Ret& value);

struct U2GS_RequestMountFightingCapacity
{
    int mountid;
	void Send();
};
void WriteU2GS_RequestMountFightingCapacity(char*& buf,U2GS_RequestMountFightingCapacity& value);
void ReadU2GS_RequestMountFightingCapacity(char*& buf,U2GS_RequestMountFightingCapacity& value);

struct U2GS_RequestMountFightingCapacity_Ret
{
    int fightingcapacity;
};
void WriteU2GS_RequestMountFightingCapacity_Ret(char*& buf,U2GS_RequestMountFightingCapacity_Ret& value);
void OnU2GS_RequestMountFightingCapacity_Ret(U2GS_RequestMountFightingCapacity_Ret* value);
void ReadU2GS_RequestMountFightingCapacity_Ret(char*& buf,U2GS_RequestMountFightingCapacity_Ret& value);

struct VariantData
{
    int16 index;
    int value;
};
void WriteVariantData(char*& buf,VariantData& value);
void ReadVariantData(char*& buf,VariantData& value);

struct GS2U_VariantDataSet
{
    int8 variant_type;
    vector<VariantData> info_list;
};
void WriteGS2U_VariantDataSet(char*& buf,GS2U_VariantDataSet& value);
void OnGS2U_VariantDataSet(GS2U_VariantDataSet* value);
void ReadGS2U_VariantDataSet(char*& buf,GS2U_VariantDataSet& value);

struct U2GS_GetRankList
{
    int mapDataID;
	void Send();
};
void WriteU2GS_GetRankList(char*& buf,U2GS_GetRankList& value);
void ReadU2GS_GetRankList(char*& buf,U2GS_GetRankList& value);

struct GS2U_RankList
{
    int mapID;
    int rankNum;
    string name1;
    int harm1;
    string name2;
    int harm2;
    string name3;
    int harm3;
    string name4;
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
void WriteGS2U_RankList(char*& buf,GS2U_RankList& value);
void OnGS2U_RankList(GS2U_RankList* value);
void ReadGS2U_RankList(char*& buf,GS2U_RankList& value);

struct GS2U_WordBossCmd
{
    int m_iCmd;
    int m_iParam;
};
void WriteGS2U_WordBossCmd(char*& buf,GS2U_WordBossCmd& value);
void OnGS2U_WordBossCmd(GS2U_WordBossCmd* value);
void ReadGS2U_WordBossCmd(char*& buf,GS2U_WordBossCmd& value);

struct U2GS_ChangePlayerName
{
    int64 id;
    string name;
	void Send();
};
void WriteU2GS_ChangePlayerName(char*& buf,U2GS_ChangePlayerName& value);
void ReadU2GS_ChangePlayerName(char*& buf,U2GS_ChangePlayerName& value);

struct GS2U_ChangePlayerNameResult
{
    int retCode;
};
void WriteGS2U_ChangePlayerNameResult(char*& buf,GS2U_ChangePlayerNameResult& value);
void OnGS2U_ChangePlayerNameResult(GS2U_ChangePlayerNameResult* value);
void ReadGS2U_ChangePlayerNameResult(char*& buf,GS2U_ChangePlayerNameResult& value);

struct U2GS_SetProtectPwd
{
    int64 id;
    string oldpwd;
    string pwd;
	void Send();
};
void WriteU2GS_SetProtectPwd(char*& buf,U2GS_SetProtectPwd& value);
void ReadU2GS_SetProtectPwd(char*& buf,U2GS_SetProtectPwd& value);

struct GS2U_SetProtectPwdResult
{
    int retCode;
};
void WriteGS2U_SetProtectPwdResult(char*& buf,GS2U_SetProtectPwdResult& value);
void OnGS2U_SetProtectPwdResult(GS2U_SetProtectPwdResult* value);
void ReadGS2U_SetProtectPwdResult(char*& buf,GS2U_SetProtectPwdResult& value);

struct U2GS_HeartBeat
{
	void Send();
};
void WriteU2GS_HeartBeat(char*& buf,U2GS_HeartBeat& value);
void ReadU2GS_HeartBeat(char*& buf,U2GS_HeartBeat& value);

struct GS2U_CopyProgressUpdate
{
    int8 progress;
};
void WriteGS2U_CopyProgressUpdate(char*& buf,GS2U_CopyProgressUpdate& value);
void OnGS2U_CopyProgressUpdate(GS2U_CopyProgressUpdate* value);
void ReadGS2U_CopyProgressUpdate(char*& buf,GS2U_CopyProgressUpdate& value);

struct U2GS_QequestGiveGoldCheck
{
	void Send();
};
void WriteU2GS_QequestGiveGoldCheck(char*& buf,U2GS_QequestGiveGoldCheck& value);
void ReadU2GS_QequestGiveGoldCheck(char*& buf,U2GS_QequestGiveGoldCheck& value);

struct U2GS_StartGiveGold
{
	void Send();
};
void WriteU2GS_StartGiveGold(char*& buf,U2GS_StartGiveGold& value);
void ReadU2GS_StartGiveGold(char*& buf,U2GS_StartGiveGold& value);

struct U2GS_StartGiveGoldResult
{
    int8 goldType;
    int8 useCnt;
    int exp;
    int level;
    int awardMoney;
    int retCode;
};
void WriteU2GS_StartGiveGoldResult(char*& buf,U2GS_StartGiveGoldResult& value);
void OnU2GS_StartGiveGoldResult(U2GS_StartGiveGoldResult* value);
void ReadU2GS_StartGiveGoldResult(char*& buf,U2GS_StartGiveGoldResult& value);

struct U2GS_GoldLineInfo
{
    int8 useCnt;
    int exp;
    int level;
};
void WriteU2GS_GoldLineInfo(char*& buf,U2GS_GoldLineInfo& value);
void OnU2GS_GoldLineInfo(U2GS_GoldLineInfo* value);
void ReadU2GS_GoldLineInfo(char*& buf,U2GS_GoldLineInfo& value);

struct U2GS_GoldResetTimer
{
    int8 useCnt;
};
void WriteU2GS_GoldResetTimer(char*& buf,U2GS_GoldResetTimer& value);
void OnU2GS_GoldResetTimer(U2GS_GoldResetTimer* value);
void ReadU2GS_GoldResetTimer(char*& buf,U2GS_GoldResetTimer& value);

struct GS2U_CopyMapSAData
{
    int map_id;
    int killed_count;
    int8 finish_rate;
    int cost_time;
    int exp;
    int money;
    int8 level;
    int8 is_perfect;
};
void WriteGS2U_CopyMapSAData(char*& buf,GS2U_CopyMapSAData& value);
void OnGS2U_CopyMapSAData(GS2U_CopyMapSAData* value);
void ReadGS2U_CopyMapSAData(char*& buf,GS2U_CopyMapSAData& value);

struct TokenStoreItemData
{
    int64 id;
    int item_id;
    int price;
    int tokenType;
    int isbind;
};
void WriteTokenStoreItemData(char*& buf,TokenStoreItemData& value);
void ReadTokenStoreItemData(char*& buf,TokenStoreItemData& value);

struct GetTokenStoreItemListAck
{
    int store_id;
    vector<TokenStoreItemData> itemList;
};
void WriteGetTokenStoreItemListAck(char*& buf,GetTokenStoreItemListAck& value);
void OnGetTokenStoreItemListAck(GetTokenStoreItemListAck* value);
void ReadGetTokenStoreItemListAck(char*& buf,GetTokenStoreItemListAck& value);

struct RequestLookPlayer
{
    int64 playerID;
	void Send();
};
void WriteRequestLookPlayer(char*& buf,RequestLookPlayer& value);
void ReadRequestLookPlayer(char*& buf,RequestLookPlayer& value);

struct RequestLookPlayer_Result
{
    PlayerBaseInfo baseInfo;
    vector<CharPropertyData> propertyList;
    vector<PetProperty> petList;
    vector<PlayerEquipNetData> equipList;
    int fightCapacity;
};
void WriteRequestLookPlayer_Result(char*& buf,RequestLookPlayer_Result& value);
void OnRequestLookPlayer_Result(RequestLookPlayer_Result* value);
void ReadRequestLookPlayer_Result(char*& buf,RequestLookPlayer_Result& value);

struct RequestLookPlayerFailed_Result
{
    int8 result;
};
void WriteRequestLookPlayerFailed_Result(char*& buf,RequestLookPlayerFailed_Result& value);
void OnRequestLookPlayerFailed_Result(RequestLookPlayerFailed_Result* value);
void ReadRequestLookPlayerFailed_Result(char*& buf,RequestLookPlayerFailed_Result& value);

struct U2GS_PlayerClientInfo
{
    int64 playerid;
    string platform;
    string machine;
	void Send();
};
void WriteU2GS_PlayerClientInfo(char*& buf,U2GS_PlayerClientInfo& value);
void ReadU2GS_PlayerClientInfo(char*& buf,U2GS_PlayerClientInfo& value);

struct U2GS_RequestActiveCount
{
    int8 n;
	void Send();
};
void WriteU2GS_RequestActiveCount(char*& buf,U2GS_RequestActiveCount& value);
void ReadU2GS_RequestActiveCount(char*& buf,U2GS_RequestActiveCount& value);

struct ActiveCountData
{
    int daily_id;
    int count;
};
void WriteActiveCountData(char*& buf,ActiveCountData& value);
void ReadActiveCountData(char*& buf,ActiveCountData& value);

struct GS2U_ActiveCount
{
    int activeValue;
    vector<ActiveCountData> dailyList;
};
void WriteGS2U_ActiveCount(char*& buf,GS2U_ActiveCount& value);
void OnGS2U_ActiveCount(GS2U_ActiveCount* value);
void ReadGS2U_ActiveCount(char*& buf,GS2U_ActiveCount& value);

struct U2GS_RequestConvertActive
{
    int n;
	void Send();
};
void WriteU2GS_RequestConvertActive(char*& buf,U2GS_RequestConvertActive& value);
void ReadU2GS_RequestConvertActive(char*& buf,U2GS_RequestConvertActive& value);

struct GS2U_WhetherTransferOldRecharge
{
    int64 playerID;
    string name;
    int rechargeRmb;
};
void WriteGS2U_WhetherTransferOldRecharge(char*& buf,GS2U_WhetherTransferOldRecharge& value);
void OnGS2U_WhetherTransferOldRecharge(GS2U_WhetherTransferOldRecharge* value);
void ReadGS2U_WhetherTransferOldRecharge(char*& buf,GS2U_WhetherTransferOldRecharge& value);

struct U2GS_TransferOldRechargeToPlayer
{
    int64 playerId;
    int8 isTransfer;
	void Send();
};
void WriteU2GS_TransferOldRechargeToPlayer(char*& buf,U2GS_TransferOldRechargeToPlayer& value);
void ReadU2GS_TransferOldRechargeToPlayer(char*& buf,U2GS_TransferOldRechargeToPlayer& value);

struct GS2U_TransferOldRechargeResult
{
    int errorCode;
};
void WriteGS2U_TransferOldRechargeResult(char*& buf,GS2U_TransferOldRechargeResult& value);
void OnGS2U_TransferOldRechargeResult(GS2U_TransferOldRechargeResult* value);
void ReadGS2U_TransferOldRechargeResult(char*& buf,GS2U_TransferOldRechargeResult& value);

struct PlayerEquipActiveFailReason
{
    int reason;
};
void WritePlayerEquipActiveFailReason(char*& buf,PlayerEquipActiveFailReason& value);
void OnPlayerEquipActiveFailReason(PlayerEquipActiveFailReason* value);
void ReadPlayerEquipActiveFailReason(char*& buf,PlayerEquipActiveFailReason& value);

struct PlayerEquipMinLevelChange
{
    int64 playerid;
    int8 minEquipLevel;
};
void WritePlayerEquipMinLevelChange(char*& buf,PlayerEquipMinLevelChange& value);
void OnPlayerEquipMinLevelChange(PlayerEquipMinLevelChange* value);
void ReadPlayerEquipMinLevelChange(char*& buf,PlayerEquipMinLevelChange& value);

struct PlayerImportPassWord
{
    string passWord;
    int passWordType;
	void Send();
};
void WritePlayerImportPassWord(char*& buf,PlayerImportPassWord& value);
void ReadPlayerImportPassWord(char*& buf,PlayerImportPassWord& value);

struct PlayerImportPassWordResult
{
    int result;
};
void WritePlayerImportPassWordResult(char*& buf,PlayerImportPassWordResult& value);
void OnPlayerImportPassWordResult(PlayerImportPassWordResult* value);
void ReadPlayerImportPassWordResult(char*& buf,PlayerImportPassWordResult& value);

struct GS2U_UpdatePlayerGuildInfo
{
    int64 player_id;
    int64 guild_id;
    string guild_name;
    int8 guild_rank;
};
void WriteGS2U_UpdatePlayerGuildInfo(char*& buf,GS2U_UpdatePlayerGuildInfo& value);
void OnGS2U_UpdatePlayerGuildInfo(GS2U_UpdatePlayerGuildInfo* value);
void ReadGS2U_UpdatePlayerGuildInfo(char*& buf,GS2U_UpdatePlayerGuildInfo& value);

struct U2GS_RequestBazzarItemPrice
{
    int item_id;
	void Send();
};
void WriteU2GS_RequestBazzarItemPrice(char*& buf,U2GS_RequestBazzarItemPrice& value);
void ReadU2GS_RequestBazzarItemPrice(char*& buf,U2GS_RequestBazzarItemPrice& value);

struct U2GS_RequestBazzarItemPrice_Result
{
    vector<BazzarItem> item;
};
void WriteU2GS_RequestBazzarItemPrice_Result(char*& buf,U2GS_RequestBazzarItemPrice_Result& value);
void OnU2GS_RequestBazzarItemPrice_Result(U2GS_RequestBazzarItemPrice_Result* value);
void ReadU2GS_RequestBazzarItemPrice_Result(char*& buf,U2GS_RequestBazzarItemPrice_Result& value);

struct RequestChangeGoldPassWord
{
    string oldGoldPassWord;
    string newGoldPassWord;
    int status;
	void Send();
};
void WriteRequestChangeGoldPassWord(char*& buf,RequestChangeGoldPassWord& value);
void ReadRequestChangeGoldPassWord(char*& buf,RequestChangeGoldPassWord& value);

struct PlayerGoldPassWordChanged
{
    int result;
};
void WritePlayerGoldPassWordChanged(char*& buf,PlayerGoldPassWordChanged& value);
void OnPlayerGoldPassWordChanged(PlayerGoldPassWordChanged* value);
void ReadPlayerGoldPassWordChanged(char*& buf,PlayerGoldPassWordChanged& value);

struct PlayerImportGoldPassWordResult
{
    int result;
};
void WritePlayerImportGoldPassWordResult(char*& buf,PlayerImportGoldPassWordResult& value);
void OnPlayerImportGoldPassWordResult(PlayerImportGoldPassWordResult* value);
void ReadPlayerImportGoldPassWordResult(char*& buf,PlayerImportGoldPassWordResult& value);

struct PlayerGoldUnlockTimesChanged
{
    int unlockTimes;
};
void WritePlayerGoldUnlockTimesChanged(char*& buf,PlayerGoldUnlockTimesChanged& value);
void OnPlayerGoldUnlockTimesChanged(PlayerGoldUnlockTimesChanged* value);
void ReadPlayerGoldUnlockTimesChanged(char*& buf,PlayerGoldUnlockTimesChanged& value);

struct GS2U_LeftSmallMonsterNumber
{
    int16 leftMonsterNum;
};
void WriteGS2U_LeftSmallMonsterNumber(char*& buf,GS2U_LeftSmallMonsterNumber& value);
void OnGS2U_LeftSmallMonsterNumber(GS2U_LeftSmallMonsterNumber* value);
void ReadGS2U_LeftSmallMonsterNumber(char*& buf,GS2U_LeftSmallMonsterNumber& value);

struct GS2U_VipInfo
{
    int vipLevel;
    int vipTime;
    int vipTimeExpire;
    int vipTimeBuy;
};
void WriteGS2U_VipInfo(char*& buf,GS2U_VipInfo& value);
void OnGS2U_VipInfo(GS2U_VipInfo* value);
void ReadGS2U_VipInfo(char*& buf,GS2U_VipInfo& value);

struct GS2U_TellMapLineID
{
    int8 iLineID;
};
void WriteGS2U_TellMapLineID(char*& buf,GS2U_TellMapLineID& value);
void OnGS2U_TellMapLineID(GS2U_TellMapLineID* value);
void ReadGS2U_TellMapLineID(char*& buf,GS2U_TellMapLineID& value);

struct VIPPlayerOpenVIPStoreRequest
{
    int request;
	void Send();
};
void WriteVIPPlayerOpenVIPStoreRequest(char*& buf,VIPPlayerOpenVIPStoreRequest& value);
void ReadVIPPlayerOpenVIPStoreRequest(char*& buf,VIPPlayerOpenVIPStoreRequest& value);

struct VIPPlayerOpenVIPStoreFail
{
    int fail;
};
void WriteVIPPlayerOpenVIPStoreFail(char*& buf,VIPPlayerOpenVIPStoreFail& value);
void OnVIPPlayerOpenVIPStoreFail(VIPPlayerOpenVIPStoreFail* value);
void ReadVIPPlayerOpenVIPStoreFail(char*& buf,VIPPlayerOpenVIPStoreFail& value);

struct UpdateVIPLevelInfo
{
    int64 playerID;
    int8 vipLevel;
};
void WriteUpdateVIPLevelInfo(char*& buf,UpdateVIPLevelInfo& value);
void OnUpdateVIPLevelInfo(UpdateVIPLevelInfo* value);
void ReadUpdateVIPLevelInfo(char*& buf,UpdateVIPLevelInfo& value);

struct ActiveCodeRequest
{
    string active_code;
	void Send();
};
void WriteActiveCodeRequest(char*& buf,ActiveCodeRequest& value);
void ReadActiveCodeRequest(char*& buf,ActiveCodeRequest& value);

struct ActiveCodeResult
{
    int result;
};
void WriteActiveCodeResult(char*& buf,ActiveCodeResult& value);
void OnActiveCodeResult(ActiveCodeResult* value);
void ReadActiveCodeResult(char*& buf,ActiveCodeResult& value);

struct U2GS_RequestOutFightPetPropetry
{
    int8 n;
	void Send();
};
void WriteU2GS_RequestOutFightPetPropetry(char*& buf,U2GS_RequestOutFightPetPropetry& value);
void ReadU2GS_RequestOutFightPetPropetry(char*& buf,U2GS_RequestOutFightPetPropetry& value);

struct GS2U_RequestOutFightPetPropetryResult
{
    int64 pet_id;
    int attack;
    int defence;
    int hit;
    int dodge;
    int block;
    int tough;
    int crit;
    int crit_damage_rate;
    int attack_speed;
    int pierce;
    int ph_def;
    int fire_def;
    int ice_def;
    int elec_def;
    int poison_def;
    int coma_def;
    int hold_def;
    int silent_def;
    int move_def;
    int max_life;
};
void WriteGS2U_RequestOutFightPetPropetryResult(char*& buf,GS2U_RequestOutFightPetPropetryResult& value);
void OnGS2U_RequestOutFightPetPropetryResult(GS2U_RequestOutFightPetPropetryResult* value);
void ReadGS2U_RequestOutFightPetPropetryResult(char*& buf,GS2U_RequestOutFightPetPropetryResult& value);

struct PlayerDirMove
{
    int16 pos_x;
    int16 pos_y;
    int8 dir;
	void Send();
};
void WritePlayerDirMove(char*& buf,PlayerDirMove& value);
void ReadPlayerDirMove(char*& buf,PlayerDirMove& value);

struct PlayerDirMove_S2C
{
    int64 player_id;
    int16 pos_x;
    int16 pos_y;
    int8 dir;
};
void WritePlayerDirMove_S2C(char*& buf,PlayerDirMove_S2C& value);
void OnPlayerDirMove_S2C(PlayerDirMove_S2C* value);
void ReadPlayerDirMove_S2C(char*& buf,PlayerDirMove_S2C& value);

struct U2GS_EnRollCampusBattle
{
    int64 npcID;
    int16 battleID;
	void Send();
};
void WriteU2GS_EnRollCampusBattle(char*& buf,U2GS_EnRollCampusBattle& value);
void ReadU2GS_EnRollCampusBattle(char*& buf,U2GS_EnRollCampusBattle& value);

struct GSWithU_GameSetMenu_3
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
	void Send();
};
void WriteGSWithU_GameSetMenu_3(char*& buf,GSWithU_GameSetMenu_3& value);
void OnGSWithU_GameSetMenu_3(GSWithU_GameSetMenu_3* value);
void ReadGSWithU_GameSetMenu_3(char*& buf,GSWithU_GameSetMenu_3& value);

struct StartCompound
{
    int makeItemID;
    int8 compounBindedType;
    int8 isUseDoubleRule;
	void Send();
};
void WriteStartCompound(char*& buf,StartCompound& value);
void ReadStartCompound(char*& buf,StartCompound& value);

struct StartCompoundResult
{
    int8 retCode;
};
void WriteStartCompoundResult(char*& buf,StartCompoundResult& value);
void OnStartCompoundResult(StartCompoundResult* value);
void ReadStartCompoundResult(char*& buf,StartCompoundResult& value);

struct CompoundBaseInfo
{
    int exp;
    int level;
    int makeItemID;
};
void WriteCompoundBaseInfo(char*& buf,CompoundBaseInfo& value);
void OnCompoundBaseInfo(CompoundBaseInfo* value);
void ReadCompoundBaseInfo(char*& buf,CompoundBaseInfo& value);

struct RequestEquipFastUpQuality
{
    int equipId;
	void Send();
};
void WriteRequestEquipFastUpQuality(char*& buf,RequestEquipFastUpQuality& value);
void ReadRequestEquipFastUpQuality(char*& buf,RequestEquipFastUpQuality& value);

struct EquipQualityFastUPByTypeBack
{
    int result;
};
void WriteEquipQualityFastUPByTypeBack(char*& buf,EquipQualityFastUPByTypeBack& value);
void OnEquipQualityFastUPByTypeBack(EquipQualityFastUPByTypeBack* value);
void ReadEquipQualityFastUPByTypeBack(char*& buf,EquipQualityFastUPByTypeBack& value);

struct PlayerTeleportMove
{
    int16 pos_x;
    int16 pos_y;
	void Send();
};
void WritePlayerTeleportMove(char*& buf,PlayerTeleportMove& value);
void ReadPlayerTeleportMove(char*& buf,PlayerTeleportMove& value);

struct PlayerTeleportMove_S2C
{
    int64 player_id;
    int16 pos_x;
    int16 pos_y;
};
void WritePlayerTeleportMove_S2C(char*& buf,PlayerTeleportMove_S2C& value);
void OnPlayerTeleportMove_S2C(PlayerTeleportMove_S2C* value);
void ReadPlayerTeleportMove_S2C(char*& buf,PlayerTeleportMove_S2C& value);

struct U2GS_leaveCampusBattle
{
    int8 unUsed;
	void Send();
};
void WriteU2GS_leaveCampusBattle(char*& buf,U2GS_leaveCampusBattle& value);
void ReadU2GS_leaveCampusBattle(char*& buf,U2GS_leaveCampusBattle& value);

struct U2GS_LeaveBattleScene
{
    int8 unUsed;
	void Send();
};
void WriteU2GS_LeaveBattleScene(char*& buf,U2GS_LeaveBattleScene& value);
void ReadU2GS_LeaveBattleScene(char*& buf,U2GS_LeaveBattleScene& value);

struct battleResult
{
    string name;
    int8 campus;
    int16 killPlayerNum;
    int16 beenKiiledNum;
    int64 playerID;
    int harm;
    int harmed;
};
void WritebattleResult(char*& buf,battleResult& value);
void ReadbattleResult(char*& buf,battleResult& value);

struct BattleResultList
{
    vector<battleResult> resultList;
};
void WriteBattleResultList(char*& buf,BattleResultList& value);
void OnBattleResultList(BattleResultList* value);
void ReadBattleResultList(char*& buf,BattleResultList& value);

struct GS2U_BattleEnrollResult
{
    int8 enrollResult;
    int16 mapDataID;
};
void WriteGS2U_BattleEnrollResult(char*& buf,GS2U_BattleEnrollResult& value);
void OnGS2U_BattleEnrollResult(GS2U_BattleEnrollResult* value);
void ReadGS2U_BattleEnrollResult(char*& buf,GS2U_BattleEnrollResult& value);

struct U2GS_requestEnrollInfo
{
    int8 unUsed;
	void Send();
};
void WriteU2GS_requestEnrollInfo(char*& buf,U2GS_requestEnrollInfo& value);
void ReadU2GS_requestEnrollInfo(char*& buf,U2GS_requestEnrollInfo& value);

struct GS2U_sendEnrollInfo
{
    int16 enrollxuanzong;
    int16 enrolltianji;
};
void WriteGS2U_sendEnrollInfo(char*& buf,GS2U_sendEnrollInfo& value);
void OnGS2U_sendEnrollInfo(GS2U_sendEnrollInfo* value);
void ReadGS2U_sendEnrollInfo(char*& buf,GS2U_sendEnrollInfo& value);

struct GS2U_NowCanEnterBattle
{
    int16 battleID;
};
void WriteGS2U_NowCanEnterBattle(char*& buf,GS2U_NowCanEnterBattle& value);
void OnGS2U_NowCanEnterBattle(GS2U_NowCanEnterBattle* value);
void ReadGS2U_NowCanEnterBattle(char*& buf,GS2U_NowCanEnterBattle& value);

struct U2GS_SureEnterBattle
{
    int8 unUsed;
	void Send();
};
void WriteU2GS_SureEnterBattle(char*& buf,U2GS_SureEnterBattle& value);
void ReadU2GS_SureEnterBattle(char*& buf,U2GS_SureEnterBattle& value);

struct GS2U_EnterBattleResult
{
    int8 faileReason;
};
void WriteGS2U_EnterBattleResult(char*& buf,GS2U_EnterBattleResult& value);
void OnGS2U_EnterBattleResult(GS2U_EnterBattleResult* value);
void ReadGS2U_EnterBattleResult(char*& buf,GS2U_EnterBattleResult& value);

struct GS2U_BattleScore
{
    int16 xuanzongScore;
    int16 tianjiScore;
};
void WriteGS2U_BattleScore(char*& buf,GS2U_BattleScore& value);
void OnGS2U_BattleScore(GS2U_BattleScore* value);
void ReadGS2U_BattleScore(char*& buf,GS2U_BattleScore& value);

struct U2GS_RequestBattleResultList
{
    int8 unUsed;
	void Send();
};
void WriteU2GS_RequestBattleResultList(char*& buf,U2GS_RequestBattleResultList& value);
void ReadU2GS_RequestBattleResultList(char*& buf,U2GS_RequestBattleResultList& value);

struct GS2U_BattleEnd
{
    int8 unUsed;
};
void WriteGS2U_BattleEnd(char*& buf,GS2U_BattleEnd& value);
void OnGS2U_BattleEnd(GS2U_BattleEnd* value);
void ReadGS2U_BattleEnd(char*& buf,GS2U_BattleEnd& value);

struct GS2U_LeftOpenTime
{
    int leftOpenTime;
};
void WriteGS2U_LeftOpenTime(char*& buf,GS2U_LeftOpenTime& value);
void OnGS2U_LeftOpenTime(GS2U_LeftOpenTime* value);
void ReadGS2U_LeftOpenTime(char*& buf,GS2U_LeftOpenTime& value);

struct GS2U_HeartBeatAck
{
};
void WriteGS2U_HeartBeatAck(char*& buf,GS2U_HeartBeatAck& value);
void OnGS2U_HeartBeatAck(GS2U_HeartBeatAck* value);
void ReadGS2U_HeartBeatAck(char*& buf,GS2U_HeartBeatAck& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
