<?php
/********************************************************
 *
 * 查看登录日志
 *
 * @package admin
 * @module role
 * @author Tim <mianyangone@gmail.com> 
 * @date 2009-12-14 下午05:07:47
 * @todo 对ts字段进行索引
 *
 *******************************************************/
class Act_Log_login extends Action {
    const TABLE_NAME = 'log_login';
    private $roleId = null;
    public function __construct(){		
        parent::__construct();
    }

    public function process(){
        if (isset($this->input['role_id']) && is_numeric($this->input['role_id'])){
            $this->roleId = $this->input['role_id'];
        } else{
            exit('角色ID错误');
        }
        echo $this->getLog();
    }

    private function getLog(){
        $html = '<table width="100%" border="0">
            <tr>
            <td>事件</td>
            <td>登录时间</td>
            <td>退出时间</td>
            <td>IP</td>
            </tr>';
        $sql = 'select * from '. self::TABLE_NAME . " where role_id = {$this->roleId} order by id desc limit 30";
        $db = Db::getInstance();
        $handle = $db->query($sql);
        while ($row = $db->fetch_array($handle)){
            switch($row['event']){
            case 0: $event = "登陆中";break;
            case 1: $event = "已退出";break;
            case 2: $event = "系统关闭";break;
            case 3: $event = "被动退出";break;
            case 4: $event = "其它退出";break;
            }
            $logout_time = $row['logout_time'] > 0 ? date('Y-m-d H:i:s',$row['logout_time']) : "--";
            $html .= '<tr>
                <td>' .  $event . '</td>
                <td>' . date('Y-m-d H:i:s',$row['login_time']) . '</td>
                <td>' . $logout_time . '</td>
                <td>' . $row['ip'] . Utils::ip2addr($row['ip']) . '</td>
                </tr>
                ';
        }
        return $html .= '</table>';	
    }
} 
 
