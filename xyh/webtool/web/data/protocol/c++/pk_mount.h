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

struct mountInfo
{
    int8 mountDataID;
    int8 level;
    int8 equiped;
    int8 progress;
    int benison_Value;
};
void WritemountInfo(char*& buf,mountInfo& value);
void ReadmountInfo(char*& buf,mountInfo& value);

struct U2GS_QueryMyMountInfo
{
    int8 reserve;
	void Send();
};
void WriteU2GS_QueryMyMountInfo(char*& buf,U2GS_QueryMyMountInfo& value);
void ReadU2GS_QueryMyMountInfo(char*& buf,U2GS_QueryMyMountInfo& value);

struct GS2U_QueryMyMountInfoResult
{
    vector<mountInfo> mounts;
};
void WriteGS2U_QueryMyMountInfoResult(char*& buf,GS2U_QueryMyMountInfoResult& value);
void OnGS2U_QueryMyMountInfoResult(GS2U_QueryMyMountInfoResult* value);
void ReadGS2U_QueryMyMountInfoResult(char*& buf,GS2U_QueryMyMountInfoResult& value);

struct GS2U_MountInfoUpdate
{
    mountInfo mounts;
};
void WriteGS2U_MountInfoUpdate(char*& buf,GS2U_MountInfoUpdate& value);
void OnGS2U_MountInfoUpdate(GS2U_MountInfoUpdate* value);
void ReadGS2U_MountInfoUpdate(char*& buf,GS2U_MountInfoUpdate& value);

struct GS2U_MountOPResult
{
    int8 mountDataID;
    int result;
};
void WriteGS2U_MountOPResult(char*& buf,GS2U_MountOPResult& value);
void OnGS2U_MountOPResult(GS2U_MountOPResult* value);
void ReadGS2U_MountOPResult(char*& buf,GS2U_MountOPResult& value);

struct U2GS_MountEquipRequest
{
    int8 mountDataID;
	void Send();
};
void WriteU2GS_MountEquipRequest(char*& buf,U2GS_MountEquipRequest& value);
void ReadU2GS_MountEquipRequest(char*& buf,U2GS_MountEquipRequest& value);

struct U2GS_Cancel_MountEquipRequest
{
    int8 reserve;
	void Send();
};
void WriteU2GS_Cancel_MountEquipRequest(char*& buf,U2GS_Cancel_MountEquipRequest& value);
void ReadU2GS_Cancel_MountEquipRequest(char*& buf,U2GS_Cancel_MountEquipRequest& value);

struct U2GS_MountUpRequest
{
    int8 reserve;
	void Send();
};
void WriteU2GS_MountUpRequest(char*& buf,U2GS_MountUpRequest& value);
void ReadU2GS_MountUpRequest(char*& buf,U2GS_MountUpRequest& value);

struct GS2U_MountUp
{
    int64 actorID;
    int8 mount_data_id;
};
void WriteGS2U_MountUp(char*& buf,GS2U_MountUp& value);
void OnGS2U_MountUp(GS2U_MountUp* value);
void ReadGS2U_MountUp(char*& buf,GS2U_MountUp& value);

struct U2GS_MountDownRequest
{
    int8 reserve;
	void Send();
};
void WriteU2GS_MountDownRequest(char*& buf,U2GS_MountDownRequest& value);
void ReadU2GS_MountDownRequest(char*& buf,U2GS_MountDownRequest& value);

struct GS2U_MountDown
{
    int64 actorID;
};
void WriteGS2U_MountDown(char*& buf,GS2U_MountDown& value);
void OnGS2U_MountDown(GS2U_MountDown* value);
void ReadGS2U_MountDown(char*& buf,GS2U_MountDown& value);

struct U2GS_LevelUpRequest
{
    int8 mountDataID;
    int8 isAuto;
	void Send();
};
void WriteU2GS_LevelUpRequest(char*& buf,U2GS_LevelUpRequest& value);
void ReadU2GS_LevelUpRequest(char*& buf,U2GS_LevelUpRequest& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
