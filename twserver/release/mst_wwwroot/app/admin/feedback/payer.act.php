<?php

/* -----------------------------------------------------+
 * 运营活动付费用户数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Payer extends Page
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
        $sqlOrder = " GROUP BY `role_id` order by `role_id` desc";
        // $sql = "select `id`, `gold`, `diamond`, `tollgate_id`, `ctime`, `aid`, `name` from role";
        $sql = "SELECT DISTINCT `role_id` as `id`, r.aid, r.name, COUNT( a.role_id ) as pays, SUM( a.rmb ) as rmb, SUM( a.diamond ) as diamond, MIN( a.diamond ) as first, MIN( a.purchase_date ) as first_time, r.ctime, `login_time` FROM  `app_store` a,  `role` r ";
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(DISTINCT role_id) as total FROM', $sql . $sqlWhere));
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
        if (($this->input['kw']['pays_st']) && ($this->input['kw']['pays_et']))
        {
            $kw['kw_pays_st'] = $this->input['kw']['pays_st'];
            $kw['kw_pays_et'] = $this->input['kw']['pays_et'];
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
        if ($kw['kw_id']){
            $sqlWhere = " WHERE a.role_id = r.id AND r.id = " . $kw['kw_id'];
        } else {
            $sqlWhere = " WHERE a.role_id = r.id AND 1 ";
            if (isset($kw['kw_name']) && strlen($kw['kw_name']))
            {
                $sqlWhere .= " and r.name like('%{$kw['kw_name']}%')";
            }
            // if (isset($kw['kw_pays_st']) && strlen($kw['kw_pays_et']))
            // {
            //     $sqlWhere .= " and pays >= {$kw['kw_pays_st']} and pays <= {$kw['kw_pays_et']}";
            // }
            if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
            {
                $sqlWhere .= " and r.ctime >= {$kw['kw_reg_st']} and r.ctime <= {$kw['kw_reg_et']}";
            }
            if (isset($kw['kw_login_st']) && strlen($kw['kw_login_et']))
            {
                $sqlWhere .= " and r.login_time >= {$kw['kw_login_st']} and r.login_time <= {$kw['kw_login_et']}";
            }
            $sqlWhere .= isset($kw['kw_accname']) && strlen($kw['kw_accname']) ? " and aid like('%{$kw['kw_accname']}%')" : '';
            // if($this->input['kw']['lv_st'] && $this->input['kw']['lv_et'])
            // {
            //     $sqlWhere .= " and tollgate_id >= ".intval($this->input['kw']['lv_st'])." and tollgate_id <= ".intval($this->input['kw']['lv_et']);
            // }
            // if($this->input['kw']['as_st'] && $this->input['kw']['as_et'] && $this->input['kw']['as_st'] < $this->input['kw']['as_et'])
            // {
            //     $sqlWhere .= " and `id` in ( select `role_id` from `app_store` group by `role_id` having sum(diamond) >= ".intval($this->input['kw']['as_st'])." and sum(diamond) <= ".intval($this->input['kw']['as_et'])." )";
            // }
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
            'send_email' => array(
                '发送邮件',
                '?mod=role&act=send_email',
                // '确定发送邮件？',
            ),
        );
        return Form::batchSelector($btns);
    }

}
