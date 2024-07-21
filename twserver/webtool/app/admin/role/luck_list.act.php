<?php

/* -----------------------------------------------------+
 * 玩家物品流动明细
 * @author Rolong<rolong@vip.qq.com>
 +----------------------------------------------------- */

class Act_Luck_List extends Page
{

    private
        $log_item,
        $log_goods,
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if(!$this->input['id']) {
            exit("ERROR ID!");
        }
        include(WEB_DIR . "/protocol/log_goods.php");
        include(WEB_DIR . "/protocol/log_item.php");
        include(WEB_DIR . "/protocol/log_type.php");
        $this->log_goods = $log_goods;
        $this->log_item = $item_tid;
        $this->log_type = $log_type;
        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

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
    }

    public function process()
    {

        $data = array();
        $sqlOrder = " order by `ctime` desc";
        $sql1 = "SELECT `type`, `tid`, `num`, `ctime` FROM `log_add_item` where role_id = " . $this->input['id'];
        $sql2 = "SELECT `type`, '' as `tid`, `num`, `ctime` FROM `log_diamond` where role_id = " . $this->input['id'];
        $sql3 = "SELECT `type`, '' as `tid`, `num`, `ctime` FROM `log_gold` where role_id = " . $this->input['id'];

        $sql1 .= " and `type` = 11";
        $sql2 .= " and `type` = 9";
        $sql3 .= " and `type` = 9";

        $sql = $sql1 . " UNION ALL " . $sql2 . " UNION ALL " . $sql3;
        $data['list'] = $this->getList($sql . $sqlOrder);
        $totalRecord1 = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql1));
        $totalRecord2 = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql2));
        $totalRecord3 = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql3));
        $totalRecord = $totalRecord1 + $totalRecord2 + $totalRecord3;
        $data['page_index'] = Utils::pager(Admin::url('', '', array('id'=>$this->input['id'], 'limit' => $this->limit), true), $totalRecord, $this->page, $this->limit);

        // $data['list1'] = $this->getList($sql1 . $sqlOrder);
        // $data['list2'] = $this->getList($sql2 . $sqlOrder);
        // $data['list3'] = $this->getList($sql3 . $sqlOrder);
        // foreach($data['list1'] as $k => $v){
        //     $data['list1'][$k]['tid_name'] = $this->log_item[$v['tid']];
        //     $data['list1'][$k]['type_name'] = $this->log_goods[$v['type']];
        // }
        // foreach($data['list2'] as $k => $v){
        //     $data['list2'][$k]['tid_name'] = "钻石";
        //     $data['list2'][$k]['tid'] = "2";
        // }
        // foreach($data['list3'] as $k => $v){
        //     $data['list3'][$k]['tid_name'] = "金币";
        //     $data['list3'][$k]['tid'] = "1";
        // }
        // //TODO: array merge
        // foreach($data['list'] as $k => $v){
        //     $ctime[$k] = $v['ctime'];
        // }
        // $data['list'] = array_multisort($ctime, SORT_DESC, $data['list']);

        // array_multisort($ctime, SORT_DESC, $num, SORT_ASC, $data['list']);
        foreach($data['list'] as $k => $v){
            if ($v['tid'] == "" && $v['type'] == 9){
                if ($v['num'] >= 5000){
                    $data['list'][$k]['tid_name'] = "金币";
                    $data['list'][$k]['tid'] = "1";
                } else {
                    $data['list'][$k]['tid_name'] = "钻石";
                    $data['list'][$k]['tid'] = "2";
                }
                $data['list'][$k]['type_name'] = $this->log_type[$v['type']];
            } else {
                $data['list'][$k]['tid_name'] = $this->log_item[$v['tid']];
                $data['list'][$k]['type_name'] = $this->log_goods[$v['type']];
            }
        }

        $sql4 = "SELECT `kvs` FROM `role` where `id` = " . $this->input['id'];
        $kvs = $this->dbh->getOne($sql4);
        $luck = substr($kvs,29,16);
        $binary = new Binary($luck);
        //,luck              = {LuckStar, LuckDia, LuckUsed, ValSum}
        $rt['luck_num'] = $binary->read_uint32_big();
        $rt['luck_dia'] = $binary->read_uint32_big();
        $rt['luck_use'] = $binary->read_uint32_big();
        $rt['luck_sum'] = $binary->read_uint32_big();
        //print_r($rt);

        $this->assign('data', $data);
        $this->assign('rt',$rt);
        $this->assign('id', $this->input['id']);
        $this->assign('formAction', Admin::url('', '', '', true));
        // $this->assign('type', Form::select('type', $this->log_goods, $this->input['type']));
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
        $last = -1;
        $index = $start + 1;
        // while ($row = $this->dbh->fetch_array($rs)) {
        //     if($last < 0){
        //         $row['status'] = "";
        //     }else{
        //         if(($last + $row['num']) == $row['rest']){
        //             $row['status'] = "";
        //         }else{
        //             $row['status'] = " <font color='#ff0000'>[异常]</font>";
        //         }
        //     }
        //     if($row['num'] < 0){
        //         $row['num'] = " <font color='#ff0000'>".number_format($row['num'])."</font>";
        //     }else{
        //         $row['num'] = number_format($row['num']);
        //     }
        //     $last = $row['rest'];
        while ($row = $this->dbh->fetch_array($rs)) {
            // if($last < 0){
            //     $row['status'] = "";
            // }elseif($this->input['type']){
            //     $row['status'] = "";
            // }else{
            //     if($lastnum < 0){
            //         if(floor($last + abs($lastnum)) == floor($row['rest'])){
            //             $row['status'] = "";
            //         }else{
            //             $row['status'] = " <font color='#ff0000'>[异常]</font>";
            //         }
            //     }else{
            //         if($last - $lastnum == $row['rest']){
            //             $row['status'] = "";
            //         }else{
            //             $row['status'] = " <font color='#ff0000'>[异常]</font>";
            //         }
            //     }
            // }
            $list[] = $row;
            $index += 1;
        }
        return $list;
    }

}
