<?php
/*-----------------------------------------------------+
 * 查看角色任务
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Task_list extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        include(WEB_DIR . "/protocol/log_task.php");
        $this->log_task = $task_tid;
        $prize_type[0]  = "未完成";
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
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        if(is_numeric($this->input['id'])){
            $id = $this->input['id'];
        }else{
            throw new NotifyException('参数错误!');
        }
        $sql = 'SELECT `task` FROM `task` WHERE `id` = ';
        $task = $this->dbh->getOne($sql . (int)$id);
        // $length = strlen($task);
        // $binary = new Binary($task);
        // $reststring = ($length - 1) / 20;
        // $version = $binary->read_uint8();
        // for($i=1; $i <= $reststring; $i++){
        //     $rt[$i]['id'] = $binary->read_uint32_big();
        //     $rt[$i]['target'] = $binary->read_uint8();
        //     $rt[$i]['len'] = $binary->read_uint8();
        //     for($l=1; $l <= $rt[$i]['len'];$l++){
        //         $con[$l]['t'] = $binary->read_uint32_big();
        //         $con[$l]['n'] = $binary->read_uint32_big();
        //     }
        //     foreach($con as $v){
        //         $rt[$i]['condition'] .= "{". $v['t']. ",". $v['n'] ."}";
        //     }
        //     $rt[$i]['st'] = $binary->read_uint8();
        //     $rt[$i]['type'] = $this->prize_type[$rt[$i]['st']];
        // }

        $task = substr($task,1);
        $i=1;
        while($task){
            if (strlen($task) <= 0){
                break;
            } else {
                $binary = new Binary($task);
                $rt[$i]['id'] = $binary->read_uint32_big();
                $rt[$i]['name'] = $this->log_task[$rt[$i]['id']];
                $rt[$i]['target'] = $binary->read_uint8();
                $rt[$i]['len'] = $binary->read_uint8();
                $con = array();
                for($l=1; $l <= $rt[$i]['len'];$l++){
                    $con[$l]['t'] = $binary->read_uint32_big();
                    $con[$l]['n'] = $binary->read_uint32_big();
                }
                $rt[$i]['condition'] = "";
                foreach($con as $v){
                    $rt[$i]['condition'] .= "{". $v['t']. ",". $v['n'] ."}";
                }
                $rt[$i]['st'] = $binary->read_uint8();
                $rt[$i]['type'] = $this->prize_type[$rt[$i]['st']];
                $num = 4 + 1 + 1 + $rt[$i]['len'] * 8 + 1;
                $i++;
                $task = substr($task, $num);
            }
        }

        $this->assign('data', $rt);
        $this->display();
    }
}
