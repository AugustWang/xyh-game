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

struct FriendInfo
{
    int8 friendType;
    int64 friendID;
    string friendName;
    int8 friendSex;
    int8 friendFace;
    int8 friendClassType;
    int16 friendLevel;
    int8 friendVip;
    int friendValue;
    int8 friendOnline;
};
void WriteFriendInfo(char*& buf,FriendInfo& value);
void ReadFriendInfo(char*& buf,FriendInfo& value);

struct GS2U_LoadFriend
{
    vector<FriendInfo> info_list;
};
void WriteGS2U_LoadFriend(char*& buf,GS2U_LoadFriend& value);
void OnGS2U_LoadFriend(GS2U_LoadFriend* value);
void ReadGS2U_LoadFriend(char*& buf,GS2U_LoadFriend& value);

struct U2GS_QueryFriend
{
    int64 playerid;
	void Send();
};
void WriteU2GS_QueryFriend(char*& buf,U2GS_QueryFriend& value);
void ReadU2GS_QueryFriend(char*& buf,U2GS_QueryFriend& value);

struct GS2U_FriendTips
{
    int8 type;
    int8 tips;
};
void WriteGS2U_FriendTips(char*& buf,GS2U_FriendTips& value);
void OnGS2U_FriendTips(GS2U_FriendTips* value);
void ReadGS2U_FriendTips(char*& buf,GS2U_FriendTips& value);

struct GS2U_LoadBlack
{
    vector<FriendInfo> info_list;
};
void WriteGS2U_LoadBlack(char*& buf,GS2U_LoadBlack& value);
void OnGS2U_LoadBlack(GS2U_LoadBlack* value);
void ReadGS2U_LoadBlack(char*& buf,GS2U_LoadBlack& value);

struct U2GS_QueryBlack
{
    int64 playerid;
	void Send();
};
void WriteU2GS_QueryBlack(char*& buf,U2GS_QueryBlack& value);
void ReadU2GS_QueryBlack(char*& buf,U2GS_QueryBlack& value);

struct GS2U_LoadTemp
{
    vector<FriendInfo> info_list;
};
void WriteGS2U_LoadTemp(char*& buf,GS2U_LoadTemp& value);
void OnGS2U_LoadTemp(GS2U_LoadTemp* value);
void ReadGS2U_LoadTemp(char*& buf,GS2U_LoadTemp& value);

struct U2GS_QueryTemp
{
    int64 playerid;
	void Send();
};
void WriteU2GS_QueryTemp(char*& buf,U2GS_QueryTemp& value);
void ReadU2GS_QueryTemp(char*& buf,U2GS_QueryTemp& value);

struct GS2U_FriendInfo
{
    FriendInfo friendInfo;
};
void WriteGS2U_FriendInfo(char*& buf,GS2U_FriendInfo& value);
void OnGS2U_FriendInfo(GS2U_FriendInfo* value);
void ReadGS2U_FriendInfo(char*& buf,GS2U_FriendInfo& value);

struct U2GS_AddFriend
{
    int64 friendID;
    string friendName;
    int8 type;
	void Send();
};
void WriteU2GS_AddFriend(char*& buf,U2GS_AddFriend& value);
void ReadU2GS_AddFriend(char*& buf,U2GS_AddFriend& value);

struct GS2U_AddAcceptResult
{
    int8 isSuccess;
    int64 type;
    string fname;
};
void WriteGS2U_AddAcceptResult(char*& buf,GS2U_AddAcceptResult& value);
void OnGS2U_AddAcceptResult(GS2U_AddAcceptResult* value);
void ReadGS2U_AddAcceptResult(char*& buf,GS2U_AddAcceptResult& value);

struct U2GS_DeleteFriend
{
    int64 friendID;
    int8 type;
	void Send();
};
void WriteU2GS_DeleteFriend(char*& buf,U2GS_DeleteFriend& value);
void ReadU2GS_DeleteFriend(char*& buf,U2GS_DeleteFriend& value);

struct U2GS_AcceptFriend
{
    int8 result;
    int64 friendID;
	void Send();
};
void WriteU2GS_AcceptFriend(char*& buf,U2GS_AcceptFriend& value);
void ReadU2GS_AcceptFriend(char*& buf,U2GS_AcceptFriend& value);

struct GS2U_DeteFriendBack
{
    int8 type;
    int64 friendID;
};
void WriteGS2U_DeteFriendBack(char*& buf,GS2U_DeteFriendBack& value);
void OnGS2U_DeteFriendBack(GS2U_DeteFriendBack* value);
void ReadGS2U_DeteFriendBack(char*& buf,GS2U_DeteFriendBack& value);

struct GS2U_Net_Message
{
    int mswerHead;
    int skno;
    int rel;
	void Send();
};
void WriteGS2U_Net_Message(char*& buf,GS2U_Net_Message& value);
void OnGS2U_Net_Message(GS2U_Net_Message* value);
void ReadGS2U_Net_Message(char*& buf,GS2U_Net_Message& value);

struct GS2U_OnHookSet_Mess
{
    int playerHP;
    int petHP;
    int skillID1;
    int skillID2;
    int skillID3;
    int skillID4;
    int skillID5;
    int skillID6;
    int getThing;
    int hpThing;
    int other;
    int isAutoDrug;
	void Send();
};
void WriteGS2U_OnHookSet_Mess(char*& buf,GS2U_OnHookSet_Mess& value);
void OnGS2U_OnHookSet_Mess(GS2U_OnHookSet_Mess* value);
void ReadGS2U_OnHookSet_Mess(char*& buf,GS2U_OnHookSet_Mess& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
