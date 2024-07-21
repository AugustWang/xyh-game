<?php

/* -----------------------------------------------------+
 * 充值日志
 * @author Rolong<rolong@vip.qq.com>
 +----------------------------------------------------- */

class Act_order extends ChargeCallback
{

    private
        $dbh,
        $limit = 30,
        $title = '充值订单',
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();
        if (isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000)
        {
            $this->limit = $this->input['limit'];
        }
        if (isset($this->input['page'])
            && is_numeric($this->input['page']))
        {
            $this->page = $this->input['page'];
        }
        $this->assign('limit', $this->limit);
    }

    public function process()
    {
        $data = array();
        $sql = "SELECT * FROM charge_order where 1";
        if($this->input['platformName'] && $this->input['platformName'] != 'all'){
            $sql .= " and platformName = '" . $this->input['platformName'] . "'";
        }else{
            $this->input['platformName'] = 'all';
        }
        if(isset($this->input['status']) && $this->input['status'] > 0){
            $sql .= " and isVerified = " . ($this->input['status']-1);
        }else{
            $this->input['status'] = 'all';
        }
        if ($this->input['start_time'])
        {
            $sql .= " and ctime >= '" . strtotime($this->input['start_time']) . "'";
        }
        if ($this->input['end_time'])
        {
            $sql .= " and ctime <= '" . strtotime($this->input['end_time']) . "'";
        }
        $sql .= " order by id desc";
        $data['list'] = $this->getList($sql);
		$totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql));
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('id', $this->input['id']);
        $this->assign('title', $this->title);
        $this->assign('formAction', Admin::url('', '', '', true));

        $platforms = array();
        $platforms['all'     ] = '全部'    ; 
        $platforms['a_oppo'  ] = 'a_oppo'  ; 
        $platforms['i_91'    ] = 'i_91'    ; 
        $platforms['a_91'    ] = 'a_91'    ;  
        $platforms['a_uc'    ] = 'a_uc'    ;  
        $platforms['a_wdj'   ] = 'a_wdj'   ; 
        $platforms['a_hw'    ] = 'a_hw'    ; 
        $platforms['i_tb'    ] = 'i_tb'    ; 
        $platforms['i_pp'    ] = 'i_pp'    ; 
        $platforms['a_dl'    ] = 'a_dl'    ; 
        $platforms['a_360'   ] = 'a_360'   ; 
        $platforms['a_lenovo'] = 'a_lenovo'; 
        $platforms['a_kp'    ] = 'a_kp'    ; 
        $platforms['a_xm'    ] = 'a_xm'    ; 
        $this->assign('platforms', Form::select('platformName', $platforms, $this->input['platformName']));
        $status = array();
        $status['0'] = '-全部-'  ; 
        $status['1' ] = '未发货'  ; 
        $status['2' ] = '已发货'  ; 
        $this->assign('status', Form::select('status', $status, $this->input['status']));
        if($this->input['order']){
            $msg = $this->order_notice($this->input['order']);
            $this->assign('msg', $msg);
        }
        $this->display();
    }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($sql)
    {
        $start = $this->page * $this->limit;
        $rs = $this->dbh->selectLimit($sql, $start, $this->limit);
        $list = array();
        $predefine = Defines::init();
        while ($row = $this->dbh->fetch_array($rs)) {
            $list[] = $row;
        }
        return $list;
    }

    /**
     * 生成批量处理按钮
     */
    private function op()
    {
        $btns = array(
        );
        return Form::batchSelector($btns);
    }

}
