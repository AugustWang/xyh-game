<?php

/* -----------------------------------------------------+
 * 运营自定义活动
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Extra extends Page
{
    private $limit = 30, $page = 0;

    public function __construct()
    {
        parent::__construct();
        $active_type['hero']      = "酒馆购买英雄";
        $active_type['rmb']       = "RMB充值";
        $active_type['tollgate']  = "关卡挑战";
        $active_type['colosseum'] = "角斗场排名";
        $active_type['luck']      = "幸运星抽奖";
        $this->active_type = $active_type;

        $this->db = Db::getInstance();
        if (isset($this->input['page']) && is_numeric($this->input['page'])) {
            $this->page = $this->input['page'];
        }
        if (isset($this->input['limit']) && is_numeric($this->input['limit'])) {
            $this->limit = $this->input['limit'];
        }
    }

    public function process()
    {
        // if ($this->input['body'] && $this->input['value'] && $this->input['start_time'] && $this->input['end_time']){
        // } else {
        //     $this->assign('alert', "没有填全内容");
        //     $this->display();
        // }
        if ($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            // $type = $this->input['type'];
            // $val = $this->input['value'];
            $arg = array(
                array(
                    $this->input['type'],
                    $this->input['value'],
                    $this->input['body'],
                    (int)strtotime($this->input['kw']['start_time']),
                    (int)strtotime($this->input['kw']['end_time']),
                )
            );
            $rt = $erl->get('lib_admin', 'active_set', '[~s, ~s, ~s, ~u, ~u]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("type:%s, value:%s, body:%s
                    ,sd_st:%d,sd_et:%d",
                    $this->input['type'],
                    $this->input['value'],
                    $this->input['body'],
                    (int)$this->input['kw']['start_time'],
                    (int)$this->input['kw']['end_time']
                );
                Admin::log(36, $log);
                $this->assign('alert', "设置发送成功{$rt[0]}");
            }else{
                $this->assign('alert', $rt[0]);
            }
        }
        $this->assign('type', Form::select('type', $this->active_type, $this->input['type']));
        $this->display();
    }
}
?>
