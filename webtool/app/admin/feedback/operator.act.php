<?php

/* -----------------------------------------------------+
 * 运营活动操作数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Operator extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();

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
        $data = array();
        $kw = $this->getKeyword();
        $sqlWhere = $this->getSqlWhere($kw);
        $sqlOrder = " order by tollgate_newid desc";
        $sql = "select `id`, `gold`, `diamond`, `tollgate_newid`, `ctime`, `aid`, `name`, `login_time` from role";
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere));
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
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
        if (($this->input['kw']['name']))
        {
            $kw['kw_name'] = $this->input['kw']['name'];
        }
        if (($this->input['kw']['accname']))
        {
            $kw['kw_accname'] = $this->input['kw']['accname'];
        }
        if (($this->input['kw']['id']))
        {
            $kw['kw_id'] = $this->input['kw']['id'];
        }
        if (($this->input['kw']['reg_st']) && ($this->input['kw']['reg_et']))
        {
            $kw['kw_reg_st'] = strtotime($this->input['kw']['reg_st']);
            $kw['kw_reg_et'] = strtotime($this->input['kw']['reg_et']);
        }
        if (($this->input['kw']['login_st']) && ($this->input['kw']['login_et']))
        {
            $kw['kw_login_st'] = strtotime($this->input['kw']['login_st']);
            $kw['kw_login_et'] = strtotime($this->input['kw']['login_et']);
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
        if ($kw['kw_id']){
            $sqlWhere = " where id = " . $kw['kw_id'];
        } else {
            $sqlWhere = " where 1";
            if (isset($kw['kw_name']) && strlen($kw['kw_name']))
            {
                $sqlWhere .= " and name like('%{$kw['kw_name']}%')";
            }
            if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
            {
                $sqlWhere .= " and ctime >= {$kw['kw_reg_st']} and ctime <= {$kw['kw_reg_et']}";
            }
            if (isset($kw['kw_login_st']) && strlen($kw['kw_login_et']))
            {
                $sqlWhere .= " and login_time >= {$kw['kw_login_st']} and login_time <= {$kw['kw_login_et']}";
            }
            $sqlWhere .= isset($kw['kw_accname']) && strlen($kw['kw_accname']) ? " and aid like('%{$kw['kw_accname']}%')" : '';
            if($this->input['kw']['lv_st'] && $this->input['kw']['lv_et'])
            {
                $sqlWhere .= " and tollgate_newid >= ".intval($this->input['kw']['lv_st'])." and tollgate_newid <= ".intval($this->input['kw']['lv_et']);
            }
            if($this->input['kw']['as_st'] && $this->input['kw']['as_et'] && $this->input['kw']['as_st'] < $this->input['kw']['as_et'])
            {
                $sqlWhere .= " and `id` in ( select `role_id` from `app_store` group by `role_id` having sum(diamond) >= ".intval($this->input['kw']['as_st'])." and sum(diamond) <= ".intval($this->input['kw']['as_et'])." )";
            }
        }

        // echo $sqlWhere;
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
