<?php
/*-----------------------------------------------------+
 * 给角色进程发送消息
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
class Act_Send_Info extends Page{
    public function __construct(){
        parent::__construct();
    }

    public function process(){
        if(!isset($this->input['id']) || !is_numeric($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        $id = $this->input['id'];

        $erl = new Erlang();
        $erl->connect();
        $arg = array(
            array(
                (int)$this->input['id'],
                (int)$this->input['cmd'],
            )
        );
        $rt = $erl->get('sender', 'send_info', '[~u, ~u]', $arg);
        $log = sprintf("id:%d, cmd:%d", 
            $this->input['id'],
            $this->input['cmd']
        );
        Admin::log(17, $log);
        $this->assign('alert', $rt);
        $from_mod = $this->input['from_mod'];
        $from_act = $this->input['from_act'];
        $this->display();
        // Admin::redirect(Admin::url($from_mod, $from_act, '', true));
    }
}
