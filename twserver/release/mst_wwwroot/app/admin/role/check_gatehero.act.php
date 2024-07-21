<?php
/*-----------------------------------------------------+
 * 查看雇佣兵情况
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_gatehero extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        include(WEB_DIR . "/protocol/log_hero.php");
        $gatehero[1]    = 30002;
        $gatehero[2]    = 30001;
        $gatehero[3]    = 30004;
        $gatehero[4]    = 30009;
        $gatehero[5]    = 30011;
        $gatehero[6]    = 30003;
        $gatehero[7]    = 30006;
        $gatehero[8]    = 30013;

        $prize_type[0]  = "可购买";
        $prize_type[1]  = "未解锁";
        $prize_type[2]  = "已购买";
        $this->prize_type = $prize_type;
        $this->gatehero = $gatehero;
        $this->log_hero = $hero_tid;

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
        $sql = 'SELECT `hid` FROM `gatehero` WHERE `role_id` = ';
        $hid = $this->dbh->getOne($sql . (int)$id);

        // for($i; $i<=strlen($hid);$i++){
        //     $vb = substr($hid,$i,1);
        //     echo ord($vb).",";
        // }

        if(strlen($hid) > 0){

            $length = (strlen($hid)-1) / 4;
            $binary = new Binary($hid);
            $version = $binary->read_uint8();
            for($i=1; $i <= $length; $i++){
                $rt['list'][$i]['id'] = $binary->read_uint32_big();
                // $rt['list'][$i]['1'] = $binary->read_uint8();
                // $rt['list'][$i]['type'] = $this->prize_type[$rt['list'][$i][1]];
                $rt['list'][$i]['type'] = $this->prize_type[2];
                $rt['list'][$i]['hero'] = $this->log_hero[$this->gatehero[$rt['list'][$i]['id']]];
            }
            $this->assign('rt', $rt);
            $this->display();

        } else {
            //throw new NotifyException('没有购买记录!');
            $this->assign('alert',"没有购买记录");
            $this->display();
        }
    }
}
