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

using namespace std;

const int MSG_LS2GS_LoginResult			= 401;
const int MSG_LS2GS_QueryUserMaxLevel			= 402;
const int MSG_LS2GS_UserReadyToLogin			= 403;
const int MSG_LS2GS_KickOutUser			= 404;
const int MSG_LS2GS_ActiveCode			= 405;
const int MSG_GS2LS_Request_Login			= 406;
const int MSG_GS2LS_ReadyToAcceptUser			= 407;
const int MSG_GS2LS_OnlinePlayers			= 408;
const int MSG_GS2LS_QueryUserMaxLevelResult			= 409;
const int MSG_GS2LS_UserReadyLoginResult			= 410;
const int MSG_GS2LS_UserLoginGameServer			= 411;
const int MSG_GS2LS_UserLogoutGameServer			= 412;
const int MSG_GS2LS_ActiveCode			= 413;
const int MSG_LS2GS_Announce			= 414;
const int MSG_LS2GS_Command			= 415;
const int MSG_GS2LS_Command			= 416;
const int MSG_LS2GS_Recharge			= 417;
const int MSG_GS2LS_Recharge			= 418;

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
