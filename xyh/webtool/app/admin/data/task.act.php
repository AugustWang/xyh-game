<?php
/**
 * 生成任务数据
 */

set_time_limit(0);
ini_set('memory_limit','512M');

define('OBJ_NPC', 2);
define('OBJ_MONSTER', 3);
define('OBJ_COLLECT', 9);
define('OBJ_POINT', 10);

define('BONUS_EXP', 1);
define('BONUS_GOLD', 2);

class Act_Task extends Page{
    private
        $npc_name2id = array(),
        $monster_name2id = array(),
        $point_name2id = array(),
        $object_name2id = array(),
        $item_name2id = array(),
        $npc_obj = array(),
        $point_obj = array(),
        $npc = array(),
        $npc_xy = array(),
        $type = array(
            '主线' => 0,
            '支线' => 1,
            '日常' => 3,
            '循环' => 4,
            '其它' => 5,
        ),
        $task_id = 0,
        $info = "";

    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->excel_dir = WEB_DIR . "/data/excel/";
        if($this->input['do'] == 'ok'){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt = $erl -> get('u', 'update_xyh_bin');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn add：" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            // 生成任务数据
            $task = include(WEB_DIR . "/data/php/task.php");
            ####### IMPORT DATA #######
            $this->set_map_object();
            $this->set_npc_name2id();
            $this->set_monster_name2id();
            $this->set_point_name2id();
            $this->set_object_name2id();
            $this->set_item_name2id();
            ########################
            $pack = new Pack();
            foreach ($task as $task_id => $task_data){
                $this->task_id = $task_id;
                $pack->int16($task_id);
                $this->pack_npc(&$pack, $task_data);
                $type = isset($this->type[$task_data['type']]) ? $this->type[$task_data['type']] : 5;
                $class = isset($task_data['class']) ? $task_data['class'] : 0;
                $lev = isset($task_data['lev']) ? $task_data['lev'] : 0;
                $guild_lev = isset($task_data['guild_lev']) ? $task_data['guild_lev'] : 0;
                $camp = isset($task_data['camp']) ? $task_data['camp'] : 0;
                $prev_task = isset($task_data['prev_task']) ? $task_data['prev_task'] : 0;
                $pack->int8($type);
                $pack->int16($class);
                $lev = 0;
                $lev_max = 0;
                if($task_data['lev']){
                    $lev_arr = explode('&', $task_data['lev']);
                    $lev = $lev_arr[0];
                    $lev_max = $lev_arr[1];
                }
                $pack->int16($lev);
                $pack->int16($lev_max);
                $pack->int16($guild_lev);
                $pack->int16($camp);
                $pack->int16($prev_task);
                $pack->string($task_data['name']);
                $pack->string($task_data['desc1']);
                $pack->string($task_data['desc2']);
                $this->pack_aim($pack, $task_data);
                $this->pack_bonus($pack, $task_data);
                $this->pack_story_desc($pack, $task_data['story_desc1']);
                $this->pack_story_desc($pack, $task_data['story_desc2']);
                $is_auto_run = isset($task_data['is_auto_run']) ? $task_data['is_auto_run'] : 0;
                $pack->int16($is_auto_run);
                $anim = isset($task_data['anim']) ? $task_data['anim'] : '';
                $conditions = isset($task_data['conditions']) ? $task_data['conditions'] : '';
                $aim_map_id = isset($task_data['aim_map_id']) ? $task_data['aim_map_id'] : 0;
                $pack->string($anim);
                $pack->string($conditions);
                $pack->int16($aim_map_id);
                // '2' => array('npc1' => '小道童','npc2' => '天池守卫长','type' => '主线','camp' => 1,'prev_task' => 1,'aim' => '对话','name' => '寻找守卫','desc1' => '守卫队长就在前面不远处。','desc2' => '原来少侠已经醒了。','bonus' => '经验_4&金币_2','is_auto_run' => 1,'anim' => '0&0','conditions' => '0&0','aim_map_id' => 0),
            }
            $target_file = WEB_DIR . "/data/bin/task.bin";
            file_put_contents($target_file, $pack->get_binary());
            $this->info .= '<br/>任务数据生成完毕：' . $target_file;
            if (extension_loaded('ropeb')) {
                $rt = $erl -> get('u', 'commit_xyh_bin');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn commit：<br/>" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
                // $log = '[' . $this->import_count . ']';
                // Admin::log(10, $log .'\n'. $rt .'\n'. $rt2 .'\n'. $rt4);
            }else{
                $this->info .= "<h5><font color='red'>No ropeb module!</h5></font>";
            }
        }
        $this->assign('info', $this->info);
        $this->display();
    }

    public function set_map_object(){
        $map_object = include(WEB_DIR . "/data/php/map_object.php");
        $npc = array();
        $monster = array();
        $point = array();
        foreach($map_object as $obj){
            switch($obj['type']){
            case OBJ_NPC :
                $this->npc_obj[$obj['type_id']] = $obj;
                break;
            case OBJ_POINT :
                $this->point_obj[$obj['type_id']] = $obj;
                break;
            }
        }
    }

    public function set_npc_name2id(){
        $npc = include(WEB_DIR . "/data/php/npc.php");
        $npc_name2id = array();
        foreach($npc as $npc_id => $npc_data){
            $npc_name2id[$npc_data['name']] = $npc_id;
        }
        $this->npc_name2id = $npc_name2id;
    }

    public function set_monster_name2id(){
        $monster = include(WEB_DIR . "/data/php/monster.php");
        $monster_name2id = array();
        foreach($monster as $monster_id => $monster_data){
            $monster_name2id[$monster_data['name']] = $monster_id;
        }
        $this->monster_name2id = $monster_name2id;
    }

    public function set_point_name2id(){
        $point = include(WEB_DIR . "/data/php/pathpoint.php");
        $point_name2id = array();
        foreach($point as $point_id => $point_data){
            $point_name2id[$point_data['name']] = $point_id;
        }
        $this->point_name2id = $point_name2id;
    }

    public function set_object_name2id(){
        $object = include(WEB_DIR . "/data/php/object.php");
        $object_name2id = array();
        foreach($object as $object_id => $object_data){
            $object_name2id[$object_data['name']] = $object_id;
        }
        $this->object_name2id = $object_name2id;
    }

    public function set_item_name2id(){
        $item = include(WEB_DIR . "/data/php/item.php");
        $item_name2id = array();
        foreach($item as $item_id => $item_data){
            $item_name2id[$item_data['name']] = $item_id;
        }
        $this->item_name2id = $item_name2id;
    }

    public function pack_npc($pack, $task_data){
        // NPC1
        $npc1_id = -1;
        $npc1_x = 0;
        $npc1_y = 0;
        $npc1_map_id = 0;
        if(isset($task_data['npc1'])){
            if(isset($this->npc_name2id[$task_data['npc1']])){
                $npc1_id = $this->npc_name2id[$task_data['npc1']];
                $npc1_obj = $this->npc_obj[$npc1_id];
                $npc1_x = $npc1_obj['x'];
                $npc1_y = $npc1_obj['y'];
                $npc1_map_id = $npc1_obj['map_id'];
            }else{
                $this->set_info("Error Npc1: " . $task_data['npc1']);
            }
        }else{
            $this->set_info("Task ". $this->task_id ." No Npc1");
        }
        // NPC2
        $npc2_id = -1;
        $npc2_x = 0;
        $npc2_y = 0;
        $npc2_map_id = 0;
        if(isset($task_data['npc2'])){
            if(isset($this->npc_name2id[$task_data['npc2']])){
                $npc2_id = $this->npc_name2id[$task_data['npc2']];
                $npc2_obj = $this->npc_obj[$npc2_id];
                $npc2_x = $npc2_obj['x'];
                $npc2_y = $npc2_obj['y'];
                $npc2_map_id = $npc2_obj['map_id'];
            }else{
                $this->set_info("Error Npc2: " . $task_data['npc2']);
            }
        }else{
            $this->set_info("Task ". $this->task_id ." No Npc2");
        }
        // NPC1
        $pack->int16($npc1_id);
        $pack->int16($npc1_map_id);
        $pack->int16($npc1_x);
        $pack->int16($npc1_y);
        // NPC2
        $pack->int16($npc2_id);
        $pack->int16($npc2_map_id);
        $pack->int16($npc2_x);
        $pack->int16($npc2_y);
        // echo "npc2_id=" . $npc2_id . '<br/>';
        // echo "npc2_map_id=" . $npc2_map_id . '<br/>';
        // echo "npc2_x=" . $npc2_x . '<br/>';
        // echo "npc2_y=" . $npc2_y . '<br/>';
    }

    public function pack_aim($pack, $task_data) {
        if($task_data['aim']){
            $aim_str = $task_data['aim'];
        }else{
            $pack->uint8(0);
            return;
        }
        // // 对话
        // 杀怪_怪物名_5(个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
        // 采集_获得物品名_5(个数)_采集物名_50(掉落率)_1(一次掉落个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
        // 打怪收集_收集物品名_5(个数)_怪物名_50(掉落率)_1(一次掉落个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
        // 商店_1(商店id)
        // 使用物品_物品名_1(使用数量)
        // 激活装备_1(装备id)_1
        // 学习技能_2(技能id)_1
        // %%任务条件类型ETaskType
        // -define( TASKTYPE_TALK, 1 ). %%//对话
        // -define( TASKTYPE_MONSTER, 2). %%//杀怪
        // -define( TASKTYPE_COLLECT, 3). %%//采集
        // -define( TASKTYPE_ITEM, 4). %%//物品收集
        // -define( TASKTYPE_USEITEM, 5). %%//使用物品
        // -define( TASKTYPE_BUSINESS, 6). %%//跑商
        // -define( TASKTYPE_GUARD, 7). %%//守卫
        // -define( TASKTYPE_PRMRY_ESCORT, 8). %%//护送
        // -define( TASKTYPE_ADVN_ESCORT, 9). %%//高级护送
        // -define( TASKTYPE_SPECIAL, 10). %%//其他
        // -define( TASKTYPE_SHOP, 11). %%//商店
        // -define( TASKTYPE_TEACH, 12). %%//教学
        // -define( TASKTYPE_GUILD, 13). %%//帮会
        // -define( TASKTYPE_STORAGE, 14). %%//仓库
        // -define( TASKTYPE_COPYMAP, 15). %%//副本
        // -define( TASKTYPE_ACTIVEEQUIP, 16). %%//激活装备
        // -define( TASKTYPE_LEARNSKILL, 17). %%//学习技能
        // -define( TASKTYPE_BUYITEM, 21). %%//购买物品
        // '杀怪_苍狼_8_苍狼桩桩_0&杀怪_驯狼山贼_8_驯狼山贼桩桩_0'
        // [{taskAim,2,8,8,0,0,0},{taskAim,2,127,8,0,0,0}]
        // <<Type:?INT16,Index:?INT16,Count:?INT,TargetID:?INT16,DropRate:?INT16,DropCount:?INT16,_S1:?INT16,_S2:?INT16,_S3:?INT16,_S4:?INT16,_S5:?INT16,B3/binary>> = B,
        $aim_arr = explode('&', $aim_str);
        $pack->uint8(count($aim_arr));
        foreach($aim_arr as $aim) {
            $aim_data = explode('_', $aim);
            switch($aim_data[0]){
            case '对话' :
                $pack->int16(1); # type
                $pack->int16(0); # index
                $pack->int32(0); # count
                $pack->int16(0); # TargetID
                $pack->int16(0); # DropRate
                $pack->int16(0); # DropCount
                $pack->int16(0); # s1
                $pack->int16(0); # s2
                $pack->int16(0); # s3
                $pack->int16(0); # s4
                $pack->int16(0); # s5
                break;
            case '杀怪' :
                # 杀怪_怪物名_5(个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
                # ID:3 Type:2,Index:158,Count:3,TargetID:0,DropRate:0,DropCount:0,_S1:204,_S2:9,_S3:3859,_S4:2012,_S5:0
                # 杀怪_幼蟾蜍_3_幼蟾蜍桩桩_0
                # Type:2,Index:2,Count:3,TargetID:0,DropRate:0,DropCount:0,_S1:2,_S2:1,_S3:1695,_S4:1147,_S5:0
                # 杀怪_古树老人的幻象_1_守阵之人_1
                # Type:2,Index:23,Count:1,TargetID:0,DropRate:0,DropCount:0,_S1:44,_S2:5,_S3:508,_S4:1962,_S5:1
                $monster_name = $aim_data[1];
                $monster_id = $this->monster_name2id[$monster_name];
                $monster_count = $aim_data[2];
                $is_npc = $aim_data[4];
                $target_id = 0;
                $target_obj = array(
                    'map_id' => 0,
                    'x' => 0,
                    'y' => 0,
                );
                if($is_npc == 1){
                    $npc_name = $aim_data[3];
                    if(isset($this->npc_name2id[$npc_name])) {
                        $target_id = $this->npc_name2id[$npc_name];
                        $target_obj = $this->npc_obj[$target_id];
                    }else{
                        $this->set_info('Error Npc Name: ' . $npc_name);
                    }
                }else{
                    $point_name = $aim_data[3];
                    if(isset($this->point_name2id[$point_name])) {
                        $target_id = $this->point_name2id[$point_name];
                        $target_obj = $this->point_obj[$target_id];
                    }else{
                        $this->set_info('Error Point Name: ' . $point_name);
                    }
                }
                $pack->int16(2); # type
                $pack->int16($monster_id); # index
                $pack->int32($monster_count); # count
                $pack->int16(0); # TargetID
                $pack->int16(0); # DropRate
                $pack->int16(0); # DropCount
                // BUFF_READ_SHORT( a.findTargetID, data, off );
                // BUFF_READ_SHORT( a.conditon_pos.mapID, data, off);
                // BUFF_READ_SHORT( a.conditon_pos.posX, data, off);
                // BUFF_READ_SHORT( a.conditon_pos.posY, data, off);
                // BUFF_READ_SHORT( findType, data, off);
                $pack->int16($target_id); # s1 
                $pack->int16($target_obj['map_id']); # s2
                $pack->int16($target_obj['x']); # s3
                $pack->int16($target_obj['y']); # s4
                $pack->int16($is_npc); # s5
                break;
            case '采集' :
                # 采集_获得物品名_5(个数)_采集物名_50(掉落率)_1(一次掉落个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
                # 采集_树莓_10_树莓_100_1_树莓桩桩_0
                # Type:3,Index:5036, Count:10, TargetID:518, DropRate:100,DropCount:1,_S1:157,_S2:5,_S3:2695,_S4:1469,_S5:0
                $target_id = 0;
                $target_obj = array(
                    'map_id' => 0,
                    'x' => 0,
                    'y' => 0,
                );
                $item_name = $aim_data[1];
                $item_id = $this->item_name2id[$item_name];
                $item_count = $aim_data[2];
                $object_name = $aim_data[3];
                $object_id = $this->object_name2id[$object_name];
                $drop_rate = $aim_data[4];
                $drop_count = $aim_data[5];
                $is_npc = $aim_data[7];
                if($is_npc == 1){
                    $npc_name = $aim_data[6];
                    if(isset($this->npc_name2id[$npc_name])) {
                        $target_id = $this->npc_name2id[$npc_name];
                        $target_obj = $this->npc_obj[$target_id];
                    }else{
                        $this->set_info('Error Npc Name: ' . $npc_name);
                    }
                }else{
                    $point_name = $aim_data[6];
                    if(isset($this->point_name2id[$point_name])) {
                        $target_id = $this->point_name2id[$point_name];
                        $target_obj = $this->point_obj[$target_id];
                    }else{
                        $this->set_info('Error Point Name: ' . $point_name);
                    }
                }
                $pack->int16(3); # type
                $pack->int16($item_id); # index
                $pack->int32($item_count); # count
                $pack->int16($object_id); # TargetID
                $pack->int16($drop_rate); # DropRate
                $pack->int16($drop_count); # DropCount
                $pack->int16($target_id); # s1 
                $pack->int16($target_obj['map_id']); # s2
                $pack->int16($target_obj['x']); # s3
                $pack->int16($target_obj['y']); # s4
                $pack->int16($is_npc); # s5
                break;
            case '打怪收集' :
                # 打怪收集_收集物品名_5(个数)_怪物名_50(掉落率)_1(一次掉落个数)_桩桩名(根据后面是0或1填桩桩名或npc名)_0(0寻桩桩，1寻npc) (多目标用&连接)
                # 打怪收集_雀鸟翅膀_10_雀鸟_100_1_雀鸟桩桩_0
                # Type:4,Index:5031,Count:10,TargetID:17,DropRate:100,DropCount:1,_S1:22,_S2:5,_S3:2200,_S4:2376,_S5:0
                $item_name = $aim_data[1];
                $item_id = $this->item_name2id[$item_name];
                $item_count = $aim_data[2];
                $monster_name = $aim_data[3];
                $monster_id = $this->monster_name2id[$monster_name];
                $drop_rate = $aim_data[4];
                $drop_count = $aim_data[5];
                $is_npc = $aim_data[7];
                if($is_npc == 1){
                    $npc_name = $aim_data[6];
                    if(isset($this->npc_name2id[$npc_name])) {
                        $target_id = $this->npc_name2id[$npc_name];
                        $target_obj = $this->npc_obj[$target_id];
                    }
                }else{
                    $point_name = $aim_data[6];
                    if(isset($this->point_name2id[$point_name])) {
                        $target_id = $this->point_name2id[$point_name];
                        $target_obj = $this->point_obj[$target_id];
                    }
                }
                $pack->int16(4); # type
                $pack->int16($item_id); # index
                $pack->int32($item_count); # count
                $pack->int16($monster_id); # TargetID
                $pack->int16($drop_rate); # DropRate
                $pack->int16($drop_count); # DropCount
                $pack->int16($target_id); # s1 
                $pack->int16($target_obj['map_id']); # s2
                $pack->int16($target_obj['x']); # s3
                $pack->int16($target_obj['y']); # s4
                $pack->int16($is_npc); # s5
                break;
            case '使用物品' :
                // 商店_物品名_1(使用数量)
                // 激活装备_1(装备id)_1
                // 学习技能_2(技能id)_1
                $item_name = $aim_data[1];
                $item_id = $this->item_name2id[$item_name];
                $item_count = $aim_data[2];
                $pack->int16(5); # type
                $pack->int16($item_id); # index
                $pack->int32($item_count); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '初级护送' :
                $pack->int16(8); # type
                $pack->int16(0); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '高级护送' :
                $pack->int16(9); # type
                $pack->int16(0); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '商店' :
                // 商店_1(商店id)
                // 使用物品_物品名_1(使用数量)
                // 激活装备_1(装备id)_1
                // 学习技能_2(技能id)_1
                $pack->int16(11); # type
                $pack->int16($aim_data[1]); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '仓库' :
                $pack->int16(14); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(isset($aim_data[2]) ? $aim_data[2] : 0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '副本' :
                $pack->int16(15); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(isset($aim_data[2]) ? $aim_data[2] : 0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '激活装备' :
                # 激活装备_1(装备id)_1
                # Type:16,Index:1,Count:0,TargetID:0,DropRate:0,DropCount:0,_S1:0,_S2:0,_S3:0,_S4:0,_S5:0
                $pack->int16(16); # type
                $pack->int16(0); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '学习技能' :
                # 学习技能_2(技能id)_1
                # Type:17,Index:1,Count:0,TargetID:0,DropRate:0,DropCount:0,_S1:0,_S2:0,_S3:0,_S4:0,_S5:0
                $item_name = $aim_data[1];
                $item_id = $this->item_name2id[$item_name];
                $item_count = $aim_data[2];
                $pack->int16(17); # type
                $pack->int16($item_id); # index
                $pack->int32($item_count); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '购买物品' :
                $pack->int16(18); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '装备精炼' :
                $pack->int16(19); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(isset($aim_data[2]) ? $aim_data[2] : 0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '宠物精炼' :
                $pack->int16(20); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(isset($aim_data[2]) ? $aim_data[2] : 0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '采购物品' :
                $pack->int16(21); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(isset($aim_data[2]) ? $aim_data[2] : 0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            case '凡仙战场' :
                $pack->int16(22); # type
                $pack->int16(isset($aim_data[1]) ? $aim_data[1] : 0); # index
                $pack->int32(0); # count
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                $pack->int16(0);
                break;
            default:
                $this->set_info('Undef Task Type: ' . $aim_data[0]);
                $pack->int16(0); # type
                $pack->int16(0); # index
                $pack->int32(0); # count
                $pack->int16(0); # TargetID
                $pack->int16(0); # DropRate
                $pack->int16(0); # DropCount
                $pack->int16(0); # s1
                $pack->int16(0); # s2
                $pack->int16(0); # s3
                $pack->int16(0); # s4
                $pack->int16(0); # s5
                break;
            }
        }
    }

    public function pack_bonus($pack, $task_data) {
        if($task_data['bonus']){
            $bonus_str = $task_data['bonus'];
        }else{
            $pack->uint8(0);
            return;
        }
        $bonus_arr = explode('&', $bonus_str);
        $pack->uint8(count($bonus_arr));
        foreach($bonus_arr as $bonus) {
            $bonus_data = explode('_', $bonus);
            switch($bonus_data[0]){
            case '经验' :
                $pack->int16(1);
                $pack->int32($bonus_data[1]);
                break;
            case '金币' :
                $pack->int16(2);
                $pack->int32($bonus_data[1]);
                break;
            default:
                $item_name = $bonus_data[0];
                $item_id = 0;
                if(isset($this->item_name2id[$item_name])){
                    $item_id = $this->item_name2id[$item_name];
                }else{
                    $this->set_info("Error Item Name: " . $item_name);
                }
                $item_count = $bonus_data[1];
                $pack->int16($item_id);
                $pack->int32($item_count);
                break;
            }
        }
    }

    public function pack_story_desc($pack, $desc) {
        if(!$desc || strlen($desc) < 2){
            $pack->uint16(1);
            $pack->uint16(0);
            $pack->uint16(0);
            return;
        }
        $story_arr = explode('&', $desc);
        $pack->uint16(count($story_arr));
        foreach($story_arr as $story) {
            $story_sub_arr = explode('_', $story);
            $pack->string($story_sub_arr[0]);
            $pack->string($story_sub_arr[1]);
        }
    }
    
    public function set_info($info) {
        $this->info .= $info . "<br/>";
    }
}
