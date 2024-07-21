<?php
/*-----------------------------------------------------+
 * 网站管理入口模块 
 * @author rolong@vip.qq.com<rolong@vip.qq.com>
 +-----------------------------------------------------*/
class Act_Index extends Page{
    public function __construct(){
        parent::__construct();
    }

    public function process(){
		$cfg = Config::getInstance();
		$this->assign('ver', $cfg->get('version'));
		$this->assign('server_name', $cfg->get('server_name'));
        $this->display();
    }
}
