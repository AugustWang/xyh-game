<?php

/* -----------------------------------------------------+
 * 玩家金币流动明细
 * @author Rolong<rolong@vip.qq.com>
 +----------------------------------------------------- */

class Act_Diamond_List extends Page
{

    private
        $log_type,
        $dbh,
        $limit = 30,
        $page = 0;

	public function __construct()
	{
		parent::__construct();
        if(!$this->input['id']) {
            exit("ERROR ID!");
        }
        include(WEB_DIR . "/protocol/log_type.php");
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
        $sql = "SELECT `id`, `type`, `num`, `rest`, `ctime` FROM `log_diamond` where role_id = " . $this->input['id'];
        if($this->input['type']) {
            $sql .= " and `type` = ". $this->input['type'];
        }
		$data['list'] = $this->getList($sql . $sqlOrder);
		$totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql));
		$data['page_index'] = Utils::pager(Admin::url('', '', array('id'=>$this->input['id'], 'limit' => $this->limit), true), $totalRecord, $this->page, $this->limit);
		$this->assign('data', $data);
		$this->assign('id', $this->input['id']);
		$this->assign('formAction', Admin::url('', '', '', true));
        $this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
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
        $lastnum = 0;
        $index = $start + 1;
        while ($row = $this->dbh->fetch_array($rs)) {
            //if($last < 0){
            //    $row['status'] = "";
            //}else{
            //    if($lastnum >= 0 && ($last - $lastnum) == $row['rest']){
            //        $row['status'] = "";
            //    }elseif($lastnum < 0 && (($last + abs($lastnum)) == $row['rest'])){
            //        $row['status'] = "";
            //    }else{
            //        echo $lastnum;
            //        $row['status'] = " <font color='#ff0000'>[异常]</font>";
            //    }
            //}
            if($last < 0){
                $row['status'] = "";
            }else{
                if($last - $row['rest'] - $lastnum){
                    $row['status'] = "";
                }else{
                    echo $last . ".." . $row['rest'] . ".." . $lastnum . "..";
                    $row['status'] = " <font color='#ff0000'>[异常]</font>";
                }
            }
            if($row['num'] < 0){
                $row['num'] = " <font color='#ff0000'>".number_format($row['num'])."</font>";
            }else{
                $row['num'] = number_format($row['num']);
            }
            $last = $row['rest'];
            $lastnum = $row['num'];
            $type = $row['type'];
            $row['index'] = $index;
            $row['type'] = $this->log_type[$type];
            $list[] = $row;
            $index += 1;
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
