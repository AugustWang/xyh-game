<?php

/* *******************************************************
 *
 * 设置关卡
 *
 * ***************************************************** */

class Act_Send_tollgate extends GmAction
{

    public function __construct()
    {
        parent::__construct();
    }

    public function fields(){
        return array(
            'num' => array(
                'name' => '关卡',
                'attr' => '',
                'tips' => '',
            ),
        );
    }

    public function action()
    {
        if(!(isset($this->input['num']) && is_numeric($this->input['num']) && $this->input['num'] > 0)){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                (int)$this->input['id'],
                (int)$this->input['num'],
            )
        );
        $rt = $erl->get('lib_admin', 'set_tollgate', '[~u, ~u]', $arg);
        if ($rt[0] == "ok") {
            $log = sprintf("id:%d, num:%d",
                $this->input['id'],
                $this->input['num']
            );
            Admin::log(19, $log);
            echo("设置成功({$rt[0]}: {$rt[1]})");
        }else{
            echo("设置失败($rt[0])");
        }
    }
}
?>