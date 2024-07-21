<?php

/* -----------------------------------------------------+
 * 收入总览
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Payer2 extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if ($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = (int)date('Ymd');

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
    }

    public function process()
    {
        $db = Db::getInstance();
        $data = array();
        //$kw = $this->getKeyword();
        //$sqlWhere = $this->getSqlWhere($kw);
        //$sqlWhere = "  WHERE time = $this->day ";
        $sqlOrder = " GROUP BY `time` order by `purchase_date` desc";
        //$sql = "SELECT DISTINCT FROM_UNIXTIME(TRUNCATE(`purchase_date` / 1000,0),'%Y-%m-%d') as time, SUM(rmb) as rmb, SUM(diamond) as diamond FROM  `app_store` ";
        $sql = "SELECT DISTINCT FROM_UNIXTIME(TRUNCATE(`ctime` ,0),'%Y-%m-%d') as time, COUNT(DISTINCT role_id) as pays, SUM(rmb) as rmb, SUM(diamond) as diamond FROM  `app_store` ";
        //$totalRecord = (preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(data(FLOOR('%Y-%m-%d',`purchase_date` / 1000))) as total FROM", $sql));
        //echo $totalRecord;
        //$totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(TRUNCATE(`purchase_date` / 1000, 0),'%Y-%m-%d')) as total FROM", $sql));
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(TRUNCATE(`ctime` , 0),'%Y-%m-%d')) as total FROM", $sql));
        $data['list'] = $this->getList($sql . $sqlOrder);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        // 生成日期选择下拉列表
        $dates = array();
        //$date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(TRUNCATE(`purchase_date`/1000, 0),'%Y%m%d') as time FROM app_store ORDER BY purchase_date DESC LIMIT 100");
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(TRUNCATE(`ctime`, 0),'%Y%m%d') as time FROM app_store ORDER BY ctime DESC LIMIT 100");
        foreach ($date_data as $v){
            //$dates[$v['reg_stamp']] = date("Y-m-d", $v['reg_stamp']);
            $dates[$v['time']] = $v['time'];
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        //$this->assign('kw', $kw);
        //$this->assign('op', $this->op());
        $this->assign('data', $data);
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
        if (($this->input['kw']['time_st']) && ($this->input['kw']['time_et']))
        {
            $kw['kw_time_st'] = strtotime($this->input['kw']['time_st']);
            $kw['kw_time_et'] = strtotime($this->input['kw']['time_et']);
        }
        $kw['kw_nonelike'] = isset($this->input['kw']['nonelike']) ? true : false;
        return $kw;
    }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($sql)
    {
        //echo $sql;
        $rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);

        $list = array();
        $predefine = Defines::init();
        $now = time();
        $menu = Admin::getAdminMenu();
        $gm = $menu[32]['sub'];
        while ($row = $this->dbh->fetch_array($rs)) {
            if($gm){
                $action = '';
                foreach($gm as $v){
                    $action .= " | <a href=\"{$v['url']}&from_mod=online&id={$row['id']}\">{$v['title']}</a>";
                }
                $row['action'] = $action . ' |';
            }else{
                $row['action'] = '';
            }
            $list[] = $row;
        }
        return $list;
    }

    /**
     * 构造SQL where字串
     * @param array $kw 搜索关键字
     */
    private function getSqlWhere($kw)
    {
        $sqlWhere = " WHERE 1 ";
        if (isset($kw['kw_time_st']) && strlen($kw['kw_time_et']))
        {
            $sqlWhere .= " and r.login_time >= {$kw['kw_login_st']} and r.login_time <= {$kw['kw_login_et']}";
        }

        return $sqlWhere;
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
