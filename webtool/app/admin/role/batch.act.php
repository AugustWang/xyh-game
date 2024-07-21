<?php

/* * ******************************************************
 *
 * 批量 “禁言”、“封号”、“踢人”、“解除禁言”、“解除封号”操作
 *
 * ***************************************************** */

class Act_batch extends Page
{

	public function __construct()
	{
		parent::__construct();
	}

	private function batch_doing($role_id)
	{
		$erl = new Erlang();
		$erl->connect();
		$timeout = (int) $this->input['timeout'];
		$timeout2 = $timeout ? time() + $timeout * 3600 : 1893427200;
		$db = Db::getInstance();
		foreach($role_id as $rid=>$v)
		{
			switch($this->input['submit'])
			{
				case '禁言':
					$erl->get('lib_admin', 'stop_chat', '[~u,~u]', array(array((int) $rid, $timeout)));
					break;
				case '封号':
					$memo = trim($this->input['memo']);
					if($memo)
					{
						$db->query("update role set actived={$timeout2} where id = {$rid}");
						$db->query("INSERT INTO `log_lock_memo` (`admin_name`, `role_id`, `ctime`, `timeout`, `type`, `memo`) VALUES ('{$_SESSION['admin_username']}', '{$rid}', '".time()."', '{$timeout2}', '0', '{$memo}');");
					}else{
						exit('请输入原因');
					}
					break;
				case '踢人':
					$erl->get('lib_role', 'kick', '[~l,~b,~a]', array(array((int) $rid, "服务器要求您断开连接", "all_zone")));
					break;
				case '解除禁言':
					$erl->get('lib_admin', 'open_chat', '[~u]', array(array((int) $rid)));
					break;
				case '解除封号':
					$memo = trim($this->input['memo']);
					if($memo)
					{
						$db->query("update role set actived=0 where id = {$rid}");
						$db->query("INSERT INTO `log_lock_memo` (`admin_name`, `role_id`, `ctime`, `timeout`, `type`, `memo`) VALUES ('{$_SESSION['admin_username']}', '{$rid}', '".time()."', '0', '1', '{$memo}');");
					}else{
						exit('请输入原因');
					}
					break;
			}
		}
		$this->assign('err', "操作已完成！");
	}
	
	public function process()
	{
		if($this->input['role_id'] || $this->input['role_name'])
		{
			$role_id =array();
			$exp = explode(",", $this->input['role_id']);
			$db = Db::getInstance();
			foreach($exp as $v)
			{
				$rid = (int)$v;
				if(!$rid)continue;
				$rid = $db->getOne("select id from role where id = '{$rid}'");
				if(!$rid)
				{
					$this->assign('err', "$v 不存在！");
					$this->display();
					exit;
				}
				$role_id[$rid] = 0;
			}
			$exp = explode(",", $this->input['role_name']);
			
			foreach($exp as $v)
			{
				if(!$v)continue;
				$rid = $db->getOne("select id from role where name = '{$v}'");
				if(!$rid)
				{
					$this->assign('err', "$v 不存在！");
					$this->display();
					exit;
				}
				$role_id[$rid] = 0;
			}
			$this->batch_doing($role_id);
		}

		//$this->assign('data', $data);
		$this->display();
	}

}

?>
