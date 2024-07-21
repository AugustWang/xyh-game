<?php

/* *******************************************************
 *
 * 发送成就
 *
 * ***************************************************** */

class Act_Send_attain extends GmAction
{

	public function __construct()
	{
		parent::__construct();
	}

    public function fields(){
        return array(
            'tid' => array(
                'name' => '成就/分类ID',
                'attr' => '',
                'tips' => '',
            ),
            'num' => array(
                'name' => '数量',
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
            echo "发送成功（{$rt[1]}：{$rt[2]}）";
        }else{
            echo $rt[0];
        }
    }
}
