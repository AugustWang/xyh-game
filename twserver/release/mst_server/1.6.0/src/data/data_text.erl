-module(data_text).
-export([get/1]).
get(ids) -> [];
get(1) -> "我遥远的朋友，这场战役将会万分的艰辛，请收下我最真诚的礼物!";
get(2) -> "系统消息";
get(3) -> "系统管理员";
get(4) -> "您的背包已满,请及时清理!";
get(5) -> "恭喜“~s”玩家经过不懈努力,成功将其“[{equ, ~w}]”装备,强化至+~w.太吓人了!";
get(6) -> "恭喜“~s”玩家成功合成[{equ, ~w}]装备,真NB有木有";
get(7) -> "恭喜“~s”玩家人品大爆发抽中了[{luck, ~w, ~w}],高大上有木有";
get(8) -> "恭喜“~s”获得稀世[{prop, ~w}],人品太好了";
get(9) -> "恭喜“~s”财大气粗的入手了一个“~s”级别的[{hero, ~w}]英雄";
get(10) -> "关卡冲冲冲,超值新包大奖励(节日期间通过450关的玩家均可收到此5000钻石的奖励邮件)";
get(11) -> "4月1日00:00起至4月7日23:59登录过萌兽堂1.1.1版本的用户都将获得2000钻石的补偿,每个用户限领一次,将会以邮件的形式发送,请注意查收!";
get(12) -> "英雄雇佣数量已达上限,请速去管理!";
get(13) -> "您好,欢迎加入萌兽堂玩家QQ群 226545919,进行交流,将有客服为您解答!";
get(14) -> "您参与充值优惠活动，现额外送“~w”钻石给您！请尽快点击邮件下方的“收取”按钮获取！";
get(15) -> "恭喜!您在角斗场比赛中获得了“~w”名,“~w”钻石的奖励奉上给您！请尽快点击邮件下方的“收取”按钮获取！";
get(16) -> "恭喜您完成vip晋升,获得了丰厚的奖励回报,请及时收取！";
get(17) -> "这是您的每日月卡奖励,只要您每日登陆游戏,即可获得月卡反馈给用户的钻石!";
get(18) -> "恭喜你获得媒体礼包~！";
get(19) -> "萌亲,新的“冒险”已经替换“主线”,我们将根据萌亲以前的闯关数量来赠送体力值和钻石,赶快开始新的冒险之旅吧！";
get(20) -> "萌亲,有建议和BUG反馈,尽量找QQ客服,这样处理更高效沟通更顺畅,客服QQ：2416591650";
get(21) -> "恭喜“~s”玩家成功合成[{hero, ~w}]英雄,真NB有木有";
get(22) -> "萌亲,您参加冒险比赛已完成~w关卡,获得~w颗幸运星!";
get(23) -> "萌亲,您在角斗场比赛中荣登第~w名,获得~w钻石的奖励!";
get(24) -> "萌亲,您抽到“~s”英雄,获得~w钻石和~w体力值奖励!";
get(25) -> "萌亲,恭喜你成功兑换360独家礼包,赶快收取吧!";
get(26) -> "萌亲,您参加冒险比赛已完成~w关卡,获得~w钻石,~w颗幸运星!";
get(27) -> "萌亲,您成功充值~w人民币,获得~w个中级深渊卷,~w个高级深渊卷,~w体力值的奖励!";
get(28) -> "萌亲,您在角斗场比赛中荣登第~w名,获得~w个中级深渊卷,~w个高级深渊卷,~w体力值的奖励!";
get(29) -> "萌亲,您成功充值~w人民币,获得~w个中级深渊卷,~w个高级深渊卷,~w体力值的奖励,~w大瓶经验药水!";
get(30) -> "萌亲,您参加冒险比赛已完成~w关卡,获得剑圣英雄,加入战斗吧!";
get(31) -> "萌亲,您幸运的抽中了血法英雄,额外获得英雄经验药水~w个";
get(_) -> undefined.