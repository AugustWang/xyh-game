<?php
/*-----------------------------------------------------+
 * @author Rolong@vip.qq.com
 +-----------------------------------------------------*/
 
class Game
{

	/**
	 * 运行
	 */
	public static function run()
	{
		
		if (USE_GZ_HANDLER)
		{
			ob_start('ob_gzhandler');
		} else
		{
			ob_start();
		}
		try
		{
			$actionFile = self::getActionFile();
            if (!file_exists($actionFile))
            {
				throw new NotifyException("无效的请求" );
            }
			include $actionFile;
			$actionName = 'Act_' . CURRENT_ACTION;
			
			if (! class_exists($actionName, false))
			{
				throw new NotifyException("无效的({$actionName})" );
			}
			$action = new $actionName();
			if (! ($action instanceof Action))
			{
				throw new NotifyException('"' . CURRENT_ACTION . '"无效');
			}
			if (! method_exists($action, 'process'))
			{
				throw new NotifyException('没有执行入口');
			}
			$action->process();
		} catch (NotifyException $e)
		{
			$e->raiseMsg();
		}
		/*
        catch(Exception $e){
            $code = $e->getCode() ? $e->getCode() : 500;
            header("HTTP/1.1 $code ".$e->getMessage());
            exit($e->getMessage());
        }
         */
		ob_end_flush();
	}

	/**
	 * 返回用户请求指向的Action文件
	 */
	public static function getActionFile()
	{
		$m = isset($_REQUEST['mod']) ? $_REQUEST['mod'] : 'default';
		$a = isset($_REQUEST['act']) ? $_REQUEST['act'] : 'index';
		define('CURRENT_MODULE', $m);
		define('CURRENT_ACTION', $a);
		define('APP_ROOT', APP_DIR . '/' . APP_ID . '/' . $m);
		return APP_ROOT . '/' . $a . '.act.php';
	}


	/**
	 * 生成一个影射到指定模块和动作的URL
	 *
	 * @param string $action 动作标识字串，空字串表示当前动作
	 * @param string $module 模块标识字串，空字串表示当前模块
	 * @param array $params 附加到url的参数
	 * @param bool $useParamCache 是否使用缓存中的Url参数(被保存在SESSION中)
	 * @return string $url URL字串
	 */
	public static function url($action = null, $module = null, $params = array(), $useParamCache = false)
	{
		/*
		if (is_array($params) && $useParamCache && isset($_SESSION['param_cache']) && is_array($_SESSION['param_cache']))
		{
			$params = array_merge($_SESSION['param_cache'], $params);
		} else
			if ($useParamCache && isset($_SESSION['param_cache']) && is_array($_SESSION['param_cache']))
			{
				$params = stripQuotes($_SESSION['param_cache']);
			}
		*/
		$action = $action ? $action : CURRENT_ACTION;
		$module = $module ? $module : CURRENT_MODULE;
		$url = array("?mod=$module&act=$action");
		//自动获得参数
		if(isset($_REQUEST['kw']) && is_array($_REQUEST['kw']))
		{
			foreach($_REQUEST['kw'] as $k=>$v)
				$params['kw['.$k.']'] = $v;
		}
		//为addParamCache函数打补丁
		if(isset($_REQUEST['ParamCache']) && is_array($_REQUEST['ParamCache']))
		{
			foreach($_REQUEST['ParamCache'] as $k=>$v)
				$params[$k] = $v;
		}
		if (is_array($params))
		{
			foreach ($params as $k => $v)
			{
				$url[] = urlencode($k) . '=' . urlencode($v);
			}
		}
		$url = implode($url, '&');
		return preg_match('!^' . $_SERVER['SCRIPT_NAME'] . '!', $_SERVER['REQUEST_URI']) ? $_SERVER['SCRIPT_NAME'] . $url : $url;
	}

	/**
	 * 扩展类似JS的alert函数，响应后直接退出php执行脚本
	 * @param $msg 提示信息
	 * @param $act 默认动作返回上一页，其它：href转到链接，close关闭当前窗口
	 * @param $href 网址
	 * @return null
	 */
	public static function alert($msg = '操作失败 :-(', $act = 'href', $href = '')
	{
		$js = '';
		switch ($act)
		{
			case 'href':
				if(!$href)$href = $_SERVER['HTTP_REFERER'];
				$js = "location.href='$href';";
				break;
			case 'close':
				$js = "window.open('','_parent','');window.close();";
				break;
			default:
				$js = "history.go(-1);";
		}
		//避免因字符编码问题
		echo '<html><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<body><script type="text/javascript">
alert("' . $msg . '");' . $js . '
</script></body></html>';
		exit();
	}

	/**
	 * 页面重定向
	 * @param string $url url字符串
	 */
	public static function redirect($url)
	{
		header('Location:' . $url);
		exit();
	}

}
