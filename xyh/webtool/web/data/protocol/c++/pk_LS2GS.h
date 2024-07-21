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

struct LS2GS_LoginResult
{
    int reserve;
	void Send();
};
void WriteLS2GS_LoginResult(char*& buf,LS2GS_LoginResult& value);
void OnLS2GS_LoginResult(LS2GS_LoginResult* value);
void ReadLS2GS_LoginResult(char*& buf,LS2GS_LoginResult& value);

struct LS2GS_QueryUserMaxLevel
{
    int64 userID;
	void Send();
};
void WriteLS2GS_QueryUserMaxLevel(char*& buf,LS2GS_QueryUserMaxLevel& value);
void OnLS2GS_QueryUserMaxLevel(LS2GS_QueryUserMaxLevel* value);
void ReadLS2GS_QueryUserMaxLevel(char*& buf,LS2GS_QueryUserMaxLevel& value);

struct LS2GS_UserReadyToLogin
{
    int64 userID;
    string username;
    string identity;
    int platId;
	void Send();
};
void WriteLS2GS_UserReadyToLogin(char*& buf,LS2GS_UserReadyToLogin& value);
void OnLS2GS_UserReadyToLogin(LS2GS_UserReadyToLogin* value);
void ReadLS2GS_UserReadyToLogin(char*& buf,LS2GS_UserReadyToLogin& value);

struct LS2GS_KickOutUser
{
    int64 userID;
    string identity;
	void Send();
};
void WriteLS2GS_KickOutUser(char*& buf,LS2GS_KickOutUser& value);
void OnLS2GS_KickOutUser(LS2GS_KickOutUser* value);
void ReadLS2GS_KickOutUser(char*& buf,LS2GS_KickOutUser& value);

struct LS2GS_ActiveCode
{
    string pidStr;
    string activeCode;
    string playerName;
    int type;
	void Send();
};
void WriteLS2GS_ActiveCode(char*& buf,LS2GS_ActiveCode& value);
void OnLS2GS_ActiveCode(LS2GS_ActiveCode* value);
void ReadLS2GS_ActiveCode(char*& buf,LS2GS_ActiveCode& value);

struct GS2LS_Request_Login
{
    string serverID;
    string name;
    string ip;
    int port;
    int remmond;
    int showInUserGameList;
    int hot;
	void Send();
};
void WriteGS2LS_Request_Login(char*& buf,GS2LS_Request_Login& value);
void OnGS2LS_Request_Login(GS2LS_Request_Login* value);
void ReadGS2LS_Request_Login(char*& buf,GS2LS_Request_Login& value);

struct GS2LS_ReadyToAcceptUser
{
    int reserve;
	void Send();
};
void WriteGS2LS_ReadyToAcceptUser(char*& buf,GS2LS_ReadyToAcceptUser& value);
void OnGS2LS_ReadyToAcceptUser(GS2LS_ReadyToAcceptUser* value);
void ReadGS2LS_ReadyToAcceptUser(char*& buf,GS2LS_ReadyToAcceptUser& value);

struct GS2LS_OnlinePlayers
{
    int playerCount;
	void Send();
};
void WriteGS2LS_OnlinePlayers(char*& buf,GS2LS_OnlinePlayers& value);
void OnGS2LS_OnlinePlayers(GS2LS_OnlinePlayers* value);
void ReadGS2LS_OnlinePlayers(char*& buf,GS2LS_OnlinePlayers& value);

struct GS2LS_QueryUserMaxLevelResult
{
    int64 userID;
    int maxLevel;
	void Send();
};
void WriteGS2LS_QueryUserMaxLevelResult(char*& buf,GS2LS_QueryUserMaxLevelResult& value);
void OnGS2LS_QueryUserMaxLevelResult(GS2LS_QueryUserMaxLevelResult* value);
void ReadGS2LS_QueryUserMaxLevelResult(char*& buf,GS2LS_QueryUserMaxLevelResult& value);

struct GS2LS_UserReadyLoginResult
{
    int64 userID;
    int result;
	void Send();
};
void WriteGS2LS_UserReadyLoginResult(char*& buf,GS2LS_UserReadyLoginResult& value);
void OnGS2LS_UserReadyLoginResult(GS2LS_UserReadyLoginResult* value);
void ReadGS2LS_UserReadyLoginResult(char*& buf,GS2LS_UserReadyLoginResult& value);

struct GS2LS_UserLoginGameServer
{
    int64 userID;
	void Send();
};
void WriteGS2LS_UserLoginGameServer(char*& buf,GS2LS_UserLoginGameServer& value);
void OnGS2LS_UserLoginGameServer(GS2LS_UserLoginGameServer* value);
void ReadGS2LS_UserLoginGameServer(char*& buf,GS2LS_UserLoginGameServer& value);

struct GS2LS_UserLogoutGameServer
{
    int64 userID;
    string identity;
	void Send();
};
void WriteGS2LS_UserLogoutGameServer(char*& buf,GS2LS_UserLogoutGameServer& value);
void OnGS2LS_UserLogoutGameServer(GS2LS_UserLogoutGameServer* value);
void ReadGS2LS_UserLogoutGameServer(char*& buf,GS2LS_UserLogoutGameServer& value);

struct GS2LS_ActiveCode
{
    string pidStr;
    string activeCode;
    int retcode;
	void Send();
};
void WriteGS2LS_ActiveCode(char*& buf,GS2LS_ActiveCode& value);
void OnGS2LS_ActiveCode(GS2LS_ActiveCode* value);
void ReadGS2LS_ActiveCode(char*& buf,GS2LS_ActiveCode& value);

struct LS2GS_Announce
{
    string pidStr;
    string announceInfo;
	void Send();
};
void WriteLS2GS_Announce(char*& buf,LS2GS_Announce& value);
void OnLS2GS_Announce(LS2GS_Announce* value);
void ReadLS2GS_Announce(char*& buf,LS2GS_Announce& value);

struct LS2GS_Command
{
    string pidStr;
    int num;
    int cmd;
    string params;
	void Send();
};
void WriteLS2GS_Command(char*& buf,LS2GS_Command& value);
void OnLS2GS_Command(LS2GS_Command* value);
void ReadLS2GS_Command(char*& buf,LS2GS_Command& value);

struct GS2LS_Command
{
    string pidStr;
    int num;
    int cmd;
    int retcode;
	void Send();
};
void WriteGS2LS_Command(char*& buf,GS2LS_Command& value);
void OnGS2LS_Command(GS2LS_Command* value);
void ReadGS2LS_Command(char*& buf,GS2LS_Command& value);

struct LS2GS_Recharge
{
    string pidStr;
    string orderid;
    int platform;
    string account;
    int64 userid;
    int64 playerid;
    int ammount;
	void Send();
};
void WriteLS2GS_Recharge(char*& buf,LS2GS_Recharge& value);
void OnLS2GS_Recharge(LS2GS_Recharge* value);
void ReadLS2GS_Recharge(char*& buf,LS2GS_Recharge& value);

struct GS2LS_Recharge
{
    string pidStr;
    string orderid;
    int platform;
    int retcode;
	void Send();
};
void WriteGS2LS_Recharge(char*& buf,GS2LS_Recharge& value);
void OnGS2LS_Recharge(GS2LS_Recharge* value);
void ReadGS2LS_Recharge(char*& buf,GS2LS_Recharge& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
