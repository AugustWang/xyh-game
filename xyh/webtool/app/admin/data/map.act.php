<?php
/**
 *
 * 导入地图数据
 */

set_time_limit(0);
ini_set('memory_limit','512M');

class Act_Map extends Page{
    private
        $source_dir = "",
        $npc_data = array(),
        $obj_data = array(),
        $map_res2id = array(),
        $info = "";


    public function __construct(){
        parent::__construct();
    }

    public function set_map_res2id(){
        $map = include(WEB_DIR . "/data/php/mapsetting.php");
        $map_res2id = array();
        foreach($map as $map_id => $map_data){
            $map_res2id[$map_data['res']] = $map_id;
        }
        $this->map_res2id = $map_res2id;
    }

    public function get_files(){
        $dir = $this->source_dir;
        if (is_dir($dir)) {
            if ($dh = opendir($dir)) {
                $i = 0;
                while (($file = readdir($dh)) !== false) {
                    $encode = mb_detect_encoding($file, array('UTF-8', 'GB2312','GBK', 'CP936', 'EUC-CN'), true); 
                    // var_dump($encode);
                    $file = iconv($encode, 'UTF-8', $file);
                    $ext_pos = strpos($file, '.scn');
                    if ($ext_pos !== false && $ext_pos > 0) {
                        $files[$i]["name"] = iconv($encode, 'UTF-8', $file);
                        $files[$i]["size"] = round((filesize($dir . $file)/1024),2);
                        $files[$i]["time"] = date("Y-m-d H:i:s",filemtime($dir . $file));
                        $i++;
                    }
                }
            }
            closedir($dh);
            foreach($files as $k=>$v){
                $size[$k] = $v['size'];
                $time[$k] = $v['time'];
                $name[$k] = $v['name'];
            }
            array_multisort($time,SORT_DESC,SORT_STRING, $files);//按时间排序
            //array_multisort($name,SORT_DESC,SORT_STRING, $files);//按名字排序
            //array_multisort($size,SORT_DESC,SORT_NUMERIC, $files);//按大小排序
            return $files;
        }
    }

    public function process(){
        $this->source_dir = WEB_DIR . "/data/map/";
        if($this->input['do'] == 'ok'){
            $this->set_map_res2id();
            $this->import_files();
        }
        $files = $this->get_files();
        $this->assign('files', $files);
        $this->clearTemplate();
        $this->addTemplate('map');
        $this->assign('info', $this->info);
        $this->display();
    }

    protected function read_obj($map_id, $res_id, $height, $binary, $count){
        $result = array();
        for($i = 0; $count > $i; $i++){
            $result[$i] = array(
                'map_id' => $map_id,
                'res_id' => $res_id,
                'type' => $binary->read_uint32(),
                'type_id' => $binary->read_uint32(),
                'x' => $binary->read_uint32(),
                'y' => $height * 32 - $binary->read_uint32(),
            );
            $param_count = $binary->read_uint32();
            $param = array();
            for($param_count; $param_count > 0; $param_count--){
                $param[] = $binary->read_uint32();
            }
            $result[$i]['param'] = $param;
            $this->obj_data[] = $result[$i];
        }
        return $result;
    }

    protected function import_files(){
        $files_info = $this->get_files();
        if(count($files_info > 0)){
            foreach($files_info as $file_info){
                $file = $file_info['name'];
                preg_match('/^Map([0-9]+).scn$/', $file, $matches);
                if($matches[1] >= 0){
                    $res_id = (int)$matches[1];
                    $res_str = 'Map' . $matches[1];
                    $map_id = $this->map_res2id[$res_str];
                }else{
                    exit("Error Map File: " . $file);
                }
                $file = $this->source_dir . $file;
                $source = file_get_contents($file);
                $binary = new Binary($source);
                $len = $binary->read_uint32();
                $pic_name = $binary->get_data($len);
                $width = $binary->read_uint32();
                $height = $binary->read_uint32();
                $poses = $binary->get_data($width * $height);
                $obj_count = $binary->read_uint32();
                $objs = $this->read_obj($map_id, $res_id, $height, &$binary, $obj_count);
                ## mapId=MapDataID,
                ## type=Type,
                ## typeId=TypeId,
                ## x=X,
                ## y=MapView#mapView.height - Y,
                ## param = Params,
                ## isExist = 1
            }
            // END
            $this->clearTemplate();
            $this->addTemplate('map_object');
            $this->assign('obj_data', $this->obj_data);
            $content = $this->fetch();
            $file_name = WEB_DIR . "/data/php/map_object.php";
            file_put_contents($file_name, $content);
            $this->info .= "【导入成功】" . $file_name;
        }else{
            $this->info .= "<br/><font color='red'>请选择文件...</font>";
        }
    }

}

## %%物体类型，玩家
## -define(Object_Type_Player, 1 ).
## %%物体类型，npc
## -define(Object_Type_Npc, 2 ).
## %%物体类型，monster
## -define(Object_Type_Monster, 3 ).
## %%物体类型，系统
## -define(Object_Type_System, 4 ).
## %%物体类型，仙盟
## -define(Object_Type_Guild, 5 ).
## %%物体类型，队伍
## -define(Object_Type_Team, 6 ).
## %%物件类型，object
## -define(Object_Type_Object, 7 ).
## %%物件类型，传送点
## -define(Object_Type_TRANSPORT, 8 ).
## %%物件类型，采集
## -define(Object_Type_COLLECT, 9 ).
## %%物件类型，宠物
## -define(Object_Type_Pet, 10 ).
## %%物件类型，装备
## -define(Object_Type_Equipment, 11).
## %%物件类型，地图
## -define(Object_Type_Map, 12).
## %%物件类型，任务
## -define(Object_Type_Task, 13).
## %%物件类型，技能特效
## -define(Object_Type_SkillEffect, 14).
## %%物件类型，通用
## -define(Object_Type_Normal, 15).
## %%物件类型，日常
## -define(Object_Type_Daily, 16).
## %%物件类型，坐骑
## -define(Object_Type_Mount,17).
## %%物件类型，物品
## -define(Object_Type_Item,18).
## %%物件类型，邮件
## -define(Object_Type_Mail,19).
## %%镖车类型
## -define(Object_Type_Convoy,20).
