<?php
return array(
	//sdk server的接口地址
	//端游服务端测试环境访问地址：http://sdk.test4.g.uc.cn/ss
	//端游服务端生产环境访问地址：http://sdk.g.uc.cn/ss
	// 'serverUrl'=>"http://sdk.test4.g.uc.cn/ss",
	'serverUrl'=>"http://sdk.test4.g.uc.cn/ss",
	//游戏合作商编号
	'cpId'=>37418,
	//游戏编号
	'gameId'=>539558,
	//游戏发行渠道编号
	'channelId'=>"2",
	//游戏服务器编号
	'serverId'=>3032,
	//分配给游戏合作商的接入密钥,请做好安全保密
	'apiKey'=>"5aec7f588b3033f17d0c49c8cc37179c",
	
	//以下是相关时间参数的配置
	//连接超时时间【单位:秒】 默认:5
	'connectTimeOut' => 5,
	//获取IP列表间隔的时间【单位:小时】默认:24
	'intervalTime' => 24,
	//线程检测域名的时间间隔【单位:秒】默认:10
	'checkTime' => 10
);
