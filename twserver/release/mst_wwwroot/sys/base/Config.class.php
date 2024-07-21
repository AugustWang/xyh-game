<?php
/*-----------------------------------------------------+
 * 配置处理类
 * @author erlang6@qq.com
 +-----------------------------------------------------*/
class Config {
    /**
     * 保存当前的配置内容
     * @var array
     */
    private static $conf= array ();

    private static $instance;

    private function __construct() {
        $this->conf = $this->load();
        /*
         * TODO:Memcache已经禁用
        $mc = new Memcache();
        $mc->connect(MC_HOST_SYSTEM, MC_PORT_SYSTEM);
        $this->conf = $mc->get('system_setting');
        if(false === $this->conf){
            $mc->set('system_setting', $this->conf);
        }
         */
    }

    public static function getInstance() {
        if(self::$instance){
            return self::$instance;
        }
        self::$instance= new self();
        return self::$instance;
    }

    /**
     * 取得一个配置的值
     *
     * @param string $key 配置名
     * @return mixed
     */
    public function get($key) {
    	if($key == 'erl')
    	{
            $node_key = 'admin_erlang_conn' . Config::getInstance()->get('server_id');
    		if($_SESSION[$node_key])
    			return $_SESSION[$node_key];
    	}
        return $this->conf[$key];
    }

    /**
     * 修改或添个一个配置
     *
     * @param string $key 配置名
     * @param mixed $val 值
     * @retrun 该配置的值
     */
    public function set($key, $val){
        return $this->conf[$key] = $val;
    }

    /**
     * 保存配置
     * TODO: 未实现
     */
    public function save(){
    }

    /**
     * 加载配置
     *
     * @return 配置内容
     */
    private function load(){
        //载入默认值
        if (defined('APP_CFG')) { 
            $cfg_file = APP_CFG;
        } else {
            $cfg_file = APP_ID;
        }
        return include APP_DIR.'/'.$cfg_file.'.cfg.php';
    }
}
