<?php
/***************************************************************
 * 退出登录
 * @author rolong@vip.qq.com<rolong@vip.qq.com>
 ***************************************************************/
class Act_Logoff extends Action{
    public $AuthLevel = ACT_OPEN;
    public function process(){
        unset($_SESSION['admin_uid']);
        unset($_SESSION['admin_name']);
        session_unset();
        Admin::redirect(Admin::url('login', ''));
    }
}
