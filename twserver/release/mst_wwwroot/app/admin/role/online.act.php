<?php
/*-----------------------------------------------------+
 * 在线角色列表
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Online extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if(
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        ){
            $this->limit = $this->input['limit'];
        }

        if(
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        ){
            $this->page = $this->input['page'];
        }

        $this->assign('limit', $this->limit);
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process(){
        $data = array();
        $node = $this->input['node'];
        if(!$node)$node=1;
        $erl = new Erlang();
        $erl -> connect();
        $roleId = $erl -> get('lib_admin', 'get_online_roleid');
        $kw = $this->getKeyword();
        $sqlWhere = $this->getSqlWhere($roleId, $kw);
        $sqlOrder = " order by tollgate_newid desc";
		$sql = "select `id`, `gold`, `diamond`, `lev`, `tollgate_newid`, `aid`, `name` from role";
        if($roleId)
        {
        	$totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*FROM|i', 'SELECT COUNT(*) as total FROM', $sql.$sqlWhere));
        	$data['list'] = $this->getList($sql.$sqlWhere.$sqlOrder);
        }else{
        	$totalRecord = 0;
        	$data['list'] = array();
        }
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);

        $total = count($roleId);
        $onlineNum = ' <span style="color:#f30; font:bold 14px/20px georgia;">'.$total.'</span> 人';
        $this->assign('onlineNum', $onlineNum);
        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        // $this->assign('actions', $this->getActions());
        $this->assign('actions', Admin::getGmActions());
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword(){
        $kw = array();
        if(isset($this->input['kw_name'])){
            $kw['kw_name'] = $this->input['kw_name'];
        }
    	if(isset($this->input['kw_id'])){
            $kw['kw_id'] = $this->input['kw_id'];
        }
        if(isset($this->input['kw_account'])){
            $kw['kw_account'] = $this->input['kw_account'];
        }
        if(isset($this->input['kw_career'])){
            $kw['kw_career'] = $this->input['kw_career'];
        }
        if(isset($this->input['kw_realm'])){
            $kw['kw_realm'] = $this->input['kw_realm'];
        }
        if(isset($this->input['kw_status'])){
            $kw['kw_status'] = $this->input['kw_status'];
        }
        $this->addParamCache($kw); //缓存关键字
        return $kw;
    }

    // private function getActions()
    // {
    //     $menu = Admin::getAdminMenu();
    //     $gm = $menu[32]['sub'];
    //     $actions = '';
    //     if($gm){
    //         foreach($gm as $v){
    //             $actions .= " <a class='action-link ui-state-default ui-corner-all' href='{$v['url']}&from_mod=online&id={id}'><span class='ui-icon ui-icon-newwin'></span>{$v['title']}</a>";
    //         }
    //     }
    //     return $actions;
    // }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($sql){
        $rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);
        $this->addParamCache(array('page'=>$this->page));
        $list = array();
        while($row = $this->dbh->fetch_array($rs)){
            $row['online_time'] = $row['last_visit'] < 60 ? '刚刚进来' : secondToString($now - $row['last_visit']);
            $list[] = $row;
        }
        return $list;
    }

    /**
     * 构造SQL where字串
     * @param array $kw 搜索关键字
     */
    private function getSqlWhere($roleid , $kw){
        $sqlWhere= $roleid ? " where id IN(".implode(',', $roleid).") " : " where 1 ";
        $sqlWhere .= isset($kw['kw_id']) && $kw['kw_id']>0 ? " and id={$kw['kw_id']}" : '';
        $sqlWhere .= isset($kw['kw_name']) && strlen($kw['kw_name']) ? " and name like('%{$kw['kw_name']}%')" : '';
        $sqlWhere .= isset($kw['kw_account']) && strlen($kw['kw_account']) ? " and aid like('%{$kw['kw_account']}%')" : '';
        return $sqlWhere;
    }

    /**
     * 生成批量处理按钮
     */
	private function op(){
        $btns = array(
            'send_email' => array(
                '发送邮件',
                '?mod=role&act=send_email',
                // '确定发送邮件？',
            ),
            array('踢除', Admin::url('kick', '', '', true), '你确定要将选定的角色踢出服务器吗？')
        );
        return Form::batchSelector($btns);
	}
}
