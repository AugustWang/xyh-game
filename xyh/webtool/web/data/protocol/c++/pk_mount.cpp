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

void WritemountInfo(char*& buf,mountInfo& value)
{
    Writeint8(buf,value.mountDataID);
    Writeint8(buf,value.level);
    Writeint8(buf,value.equiped);
    Writeint8(buf,value.progress);
    Writeint(buf,value.benison_Value);
}
void ReadmountInfo(char*& buf,mountInfo& value)
{
    Readint8(buf,value.mountDataID);
    Readint8(buf,value.level);
    Readint8(buf,value.equiped);
    Readint8(buf,value.progress);
    Readint(buf,value.benison_Value);
}
void WriteU2GS_QueryMyMountInfo(char*& buf,U2GS_QueryMyMountInfo& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_QueryMyMountInfo::Send(){
    BeginSend(U2GS_QueryMyMountInfo);
    WriteU2GS_QueryMyMountInfo(buf,*this);
    EndSend();
}
void ReadU2GS_QueryMyMountInfo(char*& buf,U2GS_QueryMyMountInfo& value)
{
    Readint8(buf,value.reserve);
}
void WriteGS2U_QueryMyMountInfoResult(char*& buf,GS2U_QueryMyMountInfoResult& value)
{
    WriteArray(buf,mountInfo,value.mounts);
}
void ReadGS2U_QueryMyMountInfoResult(char*& buf,GS2U_QueryMyMountInfoResult& value)
{
    ReadArray(buf,mountInfo,value.mounts);
}
void WriteGS2U_MountInfoUpdate(char*& buf,GS2U_MountInfoUpdate& value)
{
    WritemountInfo(buf,value.mounts);
}
void ReadGS2U_MountInfoUpdate(char*& buf,GS2U_MountInfoUpdate& value)
{
    ReadmountInfo(buf,value.mounts);
}
void WriteGS2U_MountOPResult(char*& buf,GS2U_MountOPResult& value)
{
    Writeint8(buf,value.mountDataID);
    Writeint(buf,value.result);
}
void ReadGS2U_MountOPResult(char*& buf,GS2U_MountOPResult& value)
{
    Readint8(buf,value.mountDataID);
    Readint(buf,value.result);
}
void WriteU2GS_MountEquipRequest(char*& buf,U2GS_MountEquipRequest& value)
{
    Writeint8(buf,value.mountDataID);
}
void U2GS_MountEquipRequest::Send(){
    BeginSend(U2GS_MountEquipRequest);
    WriteU2GS_MountEquipRequest(buf,*this);
    EndSend();
}
void ReadU2GS_MountEquipRequest(char*& buf,U2GS_MountEquipRequest& value)
{
    Readint8(buf,value.mountDataID);
}
void WriteU2GS_Cancel_MountEquipRequest(char*& buf,U2GS_Cancel_MountEquipRequest& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_Cancel_MountEquipRequest::Send(){
    BeginSend(U2GS_Cancel_MountEquipRequest);
    WriteU2GS_Cancel_MountEquipRequest(buf,*this);
    EndSend();
}
void ReadU2GS_Cancel_MountEquipRequest(char*& buf,U2GS_Cancel_MountEquipRequest& value)
{
    Readint8(buf,value.reserve);
}
void WriteU2GS_MountUpRequest(char*& buf,U2GS_MountUpRequest& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_MountUpRequest::Send(){
    BeginSend(U2GS_MountUpRequest);
    WriteU2GS_MountUpRequest(buf,*this);
    EndSend();
}
void ReadU2GS_MountUpRequest(char*& buf,U2GS_MountUpRequest& value)
{
    Readint8(buf,value.reserve);
}
void WriteGS2U_MountUp(char*& buf,GS2U_MountUp& value)
{
    Writeint64(buf,value.actorID);
    Writeint8(buf,value.mount_data_id);
}
void ReadGS2U_MountUp(char*& buf,GS2U_MountUp& value)
{
    Readint64(buf,value.actorID);
    Readint8(buf,value.mount_data_id);
}
void WriteU2GS_MountDownRequest(char*& buf,U2GS_MountDownRequest& value)
{
    Writeint8(buf,value.reserve);
}
void U2GS_MountDownRequest::Send(){
    BeginSend(U2GS_MountDownRequest);
    WriteU2GS_MountDownRequest(buf,*this);
    EndSend();
}
void ReadU2GS_MountDownRequest(char*& buf,U2GS_MountDownRequest& value)
{
    Readint8(buf,value.reserve);
}
void WriteGS2U_MountDown(char*& buf,GS2U_MountDown& value)
{
    Writeint64(buf,value.actorID);
}
void ReadGS2U_MountDown(char*& buf,GS2U_MountDown& value)
{
    Readint64(buf,value.actorID);
}
void WriteU2GS_LevelUpRequest(char*& buf,U2GS_LevelUpRequest& value)
{
    Writeint8(buf,value.mountDataID);
    Writeint8(buf,value.isAuto);
}
void U2GS_LevelUpRequest::Send(){
    BeginSend(U2GS_LevelUpRequest);
    WriteU2GS_LevelUpRequest(buf,*this);
    EndSend();
}
void ReadU2GS_LevelUpRequest(char*& buf,U2GS_LevelUpRequest& value)
{
    Readint8(buf,value.mountDataID);
    Readint8(buf,value.isAuto);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
