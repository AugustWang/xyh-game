<?php
/*-----------------------------------------------------+
 * 删除公告
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/
class Act_Notice_Del extends Action{
    public function __construct(){
        parent::__construct();
    }

    public function process(){
        if(!isset($this->input['id']) || !is_numeric($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        $id = $this->input['id'];

        $sql = "delete from sys_notices where id={$id}";
        $affetcedRows = Db::getInstance()->exec($sql);
        Admin::redirect(Admin::url('notice', '', '', true));
    }
}
