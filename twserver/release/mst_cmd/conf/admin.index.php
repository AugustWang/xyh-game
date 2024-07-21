<?php
/*-----------------------------------------------------+
 * 管理后台入口
 * @author erlang6@qq.com
 +-----------------------------------------------------*/

define('APP_ID', 'admin'); //当前应用标识
define('APP_CFG', 'SERVER_NAME'); //当前应用标识
define('USE_GZ_HANDLER', false); //使用gz_handler压缩输出页面
//权限标识常量定义
define('ACT_NEED_AUTH', 0); //需要登录并验证
define('ACT_NEED_LOGIN', 1); //需要登录
define('ACT_OPEN', 2); //完全开放

include '../../sys/boot.php';

Admin::run();
