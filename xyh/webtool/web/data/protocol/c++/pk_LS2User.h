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

struct LS2U_LoginResult
{
    int8 result;
    int64 userID;
};
void WriteLS2U_LoginResult(char*& buf,LS2U_LoginResult& value);
void OnLS2U_LoginResult(LS2U_LoginResult* value);
void ReadLS2U_LoginResult(char*& buf,LS2U_LoginResult& value);

struct GameServerInfo
{
    string serverID;
    string name;
    int8 state;
    int8 showIndex;
    int8 remmond;
    int16 maxPlayerLevel;
    int8 isnew;
    string begintime;
    int8 hot;
};
void WriteGameServerInfo(char*& buf,GameServerInfo& value);
void ReadGameServerInfo(char*& buf,GameServerInfo& value);

struct LS2U_GameServerList
{
    vector<GameServerInfo> gameServers;
};
void WriteLS2U_GameServerList(char*& buf,LS2U_GameServerList& value);
void OnLS2U_GameServerList(LS2U_GameServerList* value);
void ReadLS2U_GameServerList(char*& buf,LS2U_GameServerList& value);

struct LS2U_SelGameServerResult
{
    int64 userID;
    string ip;
    int port;
    string identity;
    int errorCode;
};
void WriteLS2U_SelGameServerResult(char*& buf,LS2U_SelGameServerResult& value);
void OnLS2U_SelGameServerResult(LS2U_SelGameServerResult* value);
void ReadLS2U_SelGameServerResult(char*& buf,LS2U_SelGameServerResult& value);

struct U2LS_Login_553
{
    string account;
    int16 platformID;
    int64 time;
    string sign;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_553(char*& buf,U2LS_Login_553& value);
void ReadU2LS_Login_553(char*& buf,U2LS_Login_553& value);

struct U2LS_Login_PP
{
    string account;
    int16 platformID;
    int64 token1;
    int64 token2;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_PP(char*& buf,U2LS_Login_PP& value);
void ReadU2LS_Login_PP(char*& buf,U2LS_Login_PP& value);

struct U2LS_RequestGameServerList
{
    int reserve;
	void Send();
};
void WriteU2LS_RequestGameServerList(char*& buf,U2LS_RequestGameServerList& value);
void ReadU2LS_RequestGameServerList(char*& buf,U2LS_RequestGameServerList& value);

struct U2LS_RequestSelGameServer
{
    string serverID;
	void Send();
};
void WriteU2LS_RequestSelGameServer(char*& buf,U2LS_RequestSelGameServer& value);
void ReadU2LS_RequestSelGameServer(char*& buf,U2LS_RequestSelGameServer& value);

struct LS2U_ServerInfo
{
    int16 lsid;
    string client_ip;
};
void WriteLS2U_ServerInfo(char*& buf,LS2U_ServerInfo& value);
void OnLS2U_ServerInfo(LS2U_ServerInfo* value);
void ReadLS2U_ServerInfo(char*& buf,LS2U_ServerInfo& value);

struct U2LS_Login_APPS
{
    string account;
    int16 platformID;
    int64 time;
    string sign;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_APPS(char*& buf,U2LS_Login_APPS& value);
void ReadU2LS_Login_APPS(char*& buf,U2LS_Login_APPS& value);

struct U2LS_Login_360
{
    string account;
    int16 platformID;
    string authoCode;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_360(char*& buf,U2LS_Login_360& value);
void ReadU2LS_Login_360(char*& buf,U2LS_Login_360& value);

struct LS2U_Login_360
{
    string account;
    string userid;
    string access_token;
    string refresh_token;
};
void WriteLS2U_Login_360(char*& buf,LS2U_Login_360& value);
void OnLS2U_Login_360(LS2U_Login_360* value);
void ReadLS2U_Login_360(char*& buf,LS2U_Login_360& value);

struct U2LS_Login_UC
{
    string account;
    int16 platformID;
    string authoCode;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_UC(char*& buf,U2LS_Login_UC& value);
void ReadU2LS_Login_UC(char*& buf,U2LS_Login_UC& value);

struct LS2U_Login_UC
{
    string account;
    int64 userid;
    string nickName;
};
void WriteLS2U_Login_UC(char*& buf,LS2U_Login_UC& value);
void OnLS2U_Login_UC(LS2U_Login_UC* value);
void ReadLS2U_Login_UC(char*& buf,LS2U_Login_UC& value);

struct U2LS_Login_91
{
    string account;
    int16 platformID;
    string uin;
    string sessionID;
    int versionRes;
    int versionExe;
    int versionGame;
    int versionPro;
	void Send();
};
void WriteU2LS_Login_91(char*& buf,U2LS_Login_91& value);
void ReadU2LS_Login_91(char*& buf,U2LS_Login_91& value);

struct LS2U_Login_91
{
    string account;
    string userid;
    string access_token;
    string refresh_token;
};
void WriteLS2U_Login_91(char*& buf,LS2U_Login_91& value);
void OnLS2U_Login_91(LS2U_Login_91* value);
void ReadLS2U_Login_91(char*& buf,LS2U_Login_91& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
