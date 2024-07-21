<?php

/* -----------------------------------------------------+
 * 英雄购买日志数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_statis_growth extends Page
{

    private
        //$log_type,
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        //include(WEB_DIR . "/protocol/log_type.php");
        //$this->log_type = $log_type;

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if (
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        )
        {
            $this->limit = $this->input['limit'];
        }

        if (
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        )
        {
            $this->page = $this->input['page'];
        }

        $this->assign('limit', $this->limit);
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process()
    {
        $data = array();
        $sqlwheres = array();
        //$sql = array();
        $kvs = array();
        $growth_con = array();
        $kw = $this->getKeyword();
        $sqlWhere = $this->getSqlWhere($kw);

        $sqlWheres[1 ] = " and `ctime` = `login_time` ";
        $sqlWheres[2 ] = " and `gold` = 10000 and `diamond` = 200 "; //" and `growth` = 1 ";
        $sqlWheres[3 ] = " and `gold` = 10000 and `diamond` = 200 "; //" and `growth` = 2 ";
        $sqlWheres[4 ] = " and `gold` = 10080 and `diamond` = 200 "; //" and `growth` = 3 ";
        $sqlWheres[5 ] = " and `gold` = 20080 and `diamond` = 210 "; //" and `growth` = 4 ";
        $sqlWheres[6 ] = " and `gold` = 20165 and `diamond` = 210 "; //" and `growth` = 5 ";
        $sqlWheres[7 ] = " and `gold` = 20165 and `diamond` = 210 "; //" and `growth` = 6 ";
        $sqlWheres[8 ] = " and `gold` = 19725 and `diamond` = 210 "; //" and `growth` = 7 ";
        $sqlWheres[9 ] = " and `gold` = 18365 and `diamond` = 210 "; //" and `growth` = 8 ";
        $sqlWheres[10] = " and `gold` = 18455 and `diamond` = 210 "; //" and `growth` = 9 ";
        $sqlWheres[11] = " and `gold` = 18455 and `diamond` = 210 "; //" and `growth` = 10 ";
        $sqlWheres[12] = " and `gold` = 18550 and `diamond` = 210 "; //" and `growth` = 11 ";
        $sqlWheres[13] = " and `gold` = 23550 and `diamond` = 220 "; //" and `growth` = 12 ";
        $sqlWheres[14] = " and `gold` = 23550 and `diamond` = 220 "; //" and `growth` = 13 ";

        for($i=2;$i<=14;$i++){
            $growth_con[$i] = $i-1;
        }

        //$sql[1] = "select COUNT(*) from `test_ios33`";
        //$sql[2] = "select COUNT(*) from `test_ios44`";
        $sql = "select `kvs` from `role` ";

        //$totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql[1] . $sqlWhere . $sqlWheres[1]));
        //echo $totalRecord;
        //
        for($j=1;$j<=1;$j++){
            for($i=1;$i<=14;$i++){
                if($i==1){
                    $data['list'][$j][$i] = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere . $sqlWheres[$i]));
                } else {
                    $kvs[$i] = $this->dbh->getAll($sql . $sqlWhere . $sqlWheres[$i]);
                    if(sizeof($kvs[$i]) == 0){
                        $data['growth'][$i] = 0;
                    } else {
                        foreach($kvs[$i] as $v){
                            $binary = new Binary($v['kvs']);
                            $version = $binary->read_uint8();
                            $growth = $binary->read_uint8();
                            if($growth_con[$i] == $growth){
                                $data['growth'][$i] += 1;
                            }
                        }
                    }
                    if($data['list'][$j][1] == 0){
                        $data['list'][$j][$i] = 0;
                    } else {
                        $data['list'][$j][$i] = $data['growth'][$i]. "(". round($data['growth'][$i] / $data['list'][$j][1], 4) * 100 . "%)";
                    }
                }
            }
        }
        //print_r($data['growth']);
        //$data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('data', $data['list']);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword()
    {
        $kw = array();
        if (($this->input['kw']['pay_st']) && ($this->input['kw']['pay_et']))
        {
            $kw['kw_pay_st'] = strtotime($this->input['kw']['pay_st']);
            $kw['kw_pay_et'] = strtotime($this->input['kw']['pay_et']);
        }
        $kw['kw_nonelike'] = isset($this->input['kw']['nonelike']) ? true : false;
        return $kw;
    }

    /**
     * 构造SQL where字串
     * @param array $kw 搜索关键字
     */
    private function getSqlWhere($kw)
    {
        if (isset($kw['kw_pay_st']) && strlen($kw['kw_pay_et']))
        {
            $sqlWhere = " where ctime >= {$kw['kw_pay_st']} and ctime <= {$kw['kw_pay_et']}";
        } else {
            $sqlWhere = " where 1";
        }

        //echo $sqlWhere;
        return $sqlWhere;
    }

}
