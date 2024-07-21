<?php
/********************************************************
 *
 * 金币充值/消费记录
 *
 * @package admin
 * @module role
 * @author Tim <mianyangone@gmail.com> 
 * @date 2009-12-16 上午09:40:25
 *
 *******************************************************/ 
 
 
class Act_Log_gold extends Action {
	const TABLE_NAME = 'log_gold';
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
				    <td>线路</td>
				    <td>时间</td>
				    <td>类型</td>
				    <td>目标id/充值订单号</td>
				    <td>目标名称/物品名称</td>
				    <td>涉及总金额</td>
				    <td>涉及数量</td>
				    <td>单个金额/单价</td>
				    <td>操作后剩余金</td>
				    <td>备注</td>
				  </tr>';
		$sql = 'select * from '. self::TABLE_NAME . " where role_id = {$this->roleId} order by id desc limit 30";
		$db = Db::getInstance();
		$handle = $db->query($sql);
		while ($row = $db->fetch_array($handle)){
			$html .= '<tr>
						<td>' . $row['zone_id'] . '</td>
    					<td>' . date('Y-m-d H:i:s',$row['ctime']) . '</td>
    					<td>' . ($row['event'] == 1 ? '<span style="color:green">充值</span>': '<span style="color:red">消费</span>') . '</td>
    					<td>' . $row['target_id '] . '</td>
    					<td>' . $row['target_name '] . '</td>
    					<td>' . $row['sum '] . '</td>
    					<td>' . $row['num'] . '</td>
    					<td>' . $row['price'] . '</td>
    					<td>' . $row['remain'] . '</td>
    					<td>' . $row['note'] . '</td>
  					</tr>
  					';
		}
		return $html .= '</table>';	
	}
	
} 
 