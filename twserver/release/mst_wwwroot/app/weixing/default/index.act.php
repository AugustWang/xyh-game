<?php
/*-----------------------------------------------------+
 * 微信消息处理
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/


class Act_Index extends Page{
	public $token = 'turbine';
	public $wx;
    public $tplPrefix;
	
    public function __construct(){
        parent::__construct();
        $this->wx = new Weixing($this->token);
        $this->tplPrefix = APP_ROOT.'/_tpl/';
    }

    public function process(){
        $this->do_cmd();
    }

    public function do_cmd(){
        switch($this->wx->keyword)
        {
        case 1:
            $items = array(
                array(
                    "title"=>"《萌兽堂》官方网站",
                    "desc"=>"《萌兽堂》官方网站",
                    "url"=>"http://szturbotech.com/",
                    "picurl"=>"http://szturbotech.com/images/combat1.png",
                ),
                array(
                    "title"=>"苹果版下载",
                    "desc"=>"苹果版下载",
                    "url"=>"https://itunes.apple.com/cn/app/meng-shou-tang/id785823993?mt=8",
                    "picurl"=>"http://szturbotech.com/images/face50.png",
                ),
                array(
                    "title"=>"安卓版下载",
                    "desc"=>"安卓版下载",
                    "url"=>"http://szturbotech.com/download/YXLM.apk",
                    "picurl"=>"http://szturbotech.com/images/face50.png",
                ),
            );
            $this->response_news($items);
            break;
        case 2:
            $items = array(
                array(
                    "title"=>"游戏说明",
                    "desc"=>"横版RPG手机网游《萌兽堂》官方帐号，分享产品动态，深度用户沟通，精彩活动、游戏功略一网打尽...",
                    "picurl"=>"http://szturbotech.com/images/combat1.png",
                    "url"=>"http://szturbotech.com"
                ),
            );
            $this->response_news($items);
            break;
        default:
            $this-> response_text("深圳市涡轮科技有限公司\n横版RPG手机网游《萌兽堂》官方帐号，分享产品动态，深度用户沟通，精彩活动、游戏功略一网打尽...\n请回复以下数字进行相关操作：\n[1]、下载《萌兽堂》安装包\n[2]、游戏说明\n[0]、操作说明");
        }
    }

    // 返回文本消息
    public function response_text($content){
        $data = array(
            'to' => $this->wx->fromUsername,
            'from' => $this->wx->toUsername,
            'time' => time(),
            'content' => $content,
        );
        $this-> assign("data", $data);
        $this->clearTemplate();
        $this->addTemplate($this->tplPrefix . 'response_text.xml', true);
        $this->display();
    }

    // 返回图文消息
    public function response_news($items){
        $data = array(
            'to' => $this->wx->fromUsername,
            'from' => $this->wx->toUsername,
            'time' => time(),
            'items' => $items,
        );
        $this-> assign("data", $data);
        $this->clearTemplate();
        $this->addTemplate($this->tplPrefix . 'response_news.xml', true);
        $this->display();
    }

}
