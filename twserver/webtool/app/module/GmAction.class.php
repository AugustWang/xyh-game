<?php

/* *******************************************************
 *
 * Gm Action Op
 *
 * ***************************************************** */

class GmAction extends Page
{
    public $gm_action_template = 'gm_action';
	public function __construct()
	{
		parent::__construct();
	}

    public function fields(){
        // key 不能为: id | mod | act | rand | op
        //
        // return array(
        //     'money_type' => array(
        //         'name' => '类型',
        //         'attr' => '',
        //         'options' => array(
        //             'diamond' => '钻石',
        //             'gold' => '金币',
        //         ),
        //         'tips' => '',
        //     ),
        //     'money' => array(
        //         'name' => '数量',
        //         'attr' => '',
        //         'tips' => '',
        //     ),
        // );
        return array();
    }

    public function params(){
        // return array(
        //     'id_type' => 'role_id',
        // );
        return array();
    }

    public function process()
    {
        if ($this->input['op'] == 1)
        {
            if (!extension_loaded('ropeb')) {
                echo 'No ropeb module!';
                return;
            }
            $this->action();
            echo $GLOBALS['erl_error'];
        }else{
            $fields = $this->fields();
            $params = array();
            foreach($this->params() as $k => $v){
                $params[$k] = '"'.$v.'"';
            }
            $this->clearTemplate();
            $this->addTemplate($this->gm_action_template);
            $this->assign('fields', $fields);
            $this->assign('params', $params);
            $this->display();
        }
    }
}
