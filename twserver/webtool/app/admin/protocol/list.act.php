<?php
/*-----------------------------------------------------+
 * protocol
 * @author rolong@vip.qq.com
 +-----------------------------------------------------*/
         
class Act_List extends Page{
    private
        $protocol = array(),
        $limit = 100,
        $page = 0,
        $mid2pid = array();

    public function __construct(){
        parent::__construct();

        $protocol = array();

        $protocol_src_dir = WEB_DIR . "/protocol/";
        $protocol_files = glob($protocol_src_dir . "*.php");
        foreach($protocol_files as $protocol_file_name){
            include_once $protocol_file_name;
        }
        $this->protocol = $protocol;


        $protocol_ids = array();
        $module_ids = array();
        $protocol_ids[0] = '- 不限 -';
        $module_ids[0] = '不限';
        $m2p = array();
        foreach($protocol as $k=>$v){
			$protocol_ids[$k] = $k;
            $module_id = (int)($k / 1000);
			$module_ids[$module_id] = $module_id;
            $m2p[$module_id][] = $k;
		}
        $this->mid2pid = $m2p;
        $this->assign('protocol_id', Form::select('protocol_id', $protocol_ids));
        $this->assign('module_id', Form::select('module_id', $module_ids));



        $this->input = trimArr($this->input);

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
        $data = $this->protocol;
        $kw = $this->getKeyword();
        $pid = $kw['protocol_id'];
        $mid = $kw['module_id'];
        if($pid > 0){
            $data = array(
                $pid => $data[$pid],
            );
        }else if($mid > 0){
            $m = $this->mid2pid[$mid];
            $data = array();
            foreach($this->protocol as $k => $v){
                if(in_array($k, $m)){
                    $data[$k] = $v;
                }
            }
        }
        $totalRecord = count($data);
        $data['list'] = $this->getList($data);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword(){
        $kw = array(
            'protocol_id' => 0,
            'module_id' => 0,
        );
        if(isset($this->input['protocol_id'])){
            $kw['protocol_id'] = $this->input['protocol_id'];
        }
        if(isset($this->input['module_id'])){
            $kw['module_id'] = $this->input['module_id'];
        }
        $this->addParamCache($kw); //缓存关键字
        return $kw;
    }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($data){
//        if(0 != $this->page){ //如果在指定的分页查找不到数据，则读取第一页
//            $this->page = 0;
//            $rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);
//        }
        $this->addParamCache(array('page'=>$this->page));
        
        $list = array();
        foreach($data as $pid => $row){
            $row['id'] = $pid;
            $row['action'] = '<a href="'.Admin::url('edit', '', array('id'=>$row['id'])).'">详细</a> <a href="javascript:if(confirm(\'你确定要删除此项吗？\'))location.replace(\''.Admin::url('delete', '', array('id'=>$row['id'])).'\');">删除</a>';

            $list[] = $row;
        }
        return $list;
    }
}
