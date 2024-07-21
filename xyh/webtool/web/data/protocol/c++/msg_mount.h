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

const int MSG_U2GS_QueryMyMountInfo			= 602;
const int MSG_GS2U_QueryMyMountInfoResult			= 603;
const int MSG_GS2U_MountInfoUpdate			= 604;
const int MSG_GS2U_MountOPResult			= 605;
const int MSG_U2GS_MountEquipRequest			= 606;
const int MSG_U2GS_Cancel_MountEquipRequest			= 607;
const int MSG_U2GS_MountUpRequest			= 608;
const int MSG_GS2U_MountUp			= 609;
const int MSG_U2GS_MountDownRequest			= 610;
const int MSG_GS2U_MountDown			= 611;
const int MSG_U2GS_LevelUpRequest			= 612;

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
