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

const int MSG_GS2U_LoadFriend			= 202;
const int MSG_U2GS_QueryFriend			= 203;
const int MSG_GS2U_FriendTips			= 204;
const int MSG_GS2U_LoadBlack			= 205;
const int MSG_U2GS_QueryBlack			= 206;
const int MSG_GS2U_LoadTemp			= 207;
const int MSG_U2GS_QueryTemp			= 208;
const int MSG_GS2U_FriendInfo			= 209;
const int MSG_U2GS_AddFriend			= 210;
const int MSG_GS2U_AddAcceptResult			= 211;
const int MSG_U2GS_DeleteFriend			= 212;
const int MSG_U2GS_AcceptFriend			= 213;
const int MSG_GS2U_DeteFriendBack			= 214;
const int MSG_GS2U_Net_Message			= 215;
const int MSG_GS2U_OnHookSet_Mess			= 216;

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
