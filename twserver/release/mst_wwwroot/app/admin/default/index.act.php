<?php
/*-----------------------------------------------------+
 * 网站管理入口模块 
 * @author yeahoo2000@gmail.com
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
