<?php
/*-----------------------------------------------------+
 * 净化
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_purge extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        //include(WEB_DIR . "/protocol/log_item.php");
        $item_tid[13001  ]   =   "二级净化石";
        $item_tid[13002  ]   =   "三级净化石";
        $item_tid[13003  ]   =   "四级净化石";
        $item_tid[13004  ]   =   "五级净化石";
        $item_tid[13005  ]   =   "六级净化石";
        $item_tid[13006  ]   =   "七级净化石";

        $purge[13001]  = "品质:D ->C";
        $purge[13002]  = "品质:C ->B";
        $purge[13003]  = "品质:B->B+";
        $purge[13004]  = "品质:B+->A";
        $purge[13005]  = "品质:A->A+";
        $purge[13006]  = "品质:A+->S";
        $this->purge = $purge;
        $this->item_tid = $item_tid;

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
        $sql = 'SELECT `tid`,`num`,`ctime` FROM `log_del_item` WHERE `type` = 12 and `role_id` = ';
        $data['list'] = $this->dbh->getAll($sql . (int)$id . $sqlOrder);
        foreach($data['list'] as $k => $v){
            $data['list'][$k]['tid_name'] = $this->item_tid[$v['tid']];
            $data['list'][$k]['purge'] = $this->purge[$v['tid']];
        }
        $this->assign('data', $data);
        $this->display();
    }
}
