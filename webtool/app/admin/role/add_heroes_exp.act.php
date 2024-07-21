<?php

/* *******************************************************
 *
 * 增加英雄经验
 *
 * ***************************************************** */

class Act_Add_heroes_Exp extends Page
{

	public function __construct()
	{
		parent::__construct();
	}

    public function process()
    {
        if($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            $arg = array(
                array(
                    (int)$this->input['id'],
                    (int)$this->input['num'],
                )
            );
            $rt = $erl->get('lib_admin', 'add_heroes_exp', '[~u, ~u]', $arg);
            $log = sprintf("id:%d, num:%d", 
                $this->input['id'],
                $this->input['num']
            );
            Admin::log(16, $log);
            $this->assign('alert', "OK");
        }
		$this->assign('id', $this->input['id']);
		$this->display();
	}

}
?>
