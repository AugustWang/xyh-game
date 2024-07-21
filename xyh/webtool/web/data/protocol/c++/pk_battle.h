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

struct Skillcooldown
{
    int skillID;
    int time;
};
void WriteSkillcooldown(char*& buf,Skillcooldown& value);
void OnSkillcooldown(Skillcooldown* value);
void ReadSkillcooldown(char*& buf,Skillcooldown& value);


};

// vim: set foldmethod=marker filetype=c foldmarker=%%',%%.:
