<?php
/********************************************************
 *
 * 查看角色升级日志
 *
 * @package admin
 * @module role;
 * @author Tim <mianyangone@gmail.com> 
 * @date 2009-12-14 下午05:52:35
 *
 *******************************************************/ 
 
class Act_Log_upgrade extends Action {
	const TABLE_NAME = 'log_upgrade';
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
				    <td>等级</td>
				    <td>升级时间</td>
				  </tr>';
		$sql = 'select lev, ctime from '. self::TABLE_NAME . " where role_id = {$this->roleId} order by ctime desc limit 30";
		$db = Db::getInstance();
		$handle = $db->query($sql);
		while ($row = $db->fetch_array($handle)){
			$html .= '<tr>
    					<td>' . $row['lev'] . '</td>
    					<td>' . date('Y-m-d H:i:s',$row['ctime']) . '</td>
  					</tr>
  					';
		}
		return $html .= '</table>';	
	}
	
} 
 
