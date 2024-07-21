<?php
/*-----------------------------------------------------+
 * 踢除角色
 +-----------------------------------------------------*/
class Act_Kick extends Action{
    public function __construct(){
        parent::__construct();
    }

    public function process(){
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        if(is_numeric($this->input['id'])){
            $idArr = array($this->input['id']);
        }else if(is_array($this->input['id'])){
            $idArr = $this->input['id'];
        }else{
            throw new NotifyException('参数错误!');
        }
        $erl = new Erlang();
        $erl -> connect();
        foreach($idArr as $id){
            $erl -> get('lib_role', 'kick', '[~l,~b]', array(array((int)$id, '[WEB] Admin('.$_SESSION['admin_uid'].') Kick!')));
            $log = sprintf("id:%d", $id);
            Admin::log(18, $log);
        }
        //d($erl->getError());
        Admin::redirect($_SERVER['HTTP_REFERER']);
    }
}
