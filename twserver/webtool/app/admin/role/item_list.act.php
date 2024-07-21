<?php

/* -----------------------------------------------------+
 * 玩家物品流动明细
 * @author Rolong<rolong@vip.qq.com>
 +----------------------------------------------------- */

class Act_Item_List extends Page
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
        $this->log_goods = $log_goods;
        $this->log_item = $item_tid;
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
        $sql2 = "SELECT `type`, `tid`, `num`, `ctime` FROM `log_del_item` where role_id = " . $this->input['id'];
        if($this->input['type']) {
            $sql1 .= " and `type` = ". $this->input['type'];
            $sql2 .= " and `type` = ". $this->input['type'];
        }
        $sql = $sql1 . " UNION ALL " . $sql2;
        // echo $sql . $sqlOrder;
        $data['list'] = $this->getList($sql . $sqlOrder);
        $totalRecord1 = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql1));
        $totalRecord2 = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql2));
        $totalRecord = $totalRecord1 + $totalRecord2;
        $data['page_index'] = Utils::pager(Admin::url('', '', array('id'=>$this->input['id'], 'limit' => $this->limit), true), $totalRecord, $this->page, $this->limit);
        foreach($data['list'] as $k => $v){
            $data['list'][$k]['tid_name'] = $this->log_item[$v['tid']];
            $data['list'][$k]['type_name'] = $this->log_goods[$v['type']];
        }
        $this->assign('data', $data);
        $this->assign('id', $this->input['id']);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->assign('type', Form::select('type', $this->log_goods, $this->input['type']));
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
