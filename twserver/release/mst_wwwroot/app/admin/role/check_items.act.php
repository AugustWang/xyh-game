<?php
/*-----------------------------------------------------+
 * 查看角色物品
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_items extends Page{
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();

        include(WEB_DIR . "/protocol/log_item.php");
        $this->item_tid = $item_tid;
        // include(WEB_DIR . "/protocol/log_hero.php");
        // $this->hero_tid = $hero_tid;
        // $this->hero_quality = $hero_quality;


        $tab_type[1] = "材料";
        $tab_type[2] = "道具";
        $tab_type[5] = "装备";
        $this->tab_type = $tab_type;

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
        $sql = 'SELECT `item_id`, `val` FROM `item` WHERE `role_id` = ';
        $items = $this->dbh->getAll($sql . (int)$id);
        foreach($items as $k => $v){
            $binary = new Binary($v['val']);
            $version = $binary->read_uint8();
            $rt[$k]['id'] = $v['item_id'];
            $rt[$k]['tid'] = $binary->read_uint32_big();
            $rt[$k]['sort'] = $binary->read_uint8();
            $rt[$k]['tab'] = $binary->read_uint8();
            $rt[$k]['tab_type'] = $this->tab_type[$rt[$k]['tab']];
            $rt[$k]['item_tid'] = $this->item_tid[$rt[$k]['tid']];
            if($rt[$k]['tid'] >= 100000){
                $rt[$k]['hero_id'] = $binary->read_uint32_big();
                $rt[$k]['etime'] = $binary->read_uint32_big();
                $rt[$k]['atime'] = $binary->read_uint32_big();
                $rt[$k]['lev'] = $binary->read_uint8();
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
                $rt[$k]['sockets'] = $binary->read_uint8();
            }else if($version == 1){
                $rt[$k]['num'] = $binary->read_uint8();
                $rt[$k]['quality'] = $binary->read_uint8();
                $rt[$k]['lev'] = 0;
                $rt[$k]['exp'] = 0;
            }else{
                $rt[$k]['num'] = $binary->read_uint8();
                $rt[$k]['quality'] = $binary->read_uint8();
                $rt[$k]['lev'] = $binary->read_uint8();
                $rt[$k]['exp'] = $binary->read_uint32_big();
            }
        }

        $this->assign('data', $rt);
        // $this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
        // $this->assign('hero_quality', Form::select('hero_quality', $this->hero_quality, $this->input['hero_quality']));
        $this->display();
    }
}
