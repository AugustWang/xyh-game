<?php

/* *******************************************************
 *
 * 充值补单
 *
 * ***************************************************** */

class Act_Send_buy extends GmAction
{

    public function __construct()
    {
        parent::__construct();
    }

    public function fields(){
        return array(
            'buy_type' => array(
                'name' => '类型',
                'attr' => '',
                'options' => array(
                    'com.mst.diamond_60'    => '  -6   RMB',
                    'com.mst.diamond_315'   => '  -30  RMB',
                    'com.mst.diamond_1078'  => '  -98  RMB',
                    'com.mst.diamond_1702'  => '  -148 RMB',
                    'com.mst.diamond_3696'  => '  -308 RMB',
                    'com.mst.diamond_5376'  => '  -448 RMB',
                    'com.mst.diamond_7725'  => '  -618 RMB',
                    'com.mst.diamond_yueka' => '月卡30 RMB',
                ),
                'tips' => '',
            ),
        );
    }

    public function action()
    {
            $erl = new Erlang();
            $erl->connect();
            $arg = array(
                array(
                    (int)$this->input['id'],
                    $this->input['buy_type'],
                )
            );
            $rt = $erl->get('lib_admin', 'add_buy', '[~u, ~s]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("id:%d, buy_type:%s",
                    (int)$this->input['id'],
                    $this->input['buy_type']
                );
                Admin::log(34, $log);
                echo("发送成功（{$rt[1]}：{$rt[2]}）");
            }else{
                echo("发送失败（{$rt[0]}）");
            }
    }

}
?>
