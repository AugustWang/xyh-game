<?php

/* *******************************************************
 *
 * 重置密码
 *
 * ***************************************************** */

class Act_Reset_passwd extends GmAction
{

	public function __construct()
	{
		parent::__construct();
	}

    public function fields(){
        return array(
            'password' => array(
                'name' => '新密码',
                'attr' => '',
                'tips' => '慎重操作,操作不可逆',
            ),
        );
    }

    public function action()
    {
        if($this->input['password'] == ''){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                (int)$this->input['id'],
                $this->input['password'],
            )
        );
        $rt = $erl->get('lib_admin', 'reset_password', '[~u, ~s]', $arg);
        if ($rt[0] == "ok") {
            $log = sprintf("id:%d, num:%s",
                $this->input['id'],
                $this->input['password']
            );
            Admin::log(26, $log);
            echo("设置成功({$rt[0]}: {$rt[1]})");
        }else{
            echo("设置失败({$rt[0]}: {$rt[1]})");
        }
    }

}
?>
