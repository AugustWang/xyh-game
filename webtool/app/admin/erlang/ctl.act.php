<?php
/**
 *
 * 服务器控制终端
 */
class Act_Ctl extends Page{
    private
        $info = "";

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        if(isset($this->input['submit'])){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $submit = $this->input['submit'];
                switch($submit){
                case "热更新服务端":
                    $rt = $erl -> get('u', 'm');
                    if($rt == "[]"){
                        $this->info .= "<h5><font color='red'>没有文件可被更新！</h5></font>";
                    }else{
                        $this->info .= "<font color='green'>更新成功：" . $rt . "</font>";
                    }
                    break;
                case "TEST":
                    $arg = array( 
                        array($erl->link,'getinfo')
                    );
                    $rt = $erl->send('[~p,~a]', $arg);
                    echo "<pre>";
                    print_r($rt);
                    echo "</pre>";
                    break;
                }
            }else{
                $this->info .= "<h5><font color='red'>没有安装Erlang扩展，热更新失败！</h5></font>";
            }
        }
        $this->assign('info', $this->info);
        $this->display();
    }
}
