<?php
/*-----------------------------------------------------+
 * 查看条件活动
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_custom extends Page{

    public function __construct(){
        parent::__construct();
    }

    public function process()
    {
        if (extension_loaded('ropeb')) {
            $erl = new Erlang();
            $erl->connect();
            $rt = $erl->get('lib_admin', 'check_custom');
        }else{
            $this->assign('alert', "没有安装Erlang扩展");
        }

        // $rt = array (
        //     0 => array (
        //         0 => 2 ,
        //         1 => array ( 0 => array ( 0 => "custom_tollgate", 1 => 40, 2 => 451 ), ) ,
        //         2 => "都没人来玩这个功能啊，谁来玩一下拉，上线有BUG就惨了 ",
        //         3 => array ( 0 => array ( 0 => 5, 1 => array ( 0 => 30009, 1 => 2, ), ), 1 => array ( 0 => 2, 1 => 2000, ), ),
        //         4 => array ( 0 => 4350, 1 => 4261, 2 => 3465, 3 => 4341, 4 => 4341, 5 => 4341, 6 => 4341, ), ), );

        //print_r($rt);
        function array_implode($arrays, &$target = array()) {
            foreach ($arrays as $item) {
                if (is_array($item)) {
                    array_implode($item, $target);
                } else {
                    $target[] = $item;
                }
            }
            return $target;
        }

        foreach($rt as $k => $v){
            if(is_array($v)){
                foreach($v as $k2 => $v2){
                    if(is_array($v2)){
                        $data[$k][$k2] = join(",", array_implode($v2));
                    }else{
                        $data[$k][$k2] = $v2;
                    }
                }
            }
        }

        foreach($data as $k => $v){
            $data[$k]['con'] = "";
            $data[$k]['con3'] = "";
            $con = explode(",", $v[1]);
            //print_r($con);
            if(count($con) > 1){
                foreach($con as $kv => $vv){
                    if($vv == "custom_tollgate"){
                        //$data[$k]['custom_tollgate'] = "关卡限制(从" . $con[$kv+1] . "关到" . $con[$kv+2] . "关)";
                        $data[$k]['con'] .= "关卡限制(从" . $con[$kv+1] . "关到" . $con[$kv+2] . "关)";
                        //echo $data[$k]['custom_tollgate'];
                    }
                    if($vv == "custom_register"){
                        $d1 = date("Y-m-d H:i:s", $con[$kv+1]);
                        $d2 = date("Y-m-d H:i:s", $con[$kv+2]);
                        //$data[$k]['custom_register'] = "注册限制(". $d1 . " -> " . $d2 . ")";
                        $data[$k]['con'] .= "注册限制(". $d1 . " -> " . $d2 . ")";
                    }
                    if($vv == "custom_shop_diamond"){
                        //$data[$k]['custom_shop_diamond'] = "购买钻石限制(". $con[$kv+1]. "->". $con[$kv+2] .")";
                        $data[$k]['con'] .= "购买钻石限制(". $con[$kv+1]. "->". $con[$kv+2] .")";
                    }
                }
            }

            $con3 = explode(",", $v[3]);
            //print_r($con3);
            //echo count($con3);
            if(count($con3) > 1){
                $i = 1;
                while(true){
                    if(count($con3) <= $i){
                        break;
                    }
                    if($con3[$i-1] > 100000){
                        $data[$k]['con3'] .= "{装备:". $con3[$i-1]. ",数量:" .$con3[$i]. "} // ";
                        $i+=2;
                    }elseif($con3[$i-1] == 5){
                        $data[$k]['con3'] .= "{英雄:". $con3[$i]. ",品质:". $con3[$i+1]."} // ";
                        $i+=2;
                    }elseif($con3[$i-1] == 2){
                        $data[$k]['con3'] .= "{钻石:". $con3[$i]. "} // ";
                        $i+=2;
                    }else if($con3[$i-1] == 3){
                        $data[$k]['con3'] .= "{幸运星:". $con3[$i]. "} // ";
                        $i+=2;
                    }else if($con3[$i-1] == 7){
                        $data[$k]['con3'] .= "{疲劳值:". $con3[$i]. "} // ";
                        $i+=2;
                    }else if($con3[$i-1] == 8){
                        $data[$k]['con3'] .= "{喇叭:". $con3[$i]. "} // ";
                        $i+=2;
                    }else{
                        $data[$k]['con3'] .= "{道具:". $con3[$i]. "数量:" .$con3[$i+1]. "} // ";
                        $i+=2;
                    }
                }
            }
            //print_r($con3);

            $con4 = explode(",", $v[4]);
            $data[$k]['con4'] = count($con4);
        }

        // print_r($data);
        $this->assign('data', $data);
        $this->display();
    }

}
