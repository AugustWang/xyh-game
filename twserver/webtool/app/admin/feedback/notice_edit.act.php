<?php
/*-----------------------------------------------------+
 * 编辑公告
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Notice_Edit extends Page{
    public $id = 0;

    public function __construct(){
        parent::__construct();
        $notice_type[1]       = "公告";
        $notice_type[2]       = "广播";
        $this->notice_type = $notice_type;
        $this->input = trimArr($this->input);
        $this->assign('goback', Admin::url('notice', '', '', true));
    }

    /**
     * 执行入口
     */
    public function process(){

        if(!isset($this->input['id']) || !is_numeric($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        $this->id = $this->input['id'];
        $id = $this->input['id'];
        if(!isset($this->input['submit'])){ //用户是否点击了提交？如果没有则显示页面
            $info = $this->getInfo($id);
            //print_r($info);
            $this->assign('data', $info);
            $this->assign('type', Form::select('type', $this->notice_type, $info['type']));
            $this->display();
            return;
        }
        $info = $this->input['items'];
        if($this->input['type']) {
            $info['type'] = $this->input['type'];
        }
        if($this->id > 0) {
            $info['id'] = $id;
            $this->update($info);
        } else {
            $info['id'] = $this->id;
            $this->insert($info);
        }
        Admin::redirect(Admin::url('notice', '', '', true)); //页面跳转
    }

    private function insert($data){
        $data['start_time'] = strtotime($data['start_time']);
        $data['end_time'] = strtotime($data['end_time']);
        $dbh = Db::getInstance();
        $sql = $dbh->getInsertSql('sys_notices', $data);
        $dbh->exec($sql);
    }

    private function update($data){
        $data['start_time'] = strtotime($data['start_time']);
        $data['end_time'] = strtotime($data['end_time']);
        $dbh = Db::getInstance();
        $sql = $dbh->getUpdateSql('sys_notices', 'id', $data);
        $dbh->exec($sql);
    }

    private function getInfo($id){
        $sql = "select * from sys_notices where id={$id}";
        return Db::getInstance()->getRow($sql);
    }
}
