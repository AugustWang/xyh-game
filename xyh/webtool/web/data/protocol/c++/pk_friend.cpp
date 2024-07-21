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

void WriteFriendInfo(char*& buf,FriendInfo& value)
{
    Writeint8(buf,value.friendType);
    Writeint64(buf,value.friendID);
    Writestring(buf,value.friendName);
    Writeint8(buf,value.friendSex);
    Writeint8(buf,value.friendFace);
    Writeint8(buf,value.friendClassType);
    Writeint16(buf,value.friendLevel);
    Writeint8(buf,value.friendVip);
    Writeint(buf,value.friendValue);
    Writeint8(buf,value.friendOnline);
}
void ReadFriendInfo(char*& buf,FriendInfo& value)
{
    Readint8(buf,value.friendType);
    Readint64(buf,value.friendID);
    Readstring(buf,value.friendName);
    Readint8(buf,value.friendSex);
    Readint8(buf,value.friendFace);
    Readint8(buf,value.friendClassType);
    Readint16(buf,value.friendLevel);
    Readint8(buf,value.friendVip);
    Readint(buf,value.friendValue);
    Readint8(buf,value.friendOnline);
}
void WriteGS2U_LoadFriend(char*& buf,GS2U_LoadFriend& value)
{
    WriteArray(buf,FriendInfo,value.info_list);
}
void ReadGS2U_LoadFriend(char*& buf,GS2U_LoadFriend& value)
{
    ReadArray(buf,FriendInfo,value.info_list);
}
void WriteU2GS_QueryFriend(char*& buf,U2GS_QueryFriend& value)
{
    Writeint64(buf,value.playerid);
}
void U2GS_QueryFriend::Send(){
    BeginSend(U2GS_QueryFriend);
    WriteU2GS_QueryFriend(buf,*this);
    EndSend();
}
void ReadU2GS_QueryFriend(char*& buf,U2GS_QueryFriend& value)
{
    Readint64(buf,value.playerid);
}
void WriteGS2U_FriendTips(char*& buf,GS2U_FriendTips& value)
{
    Writeint8(buf,value.type);
    Writeint8(buf,value.tips);
}
void ReadGS2U_FriendTips(char*& buf,GS2U_FriendTips& value)
{
    Readint8(buf,value.type);
    Readint8(buf,value.tips);
}
void WriteGS2U_LoadBlack(char*& buf,GS2U_LoadBlack& value)
{
    WriteArray(buf,FriendInfo,value.info_list);
}
void ReadGS2U_LoadBlack(char*& buf,GS2U_LoadBlack& value)
{
    ReadArray(buf,FriendInfo,value.info_list);
}
void WriteU2GS_QueryBlack(char*& buf,U2GS_QueryBlack& value)
{
    Writeint64(buf,value.playerid);
}
void U2GS_QueryBlack::Send(){
    BeginSend(U2GS_QueryBlack);
    WriteU2GS_QueryBlack(buf,*this);
    EndSend();
}
void ReadU2GS_QueryBlack(char*& buf,U2GS_QueryBlack& value)
{
    Readint64(buf,value.playerid);
}
void WriteGS2U_LoadTemp(char*& buf,GS2U_LoadTemp& value)
{
    WriteArray(buf,FriendInfo,value.info_list);
}
void ReadGS2U_LoadTemp(char*& buf,GS2U_LoadTemp& value)
{
    ReadArray(buf,FriendInfo,value.info_list);
}
void WriteU2GS_QueryTemp(char*& buf,U2GS_QueryTemp& value)
{
    Writeint64(buf,value.playerid);
}
void U2GS_QueryTemp::Send(){
    BeginSend(U2GS_QueryTemp);
    WriteU2GS_QueryTemp(buf,*this);
    EndSend();
}
void ReadU2GS_QueryTemp(char*& buf,U2GS_QueryTemp& value)
{
    Readint64(buf,value.playerid);
}
void WriteGS2U_FriendInfo(char*& buf,GS2U_FriendInfo& value)
{
    WriteFriendInfo(buf,value.friendInfo);
}
void ReadGS2U_FriendInfo(char*& buf,GS2U_FriendInfo& value)
{
    ReadFriendInfo(buf,value.friendInfo);
}
void WriteU2GS_AddFriend(char*& buf,U2GS_AddFriend& value)
{
    Writeint64(buf,value.friendID);
    Writestring(buf,value.friendName);
    Writeint8(buf,value.type);
}
void U2GS_AddFriend::Send(){
    BeginSend(U2GS_AddFriend);
    WriteU2GS_AddFriend(buf,*this);
    EndSend();
}
void ReadU2GS_AddFriend(char*& buf,U2GS_AddFriend& value)
{
    Readint64(buf,value.friendID);
    Readstring(buf,value.friendName);
    Readint8(buf,value.type);
}
void WriteGS2U_AddAcceptResult(char*& buf,GS2U_AddAcceptResult& value)
{
    Writeint8(buf,value.isSuccess);
    Writeint64(buf,value.type);
    Writestring(buf,value.fname);
}
void ReadGS2U_AddAcceptResult(char*& buf,GS2U_AddAcceptResult& value)
{
    Readint8(buf,value.isSuccess);
    Readint64(buf,value.type);
    Readstring(buf,value.fname);
}
void WriteU2GS_DeleteFriend(char*& buf,U2GS_DeleteFriend& value)
{
    Writeint64(buf,value.friendID);
    Writeint8(buf,value.type);
}
void U2GS_DeleteFriend::Send(){
    BeginSend(U2GS_DeleteFriend);
    WriteU2GS_DeleteFriend(buf,*this);
    EndSend();
}
void ReadU2GS_DeleteFriend(char*& buf,U2GS_DeleteFriend& value)
{
    Readint64(buf,value.friendID);
    Readint8(buf,value.type);
}
void WriteU2GS_AcceptFriend(char*& buf,U2GS_AcceptFriend& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.friendID);
}
void U2GS_AcceptFriend::Send(){
    BeginSend(U2GS_AcceptFriend);
    WriteU2GS_AcceptFriend(buf,*this);
    EndSend();
}
void ReadU2GS_AcceptFriend(char*& buf,U2GS_AcceptFriend& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.friendID);
}
void WriteGS2U_DeteFriendBack(char*& buf,GS2U_DeteFriendBack& value)
{
    Writeint8(buf,value.type);
    Writeint64(buf,value.friendID);
}
void ReadGS2U_DeteFriendBack(char*& buf,GS2U_DeteFriendBack& value)
{
    Readint8(buf,value.type);
    Readint64(buf,value.friendID);
}
void WriteGS2U_Net_Message(char*& buf,GS2U_Net_Message& value)
{
    Writeint(buf,value.mswerHead);
    Writeint(buf,value.skno);
    Writeint(buf,value.rel);
}
void GS2U_Net_Message::Send(){
    BeginSend(GS2U_Net_Message);
    WriteGS2U_Net_Message(buf,*this);
    EndSend();
}
void ReadGS2U_Net_Message(char*& buf,GS2U_Net_Message& value)
{
    Readint(buf,value.mswerHead);
    Readint(buf,value.skno);
    Readint(buf,value.rel);
}
void WriteGS2U_OnHookSet_Mess(char*& buf,GS2U_OnHookSet_Mess& value)
{
    Writeint(buf,value.playerHP);
    Writeint(buf,value.petHP);
    Writeint(buf,value.skillID1);
    Writeint(buf,value.skillID2);
    Writeint(buf,value.skillID3);
    Writeint(buf,value.skillID4);
    Writeint(buf,value.skillID5);
    Writeint(buf,value.skillID6);
    Writeint(buf,value.getThing);
    Writeint(buf,value.hpThing);
    Writeint(buf,value.other);
    Writeint(buf,value.isAutoDrug);
}
void GS2U_OnHookSet_Mess::Send(){
    BeginSend(GS2U_OnHookSet_Mess);
    WriteGS2U_OnHookSet_Mess(buf,*this);
    EndSend();
}
void ReadGS2U_OnHookSet_Mess(char*& buf,GS2U_OnHookSet_Mess& value)
{
    Readint(buf,value.playerHP);
    Readint(buf,value.petHP);
    Readint(buf,value.skillID1);
    Readint(buf,value.skillID2);
    Readint(buf,value.skillID3);
    Readint(buf,value.skillID4);
    Readint(buf,value.skillID5);
    Readint(buf,value.skillID6);
    Readint(buf,value.getThing);
    Readint(buf,value.hpThing);
    Readint(buf,value.other);
    Readint(buf,value.isAutoDrug);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
