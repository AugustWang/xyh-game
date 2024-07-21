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

void WriteSkillcooldown(char*& buf,Skillcooldown& value)
{
    Writeint(buf,value.skillID);
    Writeint(buf,value.time);
}
void ReadSkillcooldown(char*& buf,Skillcooldown& value)
{
    Readint(buf,value.skillID);
    Readint(buf,value.time);
}
};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
