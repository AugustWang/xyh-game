<?php

/* *******************************************************
 *
 * 发送物品
 *
 * ***************************************************** */

class Act_Send_item extends GmAction
{

	public function __construct()
	{
		parent::__construct();
	}

    public function fields(){
        return array(
            'tid' => array(
                'name' => '物品/分类ID',
                'attr' => ' id="itemid" ',
                'tips' => '',
            ),
            'num' => array(
                'name' => '物品数量',
                'attr' => '',
                'tips' => '数量不要太大(<100)',
            ),
        );
    }

    // 扩展参数
    // public function params(){
    //     return array(
    //         'id_type' => '"role_id"',
    //     );
    // }

    public function action(){
        if(!(isset($this->input['num']) && is_numeric($this->input['num']) && $this->input['num'] > 0)){
            echo("参数错误");
            return;
        }
        if($this->input['num'] > 100){
            echo("参数错误");
            return;
        }
        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                'role_id',
                $this->input['id'],
                (int)$this->input['tid'],
                (int)$this->input['num'],
            )
        );
        $rt = $erl->get('lib_admin', 'add_item', '[~a, ~s, ~u, ~u]', $arg);
        if ($rt[0] == "ok") {
            $log = sprintf("id_type:%s, id:%s, tid:%d, num:%d",
                'role_id',
                $this->input['id'],
                $this->input['tid'],
                $this->input['num']
            );
            Admin::log(14, $log);
            echo "发送成功（{$rt[1]}：{$rt[2]}）";
        }else{
            echo $rt[0];
        }
    }
}
