<?php

/* -----------------------------------------------------+
 * 英雄购买日志数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Log_hero extends Page
{

    private
        $log_type,
        $hero_quality,
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        //include(WEB_DIR . "/protocol/log_type.php");
        $log_type[0]   = "==全部==";
        $log_type[30001]       = "圣骑    ";
        $log_type[30003]       = "潜行者  ";
        $log_type[30002]       = "急速女法";
        $log_type[30004]       = "矮人火枪";
        $log_type[30005]       = "剑圣    ";
        $log_type[30006]       = "兽王    ";
        $log_type[30007]       = "痛苦术士";
        $log_type[30008]       = "牛头酋长";
        $log_type[30009]       = "萨满    ";
        $log_type[30010]       = "树人    ";
        $log_type[30011]       = "圣祭祀  ";
        $log_type[30015]       = "真恶魔猎手";
        $log_type[30012]       = "盖哥    ";
        $log_type[30013]       = "真山丘之王";
        $log_type[30014]       = "巫医    ";
        $log_type[30016]       = "枪神女警";
        $log_type[30017]       = "守望者  ";
        $log_type[30018]       = "审判天使";
        $log_type[30019]       = "巫妖    ";
        $log_type[30020]       = "斧王    ";
        $log_type[30021]       = "火枪戍卫";
        $log_type[30022]       = "寒冰射手";
        $log_type[30023]       = "黑暗游侠";
        $log_type[30024]       = "矮人飞机";
        $log_type[30025]       = "熊猫    ";
        $log_type[30026]       = "血法    ";
        $log_type[39998]       = "恶魔猎手";
        $log_type[39999]       = "真山丘之王";
        $this->log_type = $log_type;

        $hero_quality[0]       = "==全部==";
        $hero_quality[1]       = "D"       ;
        $hero_quality[2]       = "C"       ;
        $hero_quality[3]       = "B"       ;
        $hero_quality[4]       = "B+"      ;
        $hero_quality[5]       = "A"       ;
        $hero_quality[6]       = "A+"      ;
        $hero_quality[7]       = "S"       ;
        $this->hero_quality = $hero_quality;

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
        $sqlOrder = " order by ctime desc";
        $sql = "select `role_id`, `hero_id`, `quality`, `ctime` from log_hero";
        if($this->input['type']) {
            $sql .= " where `hero_id` = ". $this->input['type'];
            if($this->input['hero_quality']) {
                $sql .= " and `quality` = ". $this->input['hero_quality'];
            }
        }elseif($this->input['hero_quality']) {
            $sql .= " where `quality` = ". $this->input['hero_quality'];
        }
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere));
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
        $this->assign('hero_quality', Form::select('hero_quality', $this->hero_quality, $this->input['hero_quality']));
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword()
    {
        $kw = array();
        if (($this->input['kw']['id']))
        {
            $kw['kw_id'] = $this->input['kw']['id'];
        }
        if (($this->input['kw']['hero_id']))
        {
            $kw['kw_hero_id'] = $this->input['kw']['hero_id'];
        }
        if (($this->input['kw']['quality']))
        {
            $kw['kw_quality'] = $this->input['kw']['quality'];
        }
        if (($this->input['kw']['pay_st']) && ($this->input['kw']['pay_et']))
        {
            $kw['kw_pay_st'] = strtotime($this->input['kw']['pay_st']);
            $kw['kw_pay_et'] = strtotime($this->input['kw']['pay_et']);
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
            $type = $row['hero_id'];
            $row['type'] = $this->log_type[$type];
            $hero_quality = $row['quality'];
            $row['hero_quality'] = $this->hero_quality[$hero_quality];
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
            $sqlWhere = " where role_id = " . $kw['kw_id'];
        } else {
            if(isset($this->input['type']) && $this->input['type'] == 0 && isset($this->input['hero_quality']) && $this->input['hero_quality'] == 0 ) {
                $sqlWhere = " where 1";
            }
            if (isset($kw['kw_hero_id']) && strlen($kw['kw_hero_id']))
            {
                $sqlWhere .= " and hero_id = {$kw['kw_hero_id']}";
            }
            if (isset($kw['kw_quality']) && strlen($kw['kw_quality']))
            {
                $sqlWhere .= " and quality = {$kw['kw_quality']}";
            }
            if (isset($kw['kw_pay_st']) && strlen($kw['kw_pay_et']))
            {
                $sqlWhere .= " and ctime >= {$kw['kw_pay_st']} and ctime <= {$kw['kw_pay_et']}";
            }
            // $sqlWhere .= isset($kw['kw_accname']) && strlen($kw['kw_accname']) ? " and aid like('%{$kw['kw_accname']}%')" : '';
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
                '?mod=feedback&act=timeing',
                // '确定发送邮件？',
            ),
        );
        return Form::batchSelector($btns);
    }

}
