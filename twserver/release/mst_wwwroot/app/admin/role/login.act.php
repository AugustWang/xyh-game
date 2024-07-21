<?php

/* -----------------------------------------------------+
 * 直接登录玩家账号
  +----------------------------------------------------- */

class Act_Login extends Page
{
    /**
	 * 默认每页条数
	 * @var int
	 */
	private $limit = 30;
	/**
	 * 默认为第一页
	 * @var int
	 */
	private $page = 0;

	public function __construct()
	{
		parent::__construct();
        if (isset($this->input['page']) && is_numeric($this->input['page']))
		{
			$this->page = $this->input['page'];
		}
		if (isset($this->input['limit']) && is_numeric($this->input['limit']))
		{
			$this->limit = $this->input['limit'];
		}
	}

	public function process()
	{
		$where = '';
        $this->input['acc_id'] = (int)$this->input['acc_id'];
		if ($this->input['acc_id'] > 0)
		{
			$where = "account_id='{$this->input['acc_id']}'";
		} elseif ($this->input['acc_name'])
		{
			$where = "account_name='{$this->input['acc_name']}'";
		}
         elseif ($this->input['role_name'])
		{
			$where = "name='{$this->input['role_name']}'";
		}
        $db = Db::getInstance();
		if ($where)
		{
            
			$acc = $db->getRow("select * from role where {$where} limit 1");
			if(!$acc)
			{
				$this->assign('msg',  '该玩家不存在！');
				$this->display();
				exit;
			}
			$conf = Config::getInstance();
			$ts = time();
            $db->query("INSERT INTO `log_admin_login` (`ctime`, `admin_name`, `acc_id`, `acc_name`, `role_name`, `ip`) 
                VALUES ('{$ts}', '{$_SESSION['admin_username']}', '{$this->input['acc_id']}', '{$this->input['acc_name']}', '{$this->input['role_name']}', '".clientIp()."')");
            $acc['account_name'] = urlencode($acc['account_name']);
			$ticket = createTicket($acc['account_id'], $acc['account_name'], $ts, $conf->get('server_key'));
			header('Location: /login.php?'
				.'userid='.$acc['account_id']
				.'&username='. $acc['account_name']
				.'&time='.$ts
				.'&flag='.$ticket
			);
			exit;
		}
        
        $sql =  " from log_admin_login order by id desc";
        $totalRecord = $db->getOne("select count(*) $sql");
        if ($this->page * $this->limit >= $totalRecord)
			$this->page = 0;
		$limit = " limit " . $this->page * $this->limit . ", {$this->limit}";
        $this->assign('log', $db->getAll("select * $sql $limit"));
        $this->assign('page', Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit));
		$this->display();
	}

}
