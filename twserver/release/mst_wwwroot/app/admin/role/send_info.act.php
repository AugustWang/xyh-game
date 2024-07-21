<?php
/*-----------------------------------------------------+
 * 给角色进程发送消息
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
class Act_Send_Info extends GmAction{
    public function __construct(){
        parent::__construct();
    }

    // 扩展参数
    public function params(){
        return array(
            'cmd' => $this->input['cmd'],
        );
    }

    public function action(){
        if(!isset($this->input['id']) || !is_numeric($this->input['id'])){
            echo '参数错误!';
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
        echo $rt;
    }
}
