<?php
/*-----------------------------------------------------+
 * 清除角色缓存
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Clear extends Action{
    public function __construct(){
        parent::__construct();
    }

    public function process(){
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        $roleId = (int)$this->input['id'];
        Role::clearBaseCache($roleId);
        Role::clearExtCache($roleId);
        Role::clearCombatCache($roleId);
        
        //清除好友列表缓存
        $friend = Friend::getInstance($roleId);
        $friend->clearCache();

        Admin::redirect(Admin::url('list', '', '', true));
    }
}
