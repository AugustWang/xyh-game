<?php

/* *******************************************************
 *
 * 扣除货币
 *
 * ***************************************************** */

class Act_Send_deduct extends GmAction
{

    public function __construct()
    {
        parent::__construct();
    }

    public function fields(){
        return array(
            'money_type' => array(
                'name' => '类型',
                'attr' => '',
                'options' => array(
                    'diamond' => '钻石',
                    'gold' => '金币',
                    'luck' => '幸运星',
                ),
                'tips' => '',
            ),
            'money' => array(
                'name' => '数量',
                'attr' => '',
                'tips' => '',
            ),
        );
    }

    public function action()
    {
        if(!(isset($this->input['money']) && is_numeric($this->input['money']) && $this->input['money'] > 0)){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                //$this->input['id_type'],
                (int)$this->input['id'],
                $this->input['money_type'],
                (int)$this->input['money'],
            )
        );
        $rt = $erl->get('lib_admin', 'set_attr', '[~u, ~a, ~u]', $arg);
        //var_dump($rt);
        if ($rt[0] == "ok") {
            $log = sprintf("id:%d, money_type:%s, num:%d",
                //$this->input['id_type'],
                $this->input['id'],
                $this->input['money_type'],
                $this->input['money']
            );
            Admin::log(30, $log);
            echo("发送成功（{$rt[1]}：{$rt[2]}）");
        }else{
            echo($rt[0]);
        }
    }
}
?>
