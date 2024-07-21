<?php
/*-----------------------------------------------------+
 * 查看角色成就
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_attain extends Page{
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

    protected function read_obj($height, $binary, $count){
        $result = array();
        for($i = 0; $count > $i; $i++){
            $result[$i] = array(
                'map_id' => $map_id,
                'res_id' => $res_id,
                'type' => $binary->read_uint32(),
                'type_id' => $binary->read_uint32(),
                'x' => $binary->read_uint32(),
                'y' => $height * 32 - $binary->read_uint32(),
            );
            $param_count = $binary->read_uint32();
            $param = array();
            for($param_count; $param_count > 0; $param_count--){
                $param[] = $binary->read_uint32();
            }
            $result[$i]['param'] = $param;
            $this->obj_data[] = $result[$i];
        }
        return $result;
    }

    public function process(){
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        if(is_numeric($this->input['id'])){
            $id = $this->input['id'];
        }else{
            throw new NotifyException('参数错误!');
        }
        $sql = 'SELECT `attain` FROM `attain` WHERE `id` = ';
        $attain = $this->dbh->getOne($sql . (int)$id);
        $length = strlen($attain);
        echo $length;
        $binary = new Binary($attain);
        $len = $binary->read_uint8();
        $reststring = (($length - 1) / 20));
        //echo $len;
        $version = $binary->get_data($len);
        $rt[0] = $binary->read_uint32();
        $rt[1] = $binary->read_uint32();
        $rt[2] = $binary->read_uint32();
        $rt[3] = $binary->read_uint32();
        $rt[4] = $binary->read_uint32();
        //$obj_count = $binary->read_uint32();
        //$objs = $this->read_obj($idlen, &$binary, $obj_count);


        //$erl = new Erlang();
        //$erl->connect();
        //$rt = $erl->get('lib_admin', 'check_attain', '[~u]', array(array((int)$id)));
        //var_dump($rt[1]);
        //print_r($rt[1][0]);
        //print_r($rt[1][1]);
        //$log = sprintf("id:%d",(int)$id);
        //Admin::log(31, $log);
        //$this->assign('data', $rt[1]);
        $this->assign('data', $rt);
        $this->display();
    }
}