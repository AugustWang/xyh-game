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

void WriteTopPlayerLevelInfo(char*& buf,TopPlayerLevelInfo& value)
{
    Writeint(buf,value.top);
    Writeint64(buf,value.playerid);
    Writestring(buf,value.name);
    Writeint(buf,value.camp);
    Writeint(buf,value.level);
    Writeint(buf,value.fightingcapacity);
    Writeint(buf,value.sex);
    Writeint(buf,value.weapon);
    Writeint(buf,value.coat);
}
void ReadTopPlayerLevelInfo(char*& buf,TopPlayerLevelInfo& value)
{
    Readint(buf,value.top);
    Readint64(buf,value.playerid);
    Readstring(buf,value.name);
    Readint(buf,value.camp);
    Readint(buf,value.level);
    Readint(buf,value.fightingcapacity);
    Readint(buf,value.sex);
    Readint(buf,value.weapon);
    Readint(buf,value.coat);
}
void WriteTopPlayerFightingCapacityInfo(char*& buf,TopPlayerFightingCapacityInfo& value)
{
    Writeint(buf,value.top);
    Writeint64(buf,value.playerid);
    Writestring(buf,value.name);
    Writeint(buf,value.camp);
    Writeint(buf,value.level);
    Writeint(buf,value.fightingcapacity);
    Writeint(buf,value.sex);
    Writeint(buf,value.weapon);
    Writeint(buf,value.coat);
}
void ReadTopPlayerFightingCapacityInfo(char*& buf,TopPlayerFightingCapacityInfo& value)
{
    Readint(buf,value.top);
    Readint64(buf,value.playerid);
    Readstring(buf,value.name);
    Readint(buf,value.camp);
    Readint(buf,value.level);
    Readint(buf,value.fightingcapacity);
    Readint(buf,value.sex);
    Readint(buf,value.weapon);
    Readint(buf,value.coat);
}
void WriteTopPlayerMoneyInfo(char*& buf,TopPlayerMoneyInfo& value)
{
    Writeint(buf,value.top);
    Writeint64(buf,value.playerid);
    Writestring(buf,value.name);
    Writeint(buf,value.camp);
    Writeint(buf,value.level);
    Writeint(buf,value.money);
    Writeint(buf,value.sex);
    Writeint(buf,value.weapon);
    Writeint(buf,value.coat);
}
void ReadTopPlayerMoneyInfo(char*& buf,TopPlayerMoneyInfo& value)
{
    Readint(buf,value.top);
    Readint64(buf,value.playerid);
    Readstring(buf,value.name);
    Readint(buf,value.camp);
    Readint(buf,value.level);
    Readint(buf,value.money);
    Readint(buf,value.sex);
    Readint(buf,value.weapon);
    Readint(buf,value.coat);
}
void WriteGS2U_LoadTopPlayerLevelList(char*& buf,GS2U_LoadTopPlayerLevelList& value)
{
    WriteArray(buf,TopPlayerLevelInfo,value.info_list);
}
void ReadGS2U_LoadTopPlayerLevelList(char*& buf,GS2U_LoadTopPlayerLevelList& value)
{
    ReadArray(buf,TopPlayerLevelInfo,value.info_list);
}
void WriteGS2U_LoadTopPlayerFightingCapacityList(char*& buf,GS2U_LoadTopPlayerFightingCapacityList& value)
{
    WriteArray(buf,TopPlayerFightingCapacityInfo,value.info_list);
}
void ReadGS2U_LoadTopPlayerFightingCapacityList(char*& buf,GS2U_LoadTopPlayerFightingCapacityList& value)
{
    ReadArray(buf,TopPlayerFightingCapacityInfo,value.info_list);
}
void WriteGS2U_LoadTopPlayerMoneyList(char*& buf,GS2U_LoadTopPlayerMoneyList& value)
{
    WriteArray(buf,TopPlayerMoneyInfo,value.info_list);
}
void ReadGS2U_LoadTopPlayerMoneyList(char*& buf,GS2U_LoadTopPlayerMoneyList& value)
{
    ReadArray(buf,TopPlayerMoneyInfo,value.info_list);
}
void WriteU2GS_LoadTopPlayerLevelList(char*& buf,U2GS_LoadTopPlayerLevelList& value)
{
}
void U2GS_LoadTopPlayerLevelList::Send(){
    BeginSend(U2GS_LoadTopPlayerLevelList);
    WriteU2GS_LoadTopPlayerLevelList(buf,*this);
    EndSend();
}
void ReadU2GS_LoadTopPlayerLevelList(char*& buf,U2GS_LoadTopPlayerLevelList& value)
{
}
void WriteU2GS_LoadTopPlayerFightingCapacityList(char*& buf,U2GS_LoadTopPlayerFightingCapacityList& value)
{
}
void U2GS_LoadTopPlayerFightingCapacityList::Send(){
    BeginSend(U2GS_LoadTopPlayerFightingCapacityList);
    WriteU2GS_LoadTopPlayerFightingCapacityList(buf,*this);
    EndSend();
}
void ReadU2GS_LoadTopPlayerFightingCapacityList(char*& buf,U2GS_LoadTopPlayerFightingCapacityList& value)
{
}
void WriteU2GS_LoadTopPlayerMoneyList(char*& buf,U2GS_LoadTopPlayerMoneyList& value)
{
}
void U2GS_LoadTopPlayerMoneyList::Send(){
    BeginSend(U2GS_LoadTopPlayerMoneyList);
    WriteU2GS_LoadTopPlayerMoneyList(buf,*this);
    EndSend();
}
void ReadU2GS_LoadTopPlayerMoneyList(char*& buf,U2GS_LoadTopPlayerMoneyList& value)
{
}
void WriteAnswerTopInfo(char*& buf,AnswerTopInfo& value)
{
    Writeint(buf,value.top);
    Writeint64(buf,value.playerid);
    Writestring(buf,value.name);
    Writeint(buf,value.core);
}
void ReadAnswerTopInfo(char*& buf,AnswerTopInfo& value)
{
    Readint(buf,value.top);
    Readint64(buf,value.playerid);
    Readstring(buf,value.name);
    Readint(buf,value.core);
}
void WriteGS2U_AnswerQuestion(char*& buf,GS2U_AnswerQuestion& value)
{
    Writeint(buf,value.id);
    Writeint8(buf,value.num);
    Writeint8(buf,value.maxnum);
    Writeint(buf,value.core);
    Writeint8(buf,value.special_double);
    Writeint8(buf,value.special_right);
    Writeint8(buf,value.special_exclude);
    Writeint8(buf,value.a);
    Writeint8(buf,value.b);
    Writeint8(buf,value.c);
    Writeint8(buf,value.d);
    Writeint8(buf,value.e1);
    Writeint8(buf,value.e2);
}
void ReadGS2U_AnswerQuestion(char*& buf,GS2U_AnswerQuestion& value)
{
    Readint(buf,value.id);
    Readint8(buf,value.num);
    Readint8(buf,value.maxnum);
    Readint(buf,value.core);
    Readint8(buf,value.special_double);
    Readint8(buf,value.special_right);
    Readint8(buf,value.special_exclude);
    Readint8(buf,value.a);
    Readint8(buf,value.b);
    Readint8(buf,value.c);
    Readint8(buf,value.d);
    Readint8(buf,value.e1);
    Readint8(buf,value.e2);
}
void WriteGS2U_AnswerReady(char*& buf,GS2U_AnswerReady& value)
{
    Writeint(buf,value.time);
}
void ReadGS2U_AnswerReady(char*& buf,GS2U_AnswerReady& value)
{
    Readint(buf,value.time);
}
void WriteGS2U_AnswerClose(char*& buf,GS2U_AnswerClose& value)
{
}
void ReadGS2U_AnswerClose(char*& buf,GS2U_AnswerClose& value)
{
}
void WriteGS2U_AnswerTopList(char*& buf,GS2U_AnswerTopList& value)
{
    WriteArray(buf,AnswerTopInfo,value.info_list);
}
void ReadGS2U_AnswerTopList(char*& buf,GS2U_AnswerTopList& value)
{
    ReadArray(buf,AnswerTopInfo,value.info_list);
}
void WriteU2GS_AnswerCommit(char*& buf,U2GS_AnswerCommit& value)
{
    Writeint(buf,value.num);
    Writeint(buf,value.answer);
    Writeint(buf,value.time);
}
void U2GS_AnswerCommit::Send(){
    BeginSend(U2GS_AnswerCommit);
    WriteU2GS_AnswerCommit(buf,*this);
    EndSend();
}
void ReadU2GS_AnswerCommit(char*& buf,U2GS_AnswerCommit& value)
{
    Readint(buf,value.num);
    Readint(buf,value.answer);
    Readint(buf,value.time);
}
void WriteU2GS_AnswerCommitRet(char*& buf,U2GS_AnswerCommitRet& value)
{
    Writeint8(buf,value.ret);
    Writeint(buf,value.score);
}
void ReadU2GS_AnswerCommitRet(char*& buf,U2GS_AnswerCommitRet& value)
{
    Readint8(buf,value.ret);
    Readint(buf,value.score);
}
void WriteU2GS_AnswerSpecial(char*& buf,U2GS_AnswerSpecial& value)
{
    Writeint(buf,value.type);
}
void U2GS_AnswerSpecial::Send(){
    BeginSend(U2GS_AnswerSpecial);
    WriteU2GS_AnswerSpecial(buf,*this);
    EndSend();
}
void ReadU2GS_AnswerSpecial(char*& buf,U2GS_AnswerSpecial& value)
{
    Readint(buf,value.type);
}
void WriteU2GS_AnswerSpecialRet(char*& buf,U2GS_AnswerSpecialRet& value)
{
    Writeint8(buf,value.ret);
}
void ReadU2GS_AnswerSpecialRet(char*& buf,U2GS_AnswerSpecialRet& value)
{
    Readint8(buf,value.ret);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
