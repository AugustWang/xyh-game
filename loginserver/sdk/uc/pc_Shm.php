<?php
/**
 * 内存存储工具类
 *
 */
class pc_Shm{
	var $tmp;
	var $size;
	var $shm;
	var $keyfile;
	
	/**
	 * 构造方法
	 * @param unknown_type $tmp
	 */
	function pc_Shm($tmp = ''){
		if(!function_exists('shmop_open')){
			trigger_error('pc_Shm:shmop extension is required.',E_USER_ERROR);
			return;
		}
		
		if($tmp != '' && is_dir($tmp) && is_writable($tmp)){
			$this->tmp = $tmp;
		}else{
			$this->tmp = '/tmp';
		}
		
		//默认为2K
		$this->size = 2048;
		return true;
	}
	
	/**
	 * 构造方法
	 */
	function __construct($tmp = ''){
		return $this->pc_Shm($tmp);
	}
	
	/**
	 * 设置内存大小
	 * @param unknown_type $size 内存大小【单位：字节】
	 */
	private function setSize($size){
		if(ctype_digit($size)){
			$this->size = $size;
		}
	}
	
	/**
	 * 打开内存连接 【私有】
	 * @param unknown_type $id
	 */
	private function open($id){
		$key = $this->_getKey($id);
		$shm = shmop_open($key,'c',0644,$this->size);
		if(!$shm){
			trigger_error('pc_Shm:could not create shared memory segment .',E_USER_ERROR);
			return false;
		}
		$this->shm = $shm;
		return true;
	}
	
	/**
	 * 写入内存块【私有】
	 * @param unknown_type $data
	 */
	private function write($data){
		$written = shmop_write($this->shm,$data,0);
		if($written != strlen($data)){
			trigger_error('pc_Shm:could not write entire length of data',E_USER_ERROR);
			return;
		}
		return true;
	}
	
	/**
	 * 读取内存块【私有】
	 */
	private function read(){
		$data = shmop_read($this->shm,0,$this->size);
		if(!$data){
			trigger_error('pc_Shm:could not read shared of memory block',E_USER_ERROR);
			return;
		}
		return $data;
	}
	
	/**
	 * 删除内存块【私有】
	 * @param unknown_type $id
	 */
	private function delete($id){
		$this->open($id);
		if(shmop_delete($this->shm)){
			if(file_exists($this->tmp . DIRECTORY_SEPARATOR . $this->keyfile)){
				unlink($this->tmp . DIRECTORY_SEPARATOR . $this->keyfile);
			}
		}
		$this->close();
		return true;
	}
	
	/**
	 * 关闭内存连接【私有】
	 */
	private function close(){
		return shmop_close($this->shm);
	}
	
	/**
	 * 获取filekey【私有】
	 * @param unknown_type $id
	 */
	private function _getKey($id){
		$this->keyfile = 'pcshm_' . $id;
		if(!file_exists($this->tmp . DIRECTORY_SEPARATOR . $this->keyfile)){
			touch($this->tmp . DIRECTORY_SEPARATOR . $this->keyfile);	
		}
		return ftok($this->tmp . DIRECTORY_SEPARATOR . $this->keyfile,'R' );
	}
	
	/**
	 * 根据id获取内存数据【供外部访问】
	 * @param unknown_type $id
	 */
	function fetch($id){
		$this->open($id);
		$data = $this->read();
		$this->close();
		return $data;
	}
	
	/**
	 * 通过$id保存$data数据方法
	 * @param unknown_type $id   【string】类型
	 * @param unknown_type $data 【string】类型
	 */
	function save($id,$data){
		$this ->delete($id);//先删除$id里面的数据
		$this->open($id);
		$result = $this->write($data);
		if(!(bool)$result){
			return false;	
		}else{
			$this->close();
			return $result;
		}
	}
}

?>