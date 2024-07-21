<?php

/* -----------------------------------------------------+
 * 运营定时活动
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Timeing extends Page
{
    private $limit = 30, $page = 0;

    public function __construct()
    {
        parent::__construct();
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
        if ($this->input['submit'] == '发送')
        {
            $erl = new Erlang();
            $erl->connect();
            $items1 = "{".$this->input['money_type1'].",".(int)$this->input['money1']."}";
            $items2 = "{".$this->input['money_type2'].",".(int)$this->input['money2']."}";
            $items3 = "{".$this->input['money_type3'].",".(int)$this->input['money3']."}";
            $items4 = "{".$this->input['item_type'].",".(int)$this->input['itemid'].",".(int)$this->input['items']."}";
            $items5 = "{".$this->input['heroes_id'].",".(int)$this->input['heroid'].",".(int)$this->input['quality']."}";
            // $arg = array(
            //     array(
            //         $this->input['id'],
            //         $this->input['body'],
            //         $this->input['item_type'],
            //         (int)$this->input['itemid'],
            //         //$this->input['item_num'],
            //         (int)$this->input['items'],
            //         $this->input['heroes_id'],
            //         (int)$this->input['heroid'],
            //         //$this->input['heroes_quality'],
            //         (int)$this->input['quality'],
            //     )
            // );
            $arg = array(
                array(
                    $this->input['id'],
                    $this->input['body'],
                    "[".$items1.",".$items2.",".$items3.",".$items4.",".$items5."]",
                    (int)strtotime($this->input['kw']['start_time']),
                    (int)strtotime($this->input['kw']['end_time']),
                )
            );
            $rt = $erl->get('lib_admin', 'send_email', '[~s, ~s, ~s, ~u, ~u]', $arg);
            if ($rt[0] == "ok") {
                $log = sprintf("id:%s, body:%s
                    ,money_type1:%s, money1:%d
                    ,money_type2:%s, money2:%d
                    ,money_type3:%s, money3:%d
                    ,item_type:%s, itemid:%d, items:%d
                    ,heroes_id:%s, heroid:%d, quality:%d
                    ,start_time:%d, end_time:%d",
                    $this->input['id'],
                    $this->input['body'],
                    $this->input['money_type1'],
                    (int)$this->input['money1'],
                    $this->input['money_type2'],
                    (int)$this->input['money2'],
                    $this->input['money_type3'],
                    (int)$this->input['money3'],
                    $this->input['item_type'],
                    (int)$this->input['itemid'],
                    //$this->input['itme_num'],
                    (int)$this->input['items'],
                    $this->input['heroes_id'],
                    (int)$this->input['heroid'],
                    //$this->input['heroes_quality'],
                    (int)$this->input['quality'],
                    (int)strtotime($this->input['kw']['start_time']),
                    (int)strtotime($this->input['kw']['end_time'])
                );
                Admin::log(27, $log);
                $this->assign('alert', "发送成功（{$rt[1]}：{$rt[2]}）");
            }else{
                $this->assign('alert', $rt[0]);
            }
        }
        $this->assign('id', $this->input['id']);
        $this->display();
    }

}
?>
