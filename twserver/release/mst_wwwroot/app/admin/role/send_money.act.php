<?php

/* *******************************************************
 *
 * 发送货币
 *
 * ***************************************************** */

class Act_Send_money extends GmAction
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
        if(!(isset($this->input['money']) && is_numeric($this->input['money']) && (int)$this->input['money'] > 0)){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                'role_id',
                $this->input['id'],
                $this->input['money_type'],
                (int)$this->input['money'],
            )
        );
        $rt = $erl->get('lib_admin', 'add_attr', '[~a, ~s, ~a, ~u]', $arg);
        if ($rt[0] == "ok") {
            $log = sprintf("id_type:%s, id:%s, money_type:%s, num:%d",
                'role_id',
                $this->input['id'],
                $this->input['money_type'],
                $this->input['money']
            );
            Admin::log(12, $log);
            echo("发送成功（{$rt[1]}：{$rt[2]}）");
        }else{
            echo($rt[0]);
        }
    }
}
