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

void WriteCharProperty(char*& buf,CharProperty& value)
{
    Writeint(buf,value.attack);
    Writeint(buf,value.defence);
    Writeint(buf,value.ph_def);
    Writeint(buf,value.fire_def);
    Writeint(buf,value.ice_def);
    Writeint(buf,value.elec_def);
    Writeint(buf,value.poison_def);
    Writeint(buf,value.max_life);
    Writeint(buf,value.life_recover);
    Writeint(buf,value.been_attack_recover);
    Writeint(buf,value.damage_recover);
    Writeint(buf,value.coma_def);
    Writeint(buf,value.hold_def);
    Writeint(buf,value.silent_def);
    Writeint(buf,value.move_def);
    Writeint(buf,value.hit);
    Writeint(buf,value.dodge);
    Writeint(buf,value.block);
    Writeint(buf,value.crit);
    Writeint(buf,value.pierce);
    Writeint(buf,value.attack_speed);
    Writeint(buf,value.tough);
    Writeint(buf,value.crit_damage_rate);
    Writeint(buf,value.block_dec_damage);
    Writeint(buf,value.phy_attack_rate);
    Writeint(buf,value.fire_attack_rate);
    Writeint(buf,value.ice_attack_rate);
    Writeint(buf,value.elec_attack_rate);
    Writeint(buf,value.poison_attack_rate);
    Writeint(buf,value.phy_def_rate);
    Writeint(buf,value.fire_def_rate);
    Writeint(buf,value.ice_def_rate);
    Writeint(buf,value.elec_def_rate);
    Writeint(buf,value.poison_def_rate);
    Writeint(buf,value.treat_rate);
    Writeint(buf,value.on_treat_rate);
    Writeint(buf,value.move_speed);
}
void ReadCharProperty(char*& buf,CharProperty& value)
{
    Readint(buf,value.attack);
    Readint(buf,value.defence);
    Readint(buf,value.ph_def);
    Readint(buf,value.fire_def);
    Readint(buf,value.ice_def);
    Readint(buf,value.elec_def);
    Readint(buf,value.poison_def);
    Readint(buf,value.max_life);
    Readint(buf,value.life_recover);
    Readint(buf,value.been_attack_recover);
    Readint(buf,value.damage_recover);
    Readint(buf,value.coma_def);
    Readint(buf,value.hold_def);
    Readint(buf,value.silent_def);
    Readint(buf,value.move_def);
    Readint(buf,value.hit);
    Readint(buf,value.dodge);
    Readint(buf,value.block);
    Readint(buf,value.crit);
    Readint(buf,value.pierce);
    Readint(buf,value.attack_speed);
    Readint(buf,value.tough);
    Readint(buf,value.crit_damage_rate);
    Readint(buf,value.block_dec_damage);
    Readint(buf,value.phy_attack_rate);
    Readint(buf,value.fire_attack_rate);
    Readint(buf,value.ice_attack_rate);
    Readint(buf,value.elec_attack_rate);
    Readint(buf,value.poison_attack_rate);
    Readint(buf,value.phy_def_rate);
    Readint(buf,value.fire_def_rate);
    Readint(buf,value.ice_def_rate);
    Readint(buf,value.elec_def_rate);
    Readint(buf,value.poison_def_rate);
    Readint(buf,value.treat_rate);
    Readint(buf,value.on_treat_rate);
    Readint(buf,value.move_speed);
}
void WriteObjectBuff(char*& buf,ObjectBuff& value)
{
    Writeint16(buf,value.buff_id);
    Writeint16(buf,value.allValidTime);
    Writeint8(buf,value.remainTriggerCount);
}
void ReadObjectBuff(char*& buf,ObjectBuff& value)
{
    Readint16(buf,value.buff_id);
    Readint16(buf,value.allValidTime);
    Readint8(buf,value.remainTriggerCount);
}
void WritePlayerBaseInfo(char*& buf,PlayerBaseInfo& value)
{
    Writeint64(buf,value.id);
    Writestring(buf,value.name);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint8(buf,value.sex);
    Writeint8(buf,value.face);
    Writeint8(buf,value.weapon);
    Writeint16(buf,value.level);
    Writeint8(buf,value.camp);
    Writeint8(buf,value.faction);
    Writeint8(buf,value.vip);
    Writeint16(buf,value.maxEnabledBagCells);
    Writeint16(buf,value.maxEnabledStorageBagCells);
    Writestring(buf,value.storageBagPassWord);
    Writeint(buf,value.unlockTimes);
    Writeint(buf,value.money);
    Writeint(buf,value.moneyBinded);
    Writeint(buf,value.gold);
    Writeint(buf,value.goldBinded);
    Writeint(buf,value.rechargeAmmount);
    Writeint(buf,value.ticket);
    Writeint(buf,value.guildContribute);
    Writeint(buf,value.honor);
    Writeint(buf,value.credit);
    Writeint(buf,value.exp);
    Writeint(buf,value.bloodPool);
    Writeint(buf,value.petBloodPool);
    Writeint(buf,value.life);
    Writeint(buf,value.lifeMax);
    Writeint64(buf,value.guildID);
    Writeint(buf,value.mountDataID);
    Writeint(buf,value.pK_Kill_RemainTime);
    Writeint(buf,value.exp15Add);
    Writeint(buf,value.exp20Add);
    Writeint(buf,value.exp30Add);
    Writeint(buf,value.pk_Kill_Value);
    Writeint8(buf,value.pkFlags);
    Writeint8(buf,value.minEquipLevel);
    Writestring(buf,value.guild_name);
    Writeint8(buf,value.guild_rank);
    Writestring(buf,value.goldPassWord);
}
void ReadPlayerBaseInfo(char*& buf,PlayerBaseInfo& value)
{
    Readint64(buf,value.id);
    Readstring(buf,value.name);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint8(buf,value.sex);
    Readint8(buf,value.face);
    Readint8(buf,value.weapon);
    Readint16(buf,value.level);
    Readint8(buf,value.camp);
    Readint8(buf,value.faction);
    Readint8(buf,value.vip);
    Readint16(buf,value.maxEnabledBagCells);
    Readint16(buf,value.maxEnabledStorageBagCells);
    Readstring(buf,value.storageBagPassWord);
    Readint(buf,value.unlockTimes);
    Readint(buf,value.money);
    Readint(buf,value.moneyBinded);
    Readint(buf,value.gold);
    Readint(buf,value.goldBinded);
    Readint(buf,value.rechargeAmmount);
    Readint(buf,value.ticket);
    Readint(buf,value.guildContribute);
    Readint(buf,value.honor);
    Readint(buf,value.credit);
    Readint(buf,value.exp);
    Readint(buf,value.bloodPool);
    Readint(buf,value.petBloodPool);
    Readint(buf,value.life);
    Readint(buf,value.lifeMax);
    Readint64(buf,value.guildID);
    Readint(buf,value.mountDataID);
    Readint(buf,value.pK_Kill_RemainTime);
    Readint(buf,value.exp15Add);
    Readint(buf,value.exp20Add);
    Readint(buf,value.exp30Add);
    Readint(buf,value.pk_Kill_Value);
    Readint8(buf,value.pkFlags);
    Readint8(buf,value.minEquipLevel);
    Readstring(buf,value.guild_name);
    Readint8(buf,value.guild_rank);
    Readstring(buf,value.goldPassWord);
}
void WriterideInfo(char*& buf,rideInfo& value)
{
    Writeint(buf,value.mountDataID);
    Writeint(buf,value.rideFlage);
}
void ReadrideInfo(char*& buf,rideInfo& value)
{
    Readint(buf,value.mountDataID);
    Readint(buf,value.rideFlage);
}
void WriteLookInfoPlayer(char*& buf,LookInfoPlayer& value)
{
    Writeint64(buf,value.id);
    Writestring(buf,value.name);
    Writeint8(buf,value.lifePercent);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint16(buf,value.move_target_x);
    Writeint16(buf,value.move_target_y);
    Writeint8(buf,value.move_dir);
    Writeint16(buf,value.move_speed);
    Writeint16(buf,value.level);
    Writeint(buf,value.value_flags);
    Writeint(buf,value.charState);
    Writeint16(buf,value.weapon);
    Writeint16(buf,value.coat);
    WriteArray(buf,ObjectBuff,value.buffList);
    Writeint8(buf,value.convoyFlags);
    Writeint64(buf,value.guild_id);
    Writestring(buf,value.guild_name);
    Writeint8(buf,value.guild_rank);
    Writeint8(buf,value.vip);
}
void ReadLookInfoPlayer(char*& buf,LookInfoPlayer& value)
{
    Readint64(buf,value.id);
    Readstring(buf,value.name);
    Readint8(buf,value.lifePercent);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint16(buf,value.move_target_x);
    Readint16(buf,value.move_target_y);
    Readint8(buf,value.move_dir);
    Readint16(buf,value.move_speed);
    Readint16(buf,value.level);
    Readint(buf,value.value_flags);
    Readint(buf,value.charState);
    Readint16(buf,value.weapon);
    Readint16(buf,value.coat);
    ReadArray(buf,ObjectBuff,value.buffList);
    Readint8(buf,value.convoyFlags);
    Readint64(buf,value.guild_id);
    Readstring(buf,value.guild_name);
    Readint8(buf,value.guild_rank);
    Readint8(buf,value.vip);
}
void WriteLookInfoPlayerList(char*& buf,LookInfoPlayerList& value)
{
    WriteArray(buf,LookInfoPlayer,value.info_list);
}
void ReadLookInfoPlayerList(char*& buf,LookInfoPlayerList& value)
{
    ReadArray(buf,LookInfoPlayer,value.info_list);
}
void WriteLookInfoPet(char*& buf,LookInfoPet& value)
{
    Writeint64(buf,value.id);
    Writeint64(buf,value.masterId);
    Writeint16(buf,value.data_id);
    Writestring(buf,value.name);
    Writeint16(buf,value.titleid);
    Writeint16(buf,value.modelId);
    Writeint8(buf,value.lifePercent);
    Writeint16(buf,value.level);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint16(buf,value.move_target_x);
    Writeint16(buf,value.move_target_y);
    Writeint16(buf,value.move_speed);
    Writeint(buf,value.charState);
    WriteArray(buf,ObjectBuff,value.buffList);
}
void ReadLookInfoPet(char*& buf,LookInfoPet& value)
{
    Readint64(buf,value.id);
    Readint64(buf,value.masterId);
    Readint16(buf,value.data_id);
    Readstring(buf,value.name);
    Readint16(buf,value.titleid);
    Readint16(buf,value.modelId);
    Readint8(buf,value.lifePercent);
    Readint16(buf,value.level);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint16(buf,value.move_target_x);
    Readint16(buf,value.move_target_y);
    Readint16(buf,value.move_speed);
    Readint(buf,value.charState);
    ReadArray(buf,ObjectBuff,value.buffList);
}
void WriteLookInfoPetList(char*& buf,LookInfoPetList& value)
{
    WriteArray(buf,LookInfoPet,value.info_list);
}
void ReadLookInfoPetList(char*& buf,LookInfoPetList& value)
{
    ReadArray(buf,LookInfoPet,value.info_list);
}
void WriteLookInfoMonster(char*& buf,LookInfoMonster& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.move_target_x);
    Writeint16(buf,value.move_target_y);
    Writeint16(buf,value.move_speed);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint16(buf,value.monster_data_id);
    Writeint8(buf,value.lifePercent);
    Writeint8(buf,value.faction);
    Writeint(buf,value.charState);
    WriteArray(buf,ObjectBuff,value.buffList);
}
void ReadLookInfoMonster(char*& buf,LookInfoMonster& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.move_target_x);
    Readint16(buf,value.move_target_y);
    Readint16(buf,value.move_speed);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint16(buf,value.monster_data_id);
    Readint8(buf,value.lifePercent);
    Readint8(buf,value.faction);
    Readint(buf,value.charState);
    ReadArray(buf,ObjectBuff,value.buffList);
}
void WriteLookInfoMonsterList(char*& buf,LookInfoMonsterList& value)
{
    WriteArray(buf,LookInfoMonster,value.info_list);
}
void ReadLookInfoMonsterList(char*& buf,LookInfoMonsterList& value)
{
    ReadArray(buf,LookInfoMonster,value.info_list);
}
void WriteLookInfoNpc(char*& buf,LookInfoNpc& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint16(buf,value.npc_data_id);
    Writeint16(buf,value.move_target_x);
    Writeint16(buf,value.move_target_y);
}
void ReadLookInfoNpc(char*& buf,LookInfoNpc& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint16(buf,value.npc_data_id);
    Readint16(buf,value.move_target_x);
    Readint16(buf,value.move_target_y);
}
void WriteLookInfoNpcList(char*& buf,LookInfoNpcList& value)
{
    WriteArray(buf,LookInfoNpc,value.info_list);
}
void ReadLookInfoNpcList(char*& buf,LookInfoNpcList& value)
{
    ReadArray(buf,LookInfoNpc,value.info_list);
}
void WriteLookInfoObject(char*& buf,LookInfoObject& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint16(buf,value.object_data_id);
    Writeint16(buf,value.object_type);
    Writeint(buf,value.param);
}
void ReadLookInfoObject(char*& buf,LookInfoObject& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint16(buf,value.object_data_id);
    Readint16(buf,value.object_type);
    Readint(buf,value.param);
}
void WriteLookInfoObjectList(char*& buf,LookInfoObjectList& value)
{
    WriteArray(buf,LookInfoObject,value.info_list);
}
void ReadLookInfoObjectList(char*& buf,LookInfoObjectList& value)
{
    ReadArray(buf,LookInfoObject,value.info_list);
}
void WriteActorDisapearList(char*& buf,ActorDisapearList& value)
{
    WriteArray(buf,int64,value.info_list);
}
void ReadActorDisapearList(char*& buf,ActorDisapearList& value)
{
    ReadArray(buf,int64,value.info_list);
}
void WritePosInfo(char*& buf,PosInfo& value)
{
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
}
void ReadPosInfo(char*& buf,PosInfo& value)
{
    Readint16(buf,value.x);
    Readint16(buf,value.y);
}
void WritePlayerMoveTo(char*& buf,PlayerMoveTo& value)
{
    Writeint16(buf,value.posX);
    Writeint16(buf,value.posY);
    WriteArray(buf,PosInfo,value.posInfos);
}
void PlayerMoveTo::Send(){
    BeginSend(PlayerMoveTo);
    WritePlayerMoveTo(buf,*this);
    EndSend();
}
void ReadPlayerMoveTo(char*& buf,PlayerMoveTo& value)
{
    Readint16(buf,value.posX);
    Readint16(buf,value.posY);
    ReadArray(buf,PosInfo,value.posInfos);
}
void WritePlayerStopMove(char*& buf,PlayerStopMove& value)
{
    Writeint16(buf,value.posX);
    Writeint16(buf,value.posY);
}
void PlayerStopMove::Send(){
    BeginSend(PlayerStopMove);
    WritePlayerStopMove(buf,*this);
    EndSend();
}
void ReadPlayerStopMove(char*& buf,PlayerStopMove& value)
{
    Readint16(buf,value.posX);
    Readint16(buf,value.posY);
}
void WritePlayerStopMove_S2C(char*& buf,PlayerStopMove_S2C& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.posX);
    Writeint16(buf,value.posY);
}
void ReadPlayerStopMove_S2C(char*& buf,PlayerStopMove_S2C& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.posX);
    Readint16(buf,value.posY);
}
void WriteMoveInfo(char*& buf,MoveInfo& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.posX);
    Writeint16(buf,value.posY);
    WriteArray(buf,PosInfo,value.posInfos);
}
void ReadMoveInfo(char*& buf,MoveInfo& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.posX);
    Readint16(buf,value.posY);
    ReadArray(buf,PosInfo,value.posInfos);
}
void WritePlayerMoveInfo(char*& buf,PlayerMoveInfo& value)
{
    WriteArray(buf,MoveInfo,value.ids);
}
void ReadPlayerMoveInfo(char*& buf,PlayerMoveInfo& value)
{
    ReadArray(buf,MoveInfo,value.ids);
}
void WriteChangeFlyState(char*& buf,ChangeFlyState& value)
{
    Writeint(buf,value.flyState);
}
void ChangeFlyState::Send(){
    BeginSend(ChangeFlyState);
    WriteChangeFlyState(buf,*this);
    EndSend();
}
void ReadChangeFlyState(char*& buf,ChangeFlyState& value)
{
    Readint(buf,value.flyState);
}
void WriteChangeFlyState_S2C(char*& buf,ChangeFlyState_S2C& value)
{
    Writeint64(buf,value.id);
    Writeint(buf,value.flyState);
}
void ReadChangeFlyState_S2C(char*& buf,ChangeFlyState_S2C& value)
{
    Readint64(buf,value.id);
    Readint(buf,value.flyState);
}
void WriteMonsterMoveInfo(char*& buf,MonsterMoveInfo& value)
{
    WriteArray(buf,MoveInfo,value.ids);
}
void ReadMonsterMoveInfo(char*& buf,MonsterMoveInfo& value)
{
    ReadArray(buf,MoveInfo,value.ids);
}
void WriteMonsterStopMove(char*& buf,MonsterStopMove& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
}
void ReadMonsterStopMove(char*& buf,MonsterStopMove& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
}
void WritePetMoveInfo(char*& buf,PetMoveInfo& value)
{
    WriteArray(buf,MoveInfo,value.ids);
}
void ReadPetMoveInfo(char*& buf,PetMoveInfo& value)
{
    ReadArray(buf,MoveInfo,value.ids);
}
void WritePetStopMove(char*& buf,PetStopMove& value)
{
    Writeint64(buf,value.id);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
}
void ReadPetStopMove(char*& buf,PetStopMove& value)
{
    Readint64(buf,value.id);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
}
void WriteChangeMap(char*& buf,ChangeMap& value)
{
    Writeint(buf,value.mapDataID);
    Writeint64(buf,value.mapId);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
}
void ChangeMap::Send(){
    BeginSend(ChangeMap);
    WriteChangeMap(buf,*this);
    EndSend();
}
void ReadChangeMap(char*& buf,ChangeMap& value)
{
    Readint(buf,value.mapDataID);
    Readint64(buf,value.mapId);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
}
void WriteCollectFail(char*& buf,CollectFail& value)
{
}
void ReadCollectFail(char*& buf,CollectFail& value)
{
}
void WriteRequestGM(char*& buf,RequestGM& value)
{
    Writestring(buf,value.strCMD);
}
void RequestGM::Send(){
    BeginSend(RequestGM);
    WriteRequestGM(buf,*this);
    EndSend();
}
void ReadRequestGM(char*& buf,RequestGM& value)
{
    Readstring(buf,value.strCMD);
}
void WritePlayerPropertyChangeValue(char*& buf,PlayerPropertyChangeValue& value)
{
    Writeint8(buf,value.proType);
    Writeint(buf,value.value);
}
void ReadPlayerPropertyChangeValue(char*& buf,PlayerPropertyChangeValue& value)
{
    Readint8(buf,value.proType);
    Readint(buf,value.value);
}
void WritePlayerPropertyChanged(char*& buf,PlayerPropertyChanged& value)
{
    WriteArray(buf,PlayerPropertyChangeValue,value.changeValues);
}
void ReadPlayerPropertyChanged(char*& buf,PlayerPropertyChanged& value)
{
    ReadArray(buf,PlayerPropertyChangeValue,value.changeValues);
}
void WritePlayerMoneyChanged(char*& buf,PlayerMoneyChanged& value)
{
    Writeint8(buf,value.changeReson);
    Writeint8(buf,value.moneyType);
    Writeint(buf,value.moneyValue);
}
void ReadPlayerMoneyChanged(char*& buf,PlayerMoneyChanged& value)
{
    Readint8(buf,value.changeReson);
    Readint8(buf,value.moneyType);
    Readint(buf,value.moneyValue);
}
void WritePlayerKickOuted(char*& buf,PlayerKickOuted& value)
{
    Writeint(buf,value.reserve);
}
void ReadPlayerKickOuted(char*& buf,PlayerKickOuted& value)
{
    Readint(buf,value.reserve);
}
void WriteActorStateFlagSet(char*& buf,ActorStateFlagSet& value)
{
    Writeint(buf,value.nSetStateFlag);
}
void ReadActorStateFlagSet(char*& buf,ActorStateFlagSet& value)
{
    Readint(buf,value.nSetStateFlag);
}
void WriteActorStateFlagSet_Broad(char*& buf,ActorStateFlagSet_Broad& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nSetStateFlag);
}
void ReadActorStateFlagSet_Broad(char*& buf,ActorStateFlagSet_Broad& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nSetStateFlag);
}
void WritePlayerSkillInitData(char*& buf,PlayerSkillInitData& value)
{
    Writeint16(buf,value.nSkillID);
    Writeint(buf,value.nCD);
    Writeint16(buf,value.nActiveBranch1);
    Writeint16(buf,value.nActiveBranch2);
    Writeint16(buf,value.nBindedBranch);
}
void ReadPlayerSkillInitData(char*& buf,PlayerSkillInitData& value)
{
    Readint16(buf,value.nSkillID);
    Readint(buf,value.nCD);
    Readint16(buf,value.nActiveBranch1);
    Readint16(buf,value.nActiveBranch2);
    Readint16(buf,value.nBindedBranch);
}
void WritePlayerSkillInitInfo(char*& buf,PlayerSkillInitInfo& value)
{
    WriteArray(buf,PlayerSkillInitData,value.info_list);
}
void ReadPlayerSkillInitInfo(char*& buf,PlayerSkillInitInfo& value)
{
    ReadArray(buf,PlayerSkillInitData,value.info_list);
}
void WriteU2GS_StudySkill(char*& buf,U2GS_StudySkill& value)
{
    Writeint(buf,value.nSkillID);
}
void U2GS_StudySkill::Send(){
    BeginSend(U2GS_StudySkill);
    WriteU2GS_StudySkill(buf,*this);
    EndSend();
}
void ReadU2GS_StudySkill(char*& buf,U2GS_StudySkill& value)
{
    Readint(buf,value.nSkillID);
}
void WriteGS2U_StudySkillResult(char*& buf,GS2U_StudySkillResult& value)
{
    Writeint(buf,value.nSkillID);
    Writeint(buf,value.nResult);
}
void ReadGS2U_StudySkillResult(char*& buf,GS2U_StudySkillResult& value)
{
    Readint(buf,value.nSkillID);
    Readint(buf,value.nResult);
}
void WriteactiveBranchID(char*& buf,activeBranchID& value)
{
    Writeint8(buf,value.nWhichBranch);
    Writeint(buf,value.nSkillID);
    Writeint(buf,value.branchID);
}
void activeBranchID::Send(){
    BeginSend(activeBranchID);
    WriteactiveBranchID(buf,*this);
    EndSend();
}
void ReadactiveBranchID(char*& buf,activeBranchID& value)
{
    Readint8(buf,value.nWhichBranch);
    Readint(buf,value.nSkillID);
    Readint(buf,value.branchID);
}
void WriteactiveBranchIDResult(char*& buf,activeBranchIDResult& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.nSkillID);
    Writeint(buf,value.branckID);
}
void ReadactiveBranchIDResult(char*& buf,activeBranchIDResult& value)
{
    Readint(buf,value.result);
    Readint(buf,value.nSkillID);
    Readint(buf,value.branckID);
}
void WriteU2GS_AddSkillBranch(char*& buf,U2GS_AddSkillBranch& value)
{
    Writeint(buf,value.nSkillID);
    Writeint(buf,value.nBranchID);
}
void U2GS_AddSkillBranch::Send(){
    BeginSend(U2GS_AddSkillBranch);
    WriteU2GS_AddSkillBranch(buf,*this);
    EndSend();
}
void ReadU2GS_AddSkillBranch(char*& buf,U2GS_AddSkillBranch& value)
{
    Readint(buf,value.nSkillID);
    Readint(buf,value.nBranchID);
}
void WriteGS2U_AddSkillBranchAck(char*& buf,GS2U_AddSkillBranchAck& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.nSkillID);
    Writeint(buf,value.nBranchID);
}
void ReadGS2U_AddSkillBranchAck(char*& buf,GS2U_AddSkillBranchAck& value)
{
    Readint(buf,value.result);
    Readint(buf,value.nSkillID);
    Readint(buf,value.nBranchID);
}
void WriteU2GS_UseSkillRequest(char*& buf,U2GS_UseSkillRequest& value)
{
    Writeint(buf,value.nSkillID);
    WriteArray(buf,int64,value.nTargetIDList);
    Writeint(buf,value.nCombatID);
}
void U2GS_UseSkillRequest::Send(){
    BeginSend(U2GS_UseSkillRequest);
    WriteU2GS_UseSkillRequest(buf,*this);
    EndSend();
}
void ReadU2GS_UseSkillRequest(char*& buf,U2GS_UseSkillRequest& value)
{
    Readint(buf,value.nSkillID);
    ReadArray(buf,int64,value.nTargetIDList);
    Readint(buf,value.nCombatID);
}
void WriteGS2U_UseSkillToObject(char*& buf,GS2U_UseSkillToObject& value)
{
    Writeint64(buf,value.nUserActorID);
    Writeint16(buf,value.nSkillID);
    WriteArray(buf,int64,value.nTargetActorIDList);
    Writeint(buf,value.nCombatID);
}
void ReadGS2U_UseSkillToObject(char*& buf,GS2U_UseSkillToObject& value)
{
    Readint64(buf,value.nUserActorID);
    Readint16(buf,value.nSkillID);
    ReadArray(buf,int64,value.nTargetActorIDList);
    Readint(buf,value.nCombatID);
}
void WriteGS2U_UseSkillToPos(char*& buf,GS2U_UseSkillToPos& value)
{
    Writeint64(buf,value.nUserActorID);
    Writeint16(buf,value.nSkillID);
    Writeint16(buf,value.x);
    Writeint16(buf,value.y);
    Writeint(buf,value.nCombatID);
    WriteArray(buf,int64,value.id_list);
}
void ReadGS2U_UseSkillToPos(char*& buf,GS2U_UseSkillToPos& value)
{
    Readint64(buf,value.nUserActorID);
    Readint16(buf,value.nSkillID);
    Readint16(buf,value.x);
    Readint16(buf,value.y);
    Readint(buf,value.nCombatID);
    ReadArray(buf,int64,value.id_list);
}
void WriteGS2U_AttackDamage(char*& buf,GS2U_AttackDamage& value)
{
    Writeint64(buf,value.nDamageTarget);
    Writeint(buf,value.nCombatID);
    Writeint16(buf,value.nSkillID);
    Writeint(buf,value.nDamageLife);
    Writeint8(buf,value.nTargetLifePer100);
    Writeint8(buf,value.isBlocked);
    Writeint8(buf,value.isCrited);
}
void ReadGS2U_AttackDamage(char*& buf,GS2U_AttackDamage& value)
{
    Readint64(buf,value.nDamageTarget);
    Readint(buf,value.nCombatID);
    Readint16(buf,value.nSkillID);
    Readint(buf,value.nDamageLife);
    Readint8(buf,value.nTargetLifePer100);
    Readint8(buf,value.isBlocked);
    Readint8(buf,value.isCrited);
}
void WriteGS2U_CharactorDead(char*& buf,GS2U_CharactorDead& value)
{
    Writeint64(buf,value.nDeadActorID);
    Writeint64(buf,value.nKiller);
    Writeint(buf,value.nCombatNumber);
}
void ReadGS2U_CharactorDead(char*& buf,GS2U_CharactorDead& value)
{
    Readint64(buf,value.nDeadActorID);
    Readint64(buf,value.nKiller);
    Readint(buf,value.nCombatNumber);
}
void WriteGS2U_AttackMiss(char*& buf,GS2U_AttackMiss& value)
{
    Writeint64(buf,value.nActorID);
    Writeint64(buf,value.nTargetID);
    Writeint(buf,value.nCombatID);
}
void ReadGS2U_AttackMiss(char*& buf,GS2U_AttackMiss& value)
{
    Readint64(buf,value.nActorID);
    Readint64(buf,value.nTargetID);
    Readint(buf,value.nCombatID);
}
void WriteGS2U_AttackDodge(char*& buf,GS2U_AttackDodge& value)
{
    Writeint64(buf,value.nActorID);
    Writeint64(buf,value.nTargetID);
    Writeint(buf,value.nCombatID);
}
void ReadGS2U_AttackDodge(char*& buf,GS2U_AttackDodge& value)
{
    Readint64(buf,value.nActorID);
    Readint64(buf,value.nTargetID);
    Readint(buf,value.nCombatID);
}
void WriteGS2U_AttackCrit(char*& buf,GS2U_AttackCrit& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nCombatID);
}
void ReadGS2U_AttackCrit(char*& buf,GS2U_AttackCrit& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nCombatID);
}
void WriteGS2U_AttackBlock(char*& buf,GS2U_AttackBlock& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nCombatID);
}
void ReadGS2U_AttackBlock(char*& buf,GS2U_AttackBlock& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nCombatID);
}
void WritePlayerAllShortcut(char*& buf,PlayerAllShortcut& value)
{
    Writeint(buf,value.index1ID);
    Writeint(buf,value.index2ID);
    Writeint(buf,value.index3ID);
    Writeint(buf,value.index4ID);
    Writeint(buf,value.index5ID);
    Writeint(buf,value.index6ID);
    Writeint(buf,value.index7ID);
    Writeint(buf,value.index8ID);
    Writeint(buf,value.index9ID);
    Writeint(buf,value.index10ID);
    Writeint(buf,value.index11ID);
    Writeint(buf,value.index12ID);
}
void ReadPlayerAllShortcut(char*& buf,PlayerAllShortcut& value)
{
    Readint(buf,value.index1ID);
    Readint(buf,value.index2ID);
    Readint(buf,value.index3ID);
    Readint(buf,value.index4ID);
    Readint(buf,value.index5ID);
    Readint(buf,value.index6ID);
    Readint(buf,value.index7ID);
    Readint(buf,value.index8ID);
    Readint(buf,value.index9ID);
    Readint(buf,value.index10ID);
    Readint(buf,value.index11ID);
    Readint(buf,value.index12ID);
}
void WriteShortcutSet(char*& buf,ShortcutSet& value)
{
    Writeint8(buf,value.index);
    Writeint(buf,value.data);
}
void ShortcutSet::Send(){
    BeginSend(ShortcutSet);
    WriteShortcutSet(buf,*this);
    EndSend();
}
void ReadShortcutSet(char*& buf,ShortcutSet& value)
{
    Readint8(buf,value.index);
    Readint(buf,value.data);
}
void WritePlayerEXPChanged(char*& buf,PlayerEXPChanged& value)
{
    Writeint(buf,value.curEXP);
    Writeint8(buf,value.changeReson);
}
void ReadPlayerEXPChanged(char*& buf,PlayerEXPChanged& value)
{
    Readint(buf,value.curEXP);
    Readint8(buf,value.changeReson);
}
void WriteActorLifeUpdate(char*& buf,ActorLifeUpdate& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nLife);
    Writeint(buf,value.nMaxLife);
}
void ReadActorLifeUpdate(char*& buf,ActorLifeUpdate& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nLife);
    Readint(buf,value.nMaxLife);
}
void WriteActorMoveSpeedUpdate(char*& buf,ActorMoveSpeedUpdate& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nSpeed);
}
void ReadActorMoveSpeedUpdate(char*& buf,ActorMoveSpeedUpdate& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nSpeed);
}
void WritePlayerCombatIDInit(char*& buf,PlayerCombatIDInit& value)
{
    Writeint(buf,value.nBeginCombatID);
}
void ReadPlayerCombatIDInit(char*& buf,PlayerCombatIDInit& value)
{
    Readint(buf,value.nBeginCombatID);
}
void WriteGS2U_CharactorRevived(char*& buf,GS2U_CharactorRevived& value)
{
    Writeint64(buf,value.nActorID);
    Writeint(buf,value.nLife);
    Writeint(buf,value.nMaxLife);
}
void ReadGS2U_CharactorRevived(char*& buf,GS2U_CharactorRevived& value)
{
    Readint64(buf,value.nActorID);
    Readint(buf,value.nLife);
    Readint(buf,value.nMaxLife);
}
void WriteU2GS_InteractObject(char*& buf,U2GS_InteractObject& value)
{
    Writeint64(buf,value.nActorID);
}
void U2GS_InteractObject::Send(){
    BeginSend(U2GS_InteractObject);
    WriteU2GS_InteractObject(buf,*this);
    EndSend();
}
void ReadU2GS_InteractObject(char*& buf,U2GS_InteractObject& value)
{
    Readint64(buf,value.nActorID);
}
void WriteU2GS_QueryHeroProperty(char*& buf,U2GS_QueryHeroProperty& value)
{
    Writeint8(buf,value.nReserve);
}
void U2GS_QueryHeroProperty::Send(){
    BeginSend(U2GS_QueryHeroProperty);
    WriteU2GS_QueryHeroProperty(buf,*this);
    EndSend();
}
void ReadU2GS_QueryHeroProperty(char*& buf,U2GS_QueryHeroProperty& value)
{
    Readint8(buf,value.nReserve);
}
void WriteCharPropertyData(char*& buf,CharPropertyData& value)
{
    Writeint8(buf,value.nPropertyType);
    Writeint(buf,value.nValue);
}
void ReadCharPropertyData(char*& buf,CharPropertyData& value)
{
    Readint8(buf,value.nPropertyType);
    Readint(buf,value.nValue);
}
void WriteGS2U_HeroPropertyResult(char*& buf,GS2U_HeroPropertyResult& value)
{
    WriteArray(buf,CharPropertyData,value.info_list);
}
void ReadGS2U_HeroPropertyResult(char*& buf,GS2U_HeroPropertyResult& value)
{
    ReadArray(buf,CharPropertyData,value.info_list);
}
void WriteItemInfo(char*& buf,ItemInfo& value)
{
    Writeint64(buf,value.id);
    Writeint8(buf,value.owner_type);
    Writeint64(buf,value.owner_id);
    Writeint8(buf,value.location);
    Writeint16(buf,value.cell);
    Writeint(buf,value.amount);
    Writeint(buf,value.item_data_id);
    Writeint(buf,value.param1);
    Writeint(buf,value.param2);
    Writeint8(buf,value.binded);
    Writeint(buf,value.remain_time);
}
void ReadItemInfo(char*& buf,ItemInfo& value)
{
    Readint64(buf,value.id);
    Readint8(buf,value.owner_type);
    Readint64(buf,value.owner_id);
    Readint8(buf,value.location);
    Readint16(buf,value.cell);
    Readint(buf,value.amount);
    Readint(buf,value.item_data_id);
    Readint(buf,value.param1);
    Readint(buf,value.param2);
    Readint8(buf,value.binded);
    Readint(buf,value.remain_time);
}
void WritePlayerBagInit(char*& buf,PlayerBagInit& value)
{
    WriteArray(buf,ItemInfo,value.items);
}
void ReadPlayerBagInit(char*& buf,PlayerBagInit& value)
{
    ReadArray(buf,ItemInfo,value.items);
}
void WritePlayerGetItem(char*& buf,PlayerGetItem& value)
{
    WriteItemInfo(buf,value.item_info);
}
void ReadPlayerGetItem(char*& buf,PlayerGetItem& value)
{
    ReadItemInfo(buf,value.item_info);
}
void WritePlayerDestroyItem(char*& buf,PlayerDestroyItem& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint8(buf,value.reson);
}
void ReadPlayerDestroyItem(char*& buf,PlayerDestroyItem& value)
{
    Readint64(buf,value.itemDBID);
    Readint8(buf,value.reson);
}
void WritePlayerItemLocationCellChanged(char*& buf,PlayerItemLocationCellChanged& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint8(buf,value.location);
    Writeint16(buf,value.cell);
}
void ReadPlayerItemLocationCellChanged(char*& buf,PlayerItemLocationCellChanged& value)
{
    Readint64(buf,value.itemDBID);
    Readint8(buf,value.location);
    Readint16(buf,value.cell);
}
void WriteRequestDestroyItem(char*& buf,RequestDestroyItem& value)
{
    Writeint64(buf,value.itemDBID);
}
void RequestDestroyItem::Send(){
    BeginSend(RequestDestroyItem);
    WriteRequestDestroyItem(buf,*this);
    EndSend();
}
void ReadRequestDestroyItem(char*& buf,RequestDestroyItem& value)
{
    Readint64(buf,value.itemDBID);
}
void WriteRequestGetItem(char*& buf,RequestGetItem& value)
{
    Writeint(buf,value.itemDataID);
    Writeint(buf,value.amount);
}
void RequestGetItem::Send(){
    BeginSend(RequestGetItem);
    WriteRequestGetItem(buf,*this);
    EndSend();
}
void ReadRequestGetItem(char*& buf,RequestGetItem& value)
{
    Readint(buf,value.itemDataID);
    Readint(buf,value.amount);
}
void WritePlayerItemAmountChanged(char*& buf,PlayerItemAmountChanged& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.amount);
    Writeint(buf,value.reson);
}
void ReadPlayerItemAmountChanged(char*& buf,PlayerItemAmountChanged& value)
{
    Readint64(buf,value.itemDBID);
    Readint(buf,value.amount);
    Readint(buf,value.reson);
}
void WritePlayerItemParamChanged(char*& buf,PlayerItemParamChanged& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.param1);
    Writeint(buf,value.param2);
    Writeint(buf,value.reson);
}
void ReadPlayerItemParamChanged(char*& buf,PlayerItemParamChanged& value)
{
    Readint64(buf,value.itemDBID);
    Readint(buf,value.param1);
    Readint(buf,value.param2);
    Readint(buf,value.reson);
}
void WritePlayerBagOrderData(char*& buf,PlayerBagOrderData& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.amount);
    Writeint(buf,value.cell);
}
void ReadPlayerBagOrderData(char*& buf,PlayerBagOrderData& value)
{
    Readint64(buf,value.itemDBID);
    Readint(buf,value.amount);
    Readint(buf,value.cell);
}
void WriteRequestPlayerBagOrder(char*& buf,RequestPlayerBagOrder& value)
{
    Writeint(buf,value.location);
}
void RequestPlayerBagOrder::Send(){
    BeginSend(RequestPlayerBagOrder);
    WriteRequestPlayerBagOrder(buf,*this);
    EndSend();
}
void ReadRequestPlayerBagOrder(char*& buf,RequestPlayerBagOrder& value)
{
    Readint(buf,value.location);
}
void WritePlayerBagOrderResult(char*& buf,PlayerBagOrderResult& value)
{
    Writeint(buf,value.location);
    Writeint(buf,value.cell);
}
void ReadPlayerBagOrderResult(char*& buf,PlayerBagOrderResult& value)
{
    Readint(buf,value.location);
    Readint(buf,value.cell);
}
void WritePlayerRequestUseItem(char*& buf,PlayerRequestUseItem& value)
{
    Writeint16(buf,value.location);
    Writeint16(buf,value.cell);
    Writeint16(buf,value.useCount);
}
void PlayerRequestUseItem::Send(){
    BeginSend(PlayerRequestUseItem);
    WritePlayerRequestUseItem(buf,*this);
    EndSend();
}
void ReadPlayerRequestUseItem(char*& buf,PlayerRequestUseItem& value)
{
    Readint16(buf,value.location);
    Readint16(buf,value.cell);
    Readint16(buf,value.useCount);
}
void WritePlayerUseItemResult(char*& buf,PlayerUseItemResult& value)
{
    Writeint16(buf,value.location);
    Writeint16(buf,value.cell);
    Writeint(buf,value.result);
}
void ReadPlayerUseItemResult(char*& buf,PlayerUseItemResult& value)
{
    Readint16(buf,value.location);
    Readint16(buf,value.cell);
    Readint(buf,value.result);
}
void WriteRequestPlayerBagCellOpen(char*& buf,RequestPlayerBagCellOpen& value)
{
    Writeint(buf,value.cell);
    Writeint(buf,value.location);
}
void RequestPlayerBagCellOpen::Send(){
    BeginSend(RequestPlayerBagCellOpen);
    WriteRequestPlayerBagCellOpen(buf,*this);
    EndSend();
}
void ReadRequestPlayerBagCellOpen(char*& buf,RequestPlayerBagCellOpen& value)
{
    Readint(buf,value.cell);
    Readint(buf,value.location);
}
void WriteRequestChangeStorageBagPassWord(char*& buf,RequestChangeStorageBagPassWord& value)
{
    Writestring(buf,value.oldStorageBagPassWord);
    Writestring(buf,value.newStorageBagPassWord);
    Writeint(buf,value.status);
}
void RequestChangeStorageBagPassWord::Send(){
    BeginSend(RequestChangeStorageBagPassWord);
    WriteRequestChangeStorageBagPassWord(buf,*this);
    EndSend();
}
void ReadRequestChangeStorageBagPassWord(char*& buf,RequestChangeStorageBagPassWord& value)
{
    Readstring(buf,value.oldStorageBagPassWord);
    Readstring(buf,value.newStorageBagPassWord);
    Readint(buf,value.status);
}
void WritePlayerStorageBagPassWordChanged(char*& buf,PlayerStorageBagPassWordChanged& value)
{
    Writeint(buf,value.result);
}
void ReadPlayerStorageBagPassWordChanged(char*& buf,PlayerStorageBagPassWordChanged& value)
{
    Readint(buf,value.result);
}
void WritePlayerBagCellEnableChanged(char*& buf,PlayerBagCellEnableChanged& value)
{
    Writeint(buf,value.cell);
    Writeint(buf,value.location);
    Writeint(buf,value.gold);
    Writeint(buf,value.item_count);
}
void ReadPlayerBagCellEnableChanged(char*& buf,PlayerBagCellEnableChanged& value)
{
    Readint(buf,value.cell);
    Readint(buf,value.location);
    Readint(buf,value.gold);
    Readint(buf,value.item_count);
}
void WriteRequestPlayerBagSellItem(char*& buf,RequestPlayerBagSellItem& value)
{
    Writeint(buf,value.cell);
}
void RequestPlayerBagSellItem::Send(){
    BeginSend(RequestPlayerBagSellItem);
    WriteRequestPlayerBagSellItem(buf,*this);
    EndSend();
}
void ReadRequestPlayerBagSellItem(char*& buf,RequestPlayerBagSellItem& value)
{
    Readint(buf,value.cell);
}
void WriteRequestClearTempBag(char*& buf,RequestClearTempBag& value)
{
    Writeint(buf,value.reserve);
}
void RequestClearTempBag::Send(){
    BeginSend(RequestClearTempBag);
    WriteRequestClearTempBag(buf,*this);
    EndSend();
}
void ReadRequestClearTempBag(char*& buf,RequestClearTempBag& value)
{
    Readint(buf,value.reserve);
}
void WriteRequestMoveTempBagItem(char*& buf,RequestMoveTempBagItem& value)
{
    Writeint(buf,value.cell);
}
void RequestMoveTempBagItem::Send(){
    BeginSend(RequestMoveTempBagItem);
    WriteRequestMoveTempBagItem(buf,*this);
    EndSend();
}
void ReadRequestMoveTempBagItem(char*& buf,RequestMoveTempBagItem& value)
{
    Readint(buf,value.cell);
}
void WriteRequestMoveAllTempBagItem(char*& buf,RequestMoveAllTempBagItem& value)
{
    Writeint(buf,value.reserve);
}
void RequestMoveAllTempBagItem::Send(){
    BeginSend(RequestMoveAllTempBagItem);
    WriteRequestMoveAllTempBagItem(buf,*this);
    EndSend();
}
void ReadRequestMoveAllTempBagItem(char*& buf,RequestMoveAllTempBagItem& value)
{
    Readint(buf,value.reserve);
}
void WriteRequestMoveStorageBagItem(char*& buf,RequestMoveStorageBagItem& value)
{
    Writeint(buf,value.cell);
}
void RequestMoveStorageBagItem::Send(){
    BeginSend(RequestMoveStorageBagItem);
    WriteRequestMoveStorageBagItem(buf,*this);
    EndSend();
}
void ReadRequestMoveStorageBagItem(char*& buf,RequestMoveStorageBagItem& value)
{
    Readint(buf,value.cell);
}
void WriteRequestMoveBagItemToStorage(char*& buf,RequestMoveBagItemToStorage& value)
{
    Writeint(buf,value.cell);
}
void RequestMoveBagItemToStorage::Send(){
    BeginSend(RequestMoveBagItemToStorage);
    WriteRequestMoveBagItemToStorage(buf,*this);
    EndSend();
}
void ReadRequestMoveBagItemToStorage(char*& buf,RequestMoveBagItemToStorage& value)
{
    Readint(buf,value.cell);
}
void WriteRequestUnlockingStorageBagPassWord(char*& buf,RequestUnlockingStorageBagPassWord& value)
{
    Writeint(buf,value.passWordType);
}
void RequestUnlockingStorageBagPassWord::Send(){
    BeginSend(RequestUnlockingStorageBagPassWord);
    WriteRequestUnlockingStorageBagPassWord(buf,*this);
    EndSend();
}
void ReadRequestUnlockingStorageBagPassWord(char*& buf,RequestUnlockingStorageBagPassWord& value)
{
    Readint(buf,value.passWordType);
}
void WriteRequestCancelUnlockingStorageBagPassWord(char*& buf,RequestCancelUnlockingStorageBagPassWord& value)
{
    Writeint(buf,value.passWordType);
}
void RequestCancelUnlockingStorageBagPassWord::Send(){
    BeginSend(RequestCancelUnlockingStorageBagPassWord);
    WriteRequestCancelUnlockingStorageBagPassWord(buf,*this);
    EndSend();
}
void ReadRequestCancelUnlockingStorageBagPassWord(char*& buf,RequestCancelUnlockingStorageBagPassWord& value)
{
    Readint(buf,value.passWordType);
}
void WritePlayerUnlockTimesChanged(char*& buf,PlayerUnlockTimesChanged& value)
{
    Writeint(buf,value.unlockTimes);
}
void ReadPlayerUnlockTimesChanged(char*& buf,PlayerUnlockTimesChanged& value)
{
    Readint(buf,value.unlockTimes);
}
void WriteItemBagCellSetData(char*& buf,ItemBagCellSetData& value)
{
    Writeint(buf,value.location);
    Writeint(buf,value.cell);
    Writeint64(buf,value.itemDBID);
}
void ReadItemBagCellSetData(char*& buf,ItemBagCellSetData& value)
{
    Readint(buf,value.location);
    Readint(buf,value.cell);
    Readint64(buf,value.itemDBID);
}
void WriteItemBagCellSet(char*& buf,ItemBagCellSet& value)
{
    WriteArray(buf,ItemBagCellSetData,value.cells);
}
void ReadItemBagCellSet(char*& buf,ItemBagCellSet& value)
{
    ReadArray(buf,ItemBagCellSetData,value.cells);
}
void WriteNpcStoreItemData(char*& buf,NpcStoreItemData& value)
{
    Writeint64(buf,value.id);
    Writeint(buf,value.item_id);
    Writeint(buf,value.price);
    Writeint(buf,value.isbind);
}
void ReadNpcStoreItemData(char*& buf,NpcStoreItemData& value)
{
    Readint64(buf,value.id);
    Readint(buf,value.item_id);
    Readint(buf,value.price);
    Readint(buf,value.isbind);
}
void WriteRequestGetNpcStoreItemList(char*& buf,RequestGetNpcStoreItemList& value)
{
    Writeint(buf,value.store_id);
}
void RequestGetNpcStoreItemList::Send(){
    BeginSend(RequestGetNpcStoreItemList);
    WriteRequestGetNpcStoreItemList(buf,*this);
    EndSend();
}
void ReadRequestGetNpcStoreItemList(char*& buf,RequestGetNpcStoreItemList& value)
{
    Readint(buf,value.store_id);
}
void WriteGetNpcStoreItemListAck(char*& buf,GetNpcStoreItemListAck& value)
{
    Writeint(buf,value.store_id);
    WriteArray(buf,NpcStoreItemData,value.itemList);
}
void ReadGetNpcStoreItemListAck(char*& buf,GetNpcStoreItemListAck& value)
{
    Readint(buf,value.store_id);
    ReadArray(buf,NpcStoreItemData,value.itemList);
}
void WriteRequestBuyItem(char*& buf,RequestBuyItem& value)
{
    Writeint(buf,value.item_id);
    Writeint(buf,value.amount);
    Writeint(buf,value.store_id);
}
void RequestBuyItem::Send(){
    BeginSend(RequestBuyItem);
    WriteRequestBuyItem(buf,*this);
    EndSend();
}
void ReadRequestBuyItem(char*& buf,RequestBuyItem& value)
{
    Readint(buf,value.item_id);
    Readint(buf,value.amount);
    Readint(buf,value.store_id);
}
void WriteBuyItemAck(char*& buf,BuyItemAck& value)
{
    Writeint(buf,value.count);
}
void ReadBuyItemAck(char*& buf,BuyItemAck& value)
{
    Readint(buf,value.count);
}
void WriteRequestSellItem(char*& buf,RequestSellItem& value)
{
    Writeint64(buf,value.item_cell);
}
void RequestSellItem::Send(){
    BeginSend(RequestSellItem);
    WriteRequestSellItem(buf,*this);
    EndSend();
}
void ReadRequestSellItem(char*& buf,RequestSellItem& value)
{
    Readint64(buf,value.item_cell);
}
void WriteGetNpcStoreBackBuyItemList(char*& buf,GetNpcStoreBackBuyItemList& value)
{
    Writeint(buf,value.count);
}
void GetNpcStoreBackBuyItemList::Send(){
    BeginSend(GetNpcStoreBackBuyItemList);
    WriteGetNpcStoreBackBuyItemList(buf,*this);
    EndSend();
}
void ReadGetNpcStoreBackBuyItemList(char*& buf,GetNpcStoreBackBuyItemList& value)
{
    Readint(buf,value.count);
}
void WriteGetNpcStoreBackBuyItemListAck(char*& buf,GetNpcStoreBackBuyItemListAck& value)
{
    WriteArray(buf,ItemInfo,value.itemList);
}
void ReadGetNpcStoreBackBuyItemListAck(char*& buf,GetNpcStoreBackBuyItemListAck& value)
{
    ReadArray(buf,ItemInfo,value.itemList);
}
void WriteRequestBackBuyItem(char*& buf,RequestBackBuyItem& value)
{
    Writeint64(buf,value.item_id);
}
void RequestBackBuyItem::Send(){
    BeginSend(RequestBackBuyItem);
    WriteRequestBackBuyItem(buf,*this);
    EndSend();
}
void ReadRequestBackBuyItem(char*& buf,RequestBackBuyItem& value)
{
    Readint64(buf,value.item_id);
}
void WritePlayerEquipNetData(char*& buf,PlayerEquipNetData& value)
{
    Writeint(buf,value.dbID);
    Writeint(buf,value.nEquip);
    Writeint8(buf,value.type);
    Writeint8(buf,value.nQuality);
    Writeint8(buf,value.isEquiped);
    Writeint16(buf,value.enhanceLevel);
    Writeint8(buf,value.property1Type);
    Writeint8(buf,value.property1FixOrPercent);
    Writeint(buf,value.property1Value);
    Writeint8(buf,value.property2Type);
    Writeint8(buf,value.property2FixOrPercent);
    Writeint(buf,value.property2Value);
    Writeint8(buf,value.property3Type);
    Writeint8(buf,value.property3FixOrPercent);
    Writeint(buf,value.property3Value);
    Writeint8(buf,value.property4Type);
    Writeint8(buf,value.property4FixOrPercent);
    Writeint(buf,value.property4Value);
    Writeint8(buf,value.property5Type);
    Writeint8(buf,value.property5FixOrPercent);
    Writeint(buf,value.property5Value);
}
void ReadPlayerEquipNetData(char*& buf,PlayerEquipNetData& value)
{
    Readint(buf,value.dbID);
    Readint(buf,value.nEquip);
    Readint8(buf,value.type);
    Readint8(buf,value.nQuality);
    Readint8(buf,value.isEquiped);
    Readint16(buf,value.enhanceLevel);
    Readint8(buf,value.property1Type);
    Readint8(buf,value.property1FixOrPercent);
    Readint(buf,value.property1Value);
    Readint8(buf,value.property2Type);
    Readint8(buf,value.property2FixOrPercent);
    Readint(buf,value.property2Value);
    Readint8(buf,value.property3Type);
    Readint8(buf,value.property3FixOrPercent);
    Readint(buf,value.property3Value);
    Readint8(buf,value.property4Type);
    Readint8(buf,value.property4FixOrPercent);
    Readint(buf,value.property4Value);
    Readint8(buf,value.property5Type);
    Readint8(buf,value.property5FixOrPercent);
    Readint(buf,value.property5Value);
}
void WritePlayerEquipInit(char*& buf,PlayerEquipInit& value)
{
    WriteArray(buf,PlayerEquipNetData,value.equips);
}
void ReadPlayerEquipInit(char*& buf,PlayerEquipInit& value)
{
    ReadArray(buf,PlayerEquipNetData,value.equips);
}
void WriteRequestPlayerEquipActive(char*& buf,RequestPlayerEquipActive& value)
{
    Writeint(buf,value.equip_data_id);
}
void RequestPlayerEquipActive::Send(){
    BeginSend(RequestPlayerEquipActive);
    WriteRequestPlayerEquipActive(buf,*this);
    EndSend();
}
void ReadRequestPlayerEquipActive(char*& buf,RequestPlayerEquipActive& value)
{
    Readint(buf,value.equip_data_id);
}
void WritePlayerEquipActiveResult(char*& buf,PlayerEquipActiveResult& value)
{
    WritePlayerEquipNetData(buf,value.equip);
}
void ReadPlayerEquipActiveResult(char*& buf,PlayerEquipActiveResult& value)
{
    ReadPlayerEquipNetData(buf,value.equip);
}
void WriteRequestPlayerEquipPutOn(char*& buf,RequestPlayerEquipPutOn& value)
{
    Writeint(buf,value.equip_dbID);
}
void RequestPlayerEquipPutOn::Send(){
    BeginSend(RequestPlayerEquipPutOn);
    WriteRequestPlayerEquipPutOn(buf,*this);
    EndSend();
}
void ReadRequestPlayerEquipPutOn(char*& buf,RequestPlayerEquipPutOn& value)
{
    Readint(buf,value.equip_dbID);
}
void WritePlayerEquipPutOnResult(char*& buf,PlayerEquipPutOnResult& value)
{
    Writeint(buf,value.equip_dbID);
    Writeint8(buf,value.equiped);
}
void ReadPlayerEquipPutOnResult(char*& buf,PlayerEquipPutOnResult& value)
{
    Readint(buf,value.equip_dbID);
    Readint8(buf,value.equiped);
}
void WriteRequestQueryPlayerEquip(char*& buf,RequestQueryPlayerEquip& value)
{
    Writeint64(buf,value.playerid);
}
void RequestQueryPlayerEquip::Send(){
    BeginSend(RequestQueryPlayerEquip);
    WriteRequestQueryPlayerEquip(buf,*this);
    EndSend();
}
void ReadRequestQueryPlayerEquip(char*& buf,RequestQueryPlayerEquip& value)
{
    Readint64(buf,value.playerid);
}
void WriteQueryPlayerEquipResult(char*& buf,QueryPlayerEquipResult& value)
{
    WriteArray(buf,PlayerEquipNetData,value.equips);
}
void ReadQueryPlayerEquipResult(char*& buf,QueryPlayerEquipResult& value)
{
    ReadArray(buf,PlayerEquipNetData,value.equips);
}
void WriteStudySkill(char*& buf,StudySkill& value)
{
    Writeint(buf,value.id);
    Writeint(buf,value.lvl);
}
void StudySkill::Send(){
    BeginSend(StudySkill);
    WriteStudySkill(buf,*this);
    EndSend();
}
void ReadStudySkill(char*& buf,StudySkill& value)
{
    Readint(buf,value.id);
    Readint(buf,value.lvl);
}
void WriteStudyResult(char*& buf,StudyResult& value)
{
    Writeint8(buf,value.result);
    Writeint(buf,value.id);
    Writeint(buf,value.lvl);
}
void ReadStudyResult(char*& buf,StudyResult& value)
{
    Readint8(buf,value.result);
    Readint(buf,value.id);
    Readint(buf,value.lvl);
}
void WriteReborn(char*& buf,Reborn& value)
{
    Writeint8(buf,value.type);
}
void Reborn::Send(){
    BeginSend(Reborn);
    WriteReborn(buf,*this);
    EndSend();
}
void ReadReborn(char*& buf,Reborn& value)
{
    Readint8(buf,value.type);
}
void WriteRebornAck(char*& buf,RebornAck& value)
{
    Writeint(buf,value.x);
    Writeint(buf,value.y);
}
void ReadRebornAck(char*& buf,RebornAck& value)
{
    Readint(buf,value.x);
    Readint(buf,value.y);
}
void WriteChat2Player(char*& buf,Chat2Player& value)
{
    Writeint8(buf,value.channel);
    Writeint64(buf,value.sendID);
    Writeint64(buf,value.receiveID);
    Writestring(buf,value.sendName);
    Writestring(buf,value.receiveName);
    Writestring(buf,value.content);
    Writeint8(buf,value.vipLevel);
}
void ReadChat2Player(char*& buf,Chat2Player& value)
{
    Readint8(buf,value.channel);
    Readint64(buf,value.sendID);
    Readint64(buf,value.receiveID);
    Readstring(buf,value.sendName);
    Readstring(buf,value.receiveName);
    Readstring(buf,value.content);
    Readint8(buf,value.vipLevel);
}
void WriteChat2Server(char*& buf,Chat2Server& value)
{
    Writeint8(buf,value.channel);
    Writeint64(buf,value.sendID);
    Writeint64(buf,value.receiveID);
    Writestring(buf,value.sendName);
    Writestring(buf,value.receiveName);
    Writestring(buf,value.content);
}
void Chat2Server::Send(){
    BeginSend(Chat2Server);
    WriteChat2Server(buf,*this);
    EndSend();
}
void ReadChat2Server(char*& buf,Chat2Server& value)
{
    Readint8(buf,value.channel);
    Readint64(buf,value.sendID);
    Readint64(buf,value.receiveID);
    Readstring(buf,value.sendName);
    Readstring(buf,value.receiveName);
    Readstring(buf,value.content);
}
void WriteChat_Error_Result(char*& buf,Chat_Error_Result& value)
{
    Writeint(buf,value.reason);
}
void ReadChat_Error_Result(char*& buf,Chat_Error_Result& value)
{
    Readint(buf,value.reason);
}
void WriteRequestSendMail(char*& buf,RequestSendMail& value)
{
    Writeint64(buf,value.targetPlayerID);
    Writestring(buf,value.targetPlayerName);
    Writestring(buf,value.strTitle);
    Writestring(buf,value.strContent);
    Writeint64(buf,value.attachItemDBID1);
    Writeint(buf,value.attachItem1Cnt);
    Writeint64(buf,value.attachItemDBID2);
    Writeint(buf,value.attachItem2Cnt);
    Writeint(buf,value.moneySend);
    Writeint(buf,value.moneyPay);
}
void RequestSendMail::Send(){
    BeginSend(RequestSendMail);
    WriteRequestSendMail(buf,*this);
    EndSend();
}
void ReadRequestSendMail(char*& buf,RequestSendMail& value)
{
    Readint64(buf,value.targetPlayerID);
    Readstring(buf,value.targetPlayerName);
    Readstring(buf,value.strTitle);
    Readstring(buf,value.strContent);
    Readint64(buf,value.attachItemDBID1);
    Readint(buf,value.attachItem1Cnt);
    Readint64(buf,value.attachItemDBID2);
    Readint(buf,value.attachItem2Cnt);
    Readint(buf,value.moneySend);
    Readint(buf,value.moneyPay);
}
void WriteRequestSendMailAck(char*& buf,RequestSendMailAck& value)
{
    Writeint8(buf,value.result);
}
void ReadRequestSendMailAck(char*& buf,RequestSendMailAck& value)
{
    Readint8(buf,value.result);
}
void WriteRequestRecvMail(char*& buf,RequestRecvMail& value)
{
    Writeint64(buf,value.mailID);
    Writeint(buf,value.deleteMail);
}
void RequestRecvMail::Send(){
    BeginSend(RequestRecvMail);
    WriteRequestRecvMail(buf,*this);
    EndSend();
}
void ReadRequestRecvMail(char*& buf,RequestRecvMail& value)
{
    Readint64(buf,value.mailID);
    Readint(buf,value.deleteMail);
}
void WriteRequestUnReadMail(char*& buf,RequestUnReadMail& value)
{
    Writeint64(buf,value.playerID);
}
void RequestUnReadMail::Send(){
    BeginSend(RequestUnReadMail);
    WriteRequestUnReadMail(buf,*this);
    EndSend();
}
void ReadRequestUnReadMail(char*& buf,RequestUnReadMail& value)
{
    Readint64(buf,value.playerID);
}
void WriteRequestUnReadMailAck(char*& buf,RequestUnReadMailAck& value)
{
    Writeint(buf,value.unReadCount);
}
void ReadRequestUnReadMailAck(char*& buf,RequestUnReadMailAck& value)
{
    Readint(buf,value.unReadCount);
}
void WriteRequestMailList(char*& buf,RequestMailList& value)
{
    Writeint64(buf,value.playerID);
}
void RequestMailList::Send(){
    BeginSend(RequestMailList);
    WriteRequestMailList(buf,*this);
    EndSend();
}
void ReadRequestMailList(char*& buf,RequestMailList& value)
{
    Readint64(buf,value.playerID);
}
void WriteMailInfo(char*& buf,MailInfo& value)
{
    Writeint64(buf,value.id);
    Writeint(buf,value.type);
    Writeint64(buf,value.recvPlayerID);
    Writeint(buf,value.isOpen);
    Writeint(buf,value.timeOut);
    Writeint(buf,value.senderType);
    Writestring(buf,value.senderName);
    Writestring(buf,value.title);
    Writestring(buf,value.content);
    Writeint8(buf,value.haveItem);
    Writeint(buf,value.moneySend);
    Writeint(buf,value.moneyPay);
    Writeint(buf,value.mailTimerType);
    Writeint(buf,value.mailRecTime);
}
void ReadMailInfo(char*& buf,MailInfo& value)
{
    Readint64(buf,value.id);
    Readint(buf,value.type);
    Readint64(buf,value.recvPlayerID);
    Readint(buf,value.isOpen);
    Readint(buf,value.timeOut);
    Readint(buf,value.senderType);
    Readstring(buf,value.senderName);
    Readstring(buf,value.title);
    Readstring(buf,value.content);
    Readint8(buf,value.haveItem);
    Readint(buf,value.moneySend);
    Readint(buf,value.moneyPay);
    Readint(buf,value.mailTimerType);
    Readint(buf,value.mailRecTime);
}
void WriteRequestMailListAck(char*& buf,RequestMailListAck& value)
{
    WriteArray(buf,MailInfo,value.mailList);
}
void ReadRequestMailListAck(char*& buf,RequestMailListAck& value)
{
    ReadArray(buf,MailInfo,value.mailList);
}
void WriteRequestMailItemInfo(char*& buf,RequestMailItemInfo& value)
{
    Writeint64(buf,value.mailID);
}
void RequestMailItemInfo::Send(){
    BeginSend(RequestMailItemInfo);
    WriteRequestMailItemInfo(buf,*this);
    EndSend();
}
void ReadRequestMailItemInfo(char*& buf,RequestMailItemInfo& value)
{
    Readint64(buf,value.mailID);
}
void WriteRequestMailItemInfoAck(char*& buf,RequestMailItemInfoAck& value)
{
    Writeint64(buf,value.mailID);
    WriteArray(buf,ItemInfo,value.mailItem);
}
void ReadRequestMailItemInfoAck(char*& buf,RequestMailItemInfoAck& value)
{
    Readint64(buf,value.mailID);
    ReadArray(buf,ItemInfo,value.mailItem);
}
void WriteRequestAcceptMailItem(char*& buf,RequestAcceptMailItem& value)
{
    Writeint64(buf,value.mailID);
    Writeint(buf,value.isDeleteMail);
}
void RequestAcceptMailItem::Send(){
    BeginSend(RequestAcceptMailItem);
    WriteRequestAcceptMailItem(buf,*this);
    EndSend();
}
void ReadRequestAcceptMailItem(char*& buf,RequestAcceptMailItem& value)
{
    Readint64(buf,value.mailID);
    Readint(buf,value.isDeleteMail);
}
void WriteRequestAcceptMailItemAck(char*& buf,RequestAcceptMailItemAck& value)
{
    Writeint(buf,value.result);
}
void ReadRequestAcceptMailItemAck(char*& buf,RequestAcceptMailItemAck& value)
{
    Readint(buf,value.result);
}
void WriteMailReadNotice(char*& buf,MailReadNotice& value)
{
    Writeint64(buf,value.mailID);
}
void MailReadNotice::Send(){
    BeginSend(MailReadNotice);
    WriteMailReadNotice(buf,*this);
    EndSend();
}
void ReadMailReadNotice(char*& buf,MailReadNotice& value)
{
    Readint64(buf,value.mailID);
}
void WriteRequestDeleteMail(char*& buf,RequestDeleteMail& value)
{
    Writeint64(buf,value.mailID);
}
void RequestDeleteMail::Send(){
    BeginSend(RequestDeleteMail);
    WriteRequestDeleteMail(buf,*this);
    EndSend();
}
void ReadRequestDeleteMail(char*& buf,RequestDeleteMail& value)
{
    Readint64(buf,value.mailID);
}
void WriteInformNewMail(char*& buf,InformNewMail& value)
{
}
void ReadInformNewMail(char*& buf,InformNewMail& value)
{
}
void WriteRequestDeleteReadMail(char*& buf,RequestDeleteReadMail& value)
{
    WriteArray(buf,int64,value.readMailID);
}
void RequestDeleteReadMail::Send(){
    BeginSend(RequestDeleteReadMail);
    WriteRequestDeleteReadMail(buf,*this);
    EndSend();
}
void ReadRequestDeleteReadMail(char*& buf,RequestDeleteReadMail& value)
{
    ReadArray(buf,int64,value.readMailID);
}
void WriteRequestSystemMail(char*& buf,RequestSystemMail& value)
{
}
void RequestSystemMail::Send(){
    BeginSend(RequestSystemMail);
    WriteRequestSystemMail(buf,*this);
    EndSend();
}
void ReadRequestSystemMail(char*& buf,RequestSystemMail& value)
{
}
void WriteU2GS_RequestLogin(char*& buf,U2GS_RequestLogin& value)
{
    Writeint64(buf,value.userID);
    Writestring(buf,value.identity);
    Writeint(buf,value.protocolVer);
}
void U2GS_RequestLogin::Send(){
    BeginSend(U2GS_RequestLogin);
    WriteU2GS_RequestLogin(buf,*this);
    EndSend();
}
void ReadU2GS_RequestLogin(char*& buf,U2GS_RequestLogin& value)
{
    Readint64(buf,value.userID);
    Readstring(buf,value.identity);
    Readint(buf,value.protocolVer);
}
void WriteU2GS_SelPlayerEnterGame(char*& buf,U2GS_SelPlayerEnterGame& value)
{
    Writeint64(buf,value.playerID);
}
void U2GS_SelPlayerEnterGame::Send(){
    BeginSend(U2GS_SelPlayerEnterGame);
    WriteU2GS_SelPlayerEnterGame(buf,*this);
    EndSend();
}
void ReadU2GS_SelPlayerEnterGame(char*& buf,U2GS_SelPlayerEnterGame& value)
{
    Readint64(buf,value.playerID);
}
void WriteU2GS_RequestCreatePlayer(char*& buf,U2GS_RequestCreatePlayer& value)
{
    Writestring(buf,value.name);
    Writeint8(buf,value.camp);
    Writeint8(buf,value.classValue);
    Writeint8(buf,value.sex);
}
void U2GS_RequestCreatePlayer::Send(){
    BeginSend(U2GS_RequestCreatePlayer);
    WriteU2GS_RequestCreatePlayer(buf,*this);
    EndSend();
}
void ReadU2GS_RequestCreatePlayer(char*& buf,U2GS_RequestCreatePlayer& value)
{
    Readstring(buf,value.name);
    Readint8(buf,value.camp);
    Readint8(buf,value.classValue);
    Readint8(buf,value.sex);
}
void WriteU2GS_RequestDeletePlayer(char*& buf,U2GS_RequestDeletePlayer& value)
{
    Writeint64(buf,value.playerID);
}
void U2GS_RequestDeletePlayer::Send(){
    BeginSend(U2GS_RequestDeletePlayer);
    WriteU2GS_RequestDeletePlayer(buf,*this);
    EndSend();
}
void ReadU2GS_RequestDeletePlayer(char*& buf,U2GS_RequestDeletePlayer& value)
{
    Readint64(buf,value.playerID);
}
void WriteGS2U_LoginResult(char*& buf,GS2U_LoginResult& value)
{
    Writeint(buf,value.result);
}
void ReadGS2U_LoginResult(char*& buf,GS2U_LoginResult& value)
{
    Readint(buf,value.result);
}
void WriteGS2U_SelPlayerResult(char*& buf,GS2U_SelPlayerResult& value)
{
    Writeint(buf,value.result);
}
void ReadGS2U_SelPlayerResult(char*& buf,GS2U_SelPlayerResult& value)
{
    Readint(buf,value.result);
}
void WriteUserPlayerData(char*& buf,UserPlayerData& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.name);
    Writeint(buf,value.level);
    Writeint8(buf,value.classValue);
    Writeint8(buf,value.sex);
    Writeint8(buf,value.faction);
}
void ReadUserPlayerData(char*& buf,UserPlayerData& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.name);
    Readint(buf,value.level);
    Readint8(buf,value.classValue);
    Readint8(buf,value.sex);
    Readint8(buf,value.faction);
}
void WriteGS2U_UserPlayerList(char*& buf,GS2U_UserPlayerList& value)
{
    WriteArray(buf,UserPlayerData,value.info);
}
void ReadGS2U_UserPlayerList(char*& buf,GS2U_UserPlayerList& value)
{
    ReadArray(buf,UserPlayerData,value.info);
}
void WriteGS2U_CreatePlayerResult(char*& buf,GS2U_CreatePlayerResult& value)
{
    Writeint(buf,value.errorCode);
}
void ReadGS2U_CreatePlayerResult(char*& buf,GS2U_CreatePlayerResult& value)
{
    Readint(buf,value.errorCode);
}
void WriteGS2U_DeletePlayerResult(char*& buf,GS2U_DeletePlayerResult& value)
{
    Writeint64(buf,value.playerID);
    Writeint(buf,value.errorCode);
}
void ReadGS2U_DeletePlayerResult(char*& buf,GS2U_DeletePlayerResult& value)
{
    Readint64(buf,value.playerID);
    Readint(buf,value.errorCode);
}
void WriteConSales_GroundingItem(char*& buf,ConSales_GroundingItem& value)
{
    Writeint64(buf,value.dbId);
    Writeint(buf,value.count);
    Writeint(buf,value.money);
    Writeint(buf,value.timeType,);
}
void ConSales_GroundingItem::Send(){
    BeginSend(ConSales_GroundingItem);
    WriteConSales_GroundingItem(buf,*this);
    EndSend();
}
void ReadConSales_GroundingItem(char*& buf,ConSales_GroundingItem& value)
{
    Readint64(buf,value.dbId);
    Readint(buf,value.count);
    Readint(buf,value.money);
    Readint(buf,value.timeType,);
}
void WriteConSales_GroundingItem_Result(char*& buf,ConSales_GroundingItem_Result& value)
{
    Writeint(buf,value.result);
}
void ReadConSales_GroundingItem_Result(char*& buf,ConSales_GroundingItem_Result& value)
{
    Readint(buf,value.result);
}
void WriteConSales_TakeDown(char*& buf,ConSales_TakeDown& value)
{
    Writeint64(buf,value.conSalesId);
}
void ConSales_TakeDown::Send(){
    BeginSend(ConSales_TakeDown);
    WriteConSales_TakeDown(buf,*this);
    EndSend();
}
void ReadConSales_TakeDown(char*& buf,ConSales_TakeDown& value)
{
    Readint64(buf,value.conSalesId);
}
void WriteConSales_TakeDown_Result(char*& buf,ConSales_TakeDown_Result& value)
{
    Writeint(buf,value.allTakeDown);
    Writeint(buf,value.result);
    Writeint(buf,value.protectTime);
}
void ReadConSales_TakeDown_Result(char*& buf,ConSales_TakeDown_Result& value)
{
    Readint(buf,value.allTakeDown);
    Readint(buf,value.result);
    Readint(buf,value.protectTime);
}
void WriteConSales_BuyItem(char*& buf,ConSales_BuyItem& value)
{
    Writeint64(buf,value.conSalesOderId);
}
void ConSales_BuyItem::Send(){
    BeginSend(ConSales_BuyItem);
    WriteConSales_BuyItem(buf,*this);
    EndSend();
}
void ReadConSales_BuyItem(char*& buf,ConSales_BuyItem& value)
{
    Readint64(buf,value.conSalesOderId);
}
void WriteConSales_BuyItem_Result(char*& buf,ConSales_BuyItem_Result& value)
{
    Writeint8(buf,value.result);
}
void ReadConSales_BuyItem_Result(char*& buf,ConSales_BuyItem_Result& value)
{
    Readint8(buf,value.result);
}
void WriteConSales_FindItems(char*& buf,ConSales_FindItems& value)
{
    Writeint(buf,value.offsetCount);
    Writeint8(buf,value.ignoreOption);
    Writeint8(buf,value.type);
    Writeint8(buf,value.detType);
    Writeint(buf,value.levelMin);
    Writeint(buf,value.levelMax);
    Writeint(buf,value.occ);
    Writeint(buf,value.quality);
    Writeint(buf,value.idLimit);
    WriteArray(buf,int,value.idList);
}
void ConSales_FindItems::Send(){
    BeginSend(ConSales_FindItems);
    WriteConSales_FindItems(buf,*this);
    EndSend();
}
void ReadConSales_FindItems(char*& buf,ConSales_FindItems& value)
{
    Readint(buf,value.offsetCount);
    Readint8(buf,value.ignoreOption);
    Readint8(buf,value.type);
    Readint8(buf,value.detType);
    Readint(buf,value.levelMin);
    Readint(buf,value.levelMax);
    Readint(buf,value.occ);
    Readint(buf,value.quality);
    Readint(buf,value.idLimit);
    ReadArray(buf,int,value.idList);
}
void WriteConSalesItem(char*& buf,ConSalesItem& value)
{
    Writeint64(buf,value.conSalesId);
    Writeint(buf,value.conSalesMoney);
    Writeint(buf,value.groundingTime);
    Writeint(buf,value.timeType);
    Writeint(buf,value.playerId);
    Writestring(buf,value.playerName);
    Writeint(buf,value.itemDBId);
    Writeint(buf,value.itemId);
    Writeint(buf,value.itemCount);
    Writeint(buf,value.itemType);
    Writeint(buf,value.itemQuality);
    Writeint(buf,value.itemLevel);
    Writeint(buf,value.itemOcc);
}
void ReadConSalesItem(char*& buf,ConSalesItem& value)
{
    Readint64(buf,value.conSalesId);
    Readint(buf,value.conSalesMoney);
    Readint(buf,value.groundingTime);
    Readint(buf,value.timeType);
    Readint(buf,value.playerId);
    Readstring(buf,value.playerName);
    Readint(buf,value.itemDBId);
    Readint(buf,value.itemId);
    Readint(buf,value.itemCount);
    Readint(buf,value.itemType);
    Readint(buf,value.itemQuality);
    Readint(buf,value.itemLevel);
    Readint(buf,value.itemOcc);
}
void WriteConSales_FindItems_Result(char*& buf,ConSales_FindItems_Result& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.allCount);
    Writeint(buf,value.page);
    WriteArray(buf,ConSalesItem,value.itemList);
}
void ReadConSales_FindItems_Result(char*& buf,ConSales_FindItems_Result& value)
{
    Readint(buf,value.result);
    Readint(buf,value.allCount);
    Readint(buf,value.page);
    ReadArray(buf,ConSalesItem,value.itemList);
}
void WriteConSales_TrunPage(char*& buf,ConSales_TrunPage& value)
{
    Writeint(buf,value.mode);
}
void ConSales_TrunPage::Send(){
    BeginSend(ConSales_TrunPage);
    WriteConSales_TrunPage(buf,*this);
    EndSend();
}
void ReadConSales_TrunPage(char*& buf,ConSales_TrunPage& value)
{
    Readint(buf,value.mode);
}
void WriteConSales_Close(char*& buf,ConSales_Close& value)
{
    Writeint(buf,value.n);
}
void ConSales_Close::Send(){
    BeginSend(ConSales_Close);
    WriteConSales_Close(buf,*this);
    EndSend();
}
void ReadConSales_Close(char*& buf,ConSales_Close& value)
{
    Readint(buf,value.n);
}
void WriteConSales_GetSelfSell(char*& buf,ConSales_GetSelfSell& value)
{
    Writeint(buf,value.n);
}
void ConSales_GetSelfSell::Send(){
    BeginSend(ConSales_GetSelfSell);
    WriteConSales_GetSelfSell(buf,*this);
    EndSend();
}
void ReadConSales_GetSelfSell(char*& buf,ConSales_GetSelfSell& value)
{
    Readint(buf,value.n);
}
void WriteConSales_GetSelfSell_Result(char*& buf,ConSales_GetSelfSell_Result& value)
{
    WriteArray(buf,ConSalesItem,value.itemList);
}
void ReadConSales_GetSelfSell_Result(char*& buf,ConSales_GetSelfSell_Result& value)
{
    ReadArray(buf,ConSalesItem,value.itemList);
}
void WriteTradeAsk(char*& buf,TradeAsk& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
}
void TradeAsk::Send(){
    BeginSend(TradeAsk);
    WriteTradeAsk(buf,*this);
    EndSend();
}
void ReadTradeAsk(char*& buf,TradeAsk& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
}
void WriteTradeAskResult(char*& buf,TradeAskResult& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
    Writeint8(buf,value.result);
}
void TradeAskResult::Send(){
    BeginSend(TradeAskResult);
    WriteTradeAskResult(buf,*this);
    EndSend();
}
void ReadTradeAskResult(char*& buf,TradeAskResult& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
    Readint8(buf,value.result);
}
void WriteCreateTrade(char*& buf,CreateTrade& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.playerName);
    Writeint8(buf,value.result);
}
void ReadCreateTrade(char*& buf,CreateTrade& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.playerName);
    Readint8(buf,value.result);
}
void WriteTradeInputItem_C2S(char*& buf,TradeInputItem_C2S& value)
{
    Writeint(buf,value.cell);
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.count);
}
void TradeInputItem_C2S::Send(){
    BeginSend(TradeInputItem_C2S);
    WriteTradeInputItem_C2S(buf,*this);
    EndSend();
}
void ReadTradeInputItem_C2S(char*& buf,TradeInputItem_C2S& value)
{
    Readint(buf,value.cell);
    Readint64(buf,value.itemDBID);
    Readint(buf,value.count);
}
void WriteTradeInputItemResult_S2C(char*& buf,TradeInputItemResult_S2C& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.item_data_id);
    Writeint(buf,value.count);
    Writeint(buf,value.cell);
    Writeint8(buf,value.result);
}
void ReadTradeInputItemResult_S2C(char*& buf,TradeInputItemResult_S2C& value)
{
    Readint64(buf,value.itemDBID);
    Readint(buf,value.item_data_id);
    Readint(buf,value.count);
    Readint(buf,value.cell);
    Readint8(buf,value.result);
}
void WriteTradeInputItem_S2C(char*& buf,TradeInputItem_S2C& value)
{
    Writeint64(buf,value.itemDBID);
    Writeint(buf,value.item_data_id);
    Writeint(buf,value.count);
}
void ReadTradeInputItem_S2C(char*& buf,TradeInputItem_S2C& value)
{
    Readint64(buf,value.itemDBID);
    Readint(buf,value.item_data_id);
    Readint(buf,value.count);
}
void WriteTradeTakeOutItem_C2S(char*& buf,TradeTakeOutItem_C2S& value)
{
    Writeint64(buf,value.itemDBID);
}
void TradeTakeOutItem_C2S::Send(){
    BeginSend(TradeTakeOutItem_C2S);
    WriteTradeTakeOutItem_C2S(buf,*this);
    EndSend();
}
void ReadTradeTakeOutItem_C2S(char*& buf,TradeTakeOutItem_C2S& value)
{
    Readint64(buf,value.itemDBID);
}
void WriteTradeTakeOutItemResult_S2C(char*& buf,TradeTakeOutItemResult_S2C& value)
{
    Writeint(buf,value.cell);
    Writeint64(buf,value.itemDBID);
    Writeint8(buf,value.result);
}
void ReadTradeTakeOutItemResult_S2C(char*& buf,TradeTakeOutItemResult_S2C& value)
{
    Readint(buf,value.cell);
    Readint64(buf,value.itemDBID);
    Readint8(buf,value.result);
}
void WriteTradeTakeOutItem_S2C(char*& buf,TradeTakeOutItem_S2C& value)
{
    Writeint64(buf,value.itemDBID);
}
void ReadTradeTakeOutItem_S2C(char*& buf,TradeTakeOutItem_S2C& value)
{
    Readint64(buf,value.itemDBID);
}
void WriteTradeChangeMoney_C2S(char*& buf,TradeChangeMoney_C2S& value)
{
    Writeint(buf,value.money);
}
void TradeChangeMoney_C2S::Send(){
    BeginSend(TradeChangeMoney_C2S);
    WriteTradeChangeMoney_C2S(buf,*this);
    EndSend();
}
void ReadTradeChangeMoney_C2S(char*& buf,TradeChangeMoney_C2S& value)
{
    Readint(buf,value.money);
}
void WriteTradeChangeMoneyResult_S2C(char*& buf,TradeChangeMoneyResult_S2C& value)
{
    Writeint(buf,value.money);
    Writeint8(buf,value.result);
}
void ReadTradeChangeMoneyResult_S2C(char*& buf,TradeChangeMoneyResult_S2C& value)
{
    Readint(buf,value.money);
    Readint8(buf,value.result);
}
void WriteTradeChangeMoney_S2C(char*& buf,TradeChangeMoney_S2C& value)
{
    Writeint(buf,value.money);
}
void ReadTradeChangeMoney_S2C(char*& buf,TradeChangeMoney_S2C& value)
{
    Readint(buf,value.money);
}
void WriteTradeLock_C2S(char*& buf,TradeLock_C2S& value)
{
    Writeint8(buf,value.lock);
}
void TradeLock_C2S::Send(){
    BeginSend(TradeLock_C2S);
    WriteTradeLock_C2S(buf,*this);
    EndSend();
}
void ReadTradeLock_C2S(char*& buf,TradeLock_C2S& value)
{
    Readint8(buf,value.lock);
}
void WriteTradeLock_S2C(char*& buf,TradeLock_S2C& value)
{
    Writeint8(buf,value.person);
    Writeint8(buf,value.lock);
}
void ReadTradeLock_S2C(char*& buf,TradeLock_S2C& value)
{
    Readint8(buf,value.person);
    Readint8(buf,value.lock);
}
void WriteCancelTrade_S2C(char*& buf,CancelTrade_S2C& value)
{
    Writeint8(buf,value.person);
    Writeint8(buf,value.reason);
}
void ReadCancelTrade_S2C(char*& buf,CancelTrade_S2C& value)
{
    Readint8(buf,value.person);
    Readint8(buf,value.reason);
}
void WriteCancelTrade_C2S(char*& buf,CancelTrade_C2S& value)
{
    Writeint8(buf,value.reason);
}
void CancelTrade_C2S::Send(){
    BeginSend(CancelTrade_C2S);
    WriteCancelTrade_C2S(buf,*this);
    EndSend();
}
void ReadCancelTrade_C2S(char*& buf,CancelTrade_C2S& value)
{
    Readint8(buf,value.reason);
}
void WriteTradeAffirm_C2S(char*& buf,TradeAffirm_C2S& value)
{
    Writeint(buf,value.bAffrim);
}
void TradeAffirm_C2S::Send(){
    BeginSend(TradeAffirm_C2S);
    WriteTradeAffirm_C2S(buf,*this);
    EndSend();
}
void ReadTradeAffirm_C2S(char*& buf,TradeAffirm_C2S& value)
{
    Readint(buf,value.bAffrim);
}
void WriteTradeAffirm_S2C(char*& buf,TradeAffirm_S2C& value)
{
    Writeint8(buf,value.person);
    Writeint8(buf,value.bAffirm);
}
void ReadTradeAffirm_S2C(char*& buf,TradeAffirm_S2C& value)
{
    Readint8(buf,value.person);
    Readint8(buf,value.bAffirm);
}
void WritePetSkill(char*& buf,PetSkill& value)
{
    Writeint64(buf,value.id);
    Writeint(buf,value.coolDownTime);
}
void ReadPetSkill(char*& buf,PetSkill& value)
{
    Readint64(buf,value.id);
    Readint(buf,value.coolDownTime);
}
void WritePetProperty(char*& buf,PetProperty& value)
{
    Writeint64(buf,value.db_id);
    Writeint(buf,value.data_id);
    Writeint64(buf,value.master_id);
    Writeint(buf,value.level);
    Writeint(buf,value.exp);
    Writestring(buf,value.name);
    Writeint(buf,value.titleId);
    Writeint8(buf,value.aiState);
    Writeint8(buf,value.showModel);
    Writeint(buf,value.exModelId);
    Writeint(buf,value.soulLevel);
    Writeint(buf,value.soulRate);
    Writeint(buf,value.attackGrowUp);
    Writeint(buf,value.defGrowUp);
    Writeint(buf,value.lifeGrowUp);
    Writeint8(buf,value.isWashGrow);
    Writeint(buf,value.attackGrowUpWash);
    Writeint(buf,value.defGrowUpWash);
    Writeint(buf,value.lifeGrowUpWash);
    Writeint(buf,value.convertRatio);
    Writeint(buf,value.exerciseLevel);
    Writeint(buf,value.moneyExrciseNum);
    Writeint(buf,value.exerciseExp);
    Writeint(buf,value.maxSkillNum);
    WriteArray(buf,PetSkill,value.skills);
    Writeint(buf,value.life);
    Writeint(buf,value.maxLife);
    Writeint(buf,value.attack);
    Writeint(buf,value.def);
    Writeint(buf,value.crit);
    Writeint(buf,value.block);
    Writeint(buf,value.hit);
    Writeint(buf,value.dodge);
    Writeint(buf,value.tough);
    Writeint(buf,value.pierce);
    Writeint(buf,value.crit_damage_rate);
    Writeint(buf,value.attack_speed);
    Writeint(buf,value.ph_def);
    Writeint(buf,value.fire_def);
    Writeint(buf,value.ice_def);
    Writeint(buf,value.elec_def);
    Writeint(buf,value.poison_def);
    Writeint(buf,value.coma_def);
    Writeint(buf,value.hold_def);
    Writeint(buf,value.silent_def);
    Writeint(buf,value.move_def);
    Writeint(buf,value.atkPowerGrowUp_Max);
    Writeint(buf,value.defClassGrowUp_Max);
    Writeint(buf,value.hpGrowUp_Max);
    Writeint(buf,value.benison_Value);
}
void ReadPetProperty(char*& buf,PetProperty& value)
{
    Readint64(buf,value.db_id);
    Readint(buf,value.data_id);
    Readint64(buf,value.master_id);
    Readint(buf,value.level);
    Readint(buf,value.exp);
    Readstring(buf,value.name);
    Readint(buf,value.titleId);
    Readint8(buf,value.aiState);
    Readint8(buf,value.showModel);
    Readint(buf,value.exModelId);
    Readint(buf,value.soulLevel);
    Readint(buf,value.soulRate);
    Readint(buf,value.attackGrowUp);
    Readint(buf,value.defGrowUp);
    Readint(buf,value.lifeGrowUp);
    Readint8(buf,value.isWashGrow);
    Readint(buf,value.attackGrowUpWash);
    Readint(buf,value.defGrowUpWash);
    Readint(buf,value.lifeGrowUpWash);
    Readint(buf,value.convertRatio);
    Readint(buf,value.exerciseLevel);
    Readint(buf,value.moneyExrciseNum);
    Readint(buf,value.exerciseExp);
    Readint(buf,value.maxSkillNum);
    ReadArray(buf,PetSkill,value.skills);
    Readint(buf,value.life);
    Readint(buf,value.maxLife);
    Readint(buf,value.attack);
    Readint(buf,value.def);
    Readint(buf,value.crit);
    Readint(buf,value.block);
    Readint(buf,value.hit);
    Readint(buf,value.dodge);
    Readint(buf,value.tough);
    Readint(buf,value.pierce);
    Readint(buf,value.crit_damage_rate);
    Readint(buf,value.attack_speed);
    Readint(buf,value.ph_def);
    Readint(buf,value.fire_def);
    Readint(buf,value.ice_def);
    Readint(buf,value.elec_def);
    Readint(buf,value.poison_def);
    Readint(buf,value.coma_def);
    Readint(buf,value.hold_def);
    Readint(buf,value.silent_def);
    Readint(buf,value.move_def);
    Readint(buf,value.atkPowerGrowUp_Max);
    Readint(buf,value.defClassGrowUp_Max);
    Readint(buf,value.hpGrowUp_Max);
    Readint(buf,value.benison_Value);
}
void WritePlayerPetInfo(char*& buf,PlayerPetInfo& value)
{
    WriteArray(buf,int,value.petSkillBag);
    WriteArray(buf,PetProperty,value.petInfos);
}
void ReadPlayerPetInfo(char*& buf,PlayerPetInfo& value)
{
    ReadArray(buf,int,value.petSkillBag);
    ReadArray(buf,PetProperty,value.petInfos);
}
void WriteUpdatePetProerty(char*& buf,UpdatePetProerty& value)
{
    WritePetProperty(buf,value.petInfo);
}
void ReadUpdatePetProerty(char*& buf,UpdatePetProerty& value)
{
    ReadPetProperty(buf,value.petInfo);
}
void WriteDelPet(char*& buf,DelPet& value)
{
    Writeint64(buf,value.petId);
}
void ReadDelPet(char*& buf,DelPet& value)
{
    Readint64(buf,value.petId);
}
void WritePetOutFight(char*& buf,PetOutFight& value)
{
    Writeint64(buf,value.petId);
}
void PetOutFight::Send(){
    BeginSend(PetOutFight);
    WritePetOutFight(buf,*this);
    EndSend();
}
void ReadPetOutFight(char*& buf,PetOutFight& value)
{
    Readint64(buf,value.petId);
}
void WritePetOutFight_Result(char*& buf,PetOutFight_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
}
void ReadPetOutFight_Result(char*& buf,PetOutFight_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
}
void WritePetTakeRest(char*& buf,PetTakeRest& value)
{
    Writeint64(buf,value.petId);
}
void PetTakeRest::Send(){
    BeginSend(PetTakeRest);
    WritePetTakeRest(buf,*this);
    EndSend();
}
void ReadPetTakeRest(char*& buf,PetTakeRest& value)
{
    Readint64(buf,value.petId);
}
void WritePetTakeRest_Result(char*& buf,PetTakeRest_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
}
void ReadPetTakeRest_Result(char*& buf,PetTakeRest_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
}
void WritePetFreeCaptiveAnimals(char*& buf,PetFreeCaptiveAnimals& value)
{
    Writeint64(buf,value.petId);
}
void PetFreeCaptiveAnimals::Send(){
    BeginSend(PetFreeCaptiveAnimals);
    WritePetFreeCaptiveAnimals(buf,*this);
    EndSend();
}
void ReadPetFreeCaptiveAnimals(char*& buf,PetFreeCaptiveAnimals& value)
{
    Readint64(buf,value.petId);
}
void WritePetFreeCaptiveAnimals_Result(char*& buf,PetFreeCaptiveAnimals_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
}
void ReadPetFreeCaptiveAnimals_Result(char*& buf,PetFreeCaptiveAnimals_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
}
void WritePetCompoundModel(char*& buf,PetCompoundModel& value)
{
    Writeint64(buf,value.petId);
}
void PetCompoundModel::Send(){
    BeginSend(PetCompoundModel);
    WritePetCompoundModel(buf,*this);
    EndSend();
}
void ReadPetCompoundModel(char*& buf,PetCompoundModel& value)
{
    Readint64(buf,value.petId);
}
void WritePetCompoundModel_Result(char*& buf,PetCompoundModel_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
}
void ReadPetCompoundModel_Result(char*& buf,PetCompoundModel_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
}
void WritePetWashGrowUpValue(char*& buf,PetWashGrowUpValue& value)
{
    Writeint64(buf,value.petId);
}
void PetWashGrowUpValue::Send(){
    BeginSend(PetWashGrowUpValue);
    WritePetWashGrowUpValue(buf,*this);
    EndSend();
}
void ReadPetWashGrowUpValue(char*& buf,PetWashGrowUpValue& value)
{
    Readint64(buf,value.petId);
}
void WritePetWashGrowUpValue_Result(char*& buf,PetWashGrowUpValue_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.attackGrowUp);
    Writeint(buf,value.defGrowUp);
    Writeint(buf,value.lifeGrowUp);
}
void ReadPetWashGrowUpValue_Result(char*& buf,PetWashGrowUpValue_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.attackGrowUp);
    Readint(buf,value.defGrowUp);
    Readint(buf,value.lifeGrowUp);
}
void WritePetReplaceGrowUpValue(char*& buf,PetReplaceGrowUpValue& value)
{
    Writeint64(buf,value.petId);
}
void PetReplaceGrowUpValue::Send(){
    BeginSend(PetReplaceGrowUpValue);
    WritePetReplaceGrowUpValue(buf,*this);
    EndSend();
}
void ReadPetReplaceGrowUpValue(char*& buf,PetReplaceGrowUpValue& value)
{
    Readint64(buf,value.petId);
}
void WritePetReplaceGrowUpValue_Result(char*& buf,PetReplaceGrowUpValue_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
}
void ReadPetReplaceGrowUpValue_Result(char*& buf,PetReplaceGrowUpValue_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
}
void WritePetIntensifySoul(char*& buf,PetIntensifySoul& value)
{
    Writeint64(buf,value.petId);
}
void PetIntensifySoul::Send(){
    BeginSend(PetIntensifySoul);
    WritePetIntensifySoul(buf,*this);
    EndSend();
}
void ReadPetIntensifySoul(char*& buf,PetIntensifySoul& value)
{
    Readint64(buf,value.petId);
}
void WritePetIntensifySoul_Result(char*& buf,PetIntensifySoul_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.soulLevel);
    Writeint(buf,value.soulRate);
    Writeint(buf,value.benison_Value);
}
void ReadPetIntensifySoul_Result(char*& buf,PetIntensifySoul_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.soulLevel);
    Readint(buf,value.soulRate);
    Readint(buf,value.benison_Value);
}
void WritePetOneKeyIntensifySoul(char*& buf,PetOneKeyIntensifySoul& value)
{
    Writeint64(buf,value.petId);
}
void PetOneKeyIntensifySoul::Send(){
    BeginSend(PetOneKeyIntensifySoul);
    WritePetOneKeyIntensifySoul(buf,*this);
    EndSend();
}
void ReadPetOneKeyIntensifySoul(char*& buf,PetOneKeyIntensifySoul& value)
{
    Readint64(buf,value.petId);
}
void WritePetOneKeyIntensifySoul_Result(char*& buf,PetOneKeyIntensifySoul_Result& value)
{
    Writeint64(buf,value.petId);
    Writeint8(buf,value.result);
    Writeint(buf,value.itemCount);
    Writeint(buf,value.money);
}
void ReadPetOneKeyIntensifySoul_Result(char*& buf,PetOneKeyIntensifySoul_Result& value)
{
    Readint64(buf,value.petId);
    Readint8(buf,value.result);
    Readint(buf,value.itemCount);
    Readint(buf,value.money);
}
void WritePetFuse(char*& buf,PetFuse& value)
{
    Writeint64(buf,value.petSrcId);
    Writeint64(buf,value.petDestId);
}
void PetFuse::Send(){
    BeginSend(PetFuse);
    WritePetFuse(buf,*this);
    EndSend();
}
void ReadPetFuse(char*& buf,PetFuse& value)
{
    Readint64(buf,value.petSrcId);
    Readint64(buf,value.petDestId);
}
void WritePetFuse_Result(char*& buf,PetFuse_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petSrcId);
    Writeint64(buf,value.petDestId);
}
void ReadPetFuse_Result(char*& buf,PetFuse_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petSrcId);
    Readint64(buf,value.petDestId);
}
void WritePetJumpTo(char*& buf,PetJumpTo& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.x);
    Writeint(buf,value.y);
}
void ReadPetJumpTo(char*& buf,PetJumpTo& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.x);
    Readint(buf,value.y);
}
void WriteActorSetPos(char*& buf,ActorSetPos& value)
{
    Writeint64(buf,value.actorId);
    Writeint(buf,value.x);
    Writeint(buf,value.y);
}
void ReadActorSetPos(char*& buf,ActorSetPos& value)
{
    Readint64(buf,value.actorId);
    Readint(buf,value.x);
    Readint(buf,value.y);
}
void WritePetTakeBack(char*& buf,PetTakeBack& value)
{
    Writeint64(buf,value.petId);
}
void ReadPetTakeBack(char*& buf,PetTakeBack& value)
{
    Readint64(buf,value.petId);
}
void WriteChangePetAIState(char*& buf,ChangePetAIState& value)
{
    Writeint8(buf,value.state);
}
void ChangePetAIState::Send(){
    BeginSend(ChangePetAIState);
    WriteChangePetAIState(buf,*this);
    EndSend();
}
void ReadChangePetAIState(char*& buf,ChangePetAIState& value)
{
    Readint8(buf,value.state);
}
void WritePetExpChanged(char*& buf,PetExpChanged& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.curExp);
    Writeint8(buf,value.reason);
}
void ReadPetExpChanged(char*& buf,PetExpChanged& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.curExp);
    Readint8(buf,value.reason);
}
void WritePetLearnSkill(char*& buf,PetLearnSkill& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillId);
}
void PetLearnSkill::Send(){
    BeginSend(PetLearnSkill);
    WritePetLearnSkill(buf,*this);
    EndSend();
}
void ReadPetLearnSkill(char*& buf,PetLearnSkill& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.skillId);
}
void WritePetLearnSkill_Result(char*& buf,PetLearnSkill_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.oldSkillId);
    Writeint(buf,value.newSkillId);
}
void ReadPetLearnSkill_Result(char*& buf,PetLearnSkill_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.oldSkillId);
    Readint(buf,value.newSkillId);
}
void WritePetDelSkill(char*& buf,PetDelSkill& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillId);
}
void PetDelSkill::Send(){
    BeginSend(PetDelSkill);
    WritePetDelSkill(buf,*this);
    EndSend();
}
void ReadPetDelSkill(char*& buf,PetDelSkill& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.skillId);
}
void WritePetDelSkill_Result(char*& buf,PetDelSkill_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillid);
}
void ReadPetDelSkill_Result(char*& buf,PetDelSkill_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.skillid);
}
void WritePetUnLockSkillCell(char*& buf,PetUnLockSkillCell& value)
{
    Writeint64(buf,value.petId);
}
void PetUnLockSkillCell::Send(){
    BeginSend(PetUnLockSkillCell);
    WritePetUnLockSkillCell(buf,*this);
    EndSend();
}
void ReadPetUnLockSkillCell(char*& buf,PetUnLockSkillCell& value)
{
    Readint64(buf,value.petId);
}
void WritePetUnLoctSkillCell_Result(char*& buf,PetUnLoctSkillCell_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.newSkillCellNum);
}
void ReadPetUnLoctSkillCell_Result(char*& buf,PetUnLoctSkillCell_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.newSkillCellNum);
}
void WritePetSkillSealAhs(char*& buf,PetSkillSealAhs& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillid);
}
void PetSkillSealAhs::Send(){
    BeginSend(PetSkillSealAhs);
    WritePetSkillSealAhs(buf,*this);
    EndSend();
}
void ReadPetSkillSealAhs(char*& buf,PetSkillSealAhs& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.skillid);
}
void WritePetSkillSealAhs_Result(char*& buf,PetSkillSealAhs_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillid);
}
void ReadPetSkillSealAhs_Result(char*& buf,PetSkillSealAhs_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.skillid);
}
void WritePetUpdateSealAhsStore(char*& buf,PetUpdateSealAhsStore& value)
{
    WriteArray(buf,int,value.petSkillBag);
}
void ReadPetUpdateSealAhsStore(char*& buf,PetUpdateSealAhsStore& value)
{
    ReadArray(buf,int,value.petSkillBag);
}
void WritePetlearnSealAhsSkill(char*& buf,PetlearnSealAhsSkill& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.skillId);
}
void PetlearnSealAhsSkill::Send(){
    BeginSend(PetlearnSealAhsSkill);
    WritePetlearnSealAhsSkill(buf,*this);
    EndSend();
}
void ReadPetlearnSealAhsSkill(char*& buf,PetlearnSealAhsSkill& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.skillId);
}
void WritePetlearnSealAhsSkill_Result(char*& buf,PetlearnSealAhsSkill_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writeint(buf,value.oldSkillId);
    Writeint(buf,value.newSkillId);
}
void ReadPetlearnSealAhsSkill_Result(char*& buf,PetlearnSealAhsSkill_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readint(buf,value.oldSkillId);
    Readint(buf,value.newSkillId);
}
void WriteRequestGetPlayerEquipEnhanceByType(char*& buf,RequestGetPlayerEquipEnhanceByType& value)
{
    Writeint(buf,value.type);
}
void RequestGetPlayerEquipEnhanceByType::Send(){
    BeginSend(RequestGetPlayerEquipEnhanceByType);
    WriteRequestGetPlayerEquipEnhanceByType(buf,*this);
    EndSend();
}
void ReadRequestGetPlayerEquipEnhanceByType(char*& buf,RequestGetPlayerEquipEnhanceByType& value)
{
    Readint(buf,value.type);
}
void WriteGetPlayerEquipEnhanceByTypeBack(char*& buf,GetPlayerEquipEnhanceByTypeBack& value)
{
    Writeint(buf,value.type);
    Writeint(buf,value.level);
    Writeint(buf,value.progress);
    Writeint(buf,value.blessValue);
}
void ReadGetPlayerEquipEnhanceByTypeBack(char*& buf,GetPlayerEquipEnhanceByTypeBack& value)
{
    Readint(buf,value.type);
    Readint(buf,value.level);
    Readint(buf,value.progress);
    Readint(buf,value.blessValue);
}
void WriteRequestEquipEnhanceByType(char*& buf,RequestEquipEnhanceByType& value)
{
    Writeint(buf,value.type);
}
void RequestEquipEnhanceByType::Send(){
    BeginSend(RequestEquipEnhanceByType);
    WriteRequestEquipEnhanceByType(buf,*this);
    EndSend();
}
void ReadRequestEquipEnhanceByType(char*& buf,RequestEquipEnhanceByType& value)
{
    Readint(buf,value.type);
}
void WriteEquipEnhanceByTypeBack(char*& buf,EquipEnhanceByTypeBack& value)
{
    Writeint(buf,value.result);
}
void ReadEquipEnhanceByTypeBack(char*& buf,EquipEnhanceByTypeBack& value)
{
    Readint(buf,value.result);
}
void WriteRequestEquipOnceEnhanceByType(char*& buf,RequestEquipOnceEnhanceByType& value)
{
    Writeint(buf,value.type);
}
void RequestEquipOnceEnhanceByType::Send(){
    BeginSend(RequestEquipOnceEnhanceByType);
    WriteRequestEquipOnceEnhanceByType(buf,*this);
    EndSend();
}
void ReadRequestEquipOnceEnhanceByType(char*& buf,RequestEquipOnceEnhanceByType& value)
{
    Readint(buf,value.type);
}
void WriteEquipOnceEnhanceByTypeBack(char*& buf,EquipOnceEnhanceByTypeBack& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.times);
    Writeint(buf,value.itemnumber);
    Writeint(buf,value.money);
}
void ReadEquipOnceEnhanceByTypeBack(char*& buf,EquipOnceEnhanceByTypeBack& value)
{
    Readint(buf,value.result);
    Readint(buf,value.times);
    Readint(buf,value.itemnumber);
    Readint(buf,value.money);
}
void WriteRequestGetPlayerEquipQualityByType(char*& buf,RequestGetPlayerEquipQualityByType& value)
{
    Writeint(buf,value.type);
}
void RequestGetPlayerEquipQualityByType::Send(){
    BeginSend(RequestGetPlayerEquipQualityByType);
    WriteRequestGetPlayerEquipQualityByType(buf,*this);
    EndSend();
}
void ReadRequestGetPlayerEquipQualityByType(char*& buf,RequestGetPlayerEquipQualityByType& value)
{
    Readint(buf,value.type);
}
void WriteGetPlayerEquipQualityByTypeBack(char*& buf,GetPlayerEquipQualityByTypeBack& value)
{
    Writeint(buf,value.type);
    Writeint(buf,value.quality);
}
void ReadGetPlayerEquipQualityByTypeBack(char*& buf,GetPlayerEquipQualityByTypeBack& value)
{
    Readint(buf,value.type);
    Readint(buf,value.quality);
}
void WriteRequestEquipQualityUPByType(char*& buf,RequestEquipQualityUPByType& value)
{
    Writeint(buf,value.type);
}
void RequestEquipQualityUPByType::Send(){
    BeginSend(RequestEquipQualityUPByType);
    WriteRequestEquipQualityUPByType(buf,*this);
    EndSend();
}
void ReadRequestEquipQualityUPByType(char*& buf,RequestEquipQualityUPByType& value)
{
    Readint(buf,value.type);
}
void WriteEquipQualityUPByTypeBack(char*& buf,EquipQualityUPByTypeBack& value)
{
    Writeint(buf,value.result);
}
void ReadEquipQualityUPByTypeBack(char*& buf,EquipQualityUPByTypeBack& value)
{
    Readint(buf,value.result);
}
void WriteRequestEquipOldPropertyByType(char*& buf,RequestEquipOldPropertyByType& value)
{
    Writeint(buf,value.type);
}
void RequestEquipOldPropertyByType::Send(){
    BeginSend(RequestEquipOldPropertyByType);
    WriteRequestEquipOldPropertyByType(buf,*this);
    EndSend();
}
void ReadRequestEquipOldPropertyByType(char*& buf,RequestEquipOldPropertyByType& value)
{
    Readint(buf,value.type);
}
void WriteGetEquipOldPropertyByType(char*& buf,GetEquipOldPropertyByType& value)
{
    Writeint(buf,value.type);
    Writeint8(buf,value.property1Type);
    Writeint8(buf,value.property1FixOrPercent);
    Writeint(buf,value.property1Value);
    Writeint8(buf,value.property2Type);
    Writeint8(buf,value.property2FixOrPercent);
    Writeint(buf,value.property2Value);
    Writeint8(buf,value.property3Type);
    Writeint8(buf,value.property3FixOrPercent);
    Writeint(buf,value.property3Value);
    Writeint8(buf,value.property4Type);
    Writeint8(buf,value.property4FixOrPercent);
    Writeint(buf,value.property4Value);
    Writeint8(buf,value.property5Type);
    Writeint8(buf,value.property5FixOrPercent);
    Writeint(buf,value.property5Value);
}
void ReadGetEquipOldPropertyByType(char*& buf,GetEquipOldPropertyByType& value)
{
    Readint(buf,value.type);
    Readint8(buf,value.property1Type);
    Readint8(buf,value.property1FixOrPercent);
    Readint(buf,value.property1Value);
    Readint8(buf,value.property2Type);
    Readint8(buf,value.property2FixOrPercent);
    Readint(buf,value.property2Value);
    Readint8(buf,value.property3Type);
    Readint8(buf,value.property3FixOrPercent);
    Readint(buf,value.property3Value);
    Readint8(buf,value.property4Type);
    Readint8(buf,value.property4FixOrPercent);
    Readint(buf,value.property4Value);
    Readint8(buf,value.property5Type);
    Readint8(buf,value.property5FixOrPercent);
    Readint(buf,value.property5Value);
}
void WriteRequestEquipChangePropertyByType(char*& buf,RequestEquipChangePropertyByType& value)
{
    Writeint(buf,value.type);
    Writeint8(buf,value.property1);
    Writeint8(buf,value.property2);
    Writeint8(buf,value.property3);
    Writeint8(buf,value.property4);
    Writeint8(buf,value.property5);
}
void RequestEquipChangePropertyByType::Send(){
    BeginSend(RequestEquipChangePropertyByType);
    WriteRequestEquipChangePropertyByType(buf,*this);
    EndSend();
}
void ReadRequestEquipChangePropertyByType(char*& buf,RequestEquipChangePropertyByType& value)
{
    Readint(buf,value.type);
    Readint8(buf,value.property1);
    Readint8(buf,value.property2);
    Readint8(buf,value.property3);
    Readint8(buf,value.property4);
    Readint8(buf,value.property5);
}
void WriteGetEquipNewPropertyByType(char*& buf,GetEquipNewPropertyByType& value)
{
    Writeint(buf,value.type);
    Writeint8(buf,value.property1Type);
    Writeint8(buf,value.property1FixOrPercent);
    Writeint(buf,value.property1Value);
    Writeint8(buf,value.property2Type);
    Writeint8(buf,value.property2FixOrPercent);
    Writeint(buf,value.property2Value);
    Writeint8(buf,value.property3Type);
    Writeint8(buf,value.property3FixOrPercent);
    Writeint(buf,value.property3Value);
    Writeint8(buf,value.property4Type);
    Writeint8(buf,value.property4FixOrPercent);
    Writeint(buf,value.property4Value);
    Writeint8(buf,value.property5Type);
    Writeint8(buf,value.property5FixOrPercent);
    Writeint(buf,value.property5Value);
}
void ReadGetEquipNewPropertyByType(char*& buf,GetEquipNewPropertyByType& value)
{
    Readint(buf,value.type);
    Readint8(buf,value.property1Type);
    Readint8(buf,value.property1FixOrPercent);
    Readint(buf,value.property1Value);
    Readint8(buf,value.property2Type);
    Readint8(buf,value.property2FixOrPercent);
    Readint(buf,value.property2Value);
    Readint8(buf,value.property3Type);
    Readint8(buf,value.property3FixOrPercent);
    Readint(buf,value.property3Value);
    Readint8(buf,value.property4Type);
    Readint8(buf,value.property4FixOrPercent);
    Readint(buf,value.property4Value);
    Readint8(buf,value.property5Type);
    Readint8(buf,value.property5FixOrPercent);
    Readint(buf,value.property5Value);
}
void WriteRequestEquipSaveNewPropertyByType(char*& buf,RequestEquipSaveNewPropertyByType& value)
{
    Writeint(buf,value.type);
}
void RequestEquipSaveNewPropertyByType::Send(){
    BeginSend(RequestEquipSaveNewPropertyByType);
    WriteRequestEquipSaveNewPropertyByType(buf,*this);
    EndSend();
}
void ReadRequestEquipSaveNewPropertyByType(char*& buf,RequestEquipSaveNewPropertyByType& value)
{
    Readint(buf,value.type);
}
void WriteRequestEquipChangeAddSavePropertyByType(char*& buf,RequestEquipChangeAddSavePropertyByType& value)
{
    Writeint(buf,value.result);
}
void ReadRequestEquipChangeAddSavePropertyByType(char*& buf,RequestEquipChangeAddSavePropertyByType& value)
{
    Readint(buf,value.result);
}
void WriteU2GS_EnterCopyMapRequest(char*& buf,U2GS_EnterCopyMapRequest& value)
{
    Writeint64(buf,value.npcActorID);
    Writeint(buf,value.enterMapID);
}
void U2GS_EnterCopyMapRequest::Send(){
    BeginSend(U2GS_EnterCopyMapRequest);
    WriteU2GS_EnterCopyMapRequest(buf,*this);
    EndSend();
}
void ReadU2GS_EnterCopyMapRequest(char*& buf,U2GS_EnterCopyMapRequest& value)
{
    Readint64(buf,value.npcActorID);
    Readint(buf,value.enterMapID);
}
void WriteGS2U_EnterMapResult(char*& buf,GS2U_EnterMapResult& value)
{
    Writeint(buf,value.result);
}
void ReadGS2U_EnterMapResult(char*& buf,GS2U_EnterMapResult& value)
{
    Readint(buf,value.result);
}
void WriteU2GS_QueryMyCopyMapCD(char*& buf,U2GS_QueryMyCopyMapCD& value)
{
    Writeint(buf,value.reserve);
}
void U2GS_QueryMyCopyMapCD::Send(){
    BeginSend(U2GS_QueryMyCopyMapCD);
    WriteU2GS_QueryMyCopyMapCD(buf,*this);
    EndSend();
}
void ReadU2GS_QueryMyCopyMapCD(char*& buf,U2GS_QueryMyCopyMapCD& value)
{
    Readint(buf,value.reserve);
}
void WriteMyCopyMapCDInfo(char*& buf,MyCopyMapCDInfo& value)
{
    Writeint16(buf,value.mapDataID);
    Writeint8(buf,value.mapEnteredCount);
    Writeint8(buf,value.mapActiveCount);
}
void ReadMyCopyMapCDInfo(char*& buf,MyCopyMapCDInfo& value)
{
    Readint16(buf,value.mapDataID);
    Readint8(buf,value.mapEnteredCount);
    Readint8(buf,value.mapActiveCount);
}
void WriteGS2U_MyCopyMapCDInfo(char*& buf,GS2U_MyCopyMapCDInfo& value)
{
    WriteArray(buf,MyCopyMapCDInfo,value.info_list);
}
void ReadGS2U_MyCopyMapCDInfo(char*& buf,GS2U_MyCopyMapCDInfo& value)
{
    ReadArray(buf,MyCopyMapCDInfo,value.info_list);
}
void WriteAddBuff(char*& buf,AddBuff& value)
{
    Writeint64(buf,value.actor_id);
    Writeint16(buf,value.buff_data_id);
    Writeint16(buf,value.allValidTime);
    Writeint8(buf,value.remainTriggerCount);
}
void ReadAddBuff(char*& buf,AddBuff& value)
{
    Readint64(buf,value.actor_id);
    Readint16(buf,value.buff_data_id);
    Readint16(buf,value.allValidTime);
    Readint8(buf,value.remainTriggerCount);
}
void WriteDelBuff(char*& buf,DelBuff& value)
{
    Writeint64(buf,value.actor_id);
    Writeint16(buf,value.buff_data_id);
}
void ReadDelBuff(char*& buf,DelBuff& value)
{
    Readint64(buf,value.actor_id);
    Readint16(buf,value.buff_data_id);
}
void WriteUpdateBuff(char*& buf,UpdateBuff& value)
{
    Writeint64(buf,value.actor_id);
    Writeint16(buf,value.buff_data_id);
    Writeint8(buf,value.remainTriggerCount);
}
void ReadUpdateBuff(char*& buf,UpdateBuff& value)
{
    Readint64(buf,value.actor_id);
    Readint16(buf,value.buff_data_id);
    Readint8(buf,value.remainTriggerCount);
}
void WriteHeroBuffList(char*& buf,HeroBuffList& value)
{
    WriteArray(buf,ObjectBuff,value.buffList);
}
void ReadHeroBuffList(char*& buf,HeroBuffList& value)
{
    ReadArray(buf,ObjectBuff,value.buffList);
}
void WriteU2GS_TransByWorldMap(char*& buf,U2GS_TransByWorldMap& value)
{
    Writeint(buf,value.mapDataID);
    Writeint(buf,value.posX);
    Writeint(buf,value.posY);
}
void U2GS_TransByWorldMap::Send(){
    BeginSend(U2GS_TransByWorldMap);
    WriteU2GS_TransByWorldMap(buf,*this);
    EndSend();
}
void ReadU2GS_TransByWorldMap(char*& buf,U2GS_TransByWorldMap& value)
{
    Readint(buf,value.mapDataID);
    Readint(buf,value.posX);
    Readint(buf,value.posY);
}
void WriteU2GS_TransForSameScence(char*& buf,U2GS_TransForSameScence& value)
{
    Writeint(buf,value.mapDataID);
    Writeint(buf,value.posX);
    Writeint(buf,value.posY);
}
void U2GS_TransForSameScence::Send(){
    BeginSend(U2GS_TransForSameScence);
    WriteU2GS_TransForSameScence(buf,*this);
    EndSend();
}
void ReadU2GS_TransForSameScence(char*& buf,U2GS_TransForSameScence& value)
{
    Readint(buf,value.mapDataID);
    Readint(buf,value.posX);
    Readint(buf,value.posY);
}
void WriteU2GS_FastTeamCopyMapRequest(char*& buf,U2GS_FastTeamCopyMapRequest& value)
{
    Writeint64(buf,value.npcActorID);
    Writeint(buf,value.mapDataID);
    Writeint8(buf,value.enterOrQuit);
}
void U2GS_FastTeamCopyMapRequest::Send(){
    BeginSend(U2GS_FastTeamCopyMapRequest);
    WriteU2GS_FastTeamCopyMapRequest(buf,*this);
    EndSend();
}
void ReadU2GS_FastTeamCopyMapRequest(char*& buf,U2GS_FastTeamCopyMapRequest& value)
{
    Readint64(buf,value.npcActorID);
    Readint(buf,value.mapDataID);
    Readint8(buf,value.enterOrQuit);
}
void WriteGS2U_FastTeamCopyMapResult(char*& buf,GS2U_FastTeamCopyMapResult& value)
{
    Writeint(buf,value.mapDataID);
    Writeint(buf,value.result);
    Writeint8(buf,value.enterOrQuit);
}
void ReadGS2U_FastTeamCopyMapResult(char*& buf,GS2U_FastTeamCopyMapResult& value)
{
    Readint(buf,value.mapDataID);
    Readint(buf,value.result);
    Readint8(buf,value.enterOrQuit);
}
void WriteGS2U_TeamCopyMapQuery(char*& buf,GS2U_TeamCopyMapQuery& value)
{
    Writeint(buf,value.nReadyEnterMapDataID);
    Writeint(buf,value.nCurMapID);
    Writeint(buf,value.nPosX);
    Writeint(buf,value.nPosY);
    Writeint(buf,value.nDistanceSQ);
}
void ReadGS2U_TeamCopyMapQuery(char*& buf,GS2U_TeamCopyMapQuery& value)
{
    Readint(buf,value.nReadyEnterMapDataID);
    Readint(buf,value.nCurMapID);
    Readint(buf,value.nPosX);
    Readint(buf,value.nPosY);
    Readint(buf,value.nDistanceSQ);
}
void WriteU2GS_RestCopyMapRequest(char*& buf,U2GS_RestCopyMapRequest& value)
{
    Writeint64(buf,value.nNpcID);
    Writeint(buf,value.nMapDataID);
}
void U2GS_RestCopyMapRequest::Send(){
    BeginSend(U2GS_RestCopyMapRequest);
    WriteU2GS_RestCopyMapRequest(buf,*this);
    EndSend();
}
void ReadU2GS_RestCopyMapRequest(char*& buf,U2GS_RestCopyMapRequest& value)
{
    Readint64(buf,value.nNpcID);
    Readint(buf,value.nMapDataID);
}
void WriteGS2U_AddOrRemoveHatred(char*& buf,GS2U_AddOrRemoveHatred& value)
{
    Writeint64(buf,value.nActorID);
    Writeint8(buf,value.nAddOrRemove);
}
void ReadGS2U_AddOrRemoveHatred(char*& buf,GS2U_AddOrRemoveHatred& value)
{
    Readint64(buf,value.nActorID);
    Readint8(buf,value.nAddOrRemove);
}
void WriteU2GS_QieCuoInvite(char*& buf,U2GS_QieCuoInvite& value)
{
    Writeint64(buf,value.nActorID);
}
void U2GS_QieCuoInvite::Send(){
    BeginSend(U2GS_QieCuoInvite);
    WriteU2GS_QieCuoInvite(buf,*this);
    EndSend();
}
void ReadU2GS_QieCuoInvite(char*& buf,U2GS_QieCuoInvite& value)
{
    Readint64(buf,value.nActorID);
}
void WriteGS2U_QieCuoInviteQuery(char*& buf,GS2U_QieCuoInviteQuery& value)
{
    Writeint64(buf,value.nActorID);
    Writestring(buf,value.strName);
}
void ReadGS2U_QieCuoInviteQuery(char*& buf,GS2U_QieCuoInviteQuery& value)
{
    Readint64(buf,value.nActorID);
    Readstring(buf,value.strName);
}
void WriteU2GS_QieCuoInviteAck(char*& buf,U2GS_QieCuoInviteAck& value)
{
    Writeint64(buf,value.nActorID);
    Writeint8(buf,value.agree);
}
void U2GS_QieCuoInviteAck::Send(){
    BeginSend(U2GS_QieCuoInviteAck);
    WriteU2GS_QieCuoInviteAck(buf,*this);
    EndSend();
}
void ReadU2GS_QieCuoInviteAck(char*& buf,U2GS_QieCuoInviteAck& value)
{
    Readint64(buf,value.nActorID);
    Readint8(buf,value.agree);
}
void WriteGS2U_QieCuoInviteResult(char*& buf,GS2U_QieCuoInviteResult& value)
{
    Writeint64(buf,value.nActorID);
    Writeint8(buf,value.result);
}
void ReadGS2U_QieCuoInviteResult(char*& buf,GS2U_QieCuoInviteResult& value)
{
    Readint64(buf,value.nActorID);
    Readint8(buf,value.result);
}
void WriteGS2U_QieCuoResult(char*& buf,GS2U_QieCuoResult& value)
{
    Writeint64(buf,value.nWinner_ActorID);
    Writestring(buf,value.strWinner_Name);
    Writeint64(buf,value.nLoser_ActorID);
    Writestring(buf,value.strLoser_Name);
    Writeint8(buf,value.reson);
}
void ReadGS2U_QieCuoResult(char*& buf,GS2U_QieCuoResult& value)
{
    Readint64(buf,value.nWinner_ActorID);
    Readstring(buf,value.strWinner_Name);
    Readint64(buf,value.nLoser_ActorID);
    Readstring(buf,value.strLoser_Name);
    Readint8(buf,value.reson);
}
void WriteU2GS_PK_KillOpenRequest(char*& buf,U2GS_PK_KillOpenRequest& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_PK_KillOpenRequest::Send(){
    BeginSend(U2GS_PK_KillOpenRequest);
    WriteU2GS_PK_KillOpenRequest(buf,*this);
    EndSend();
}
void ReadU2GS_PK_KillOpenRequest(char*& buf,U2GS_PK_KillOpenRequest& value)
{
    Readint8(buf,value.reserve);
}
void WriteGS2U_PK_KillOpenResult(char*& buf,GS2U_PK_KillOpenResult& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.pK_Kill_RemainTime);
    Writeint(buf,value.pk_Kill_Value);
}
void ReadGS2U_PK_KillOpenResult(char*& buf,GS2U_PK_KillOpenResult& value)
{
    Readint(buf,value.result);
    Readint(buf,value.pK_Kill_RemainTime);
    Readint(buf,value.pk_Kill_Value);
}
void WriteGS2U_Player_ChangeEquipResult(char*& buf,GS2U_Player_ChangeEquipResult& value)
{
    Writeint64(buf,value.playerID);
    Writeint(buf,value.equipID);
}
void ReadGS2U_Player_ChangeEquipResult(char*& buf,GS2U_Player_ChangeEquipResult& value)
{
    Readint64(buf,value.playerID);
    Readint(buf,value.equipID);
}
void WriteSysMessage(char*& buf,SysMessage& value)
{
    Writeint(buf,value.type);
    Writestring(buf,value.text);
}
void ReadSysMessage(char*& buf,SysMessage& value)
{
    Readint(buf,value.type);
    Readstring(buf,value.text);
}
void WriteGS2U_AddLifeByItem(char*& buf,GS2U_AddLifeByItem& value)
{
    Writeint64(buf,value.actorID);
    Writeint(buf,value.addLife);
    Writeint8(buf,value.percent);
}
void ReadGS2U_AddLifeByItem(char*& buf,GS2U_AddLifeByItem& value)
{
    Readint64(buf,value.actorID);
    Readint(buf,value.addLife);
    Readint8(buf,value.percent);
}
void WriteGS2U_AddLifeBySkill(char*& buf,GS2U_AddLifeBySkill& value)
{
    Writeint64(buf,value.actorID);
    Writeint(buf,value.addLife);
    Writeint8(buf,value.percent);
    Writeint8(buf,value.crite);
}
void ReadGS2U_AddLifeBySkill(char*& buf,GS2U_AddLifeBySkill& value)
{
    Readint64(buf,value.actorID);
    Readint(buf,value.addLife);
    Readint8(buf,value.percent);
    Readint8(buf,value.crite);
}
void WritePlayerItemCDInfo(char*& buf,PlayerItemCDInfo& value)
{
    Writeint8(buf,value.cdTypeID);
    Writeint(buf,value.remainTime);
    Writeint(buf,value.allTime);
}
void ReadPlayerItemCDInfo(char*& buf,PlayerItemCDInfo& value)
{
    Readint8(buf,value.cdTypeID);
    Readint(buf,value.remainTime);
    Readint(buf,value.allTime);
}
void WriteGS2U_PlayerItemCDInit(char*& buf,GS2U_PlayerItemCDInit& value)
{
    WriteArray(buf,PlayerItemCDInfo,value.info_list);
}
void ReadGS2U_PlayerItemCDInit(char*& buf,GS2U_PlayerItemCDInit& value)
{
    ReadArray(buf,PlayerItemCDInfo,value.info_list);
}
void WriteGS2U_PlayerItemCDUpdate(char*& buf,GS2U_PlayerItemCDUpdate& value)
{
    WritePlayerItemCDInfo(buf,value.info);
}
void ReadGS2U_PlayerItemCDUpdate(char*& buf,GS2U_PlayerItemCDUpdate& value)
{
    ReadPlayerItemCDInfo(buf,value.info);
}
void WriteU2GS_BloodPoolAddLife(char*& buf,U2GS_BloodPoolAddLife& value)
{
    Writeint64(buf,value.actorID);
}
void U2GS_BloodPoolAddLife::Send(){
    BeginSend(U2GS_BloodPoolAddLife);
    WriteU2GS_BloodPoolAddLife(buf,*this);
    EndSend();
}
void ReadU2GS_BloodPoolAddLife(char*& buf,U2GS_BloodPoolAddLife& value)
{
    Readint64(buf,value.actorID);
}
void WriteGS2U_ItemDailyCount(char*& buf,GS2U_ItemDailyCount& value)
{
    Writeint(buf,value.remainCount);
    Writeint(buf,value.task_data_id);
}
void ReadGS2U_ItemDailyCount(char*& buf,GS2U_ItemDailyCount& value)
{
    Readint(buf,value.remainCount);
    Readint(buf,value.task_data_id);
}
void WriteU2GS_GetSigninInfo(char*& buf,U2GS_GetSigninInfo& value)
{
}
void U2GS_GetSigninInfo::Send(){
    BeginSend(U2GS_GetSigninInfo);
    WriteU2GS_GetSigninInfo(buf,*this);
    EndSend();
}
void ReadU2GS_GetSigninInfo(char*& buf,U2GS_GetSigninInfo& value)
{
}
void WriteGS2U_PlayerSigninInfo(char*& buf,GS2U_PlayerSigninInfo& value)
{
    Writeint8(buf,value.isAlreadySign);
    Writeint8(buf,value.days);
}
void ReadGS2U_PlayerSigninInfo(char*& buf,GS2U_PlayerSigninInfo& value)
{
    Readint8(buf,value.isAlreadySign);
    Readint8(buf,value.days);
}
void WriteU2GS_Signin(char*& buf,U2GS_Signin& value)
{
}
void U2GS_Signin::Send(){
    BeginSend(U2GS_Signin);
    WriteU2GS_Signin(buf,*this);
    EndSend();
}
void ReadU2GS_Signin(char*& buf,U2GS_Signin& value)
{
}
void WriteGS2U_PlayerSignInResult(char*& buf,GS2U_PlayerSignInResult& value)
{
    Writeint(buf,value.nResult);
    Writeint8(buf,value.awardDays);
}
void ReadGS2U_PlayerSignInResult(char*& buf,GS2U_PlayerSignInResult& value)
{
    Readint(buf,value.nResult);
    Readint8(buf,value.awardDays);
}
void WriteU2GS_LeaveCopyMap(char*& buf,U2GS_LeaveCopyMap& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_LeaveCopyMap::Send(){
    BeginSend(U2GS_LeaveCopyMap);
    WriteU2GS_LeaveCopyMap(buf,*this);
    EndSend();
}
void ReadU2GS_LeaveCopyMap(char*& buf,U2GS_LeaveCopyMap& value)
{
    Readint8(buf,value.reserve);
}
void WritePetChangeModel(char*& buf,PetChangeModel& value)
{
    Writeint64(buf,value.petId);
    Writeint(buf,value.modelID);
}
void ReadPetChangeModel(char*& buf,PetChangeModel& value)
{
    Readint64(buf,value.petId);
    Readint(buf,value.modelID);
}
void WritePetChangeName(char*& buf,PetChangeName& value)
{
    Writeint64(buf,value.petId);
    Writestring(buf,value.newName);
}
void PetChangeName::Send(){
    BeginSend(PetChangeName);
    WritePetChangeName(buf,*this);
    EndSend();
}
void ReadPetChangeName(char*& buf,PetChangeName& value)
{
    Readint64(buf,value.petId);
    Readstring(buf,value.newName);
}
void WritePetChangeName_Result(char*& buf,PetChangeName_Result& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.petId);
    Writestring(buf,value.newName);
}
void ReadPetChangeName_Result(char*& buf,PetChangeName_Result& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.petId);
    Readstring(buf,value.newName);
}
void WriteBazzarItem(char*& buf,BazzarItem& value)
{
    Writeint(buf,value.db_id);
    Writeint16(buf,value.item_id);
    Writeint8(buf,value.item_column);
    Writeint16(buf,value.gold);
    Writeint16(buf,value.binded_gold);
    Writeint16(buf,value.remain_count);
    Writeint(buf,value.remain_time);
}
void ReadBazzarItem(char*& buf,BazzarItem& value)
{
    Readint(buf,value.db_id);
    Readint16(buf,value.item_id);
    Readint8(buf,value.item_column);
    Readint16(buf,value.gold);
    Readint16(buf,value.binded_gold);
    Readint16(buf,value.remain_count);
    Readint(buf,value.remain_time);
}
void WriteBazzarListRequest(char*& buf,BazzarListRequest& value)
{
    Writeint(buf,value.seed);
}
void BazzarListRequest::Send(){
    BeginSend(BazzarListRequest);
    WriteBazzarListRequest(buf,*this);
    EndSend();
}
void ReadBazzarListRequest(char*& buf,BazzarListRequest& value)
{
    Readint(buf,value.seed);
}
void WriteBazzarPriceItemList(char*& buf,BazzarPriceItemList& value)
{
    WriteArray(buf,BazzarItem,value.itemList);
}
void ReadBazzarPriceItemList(char*& buf,BazzarPriceItemList& value)
{
    ReadArray(buf,BazzarItem,value.itemList);
}
void WriteBazzarItemList(char*& buf,BazzarItemList& value)
{
    Writeint(buf,value.seed);
    WriteArray(buf,BazzarItem,value.itemList);
}
void ReadBazzarItemList(char*& buf,BazzarItemList& value)
{
    Readint(buf,value.seed);
    ReadArray(buf,BazzarItem,value.itemList);
}
void WriteBazzarItemUpdate(char*& buf,BazzarItemUpdate& value)
{
    WriteBazzarItem(buf,value.item);
}
void ReadBazzarItemUpdate(char*& buf,BazzarItemUpdate& value)
{
    ReadBazzarItem(buf,value.item);
}
void WriteBazzarBuyRequest(char*& buf,BazzarBuyRequest& value)
{
    Writeint(buf,value.db_id);
    Writeint16(buf,value.isBindGold);
    Writeint16(buf,value.count);
}
void BazzarBuyRequest::Send(){
    BeginSend(BazzarBuyRequest);
    WriteBazzarBuyRequest(buf,*this);
    EndSend();
}
void ReadBazzarBuyRequest(char*& buf,BazzarBuyRequest& value)
{
    Readint(buf,value.db_id);
    Readint16(buf,value.isBindGold);
    Readint16(buf,value.count);
}
void WriteBazzarBuyResult(char*& buf,BazzarBuyResult& value)
{
    Writeint8(buf,value.result);
}
void ReadBazzarBuyResult(char*& buf,BazzarBuyResult& value)
{
    Readint8(buf,value.result);
}
void WritePlayerBagCellOpenResult(char*& buf,PlayerBagCellOpenResult& value)
{
    Writeint8(buf,value.result);
}
void ReadPlayerBagCellOpenResult(char*& buf,PlayerBagCellOpenResult& value)
{
    Readint8(buf,value.result);
}
void WriteU2GS_RemoveSkillBranch(char*& buf,U2GS_RemoveSkillBranch& value)
{
    Writeint(buf,value.nSkillID);
}
void U2GS_RemoveSkillBranch::Send(){
    BeginSend(U2GS_RemoveSkillBranch);
    WriteU2GS_RemoveSkillBranch(buf,*this);
    EndSend();
}
void ReadU2GS_RemoveSkillBranch(char*& buf,U2GS_RemoveSkillBranch& value)
{
    Readint(buf,value.nSkillID);
}
void WriteGS2U_RemoveSkillBranch(char*& buf,GS2U_RemoveSkillBranch& value)
{
    Writeint(buf,value.result);
    Writeint(buf,value.nSkillID);
}
void ReadGS2U_RemoveSkillBranch(char*& buf,GS2U_RemoveSkillBranch& value)
{
    Readint(buf,value.result);
    Readint(buf,value.nSkillID);
}
void WriteU2GS_PetBloodPoolAddLife(char*& buf,U2GS_PetBloodPoolAddLife& value)
{
    Writeint8(buf,value.n);
}
void U2GS_PetBloodPoolAddLife::Send(){
    BeginSend(U2GS_PetBloodPoolAddLife);
    WriteU2GS_PetBloodPoolAddLife(buf,*this);
    EndSend();
}
void ReadU2GS_PetBloodPoolAddLife(char*& buf,U2GS_PetBloodPoolAddLife& value)
{
    Readint8(buf,value.n);
}
void WriteU2GS_CopyMapAddActiveCount(char*& buf,U2GS_CopyMapAddActiveCount& value)
{
    Writeint16(buf,value.map_data_id);
}
void U2GS_CopyMapAddActiveCount::Send(){
    BeginSend(U2GS_CopyMapAddActiveCount);
    WriteU2GS_CopyMapAddActiveCount(buf,*this);
    EndSend();
}
void ReadU2GS_CopyMapAddActiveCount(char*& buf,U2GS_CopyMapAddActiveCount& value)
{
    Readint16(buf,value.map_data_id);
}
void WriteU2GS_CopyMapAddActiveCountResult(char*& buf,U2GS_CopyMapAddActiveCountResult& value)
{
    Writeint16(buf,value.result);
}
void ReadU2GS_CopyMapAddActiveCountResult(char*& buf,U2GS_CopyMapAddActiveCountResult& value)
{
    Readint16(buf,value.result);
}
void WriteGS2U_CurConvoyInfo(char*& buf,GS2U_CurConvoyInfo& value)
{
    Writeint8(buf,value.isDead);
    Writeint(buf,value.convoyType);
    Writeint(buf,value.carriageQuality);
    Writeint(buf,value.remainTime);
    Writeint(buf,value.lowCD);
    Writeint(buf,value.highCD);
    Writeint(buf,value.freeCnt);
}
void ReadGS2U_CurConvoyInfo(char*& buf,GS2U_CurConvoyInfo& value)
{
    Readint8(buf,value.isDead);
    Readint(buf,value.convoyType);
    Readint(buf,value.carriageQuality);
    Readint(buf,value.remainTime);
    Readint(buf,value.lowCD);
    Readint(buf,value.highCD);
    Readint(buf,value.freeCnt);
}
void WriteU2GS_CarriageQualityRefresh(char*& buf,U2GS_CarriageQualityRefresh& value)
{
    Writeint(buf,value.isRefreshLegend);
    Writeint(buf,value.isCostGold);
    Writeint(buf,value.curConvoyType);
    Writeint(buf,value.curCarriageQuality);
    Writeint(buf,value.curTaskID);
}
void U2GS_CarriageQualityRefresh::Send(){
    BeginSend(U2GS_CarriageQualityRefresh);
    WriteU2GS_CarriageQualityRefresh(buf,*this);
    EndSend();
}
void ReadU2GS_CarriageQualityRefresh(char*& buf,U2GS_CarriageQualityRefresh& value)
{
    Readint(buf,value.isRefreshLegend);
    Readint(buf,value.isCostGold);
    Readint(buf,value.curConvoyType);
    Readint(buf,value.curCarriageQuality);
    Readint(buf,value.curTaskID);
}
void WriteGS2U_CarriageQualityRefreshResult(char*& buf,GS2U_CarriageQualityRefreshResult& value)
{
    Writeint(buf,value.retCode);
    Writeint(buf,value.newConvoyType);
    Writeint(buf,value.newCarriageQuality);
    Writeint(buf,value.freeCnt);
}
void ReadGS2U_CarriageQualityRefreshResult(char*& buf,GS2U_CarriageQualityRefreshResult& value)
{
    Readint(buf,value.retCode);
    Readint(buf,value.newConvoyType);
    Readint(buf,value.newCarriageQuality);
    Readint(buf,value.freeCnt);
}
void WriteU2GS_ConvoyCDRequst(char*& buf,U2GS_ConvoyCDRequst& value)
{
}
void U2GS_ConvoyCDRequst::Send(){
    BeginSend(U2GS_ConvoyCDRequst);
    WriteU2GS_ConvoyCDRequst(buf,*this);
    EndSend();
}
void ReadU2GS_ConvoyCDRequst(char*& buf,U2GS_ConvoyCDRequst& value)
{
}
void WriteGS2U_ConvoyCDResult(char*& buf,GS2U_ConvoyCDResult& value)
{
    Writeint8(buf,value.retCode);
}
void ReadGS2U_ConvoyCDResult(char*& buf,GS2U_ConvoyCDResult& value)
{
    Readint8(buf,value.retCode);
}
void WriteU2GS_BeginConvoy(char*& buf,U2GS_BeginConvoy& value)
{
    Writeint(buf,value.nTaskID);
    Writeint(buf,value.curConvoyType);
    Writeint(buf,value.curCarriageQuality);
    Writeint64(buf,value.nNpcActorID);
}
void U2GS_BeginConvoy::Send(){
    BeginSend(U2GS_BeginConvoy);
    WriteU2GS_BeginConvoy(buf,*this);
    EndSend();
}
void ReadU2GS_BeginConvoy(char*& buf,U2GS_BeginConvoy& value)
{
    Readint(buf,value.nTaskID);
    Readint(buf,value.curConvoyType);
    Readint(buf,value.curCarriageQuality);
    Readint64(buf,value.nNpcActorID);
}
void WriteGS2U_BeginConvoyResult(char*& buf,GS2U_BeginConvoyResult& value)
{
    Writeint(buf,value.retCode);
    Writeint(buf,value.curConvoyType);
    Writeint(buf,value.curCarriageQuality);
    Writeint(buf,value.remainTime);
    Writeint(buf,value.lowCD);
    Writeint(buf,value.highCD);
}
void ReadGS2U_BeginConvoyResult(char*& buf,GS2U_BeginConvoyResult& value)
{
    Readint(buf,value.retCode);
    Readint(buf,value.curConvoyType);
    Readint(buf,value.curCarriageQuality);
    Readint(buf,value.remainTime);
    Readint(buf,value.lowCD);
    Readint(buf,value.highCD);
}
void WriteGS2U_FinishConvoyResult(char*& buf,GS2U_FinishConvoyResult& value)
{
    Writeint(buf,value.curConvoyType);
    Writeint(buf,value.curCarriageQuality);
}
void ReadGS2U_FinishConvoyResult(char*& buf,GS2U_FinishConvoyResult& value)
{
    Readint(buf,value.curConvoyType);
    Readint(buf,value.curCarriageQuality);
}
void WriteGS2U_GiveUpConvoyResult(char*& buf,GS2U_GiveUpConvoyResult& value)
{
    Writeint(buf,value.curConvoyType);
    Writeint(buf,value.curCarriageQuality);
}
void ReadGS2U_GiveUpConvoyResult(char*& buf,GS2U_GiveUpConvoyResult& value)
{
    Readint(buf,value.curConvoyType);
    Readint(buf,value.curCarriageQuality);
}
void WriteGS2U_ConvoyNoticeTimerResult(char*& buf,GS2U_ConvoyNoticeTimerResult& value)
{
    Writeint8(buf,value.isDead);
    Writeint(buf,value.remainTime);
}
void ReadGS2U_ConvoyNoticeTimerResult(char*& buf,GS2U_ConvoyNoticeTimerResult& value)
{
    Readint8(buf,value.isDead);
    Readint(buf,value.remainTime);
}
void WriteGS2U_ConvoyState(char*& buf,GS2U_ConvoyState& value)
{
    Writeint8(buf,value.convoyFlags);
    Writeint(buf,value.quality);
    Writeint64(buf,value.actorID);
}
void ReadGS2U_ConvoyState(char*& buf,GS2U_ConvoyState& value)
{
    Readint8(buf,value.convoyFlags);
    Readint(buf,value.quality);
    Readint64(buf,value.actorID);
}
void WriteGSWithU_GameSetMenu(char*& buf,GSWithU_GameSetMenu& value)
{
    Writeint8(buf,value.joinTeamOnoff);
    Writeint8(buf,value.inviteGuildOnoff);
    Writeint8(buf,value.tradeOnoff);
    Writeint8(buf,value.applicateFriendOnoff);
    Writeint8(buf,value.singleKeyOperateOnoff);
    Writeint8(buf,value.musicPercent);
    Writeint8(buf,value.soundEffectPercent);
    Writeint8(buf,value.shieldEnermyCampPlayer);
    Writeint8(buf,value.shieldSelfCampPlayer);
    Writeint8(buf,value.shieldOthersPet);
    Writeint8(buf,value.shieldOthersName);
    Writeint8(buf,value.shieldSkillEffect);
    Writeint8(buf,value.dispPlayerLimit);
}
void GSWithU_GameSetMenu::Send(){
    BeginSend(GSWithU_GameSetMenu);
    WriteGSWithU_GameSetMenu(buf,*this);
    EndSend();
}
void ReadGSWithU_GameSetMenu(char*& buf,GSWithU_GameSetMenu& value)
{
    Readint8(buf,value.joinTeamOnoff);
    Readint8(buf,value.inviteGuildOnoff);
    Readint8(buf,value.tradeOnoff);
    Readint8(buf,value.applicateFriendOnoff);
    Readint8(buf,value.singleKeyOperateOnoff);
    Readint8(buf,value.musicPercent);
    Readint8(buf,value.soundEffectPercent);
    Readint8(buf,value.shieldEnermyCampPlayer);
    Readint8(buf,value.shieldSelfCampPlayer);
    Readint8(buf,value.shieldOthersPet);
    Readint8(buf,value.shieldOthersName);
    Readint8(buf,value.shieldSkillEffect);
    Readint8(buf,value.dispPlayerLimit);
}
void WriteU2GS_RequestRechargeGift(char*& buf,U2GS_RequestRechargeGift& value)
{
    Writeint8(buf,value.type);
}
void U2GS_RequestRechargeGift::Send(){
    BeginSend(U2GS_RequestRechargeGift);
    WriteU2GS_RequestRechargeGift(buf,*this);
    EndSend();
}
void ReadU2GS_RequestRechargeGift(char*& buf,U2GS_RequestRechargeGift& value)
{
    Readint8(buf,value.type);
}
void WriteU2GS_RequestRechargeGift_Ret(char*& buf,U2GS_RequestRechargeGift_Ret& value)
{
    Writeint8(buf,value.retcode);
}
void ReadU2GS_RequestRechargeGift_Ret(char*& buf,U2GS_RequestRechargeGift_Ret& value)
{
    Readint8(buf,value.retcode);
}
void WriteU2GS_RequestPlayerFightingCapacity(char*& buf,U2GS_RequestPlayerFightingCapacity& value)
{
}
void U2GS_RequestPlayerFightingCapacity::Send(){
    BeginSend(U2GS_RequestPlayerFightingCapacity);
    WriteU2GS_RequestPlayerFightingCapacity(buf,*this);
    EndSend();
}
void ReadU2GS_RequestPlayerFightingCapacity(char*& buf,U2GS_RequestPlayerFightingCapacity& value)
{
}
void WriteU2GS_RequestPlayerFightingCapacity_Ret(char*& buf,U2GS_RequestPlayerFightingCapacity_Ret& value)
{
    Writeint(buf,value.fightingcapacity);
}
void ReadU2GS_RequestPlayerFightingCapacity_Ret(char*& buf,U2GS_RequestPlayerFightingCapacity_Ret& value)
{
    Readint(buf,value.fightingcapacity);
}
void WriteU2GS_RequestPetFightingCapacity(char*& buf,U2GS_RequestPetFightingCapacity& value)
{
    Writeint(buf,value.petid);
}
void U2GS_RequestPetFightingCapacity::Send(){
    BeginSend(U2GS_RequestPetFightingCapacity);
    WriteU2GS_RequestPetFightingCapacity(buf,*this);
    EndSend();
}
void ReadU2GS_RequestPetFightingCapacity(char*& buf,U2GS_RequestPetFightingCapacity& value)
{
    Readint(buf,value.petid);
}
void WriteU2GS_RequestPetFightingCapacity_Ret(char*& buf,U2GS_RequestPetFightingCapacity_Ret& value)
{
    Writeint(buf,value.fightingcapacity);
}
void ReadU2GS_RequestPetFightingCapacity_Ret(char*& buf,U2GS_RequestPetFightingCapacity_Ret& value)
{
    Readint(buf,value.fightingcapacity);
}
void WriteU2GS_RequestMountFightingCapacity(char*& buf,U2GS_RequestMountFightingCapacity& value)
{
    Writeint(buf,value.mountid);
}
void U2GS_RequestMountFightingCapacity::Send(){
    BeginSend(U2GS_RequestMountFightingCapacity);
    WriteU2GS_RequestMountFightingCapacity(buf,*this);
    EndSend();
}
void ReadU2GS_RequestMountFightingCapacity(char*& buf,U2GS_RequestMountFightingCapacity& value)
{
    Readint(buf,value.mountid);
}
void WriteU2GS_RequestMountFightingCapacity_Ret(char*& buf,U2GS_RequestMountFightingCapacity_Ret& value)
{
    Writeint(buf,value.fightingcapacity);
}
void ReadU2GS_RequestMountFightingCapacity_Ret(char*& buf,U2GS_RequestMountFightingCapacity_Ret& value)
{
    Readint(buf,value.fightingcapacity);
}
void WriteVariantData(char*& buf,VariantData& value)
{
    Writeint16(buf,value.index);
    Writeint(buf,value.value);
}
void ReadVariantData(char*& buf,VariantData& value)
{
    Readint16(buf,value.index);
    Readint(buf,value.value);
}
void WriteGS2U_VariantDataSet(char*& buf,GS2U_VariantDataSet& value)
{
    Writeint8(buf,value.variant_type);
    WriteArray(buf,VariantData,value.info_list);
}
void ReadGS2U_VariantDataSet(char*& buf,GS2U_VariantDataSet& value)
{
    Readint8(buf,value.variant_type);
    ReadArray(buf,VariantData,value.info_list);
}
void WriteU2GS_GetRankList(char*& buf,U2GS_GetRankList& value)
{
    Writeint(buf,value.mapDataID);
}
void U2GS_GetRankList::Send(){
    BeginSend(U2GS_GetRankList);
    WriteU2GS_GetRankList(buf,*this);
    EndSend();
}
void ReadU2GS_GetRankList(char*& buf,U2GS_GetRankList& value)
{
    Readint(buf,value.mapDataID);
}
void WriteGS2U_RankList(char*& buf,GS2U_RankList& value)
{
    Writeint(buf,value.mapID);
    Writeint(buf,value.rankNum);
    Writestring(buf,value.name1);
    Writeint(buf,value.harm1);
    Writestring(buf,value.name2);
    Writeint(buf,value.harm2);
    Writestring(buf,value.name3);
    Writeint(buf,value.harm3);
    Writestring(buf,value.name4);
    Writeint(buf,value.harm4);
    Writestring(buf,value.name5);
    Writeint(buf,value.harm5);
    Writestring(buf,value.name6);
    Writeint(buf,value.harm6);
    Writestring(buf,value.name7);
    Writeint(buf,value.harm7);
    Writestring(buf,value.name8);
    Writeint(buf,value.harm8);
    Writestring(buf,value.name9);
    Writeint(buf,value.harm9);
    Writestring(buf,value.name10);
    Writeint(buf,value.harm10);
}
void ReadGS2U_RankList(char*& buf,GS2U_RankList& value)
{
    Readint(buf,value.mapID);
    Readint(buf,value.rankNum);
    Readstring(buf,value.name1);
    Readint(buf,value.harm1);
    Readstring(buf,value.name2);
    Readint(buf,value.harm2);
    Readstring(buf,value.name3);
    Readint(buf,value.harm3);
    Readstring(buf,value.name4);
    Readint(buf,value.harm4);
    Readstring(buf,value.name5);
    Readint(buf,value.harm5);
    Readstring(buf,value.name6);
    Readint(buf,value.harm6);
    Readstring(buf,value.name7);
    Readint(buf,value.harm7);
    Readstring(buf,value.name8);
    Readint(buf,value.harm8);
    Readstring(buf,value.name9);
    Readint(buf,value.harm9);
    Readstring(buf,value.name10);
    Readint(buf,value.harm10);
}
void WriteGS2U_WordBossCmd(char*& buf,GS2U_WordBossCmd& value)
{
    Writeint(buf,value.m_iCmd);
    Writeint(buf,value.m_iParam);
}
void ReadGS2U_WordBossCmd(char*& buf,GS2U_WordBossCmd& value)
{
    Readint(buf,value.m_iCmd);
    Readint(buf,value.m_iParam);
}
void WriteU2GS_ChangePlayerName(char*& buf,U2GS_ChangePlayerName& value)
{
    Writeint64(buf,value.id);
    Writestring(buf,value.name);
}
void U2GS_ChangePlayerName::Send(){
    BeginSend(U2GS_ChangePlayerName);
    WriteU2GS_ChangePlayerName(buf,*this);
    EndSend();
}
void ReadU2GS_ChangePlayerName(char*& buf,U2GS_ChangePlayerName& value)
{
    Readint64(buf,value.id);
    Readstring(buf,value.name);
}
void WriteGS2U_ChangePlayerNameResult(char*& buf,GS2U_ChangePlayerNameResult& value)
{
    Writeint(buf,value.retCode);
}
void ReadGS2U_ChangePlayerNameResult(char*& buf,GS2U_ChangePlayerNameResult& value)
{
    Readint(buf,value.retCode);
}
void WriteU2GS_SetProtectPwd(char*& buf,U2GS_SetProtectPwd& value)
{
    Writeint64(buf,value.id);
    Writestring(buf,value.oldpwd);
    Writestring(buf,value.pwd);
}
void U2GS_SetProtectPwd::Send(){
    BeginSend(U2GS_SetProtectPwd);
    WriteU2GS_SetProtectPwd(buf,*this);
    EndSend();
}
void ReadU2GS_SetProtectPwd(char*& buf,U2GS_SetProtectPwd& value)
{
    Readint64(buf,value.id);
    Readstring(buf,value.oldpwd);
    Readstring(buf,value.pwd);
}
void WriteGS2U_SetProtectPwdResult(char*& buf,GS2U_SetProtectPwdResult& value)
{
    Writeint(buf,value.retCode);
}
void ReadGS2U_SetProtectPwdResult(char*& buf,GS2U_SetProtectPwdResult& value)
{
    Readint(buf,value.retCode);
}
void WriteU2GS_HeartBeat(char*& buf,U2GS_HeartBeat& value)
{
}
void U2GS_HeartBeat::Send(){
    BeginSend(U2GS_HeartBeat);
    WriteU2GS_HeartBeat(buf,*this);
    EndSend();
}
void ReadU2GS_HeartBeat(char*& buf,U2GS_HeartBeat& value)
{
}
void WriteGS2U_CopyProgressUpdate(char*& buf,GS2U_CopyProgressUpdate& value)
{
    Writeint8(buf,value.progress);
}
void ReadGS2U_CopyProgressUpdate(char*& buf,GS2U_CopyProgressUpdate& value)
{
    Readint8(buf,value.progress);
}
void WriteU2GS_QequestGiveGoldCheck(char*& buf,U2GS_QequestGiveGoldCheck& value)
{
}
void U2GS_QequestGiveGoldCheck::Send(){
    BeginSend(U2GS_QequestGiveGoldCheck);
    WriteU2GS_QequestGiveGoldCheck(buf,*this);
    EndSend();
}
void ReadU2GS_QequestGiveGoldCheck(char*& buf,U2GS_QequestGiveGoldCheck& value)
{
}
void WriteU2GS_StartGiveGold(char*& buf,U2GS_StartGiveGold& value)
{
}
void U2GS_StartGiveGold::Send(){
    BeginSend(U2GS_StartGiveGold);
    WriteU2GS_StartGiveGold(buf,*this);
    EndSend();
}
void ReadU2GS_StartGiveGold(char*& buf,U2GS_StartGiveGold& value)
{
}
void WriteU2GS_StartGiveGoldResult(char*& buf,U2GS_StartGiveGoldResult& value)
{
    Writeint8(buf,value.goldType);
    Writeint8(buf,value.useCnt);
    Writeint(buf,value.exp);
    Writeint(buf,value.level);
    Writeint(buf,value.awardMoney);
    Writeint(buf,value.retCode);
}
void ReadU2GS_StartGiveGoldResult(char*& buf,U2GS_StartGiveGoldResult& value)
{
    Readint8(buf,value.goldType);
    Readint8(buf,value.useCnt);
    Readint(buf,value.exp);
    Readint(buf,value.level);
    Readint(buf,value.awardMoney);
    Readint(buf,value.retCode);
}
void WriteU2GS_GoldLineInfo(char*& buf,U2GS_GoldLineInfo& value)
{
    Writeint8(buf,value.useCnt);
    Writeint(buf,value.exp);
    Writeint(buf,value.level);
}
void ReadU2GS_GoldLineInfo(char*& buf,U2GS_GoldLineInfo& value)
{
    Readint8(buf,value.useCnt);
    Readint(buf,value.exp);
    Readint(buf,value.level);
}
void WriteU2GS_GoldResetTimer(char*& buf,U2GS_GoldResetTimer& value)
{
    Writeint8(buf,value.useCnt);
}
void ReadU2GS_GoldResetTimer(char*& buf,U2GS_GoldResetTimer& value)
{
    Readint8(buf,value.useCnt);
}
void WriteGS2U_CopyMapSAData(char*& buf,GS2U_CopyMapSAData& value)
{
    Writeint(buf,value.map_id);
    Writeint(buf,value.killed_count);
    Writeint8(buf,value.finish_rate);
    Writeint(buf,value.cost_time);
    Writeint(buf,value.exp);
    Writeint(buf,value.money);
    Writeint8(buf,value.level);
    Writeint8(buf,value.is_perfect);
}
void ReadGS2U_CopyMapSAData(char*& buf,GS2U_CopyMapSAData& value)
{
    Readint(buf,value.map_id);
    Readint(buf,value.killed_count);
    Readint8(buf,value.finish_rate);
    Readint(buf,value.cost_time);
    Readint(buf,value.exp);
    Readint(buf,value.money);
    Readint8(buf,value.level);
    Readint8(buf,value.is_perfect);
}
void WriteTokenStoreItemData(char*& buf,TokenStoreItemData& value)
{
    Writeint64(buf,value.id);
    Writeint(buf,value.item_id);
    Writeint(buf,value.price);
    Writeint(buf,value.tokenType);
    Writeint(buf,value.isbind);
}
void ReadTokenStoreItemData(char*& buf,TokenStoreItemData& value)
{
    Readint64(buf,value.id);
    Readint(buf,value.item_id);
    Readint(buf,value.price);
    Readint(buf,value.tokenType);
    Readint(buf,value.isbind);
}
void WriteGetTokenStoreItemListAck(char*& buf,GetTokenStoreItemListAck& value)
{
    Writeint(buf,value.store_id);
    WriteArray(buf,TokenStoreItemData,value.itemList);
}
void ReadGetTokenStoreItemListAck(char*& buf,GetTokenStoreItemListAck& value)
{
    Readint(buf,value.store_id);
    ReadArray(buf,TokenStoreItemData,value.itemList);
}
void WriteRequestLookPlayer(char*& buf,RequestLookPlayer& value)
{
    Writeint64(buf,value.playerID);
}
void RequestLookPlayer::Send(){
    BeginSend(RequestLookPlayer);
    WriteRequestLookPlayer(buf,*this);
    EndSend();
}
void ReadRequestLookPlayer(char*& buf,RequestLookPlayer& value)
{
    Readint64(buf,value.playerID);
}
void WriteRequestLookPlayer_Result(char*& buf,RequestLookPlayer_Result& value)
{
    WritePlayerBaseInfo(buf,value.baseInfo);
    WriteArray(buf,CharPropertyData,value.propertyList);
    WriteArray(buf,PetProperty,value.petList);
    WriteArray(buf,PlayerEquipNetData,value.equipList);
    Writeint(buf,value.fightCapacity);
}
void ReadRequestLookPlayer_Result(char*& buf,RequestLookPlayer_Result& value)
{
    ReadPlayerBaseInfo(buf,value.baseInfo);
    ReadArray(buf,CharPropertyData,value.propertyList);
    ReadArray(buf,PetProperty,value.petList);
    ReadArray(buf,PlayerEquipNetData,value.equipList);
    Readint(buf,value.fightCapacity);
}
void WriteRequestLookPlayerFailed_Result(char*& buf,RequestLookPlayerFailed_Result& value)
{
    Writeint8(buf,value.result);
}
void ReadRequestLookPlayerFailed_Result(char*& buf,RequestLookPlayerFailed_Result& value)
{
    Readint8(buf,value.result);
}
void WriteU2GS_PlayerClientInfo(char*& buf,U2GS_PlayerClientInfo& value)
{
    Writeint64(buf,value.playerid);
    Writestring(buf,value.platform);
    Writestring(buf,value.machine);
}
void U2GS_PlayerClientInfo::Send(){
    BeginSend(U2GS_PlayerClientInfo);
    WriteU2GS_PlayerClientInfo(buf,*this);
    EndSend();
}
void ReadU2GS_PlayerClientInfo(char*& buf,U2GS_PlayerClientInfo& value)
{
    Readint64(buf,value.playerid);
    Readstring(buf,value.platform);
    Readstring(buf,value.machine);
}
void WriteU2GS_RequestActiveCount(char*& buf,U2GS_RequestActiveCount& value)
{
    Writeint8(buf,value.n);
}
void U2GS_RequestActiveCount::Send(){
    BeginSend(U2GS_RequestActiveCount);
    WriteU2GS_RequestActiveCount(buf,*this);
    EndSend();
}
void ReadU2GS_RequestActiveCount(char*& buf,U2GS_RequestActiveCount& value)
{
    Readint8(buf,value.n);
}
void WriteActiveCountData(char*& buf,ActiveCountData& value)
{
    Writeint(buf,value.daily_id);
    Writeint(buf,value.count);
}
void ReadActiveCountData(char*& buf,ActiveCountData& value)
{
    Readint(buf,value.daily_id);
    Readint(buf,value.count);
}
void WriteGS2U_ActiveCount(char*& buf,GS2U_ActiveCount& value)
{
    Writeint(buf,value.activeValue);
    WriteArray(buf,ActiveCountData,value.dailyList);
}
void ReadGS2U_ActiveCount(char*& buf,GS2U_ActiveCount& value)
{
    Readint(buf,value.activeValue);
    ReadArray(buf,ActiveCountData,value.dailyList);
}
void WriteU2GS_RequestConvertActive(char*& buf,U2GS_RequestConvertActive& value)
{
    Writeint(buf,value.n);
}
void U2GS_RequestConvertActive::Send(){
    BeginSend(U2GS_RequestConvertActive);
    WriteU2GS_RequestConvertActive(buf,*this);
    EndSend();
}
void ReadU2GS_RequestConvertActive(char*& buf,U2GS_RequestConvertActive& value)
{
    Readint(buf,value.n);
}
void WriteGS2U_WhetherTransferOldRecharge(char*& buf,GS2U_WhetherTransferOldRecharge& value)
{
    Writeint64(buf,value.playerID);
    Writestring(buf,value.name);
    Writeint(buf,value.rechargeRmb);
}
void ReadGS2U_WhetherTransferOldRecharge(char*& buf,GS2U_WhetherTransferOldRecharge& value)
{
    Readint64(buf,value.playerID);
    Readstring(buf,value.name);
    Readint(buf,value.rechargeRmb);
}
void WriteU2GS_TransferOldRechargeToPlayer(char*& buf,U2GS_TransferOldRechargeToPlayer& value)
{
    Writeint64(buf,value.playerId);
    Writeint8(buf,value.isTransfer);
}
void U2GS_TransferOldRechargeToPlayer::Send(){
    BeginSend(U2GS_TransferOldRechargeToPlayer);
    WriteU2GS_TransferOldRechargeToPlayer(buf,*this);
    EndSend();
}
void ReadU2GS_TransferOldRechargeToPlayer(char*& buf,U2GS_TransferOldRechargeToPlayer& value)
{
    Readint64(buf,value.playerId);
    Readint8(buf,value.isTransfer);
}
void WriteGS2U_TransferOldRechargeResult(char*& buf,GS2U_TransferOldRechargeResult& value)
{
    Writeint(buf,value.errorCode);
}
void ReadGS2U_TransferOldRechargeResult(char*& buf,GS2U_TransferOldRechargeResult& value)
{
    Readint(buf,value.errorCode);
}
void WritePlayerEquipActiveFailReason(char*& buf,PlayerEquipActiveFailReason& value)
{
    Writeint(buf,value.reason);
}
void ReadPlayerEquipActiveFailReason(char*& buf,PlayerEquipActiveFailReason& value)
{
    Readint(buf,value.reason);
}
void WritePlayerEquipMinLevelChange(char*& buf,PlayerEquipMinLevelChange& value)
{
    Writeint64(buf,value.playerid);
    Writeint8(buf,value.minEquipLevel);
}
void ReadPlayerEquipMinLevelChange(char*& buf,PlayerEquipMinLevelChange& value)
{
    Readint64(buf,value.playerid);
    Readint8(buf,value.minEquipLevel);
}
void WritePlayerImportPassWord(char*& buf,PlayerImportPassWord& value)
{
    Writestring(buf,value.passWord);
    Writeint(buf,value.passWordType);
}
void PlayerImportPassWord::Send(){
    BeginSend(PlayerImportPassWord);
    WritePlayerImportPassWord(buf,*this);
    EndSend();
}
void ReadPlayerImportPassWord(char*& buf,PlayerImportPassWord& value)
{
    Readstring(buf,value.passWord);
    Readint(buf,value.passWordType);
}
void WritePlayerImportPassWordResult(char*& buf,PlayerImportPassWordResult& value)
{
    Writeint(buf,value.result);
}
void ReadPlayerImportPassWordResult(char*& buf,PlayerImportPassWordResult& value)
{
    Readint(buf,value.result);
}
void WriteGS2U_UpdatePlayerGuildInfo(char*& buf,GS2U_UpdatePlayerGuildInfo& value)
{
    Writeint64(buf,value.player_id);
    Writeint64(buf,value.guild_id);
    Writestring(buf,value.guild_name);
    Writeint8(buf,value.guild_rank);
}
void ReadGS2U_UpdatePlayerGuildInfo(char*& buf,GS2U_UpdatePlayerGuildInfo& value)
{
    Readint64(buf,value.player_id);
    Readint64(buf,value.guild_id);
    Readstring(buf,value.guild_name);
    Readint8(buf,value.guild_rank);
}
void WriteU2GS_RequestBazzarItemPrice(char*& buf,U2GS_RequestBazzarItemPrice& value)
{
    Writeint(buf,value.item_id);
}
void U2GS_RequestBazzarItemPrice::Send(){
    BeginSend(U2GS_RequestBazzarItemPrice);
    WriteU2GS_RequestBazzarItemPrice(buf,*this);
    EndSend();
}
void ReadU2GS_RequestBazzarItemPrice(char*& buf,U2GS_RequestBazzarItemPrice& value)
{
    Readint(buf,value.item_id);
}
void WriteU2GS_RequestBazzarItemPrice_Result(char*& buf,U2GS_RequestBazzarItemPrice_Result& value)
{
    WriteArray(buf,BazzarItem,value.item);
}
void ReadU2GS_RequestBazzarItemPrice_Result(char*& buf,U2GS_RequestBazzarItemPrice_Result& value)
{
    ReadArray(buf,BazzarItem,value.item);
}
void WriteRequestChangeGoldPassWord(char*& buf,RequestChangeGoldPassWord& value)
{
    Writestring(buf,value.oldGoldPassWord);
    Writestring(buf,value.newGoldPassWord);
    Writeint(buf,value.status);
}
void RequestChangeGoldPassWord::Send(){
    BeginSend(RequestChangeGoldPassWord);
    WriteRequestChangeGoldPassWord(buf,*this);
    EndSend();
}
void ReadRequestChangeGoldPassWord(char*& buf,RequestChangeGoldPassWord& value)
{
    Readstring(buf,value.oldGoldPassWord);
    Readstring(buf,value.newGoldPassWord);
    Readint(buf,value.status);
}
void WritePlayerGoldPassWordChanged(char*& buf,PlayerGoldPassWordChanged& value)
{
    Writeint(buf,value.result);
}
void ReadPlayerGoldPassWordChanged(char*& buf,PlayerGoldPassWordChanged& value)
{
    Readint(buf,value.result);
}
void WritePlayerImportGoldPassWordResult(char*& buf,PlayerImportGoldPassWordResult& value)
{
    Writeint(buf,value.result);
}
void ReadPlayerImportGoldPassWordResult(char*& buf,PlayerImportGoldPassWordResult& value)
{
    Readint(buf,value.result);
}
void WritePlayerGoldUnlockTimesChanged(char*& buf,PlayerGoldUnlockTimesChanged& value)
{
    Writeint(buf,value.unlockTimes);
}
void ReadPlayerGoldUnlockTimesChanged(char*& buf,PlayerGoldUnlockTimesChanged& value)
{
    Readint(buf,value.unlockTimes);
}
void WriteGS2U_LeftSmallMonsterNumber(char*& buf,GS2U_LeftSmallMonsterNumber& value)
{
    Writeint16(buf,value.leftMonsterNum);
}
void ReadGS2U_LeftSmallMonsterNumber(char*& buf,GS2U_LeftSmallMonsterNumber& value)
{
    Readint16(buf,value.leftMonsterNum);
}
void WriteGS2U_VipInfo(char*& buf,GS2U_VipInfo& value)
{
    Writeint(buf,value.vipLevel);
    Writeint(buf,value.vipTime);
    Writeint(buf,value.vipTimeExpire);
    Writeint(buf,value.vipTimeBuy);
}
void ReadGS2U_VipInfo(char*& buf,GS2U_VipInfo& value)
{
    Readint(buf,value.vipLevel);
    Readint(buf,value.vipTime);
    Readint(buf,value.vipTimeExpire);
    Readint(buf,value.vipTimeBuy);
}
void WriteGS2U_TellMapLineID(char*& buf,GS2U_TellMapLineID& value)
{
    Writeint8(buf,value.iLineID);
}
void ReadGS2U_TellMapLineID(char*& buf,GS2U_TellMapLineID& value)
{
    Readint8(buf,value.iLineID);
}
void WriteVIPPlayerOpenVIPStoreRequest(char*& buf,VIPPlayerOpenVIPStoreRequest& value)
{
    Writeint(buf,value.request);
}
void VIPPlayerOpenVIPStoreRequest::Send(){
    BeginSend(VIPPlayerOpenVIPStoreRequest);
    WriteVIPPlayerOpenVIPStoreRequest(buf,*this);
    EndSend();
}
void ReadVIPPlayerOpenVIPStoreRequest(char*& buf,VIPPlayerOpenVIPStoreRequest& value)
{
    Readint(buf,value.request);
}
void WriteVIPPlayerOpenVIPStoreFail(char*& buf,VIPPlayerOpenVIPStoreFail& value)
{
    Writeint(buf,value.fail);
}
void ReadVIPPlayerOpenVIPStoreFail(char*& buf,VIPPlayerOpenVIPStoreFail& value)
{
    Readint(buf,value.fail);
}
void WriteUpdateVIPLevelInfo(char*& buf,UpdateVIPLevelInfo& value)
{
    Writeint64(buf,value.playerID);
    Writeint8(buf,value.vipLevel);
}
void ReadUpdateVIPLevelInfo(char*& buf,UpdateVIPLevelInfo& value)
{
    Readint64(buf,value.playerID);
    Readint8(buf,value.vipLevel);
}
void WriteActiveCodeRequest(char*& buf,ActiveCodeRequest& value)
{
    Writestring(buf,value.active_code);
}
void ActiveCodeRequest::Send(){
    BeginSend(ActiveCodeRequest);
    WriteActiveCodeRequest(buf,*this);
    EndSend();
}
void ReadActiveCodeRequest(char*& buf,ActiveCodeRequest& value)
{
    Readstring(buf,value.active_code);
}
void WriteActiveCodeResult(char*& buf,ActiveCodeResult& value)
{
    Writeint(buf,value.result);
}
void ReadActiveCodeResult(char*& buf,ActiveCodeResult& value)
{
    Readint(buf,value.result);
}
void WriteU2GS_RequestOutFightPetPropetry(char*& buf,U2GS_RequestOutFightPetPropetry& value)
{
    Writeint8(buf,value.n);
}
void U2GS_RequestOutFightPetPropetry::Send(){
    BeginSend(U2GS_RequestOutFightPetPropetry);
    WriteU2GS_RequestOutFightPetPropetry(buf,*this);
    EndSend();
}
void ReadU2GS_RequestOutFightPetPropetry(char*& buf,U2GS_RequestOutFightPetPropetry& value)
{
    Readint8(buf,value.n);
}
void WriteGS2U_RequestOutFightPetPropetryResult(char*& buf,GS2U_RequestOutFightPetPropetryResult& value)
{
    Writeint64(buf,value.pet_id);
    Writeint(buf,value.attack);
    Writeint(buf,value.defence);
    Writeint(buf,value.hit);
    Writeint(buf,value.dodge);
    Writeint(buf,value.block);
    Writeint(buf,value.tough);
    Writeint(buf,value.crit);
    Writeint(buf,value.crit_damage_rate);
    Writeint(buf,value.attack_speed);
    Writeint(buf,value.pierce);
    Writeint(buf,value.ph_def);
    Writeint(buf,value.fire_def);
    Writeint(buf,value.ice_def);
    Writeint(buf,value.elec_def);
    Writeint(buf,value.poison_def);
    Writeint(buf,value.coma_def);
    Writeint(buf,value.hold_def);
    Writeint(buf,value.silent_def);
    Writeint(buf,value.move_def);
    Writeint(buf,value.max_life);
}
void ReadGS2U_RequestOutFightPetPropetryResult(char*& buf,GS2U_RequestOutFightPetPropetryResult& value)
{
    Readint64(buf,value.pet_id);
    Readint(buf,value.attack);
    Readint(buf,value.defence);
    Readint(buf,value.hit);
    Readint(buf,value.dodge);
    Readint(buf,value.block);
    Readint(buf,value.tough);
    Readint(buf,value.crit);
    Readint(buf,value.crit_damage_rate);
    Readint(buf,value.attack_speed);
    Readint(buf,value.pierce);
    Readint(buf,value.ph_def);
    Readint(buf,value.fire_def);
    Readint(buf,value.ice_def);
    Readint(buf,value.elec_def);
    Readint(buf,value.poison_def);
    Readint(buf,value.coma_def);
    Readint(buf,value.hold_def);
    Readint(buf,value.silent_def);
    Readint(buf,value.move_def);
    Readint(buf,value.max_life);
}
void WritePlayerDirMove(char*& buf,PlayerDirMove& value)
{
    Writeint16(buf,value.pos_x);
    Writeint16(buf,value.pos_y);
    Writeint8(buf,value.dir);
}
void PlayerDirMove::Send(){
    BeginSend(PlayerDirMove);
    WritePlayerDirMove(buf,*this);
    EndSend();
}
void ReadPlayerDirMove(char*& buf,PlayerDirMove& value)
{
    Readint16(buf,value.pos_x);
    Readint16(buf,value.pos_y);
    Readint8(buf,value.dir);
}
void WritePlayerDirMove_S2C(char*& buf,PlayerDirMove_S2C& value)
{
    Writeint64(buf,value.player_id);
    Writeint16(buf,value.pos_x);
    Writeint16(buf,value.pos_y);
    Writeint8(buf,value.dir);
}
void ReadPlayerDirMove_S2C(char*& buf,PlayerDirMove_S2C& value)
{
    Readint64(buf,value.player_id);
    Readint16(buf,value.pos_x);
    Readint16(buf,value.pos_y);
    Readint8(buf,value.dir);
}
void WriteU2GS_EnRollCampusBattle(char*& buf,U2GS_EnRollCampusBattle& value)
{
    Writeint64(buf,value.npcID);
    Writeint16(buf,value.battleID);
}
void U2GS_EnRollCampusBattle::Send(){
    BeginSend(U2GS_EnRollCampusBattle);
    WriteU2GS_EnRollCampusBattle(buf,*this);
    EndSend();
}
void ReadU2GS_EnRollCampusBattle(char*& buf,U2GS_EnRollCampusBattle& value)
{
    Readint64(buf,value.npcID);
    Readint16(buf,value.battleID);
}
void WriteGSWithU_GameSetMenu_3(char*& buf,GSWithU_GameSetMenu_3& value)
{
    Writeint8(buf,value.joinTeamOnoff);
    Writeint8(buf,value.inviteGuildOnoff);
    Writeint8(buf,value.tradeOnoff);
    Writeint8(buf,value.applicateFriendOnoff);
    Writeint8(buf,value.singleKeyOperateOnoff);
    Writeint8(buf,value.musicPercent);
    Writeint8(buf,value.soundEffectPercent);
    Writeint8(buf,value.shieldEnermyCampPlayer);
    Writeint8(buf,value.shieldSelfCampPlayer);
    Writeint8(buf,value.shieldOthersPet);
    Writeint8(buf,value.shieldOthersName);
    Writeint8(buf,value.shieldSkillEffect);
    Writeint8(buf,value.dispPlayerLimit);
    Writeint8(buf,value.shieldOthersSoundEff);
    Writeint8(buf,value.noAttackGuildMate);
    Writeint8(buf,value.reserve1);
    Writeint8(buf,value.reserve2);
}
void GSWithU_GameSetMenu_3::Send(){
    BeginSend(GSWithU_GameSetMenu_3);
    WriteGSWithU_GameSetMenu_3(buf,*this);
    EndSend();
}
void ReadGSWithU_GameSetMenu_3(char*& buf,GSWithU_GameSetMenu_3& value)
{
    Readint8(buf,value.joinTeamOnoff);
    Readint8(buf,value.inviteGuildOnoff);
    Readint8(buf,value.tradeOnoff);
    Readint8(buf,value.applicateFriendOnoff);
    Readint8(buf,value.singleKeyOperateOnoff);
    Readint8(buf,value.musicPercent);
    Readint8(buf,value.soundEffectPercent);
    Readint8(buf,value.shieldEnermyCampPlayer);
    Readint8(buf,value.shieldSelfCampPlayer);
    Readint8(buf,value.shieldOthersPet);
    Readint8(buf,value.shieldOthersName);
    Readint8(buf,value.shieldSkillEffect);
    Readint8(buf,value.dispPlayerLimit);
    Readint8(buf,value.shieldOthersSoundEff);
    Readint8(buf,value.noAttackGuildMate);
    Readint8(buf,value.reserve1);
    Readint8(buf,value.reserve2);
}
void WriteStartCompound(char*& buf,StartCompound& value)
{
    Writeint(buf,value.makeItemID);
    Writeint8(buf,value.compounBindedType);
    Writeint8(buf,value.isUseDoubleRule);
}
void StartCompound::Send(){
    BeginSend(StartCompound);
    WriteStartCompound(buf,*this);
    EndSend();
}
void ReadStartCompound(char*& buf,StartCompound& value)
{
    Readint(buf,value.makeItemID);
    Readint8(buf,value.compounBindedType);
    Readint8(buf,value.isUseDoubleRule);
}
void WriteStartCompoundResult(char*& buf,StartCompoundResult& value)
{
    Writeint8(buf,value.retCode);
}
void ReadStartCompoundResult(char*& buf,StartCompoundResult& value)
{
    Readint8(buf,value.retCode);
}
void WriteCompoundBaseInfo(char*& buf,CompoundBaseInfo& value)
{
    Writeint(buf,value.exp);
    Writeint(buf,value.level);
    Writeint(buf,value.makeItemID);
}
void ReadCompoundBaseInfo(char*& buf,CompoundBaseInfo& value)
{
    Readint(buf,value.exp);
    Readint(buf,value.level);
    Readint(buf,value.makeItemID);
}
void WriteRequestEquipFastUpQuality(char*& buf,RequestEquipFastUpQuality& value)
{
    Writeint(buf,value.equipId);
}
void RequestEquipFastUpQuality::Send(){
    BeginSend(RequestEquipFastUpQuality);
    WriteRequestEquipFastUpQuality(buf,*this);
    EndSend();
}
void ReadRequestEquipFastUpQuality(char*& buf,RequestEquipFastUpQuality& value)
{
    Readint(buf,value.equipId);
}
void WriteEquipQualityFastUPByTypeBack(char*& buf,EquipQualityFastUPByTypeBack& value)
{
    Writeint(buf,value.result);
}
void ReadEquipQualityFastUPByTypeBack(char*& buf,EquipQualityFastUPByTypeBack& value)
{
    Readint(buf,value.result);
}
void WritePlayerTeleportMove(char*& buf,PlayerTeleportMove& value)
{
    Writeint16(buf,value.pos_x);
    Writeint16(buf,value.pos_y);
}
void PlayerTeleportMove::Send(){
    BeginSend(PlayerTeleportMove);
    WritePlayerTeleportMove(buf,*this);
    EndSend();
}
void ReadPlayerTeleportMove(char*& buf,PlayerTeleportMove& value)
{
    Readint16(buf,value.pos_x);
    Readint16(buf,value.pos_y);
}
void WritePlayerTeleportMove_S2C(char*& buf,PlayerTeleportMove_S2C& value)
{
    Writeint64(buf,value.player_id);
    Writeint16(buf,value.pos_x);
    Writeint16(buf,value.pos_y);
}
void ReadPlayerTeleportMove_S2C(char*& buf,PlayerTeleportMove_S2C& value)
{
    Readint64(buf,value.player_id);
    Readint16(buf,value.pos_x);
    Readint16(buf,value.pos_y);
}
void WriteU2GS_leaveCampusBattle(char*& buf,U2GS_leaveCampusBattle& value)
{
    Writeint8(buf,value.unUsed);
}
void U2GS_leaveCampusBattle::Send(){
    BeginSend(U2GS_leaveCampusBattle);
    WriteU2GS_leaveCampusBattle(buf,*this);
    EndSend();
}
void ReadU2GS_leaveCampusBattle(char*& buf,U2GS_leaveCampusBattle& value)
{
    Readint8(buf,value.unUsed);
}
void WriteU2GS_LeaveBattleScene(char*& buf,U2GS_LeaveBattleScene& value)
{
    Writeint8(buf,value.unUsed);
}
void U2GS_LeaveBattleScene::Send(){
    BeginSend(U2GS_LeaveBattleScene);
    WriteU2GS_LeaveBattleScene(buf,*this);
    EndSend();
}
void ReadU2GS_LeaveBattleScene(char*& buf,U2GS_LeaveBattleScene& value)
{
    Readint8(buf,value.unUsed);
}
void WritebattleResult(char*& buf,battleResult& value)
{
    Writestring(buf,value.name);
    Writeint8(buf,value.campus);
    Writeint16(buf,value.killPlayerNum);
    Writeint16(buf,value.beenKiiledNum);
    Writeint64(buf,value.playerID);
    Writeint(buf,value.harm);
    Writeint(buf,value.harmed);
}
void ReadbattleResult(char*& buf,battleResult& value)
{
    Readstring(buf,value.name);
    Readint8(buf,value.campus);
    Readint16(buf,value.killPlayerNum);
    Readint16(buf,value.beenKiiledNum);
    Readint64(buf,value.playerID);
    Readint(buf,value.harm);
    Readint(buf,value.harmed);
}
void WriteBattleResultList(char*& buf,BattleResultList& value)
{
    WriteArray(buf,battleResult,value.resultList);
}
void ReadBattleResultList(char*& buf,BattleResultList& value)
{
    ReadArray(buf,battleResult,value.resultList);
}
void WriteGS2U_BattleEnrollResult(char*& buf,GS2U_BattleEnrollResult& value)
{
    Writeint8(buf,value.enrollResult);
    Writeint16(buf,value.mapDataID);
}
void ReadGS2U_BattleEnrollResult(char*& buf,GS2U_BattleEnrollResult& value)
{
    Readint8(buf,value.enrollResult);
    Readint16(buf,value.mapDataID);
}
void WriteU2GS_requestEnrollInfo(char*& buf,U2GS_requestEnrollInfo& value)
{
    Writeint8(buf,value.unUsed);
}
void U2GS_requestEnrollInfo::Send(){
    BeginSend(U2GS_requestEnrollInfo);
    WriteU2GS_requestEnrollInfo(buf,*this);
    EndSend();
}
void ReadU2GS_requestEnrollInfo(char*& buf,U2GS_requestEnrollInfo& value)
{
    Readint8(buf,value.unUsed);
}
void WriteGS2U_sendEnrollInfo(char*& buf,GS2U_sendEnrollInfo& value)
{
    Writeint16(buf,value.enrollxuanzong);
    Writeint16(buf,value.enrolltianji);
}
void ReadGS2U_sendEnrollInfo(char*& buf,GS2U_sendEnrollInfo& value)
{
    Readint16(buf,value.enrollxuanzong);
    Readint16(buf,value.enrolltianji);
}
void WriteGS2U_NowCanEnterBattle(char*& buf,GS2U_NowCanEnterBattle& value)
{
    Writeint16(buf,value.battleID);
}
void ReadGS2U_NowCanEnterBattle(char*& buf,GS2U_NowCanEnterBattle& value)
{
    Readint16(buf,value.battleID);
}
void WriteU2GS_SureEnterBattle(char*& buf,U2GS_SureEnterBattle& value)
{
    Writeint8(buf,value.unUsed);
}
void U2GS_SureEnterBattle::Send(){
    BeginSend(U2GS_SureEnterBattle);
    WriteU2GS_SureEnterBattle(buf,*this);
    EndSend();
}
void ReadU2GS_SureEnterBattle(char*& buf,U2GS_SureEnterBattle& value)
{
    Readint8(buf,value.unUsed);
}
void WriteGS2U_EnterBattleResult(char*& buf,GS2U_EnterBattleResult& value)
{
    Writeint8(buf,value.faileReason);
}
void ReadGS2U_EnterBattleResult(char*& buf,GS2U_EnterBattleResult& value)
{
    Readint8(buf,value.faileReason);
}
void WriteGS2U_BattleScore(char*& buf,GS2U_BattleScore& value)
{
    Writeint16(buf,value.xuanzongScore);
    Writeint16(buf,value.tianjiScore);
}
void ReadGS2U_BattleScore(char*& buf,GS2U_BattleScore& value)
{
    Readint16(buf,value.xuanzongScore);
    Readint16(buf,value.tianjiScore);
}
void WriteU2GS_RequestBattleResultList(char*& buf,U2GS_RequestBattleResultList& value)
{
    Writeint8(buf,value.unUsed);
}
void U2GS_RequestBattleResultList::Send(){
    BeginSend(U2GS_RequestBattleResultList);
    WriteU2GS_RequestBattleResultList(buf,*this);
    EndSend();
}
void ReadU2GS_RequestBattleResultList(char*& buf,U2GS_RequestBattleResultList& value)
{
    Readint8(buf,value.unUsed);
}
void WriteGS2U_BattleEnd(char*& buf,GS2U_BattleEnd& value)
{
    Writeint8(buf,value.unUsed);
}
void ReadGS2U_BattleEnd(char*& buf,GS2U_BattleEnd& value)
{
    Readint8(buf,value.unUsed);
}
void WriteGS2U_LeftOpenTime(char*& buf,GS2U_LeftOpenTime& value)
{
    Writeint(buf,value.leftOpenTime);
}
void ReadGS2U_LeftOpenTime(char*& buf,GS2U_LeftOpenTime& value)
{
    Readint(buf,value.leftOpenTime);
}
void WriteGS2U_HeartBeatAck(char*& buf,GS2U_HeartBeatAck& value)
{
}
void ReadGS2U_HeartBeatAck(char*& buf,GS2U_HeartBeatAck& value)
{
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
