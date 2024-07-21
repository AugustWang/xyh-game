<?php
/**
 * 查看修改角色属性日志
 */

class Act_Log_Edit_Role extends Page {
	private $limit = 30;	
	
	/**
	 * 默认为第一页
	 * @var int
	 */
	private $page = 0;
	
	public function  __construct() {    	
        parent::__construct();
        $this->clearParamCache();
		if (isset($this->input['page']) && is_numeric($this->input['page'])){
        	$this->page = $this->input['page'];
        }	
        if (isset($this->input['limit']) && is_numeric($this->input['limit'])){
        	$this->limit = $this->input['limit'];
        }
    }
    public function process(){
    	$db = Db::getInstance();
    	$time = time() - 3*24*3600;
    	//$db->query("delete from log_admin_edit_role where ctime < {$time}");
    	$sql = "select * from log_admin_edit_role";
    	$order = " order by id desc";
    	
    	$totalRecord = $db->getOne(preg_replace("/^select.*from/i","select count(*) as total from ",$sql));    	
    	if ($this->page * $this->limit >= $totalRecord) $this->page = 0;
    	$this->addParamCache(array('page'=>$this->page));    	
    	$limit = " limit " . $this->page * $this->limit . ", {$this->limit}";

    	$this->assign('list', $db->getAll($sql.$order.$limit));
    	$this->assign('page', $this->createPager($totalRecord));
    	$this->assign('limit', $this->limit);
    	$this->display();
    }
    
	private function createPager($totalRecord){
    	if (!$totalRecord) return;
    	$pager = Utils::pager(Admin::url('','','',true), $totalRecord, $this->page, $this->limit);
    	return $pager;
     }
}