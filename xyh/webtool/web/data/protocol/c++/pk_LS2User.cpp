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

void WriteLS2U_LoginResult(char*& buf,LS2U_LoginResult& value)
{
    Writeint8(buf,value.result);
    Writeint64(buf,value.userID);
}
void ReadLS2U_LoginResult(char*& buf,LS2U_LoginResult& value)
{
    Readint8(buf,value.result);
    Readint64(buf,value.userID);
}
void WriteGameServerInfo(char*& buf,GameServerInfo& value)
{
    Writestring(buf,value.serverID);
    Writestring(buf,value.name);
    Writeint8(buf,value.state);
    Writeint8(buf,value.showIndex);
    Writeint8(buf,value.remmond);
    Writeint16(buf,value.maxPlayerLevel);
    Writeint8(buf,value.isnew);
    Writestring(buf,value.begintime);
    Writeint8(buf,value.hot);
}
void ReadGameServerInfo(char*& buf,GameServerInfo& value)
{
    Readstring(buf,value.serverID);
    Readstring(buf,value.name);
    Readint8(buf,value.state);
    Readint8(buf,value.showIndex);
    Readint8(buf,value.remmond);
    Readint16(buf,value.maxPlayerLevel);
    Readint8(buf,value.isnew);
    Readstring(buf,value.begintime);
    Readint8(buf,value.hot);
}
void WriteLS2U_GameServerList(char*& buf,LS2U_GameServerList& value)
{
    WriteArray(buf,GameServerInfo,value.gameServers);
}
void ReadLS2U_GameServerList(char*& buf,LS2U_GameServerList& value)
{
    ReadArray(buf,GameServerInfo,value.gameServers);
}
void WriteLS2U_SelGameServerResult(char*& buf,LS2U_SelGameServerResult& value)
{
    Writeint64(buf,value.userID);
    Writestring(buf,value.ip);
    Writeint(buf,value.port);
    Writestring(buf,value.identity);
    Writeint(buf,value.errorCode);
}
void ReadLS2U_SelGameServerResult(char*& buf,LS2U_SelGameServerResult& value)
{
    Readint64(buf,value.userID);
    Readstring(buf,value.ip);
    Readint(buf,value.port);
    Readstring(buf,value.identity);
    Readint(buf,value.errorCode);
}
void WriteU2LS_Login_553(char*& buf,U2LS_Login_553& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writeint64(buf,value.time);
    Writestring(buf,value.sign);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_553::Send(){
    BeginSend(U2LS_Login_553);
    WriteU2LS_Login_553(buf,*this);
    EndSend();
}
void ReadU2LS_Login_553(char*& buf,U2LS_Login_553& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readint64(buf,value.time);
    Readstring(buf,value.sign);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteU2LS_Login_PP(char*& buf,U2LS_Login_PP& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writeint64(buf,value.token1);
    Writeint64(buf,value.token2);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_PP::Send(){
    BeginSend(U2LS_Login_PP);
    WriteU2LS_Login_PP(buf,*this);
    EndSend();
}
void ReadU2LS_Login_PP(char*& buf,U2LS_Login_PP& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readint64(buf,value.token1);
    Readint64(buf,value.token2);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteU2LS_RequestGameServerList(char*& buf,U2LS_RequestGameServerList& value)
{
    Writeint(buf,value.reserve);
}
void U2LS_RequestGameServerList::Send(){
    BeginSend(U2LS_RequestGameServerList);
    WriteU2LS_RequestGameServerList(buf,*this);
    EndSend();
}
void ReadU2LS_RequestGameServerList(char*& buf,U2LS_RequestGameServerList& value)
{
    Readint(buf,value.reserve);
}
void WriteU2LS_RequestSelGameServer(char*& buf,U2LS_RequestSelGameServer& value)
{
    Writestring(buf,value.serverID);
}
void U2LS_RequestSelGameServer::Send(){
    BeginSend(U2LS_RequestSelGameServer);
    WriteU2LS_RequestSelGameServer(buf,*this);
    EndSend();
}
void ReadU2LS_RequestSelGameServer(char*& buf,U2LS_RequestSelGameServer& value)
{
    Readstring(buf,value.serverID);
}
void WriteLS2U_ServerInfo(char*& buf,LS2U_ServerInfo& value)
{
    Writeint16(buf,value.lsid);
    Writestring(buf,value.client_ip);
}
void ReadLS2U_ServerInfo(char*& buf,LS2U_ServerInfo& value)
{
    Readint16(buf,value.lsid);
    Readstring(buf,value.client_ip);
}
void WriteU2LS_Login_APPS(char*& buf,U2LS_Login_APPS& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writeint64(buf,value.time);
    Writestring(buf,value.sign);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_APPS::Send(){
    BeginSend(U2LS_Login_APPS);
    WriteU2LS_Login_APPS(buf,*this);
    EndSend();
}
void ReadU2LS_Login_APPS(char*& buf,U2LS_Login_APPS& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readint64(buf,value.time);
    Readstring(buf,value.sign);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteU2LS_Login_360(char*& buf,U2LS_Login_360& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writestring(buf,value.authoCode);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_360::Send(){
    BeginSend(U2LS_Login_360);
    WriteU2LS_Login_360(buf,*this);
    EndSend();
}
void ReadU2LS_Login_360(char*& buf,U2LS_Login_360& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readstring(buf,value.authoCode);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteLS2U_Login_360(char*& buf,LS2U_Login_360& value)
{
    Writestring(buf,value.account);
    Writestring(buf,value.userid);
    Writestring(buf,value.access_token);
    Writestring(buf,value.refresh_token);
}
void ReadLS2U_Login_360(char*& buf,LS2U_Login_360& value)
{
    Readstring(buf,value.account);
    Readstring(buf,value.userid);
    Readstring(buf,value.access_token);
    Readstring(buf,value.refresh_token);
}
void WriteU2LS_Login_UC(char*& buf,U2LS_Login_UC& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writestring(buf,value.authoCode);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_UC::Send(){
    BeginSend(U2LS_Login_UC);
    WriteU2LS_Login_UC(buf,*this);
    EndSend();
}
void ReadU2LS_Login_UC(char*& buf,U2LS_Login_UC& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readstring(buf,value.authoCode);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteLS2U_Login_UC(char*& buf,LS2U_Login_UC& value)
{
    Writestring(buf,value.account);
    Writeint64(buf,value.userid);
    Writestring(buf,value.nickName);
}
void ReadLS2U_Login_UC(char*& buf,LS2U_Login_UC& value)
{
    Readstring(buf,value.account);
    Readint64(buf,value.userid);
    Readstring(buf,value.nickName);
}
void WriteU2LS_Login_91(char*& buf,U2LS_Login_91& value)
{
    Writestring(buf,value.account);
    Writeint16(buf,value.platformID);
    Writestring(buf,value.uin);
    Writestring(buf,value.sessionID);
    Writeint(buf,value.versionRes);
    Writeint(buf,value.versionExe);
    Writeint(buf,value.versionGame);
    Writeint(buf,value.versionPro);
}
void U2LS_Login_91::Send(){
    BeginSend(U2LS_Login_91);
    WriteU2LS_Login_91(buf,*this);
    EndSend();
}
void ReadU2LS_Login_91(char*& buf,U2LS_Login_91& value)
{
    Readstring(buf,value.account);
    Readint16(buf,value.platformID);
    Readstring(buf,value.uin);
    Readstring(buf,value.sessionID);
    Readint(buf,value.versionRes);
    Readint(buf,value.versionExe);
    Readint(buf,value.versionGame);
    Readint(buf,value.versionPro);
}
void WriteLS2U_Login_91(char*& buf,LS2U_Login_91& value)
{
    Writestring(buf,value.account);
    Writestring(buf,value.userid);
    Writestring(buf,value.access_token);
    Writestring(buf,value.refresh_token);
}
void ReadLS2U_Login_91(char*& buf,LS2U_Login_91& value)
{
    Readstring(buf,value.account);
    Readstring(buf,value.userid);
    Readstring(buf,value.access_token);
    Readstring(buf,value.refresh_token);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
