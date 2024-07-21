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

struct TopPlayerLevelInfo
{
    int top;
    int64 playerid;
    string name;
    int camp;
    int level;
    int fightingcapacity;
    int sex;
    int weapon;
    int coat;
};
void WriteTopPlayerLevelInfo(char*& buf,TopPlayerLevelInfo& value);
void ReadTopPlayerLevelInfo(char*& buf,TopPlayerLevelInfo& value);

struct TopPlayerFightingCapacityInfo
{
    int top;
    int64 playerid;
    string name;
    int camp;
    int level;
    int fightingcapacity;
    int sex;
    int weapon;
    int coat;
};
void WriteTopPlayerFightingCapacityInfo(char*& buf,TopPlayerFightingCapacityInfo& value);
void ReadTopPlayerFightingCapacityInfo(char*& buf,TopPlayerFightingCapacityInfo& value);

struct TopPlayerMoneyInfo
{
    int top;
    int64 playerid;
    string name;
    int camp;
    int level;
    int money;
    int sex;
    int weapon;
    int coat;
};
void WriteTopPlayerMoneyInfo(char*& buf,TopPlayerMoneyInfo& value);
void ReadTopPlayerMoneyInfo(char*& buf,TopPlayerMoneyInfo& value);

struct GS2U_LoadTopPlayerLevelList
{
    vector<TopPlayerLevelInfo> info_list;
};
void WriteGS2U_LoadTopPlayerLevelList(char*& buf,GS2U_LoadTopPlayerLevelList& value);
void OnGS2U_LoadTopPlayerLevelList(GS2U_LoadTopPlayerLevelList* value);
void ReadGS2U_LoadTopPlayerLevelList(char*& buf,GS2U_LoadTopPlayerLevelList& value);

struct GS2U_LoadTopPlayerFightingCapacityList
{
    vector<TopPlayerFightingCapacityInfo> info_list;
};
void WriteGS2U_LoadTopPlayerFightingCapacityList(char*& buf,GS2U_LoadTopPlayerFightingCapacityList& value);
void OnGS2U_LoadTopPlayerFightingCapacityList(GS2U_LoadTopPlayerFightingCapacityList* value);
void ReadGS2U_LoadTopPlayerFightingCapacityList(char*& buf,GS2U_LoadTopPlayerFightingCapacityList& value);

struct GS2U_LoadTopPlayerMoneyList
{
    vector<TopPlayerMoneyInfo> info_list;
};
void WriteGS2U_LoadTopPlayerMoneyList(char*& buf,GS2U_LoadTopPlayerMoneyList& value);
void OnGS2U_LoadTopPlayerMoneyList(GS2U_LoadTopPlayerMoneyList* value);
void ReadGS2U_LoadTopPlayerMoneyList(char*& buf,GS2U_LoadTopPlayerMoneyList& value);

struct U2GS_LoadTopPlayerLevelList
{
	void Send();
};
void WriteU2GS_LoadTopPlayerLevelList(char*& buf,U2GS_LoadTopPlayerLevelList& value);
void ReadU2GS_LoadTopPlayerLevelList(char*& buf,U2GS_LoadTopPlayerLevelList& value);

struct U2GS_LoadTopPlayerFightingCapacityList
{
	void Send();
};
void WriteU2GS_LoadTopPlayerFightingCapacityList(char*& buf,U2GS_LoadTopPlayerFightingCapacityList& value);
void ReadU2GS_LoadTopPlayerFightingCapacityList(char*& buf,U2GS_LoadTopPlayerFightingCapacityList& value);

struct U2GS_LoadTopPlayerMoneyList
{
	void Send();
};
void WriteU2GS_LoadTopPlayerMoneyList(char*& buf,U2GS_LoadTopPlayerMoneyList& value);
void ReadU2GS_LoadTopPlayerMoneyList(char*& buf,U2GS_LoadTopPlayerMoneyList& value);

struct AnswerTopInfo
{
    int top;
    int64 playerid;
    string name;
    int core;
};
void WriteAnswerTopInfo(char*& buf,AnswerTopInfo& value);
void ReadAnswerTopInfo(char*& buf,AnswerTopInfo& value);

struct GS2U_AnswerQuestion
{
    int id;
    int8 num;
    int8 maxnum;
    int core;
    int8 special_double;
    int8 special_right;
    int8 special_exclude;
    int8 a;
    int8 b;
    int8 c;
    int8 d;
    int8 e1;
    int8 e2;
};
void WriteGS2U_AnswerQuestion(char*& buf,GS2U_AnswerQuestion& value);
void OnGS2U_AnswerQuestion(GS2U_AnswerQuestion* value);
void ReadGS2U_AnswerQuestion(char*& buf,GS2U_AnswerQuestion& value);

struct GS2U_AnswerReady
{
    int time;
};
void WriteGS2U_AnswerReady(char*& buf,GS2U_AnswerReady& value);
void OnGS2U_AnswerReady(GS2U_AnswerReady* value);
void ReadGS2U_AnswerReady(char*& buf,GS2U_AnswerReady& value);

struct GS2U_AnswerClose
{
};
void WriteGS2U_AnswerClose(char*& buf,GS2U_AnswerClose& value);
void OnGS2U_AnswerClose(GS2U_AnswerClose* value);
void ReadGS2U_AnswerClose(char*& buf,GS2U_AnswerClose& value);

struct GS2U_AnswerTopList
{
    vector<AnswerTopInfo> info_list;
};
void WriteGS2U_AnswerTopList(char*& buf,GS2U_AnswerTopList& value);
void OnGS2U_AnswerTopList(GS2U_AnswerTopList* value);
void ReadGS2U_AnswerTopList(char*& buf,GS2U_AnswerTopList& value);

struct U2GS_AnswerCommit
{
    int num;
    int answer;
    int time;
	void Send();
};
void WriteU2GS_AnswerCommit(char*& buf,U2GS_AnswerCommit& value);
void ReadU2GS_AnswerCommit(char*& buf,U2GS_AnswerCommit& value);

struct U2GS_AnswerCommitRet
{
    int8 ret;
    int score;
};
void WriteU2GS_AnswerCommitRet(char*& buf,U2GS_AnswerCommitRet& value);
void OnU2GS_AnswerCommitRet(U2GS_AnswerCommitRet* value);
void ReadU2GS_AnswerCommitRet(char*& buf,U2GS_AnswerCommitRet& value);

struct U2GS_AnswerSpecial
{
    int type;
	void Send();
};
void WriteU2GS_AnswerSpecial(char*& buf,U2GS_AnswerSpecial& value);
void ReadU2GS_AnswerSpecial(char*& buf,U2GS_AnswerSpecial& value);

struct U2GS_AnswerSpecialRet
{
    int8 ret;
};
void WriteU2GS_AnswerSpecialRet(char*& buf,U2GS_AnswerSpecialRet& value);
void OnU2GS_AnswerSpecialRet(U2GS_AnswerSpecialRet* value);
void ReadU2GS_AnswerSpecialRet(char*& buf,U2GS_AnswerSpecialRet& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
