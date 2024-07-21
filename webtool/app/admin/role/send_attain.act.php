<?php

/* *******************************************************
 *
 * 发送成就
 *
 * ***************************************************** */

class Act_Send_attain extends Page
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
                    // $this->input['id_type'],
                    (int)$this->input['id'],
                    (int)$this->input['tid'],
                    (int)$this->input['num'],
                )
            );
            $rt = $erl->get('lib_admin', 'add_attain', '[~u, ~u, ~u]', $arg);
            if($rt[0] == "ok") {
                $log = sprintf("id:%d, tid:%d, num:%d", 
                    $this->input['id'],
                    $this->input['tid'],
                    $this->input['num']
                );
                Admin::log(13, $log);
                $this->assign('alert', "发送成功（{$rt[1]}：{$rt[2]}）");
            }else{
                $this->assign('alert', $rt[0]);
            }
        }
		$this->assign('id', $this->input['id']);
		$this->display();
	}

}
?>
