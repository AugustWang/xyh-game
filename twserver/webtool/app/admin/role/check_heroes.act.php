<?php
/*-----------------------------------------------------+
 * 查看角色英雄
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_heroes extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        // include(WEB_DIR . "/protocol/log_type.php");
        $log_type[0]   = "==全部==";
        $log_type[30001]       = "圣骑    ";
        $log_type[30003]       = "潜行者  ";
        $log_type[30002]       = "急速女法";
        $log_type[30004]       = "矮人火枪";
        $log_type[30005]       = "剑圣    ";
        $log_type[30006]       = "兽王    ";
        $log_type[30007]       = "痛苦术士";
        $log_type[30008]       = "牛头酋长";
        $log_type[30009]       = "萨满    ";
        $log_type[30010]       = "树人    ";
        $log_type[30011]       = "圣祭祀  ";
        $log_type[30015]       = "真恶魔猎手";
        $log_type[30012]       = "盖哥    ";
        $log_type[30013]       = "真山丘之王";
        $log_type[30014]       = "巫医    ";
        $log_type[30016]       = "枪神女警";
        $log_type[30017]       = "守望者  ";
        $log_type[30018]       = "审判天使";
        $log_type[30019]       = "巫妖    ";
        $log_type[30020]       = "斧王    ";
        $log_type[30021]       = "火枪戍卫";
        $log_type[30022]       = "寒冰射手";
        $log_type[30023]       = "黑暗游侠";
        $log_type[30024]       = "矮人飞机";
        $log_type[30025]       = "熊猫    ";
        $log_type[30026]       = "血法    ";
        $log_type[39998]       = "恶魔猎手";
        $log_type[39999]       = "真山丘之王";
        $this->log_type = $log_type;

        $hero_quality[0]       = "==全部==";
        $hero_quality[1]       = "D"       ;
        $hero_quality[2]       = "C"       ;
        $hero_quality[3]       = "B"       ;
        $hero_quality[4]       = "B+"      ;
        $hero_quality[5]       = "A"       ;
        $hero_quality[6]       = "A+"      ;
        $hero_quality[7]       = "S"       ;
        $this->hero_quality = $hero_quality;

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if(
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        ){
            $this->limit = $this->input['limit'];
        }

        if(
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        ){
            $this->page = $this->input['page'];
        }

        $this->assign('limit', $this->limit);
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process(){
        if(!isset($this->input['id'])){
            throw new NotifyException('参数错误!');
        }
        if(is_numeric($this->input['id'])){
            $id = $this->input['id'];
        }else{
            throw new NotifyException('参数错误!');
        }
        $sql = 'SELECT `hero_id`, `val` FROM `hero` WHERE `role_id` = ';
        $heroes = $this->dbh->getAll($sql . (int)$id);
        foreach($heroes as $k => $v){
            $binary = new Binary($v['val']);
            $version = $binary->read_uint8();
            $rt[$k]['id'] = $v['hero_id'];
            $rt[$k]['tid'] = $binary->read_uint32_big();
            $rt[$k]['job'] = $binary->read_uint8();
            $rt[$k]['sort'] = $binary->read_uint8();
            $rt[$k]['rare'] = $binary->read_uint8();
            $rt[$k]['hp'] = $binary->read_uint32_big();
            $rt[$k]['atk'] = $binary->read_uint32_big();
            $rt[$k]['def'] = $binary->read_uint32_big();
            $rt[$k]['pun'] = $binary->read_uint32_big();
            $rt[$k]['hit'] = $binary->read_uint32_big();
            $rt[$k]['dod'] = $binary->read_uint32_big();
            $rt[$k]['crit'] = $binary->read_uint32_big();
            $rt[$k]['critnum'] = $binary->read_uint32_big();
            $rt[$k]['critanit'] = $binary->read_uint32_big();
            $rt[$k]['tou'] = $binary->read_uint32_big();
            $rt[$k]['quality'] = $binary->read_uint8();
            $rt[$k]['pos'] = $binary->read_uint8();
            $rt[$k]['expmax'] = $binary->read_uint32_big();
            $rt[$k]['exp'] = $binary->read_uint32_big();
            $rt[$k]['lev'] = $binary->read_uint8();
            $rt[$k]['step'] = $binary->read_uint8();
            if($version == 2){
                $rt[$k]['foster'] = 0;
            }else{
                $rt[$k]['foster'] = $binary->read_uint8();
            }
            if($version == 4){
                $rt[$k]['star'] = $binary->read_uint8();
            }else{
                $rt[$k]['star'] = 0;
            }
            $rt[$k]['pos1'] = $binary->read_uint32_big();
            $rt[$k]['pos2'] = $binary->read_uint32_big();
            $rt[$k]['pos3'] = $binary->read_uint32_big();
            $rt[$k]['pos4'] = $binary->read_uint32_big();
            $rt[$k]['pos5'] = $binary->read_uint32_big();
            $rt[$k]['pos6'] = $binary->read_uint32_big();
            $rt[$k]['type'] = $this->log_type[$rt[$k]['tid']];
            $rt[$k]['hero_quality'] = $this->hero_quality[$rt[$k]['quality']];

            // 客户端公式: (收到的值 + 收到的值 * LV/25) + 装备属性
            $rt[$k]['hp'] = floor($rt[$k]['hp'] * $rt[$k]['lev']/25 + $rt[$k]['hp']);
            $rt[$k]['atk'] = floor($rt[$k]['atk'] * $rt[$k]['lev']/25 + $rt[$k]['atk']);
            $rt[$k]['def'] = floor($rt[$k]['def'] * $rt[$k]['lev']/25 + $rt[$k]['def']);
            $rt[$k]['pun'] = floor($rt[$k]['pun'] * $rt[$k]['lev']/25 + $rt[$k]['pun']);
            $rt[$k]['hit'] = floor($rt[$k]['hit'] * $rt[$k]['lev']/25 + $rt[$k]['hit']);
            $rt[$k]['dod'] = floor($rt[$k]['dod'] * $rt[$k]['lev']/25 + $rt[$k]['dod']);
            $rt[$k]['crit'] = floor($rt[$k]['crit'] * $rt[$k]['lev']/25 + $rt[$k]['crit']);
            $rt[$k]['critnum'] = floor($rt[$k]['critnum'] * $rt[$k]['lev']/25 + $rt[$k]['critnum']);
            $rt[$k]['critanti'] = floor($rt[$k]['critanti'] * $rt[$k]['lev']/25 + $rt[$k]['critanti']);
            $rt[$k]['tou'] = floor($rt[$k]['tou'] * $rt[$k]['lev']/25 + $rt[$k]['tou']);

        }

        $this->assign('data', $rt);
        // $this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
        // $this->assign('hero_quality', Form::select('hero_quality', $this->hero_quality, $this->input['hero_quality']));
        $this->display();
    }
}
