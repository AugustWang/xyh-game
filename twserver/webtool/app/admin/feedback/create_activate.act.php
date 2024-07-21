<?php

/* *******************************************************
 *
 * 生成兑换码,长度定死为8
 *
 * ***************************************************** */

class Act_create_activate extends Page
{

    public function __construct()
    {
        parent::__construct();
    }

    public function process()
    {
        if ($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            $arg = array(
                array(
                    (int)$this->input['num'],
                    (int)$this->input['type'],
                )
            );
            $rt = $erl->get('lib_admin', 'create_activate', '[~u,~u]', $arg);
            if ($rt == "ok") {
                $log = sprintf("num:%s,type:%s",
                    $this->input['num'],
                    $this->input['type']
                );
                Admin::log(35, $log);
                $this->assign('alert', "发送成功（{$rt}）");
            }else{
                $this->assign('alert', "last: {$rt} ");
            }
        }
        $this->display();
    }

}
?>
