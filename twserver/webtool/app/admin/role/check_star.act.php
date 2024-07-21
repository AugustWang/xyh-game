<?php
/*-----------------------------------------------------+
 * 升星
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_star extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        include(WEB_DIR . "/protocol/log_hero.php");
        $this->hero_tid = $hero_tid;

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
        $rt = array();
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        if(is_numeric($this->input['id'])){
            $id = $this->input['id'];
        }else{
            throw new NotifyException('参数错误!');
        }
        $sqlOrder = ' order by `ctime` desc';
        $sql = 'SELECT `tid`,`num`,`ctime` FROM `log_del_item` WHERE `type` = 14 and `role_id` = ';
        $data['list'] = $this->dbh->getAll($sql . (int)$id . $sqlOrder);
        foreach($data['list'] as $k => $v){
            $data['list'][$k]['tid_name'] = $this->hero_tid[$v['tid']];
        }
        $this->assign('data', $data);
        $this->display();
    }
}
