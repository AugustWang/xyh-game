<?php
/*-----------------------------------------------------+
 * 查看角色签到领取情况
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_sign extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        $prize_type[0]  = "未签到";
        $prize_type[1]  = "可领取";
        $prize_type[2]  = "已领取";
        $this->prize_type = $prize_type;

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
        $sql = 'SELECT `sign` FROM `sign` WHERE `role_id` = ';
        $sign = $this->dbh->getOne($sql . (int)$id);
        $length = strlen($sign);
        //echo $length;
        $binary = new Binary($sign);
        $version = $binary->read_uint8();
        if($version == 1){
            $reststring = ($length - 1) / 2;
            $rt['day1'] = $binary->read_uint8();
            $rt['day2'] = $binary->read_uint8();
        } else {
            $reststring = ($length - 1) / 2 - 1 - 2;
            $rt['time'] = $binary->read_uint32_big();
            $rt['type'] = $binary->read_uint8();
            $rt['day1'] = $binary->read_uint8();
            $rt['day2'] = $binary->read_uint8();
        }
        //echo $version;
        for($i=1; $i < $reststring; $i++){
            $rt['list'][$i][0] = $binary->read_uint8();
            $rt['list'][$i][1] = $binary->read_uint8();
            $rt['list'][$i]['type'] = $this->prize_type[$rt['list'][$i][1]];
        }
        $this->assign('rt', $rt);
        $this->display();
    }
}
