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

void WriteLS2GS_LoginResult(char*& buf,LS2GS_LoginResult& value)
{
    Writeint(buf,value.reserve);
}
void LS2GS_LoginResult::Send(){
    BeginSend(LS2GS_LoginResult);
    WriteLS2GS_LoginResult(buf,*this);
    EndSend();
}
void ReadLS2GS_LoginResult(char*& buf,LS2GS_LoginResult& value)
{
    Readint(buf,value.reserve);
}
void WriteLS2GS_QueryUserMaxLevel(char*& buf,LS2GS_QueryUserMaxLevel& value)
{
    Writeint64(buf,value.userID);
}
void LS2GS_QueryUserMaxLevel::Send(){
    BeginSend(LS2GS_QueryUserMaxLevel);
    WriteLS2GS_QueryUserMaxLevel(buf,*this);
    EndSend();
}
void ReadLS2GS_QueryUserMaxLevel(char*& buf,LS2GS_QueryUserMaxLevel& value)
{
    Readint64(buf,value.userID);
}
void WriteLS2GS_UserReadyToLogin(char*& buf,LS2GS_UserReadyToLogin& value)
{
    Writeint64(buf,value.userID);
    Writestring(buf,value.username);
    Writestring(buf,value.identity);
    Writeint(buf,value.platId);
}
void LS2GS_UserReadyToLogin::Send(){
    BeginSend(LS2GS_UserReadyToLogin);
    WriteLS2GS_UserReadyToLogin(buf,*this);
    EndSend();
}
void ReadLS2GS_UserReadyToLogin(char*& buf,LS2GS_UserReadyToLogin& value)
{
    Readint64(buf,value.userID);
    Readstring(buf,value.username);
    Readstring(buf,value.identity);
    Readint(buf,value.platId);
}
void WriteLS2GS_KickOutUser(char*& buf,LS2GS_KickOutUser& value)
{
    Writeint64(buf,value.userID);
    Writestring(buf,value.identity);
}
void LS2GS_KickOutUser::Send(){
    BeginSend(LS2GS_KickOutUser);
    WriteLS2GS_KickOutUser(buf,*this);
    EndSend();
}
void ReadLS2GS_KickOutUser(char*& buf,LS2GS_KickOutUser& value)
{
    Readint64(buf,value.userID);
    Readstring(buf,value.identity);
}
void WriteLS2GS_ActiveCode(char*& buf,LS2GS_ActiveCode& value)
{
    Writestring(buf,value.pidStr);
    Writestring(buf,value.activeCode);
    Writestring(buf,value.playerName);
    Writeint(buf,value.type);
}
void LS2GS_ActiveCode::Send(){
    BeginSend(LS2GS_ActiveCode);
    WriteLS2GS_ActiveCode(buf,*this);
    EndSend();
}
void ReadLS2GS_ActiveCode(char*& buf,LS2GS_ActiveCode& value)
{
    Readstring(buf,value.pidStr);
    Readstring(buf,value.activeCode);
    Readstring(buf,value.playerName);
    Readint(buf,value.type);
}
void WriteGS2LS_Request_Login(char*& buf,GS2LS_Request_Login& value)
{
    Writestring(buf,value.serverID);
    Writestring(buf,value.name);
    Writestring(buf,value.ip);
    Writeint(buf,value.port);
    Writeint(buf,value.remmond);
    Writeint(buf,value.showInUserGameList);
    Writeint(buf,value.hot);
}
void GS2LS_Request_Login::Send(){
    BeginSend(GS2LS_Request_Login);
    WriteGS2LS_Request_Login(buf,*this);
    EndSend();
}
void ReadGS2LS_Request_Login(char*& buf,GS2LS_Request_Login& value)
{
    Readstring(buf,value.serverID);
    Readstring(buf,value.name);
    Readstring(buf,value.ip);
    Readint(buf,value.port);
    Readint(buf,value.remmond);
    Readint(buf,value.showInUserGameList);
    Readint(buf,value.hot);
}
void WriteGS2LS_ReadyToAcceptUser(char*& buf,GS2LS_ReadyToAcceptUser& value)
{
    Writeint(buf,value.reserve);
}
void GS2LS_ReadyToAcceptUser::Send(){
    BeginSend(GS2LS_ReadyToAcceptUser);
    WriteGS2LS_ReadyToAcceptUser(buf,*this);
    EndSend();
}
void ReadGS2LS_ReadyToAcceptUser(char*& buf,GS2LS_ReadyToAcceptUser& value)
{
    Readint(buf,value.reserve);
}
void WriteGS2LS_OnlinePlayers(char*& buf,GS2LS_OnlinePlayers& value)
{
    Writeint(buf,value.playerCount);
}
void GS2LS_OnlinePlayers::Send(){
    BeginSend(GS2LS_OnlinePlayers);
    WriteGS2LS_OnlinePlayers(buf,*this);
    EndSend();
}
void ReadGS2LS_OnlinePlayers(char*& buf,GS2LS_OnlinePlayers& value)
{
    Readint(buf,value.playerCount);
}
void WriteGS2LS_QueryUserMaxLevelResult(char*& buf,GS2LS_QueryUserMaxLevelResult& value)
{
    Writeint64(buf,value.userID);
    Writeint(buf,value.maxLevel);
}
void GS2LS_QueryUserMaxLevelResult::Send(){
    BeginSend(GS2LS_QueryUserMaxLevelResult);
    WriteGS2LS_QueryUserMaxLevelResult(buf,*this);
    EndSend();
}
void ReadGS2LS_QueryUserMaxLevelResult(char*& buf,GS2LS_QueryUserMaxLevelResult& value)
{
    Readint64(buf,value.userID);
    Readint(buf,value.maxLevel);
}
void WriteGS2LS_UserReadyLoginResult(char*& buf,GS2LS_UserReadyLoginResult& value)
{
    Writeint64(buf,value.userID);
    Writeint(buf,value.result);
}
void GS2LS_UserReadyLoginResult::Send(){
    BeginSend(GS2LS_UserReadyLoginResult);
    WriteGS2LS_UserReadyLoginResult(buf,*this);
    EndSend();
}
void ReadGS2LS_UserReadyLoginResult(char*& buf,GS2LS_UserReadyLoginResult& value)
{
    Readint64(buf,value.userID);
    Readint(buf,value.result);
}
void WriteGS2LS_UserLoginGameServer(char*& buf,GS2LS_UserLoginGameServer& value)
{
    Writeint64(buf,value.userID);
}
void GS2LS_UserLoginGameServer::Send(){
    BeginSend(GS2LS_UserLoginGameServer);
    WriteGS2LS_UserLoginGameServer(buf,*this);
    EndSend();
}
void ReadGS2LS_UserLoginGameServer(char*& buf,GS2LS_UserLoginGameServer& value)
{
    Readint64(buf,value.userID);
}
void WriteGS2LS_UserLogoutGameServer(char*& buf,GS2LS_UserLogoutGameServer& value)
{
    Writeint64(buf,value.userID);
    Writestring(buf,value.identity);
}
void GS2LS_UserLogoutGameServer::Send(){
    BeginSend(GS2LS_UserLogoutGameServer);
    WriteGS2LS_UserLogoutGameServer(buf,*this);
    EndSend();
}
void ReadGS2LS_UserLogoutGameServer(char*& buf,GS2LS_UserLogoutGameServer& value)
{
    Readint64(buf,value.userID);
    Readstring(buf,value.identity);
}
void WriteGS2LS_ActiveCode(char*& buf,GS2LS_ActiveCode& value)
{
    Writestring(buf,value.pidStr);
    Writestring(buf,value.activeCode);
    Writeint(buf,value.retcode);
}
void GS2LS_ActiveCode::Send(){
    BeginSend(GS2LS_ActiveCode);
    WriteGS2LS_ActiveCode(buf,*this);
    EndSend();
}
void ReadGS2LS_ActiveCode(char*& buf,GS2LS_ActiveCode& value)
{
    Readstring(buf,value.pidStr);
    Readstring(buf,value.activeCode);
    Readint(buf,value.retcode);
}
void WriteLS2GS_Announce(char*& buf,LS2GS_Announce& value)
{
    Writestring(buf,value.pidStr);
    Writestring(buf,value.announceInfo);
}
void LS2GS_Announce::Send(){
    BeginSend(LS2GS_Announce);
    WriteLS2GS_Announce(buf,*this);
    EndSend();
}
void ReadLS2GS_Announce(char*& buf,LS2GS_Announce& value)
{
    Readstring(buf,value.pidStr);
    Readstring(buf,value.announceInfo);
}
void WriteLS2GS_Command(char*& buf,LS2GS_Command& value)
{
    Writestring(buf,value.pidStr);
    Writeint(buf,value.num);
    Writeint(buf,value.cmd);
    Writestring(buf,value.params);
}
void LS2GS_Command::Send(){
    BeginSend(LS2GS_Command);
    WriteLS2GS_Command(buf,*this);
    EndSend();
}
void ReadLS2GS_Command(char*& buf,LS2GS_Command& value)
{
    Readstring(buf,value.pidStr);
    Readint(buf,value.num);
    Readint(buf,value.cmd);
    Readstring(buf,value.params);
}
void WriteGS2LS_Command(char*& buf,GS2LS_Command& value)
{
    Writestring(buf,value.pidStr);
    Writeint(buf,value.num);
    Writeint(buf,value.cmd);
    Writeint(buf,value.retcode);
}
void GS2LS_Command::Send(){
    BeginSend(GS2LS_Command);
    WriteGS2LS_Command(buf,*this);
    EndSend();
}
void ReadGS2LS_Command(char*& buf,GS2LS_Command& value)
{
    Readstring(buf,value.pidStr);
    Readint(buf,value.num);
    Readint(buf,value.cmd);
    Readint(buf,value.retcode);
}
void WriteLS2GS_Recharge(char*& buf,LS2GS_Recharge& value)
{
    Writestring(buf,value.pidStr);
    Writestring(buf,value.orderid);
    Writeint(buf,value.platform);
    Writestring(buf,value.account);
    Writeint64(buf,value.userid);
    Writeint64(buf,value.playerid);
    Writeint(buf,value.ammount);
}
void LS2GS_Recharge::Send(){
    BeginSend(LS2GS_Recharge);
    WriteLS2GS_Recharge(buf,*this);
    EndSend();
}
void ReadLS2GS_Recharge(char*& buf,LS2GS_Recharge& value)
{
    Readstring(buf,value.pidStr);
    Readstring(buf,value.orderid);
    Readint(buf,value.platform);
    Readstring(buf,value.account);
    Readint64(buf,value.userid);
    Readint64(buf,value.playerid);
    Readint(buf,value.ammount);
}
void WriteGS2LS_Recharge(char*& buf,GS2LS_Recharge& value)
{
    Writestring(buf,value.pidStr);
    Writestring(buf,value.orderid);
    Writeint(buf,value.platform);
    Writeint(buf,value.retcode);
}
void GS2LS_Recharge::Send(){
    BeginSend(GS2LS_Recharge);
    WriteGS2LS_Recharge(buf,*this);
    EndSend();
}
void ReadGS2LS_Recharge(char*& buf,GS2LS_Recharge& value)
{
    Readstring(buf,value.pidStr);
    Readstring(buf,value.orderid);
    Readint(buf,value.platform);
    Readint(buf,value.retcode);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
