<?php

/* *******************************************************
 *
 * 发送短信验证码
 *
 * ***************************************************** */

class Act_Send_Verify extends GmAction
{

    public function __construct()
    {
        parent::__construct();
    }

    public function fields(){
        return array(
            'telephone' => array(
                'name' => '手机号码',
                'attr' => '',
                'tips' => '',
            ),
        );
    }

    public function action()
    {
        if(!(isset($this->input['telephone']) && is_numeric($this->input['telephone']) && $this->input['telephone'] > 0)){
            echo("参数错误");
            return;
        }
        if(strlen($this->input['telephone']) != 11){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                (int)$this->input['id'],
                $this->input['telephone'],
            )
        );
        $rt = $erl->get('lib_admin', 'send_verify', '[~u, ~s]', $arg);
        if ($rt[0] == "ok") {
            $log = sprintf("id:%d, telephone:%s",
                $this->input['id'],
                $this->input['telephone']
            );
            Admin::log(29, $log);
            echo("发送成功({$rt[0]}: {$rt[1]})");
        }else{
            echo("发送失败({$rt[0]}: {$rt[1]})");
        }
    }

}
?>
