<?php
/*-----------------------------------------------------+
 * 查看定时活动
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_timeing extends Page{

    public function __construct(){
        parent::__construct();
    }

    public function process()
    {
        if (extension_loaded('ropeb')) {
            $erl = new Erlang();
            $erl->connect();
            $rt = $erl->get('lib_admin', 'check_timeing');
        }else{
            $this->assign('alert', "没有安装Erlang扩展");
        }

        // $rt = array(
        //     0 => array(
        //         0 => 0 ,
        //         1 => 1399219200,
        //         2 => 1401551999 ,
        //         3 => array( 0 => 3517, ),
        //         4 => array( 0 => 3669, ),
        //         5 => '450关到451关用户定期活动 ',
        //         6 => array ( 0 => array ( 0 => 101000, 1 => 2, ), 1 => array ( 0 => 2, 1 => 2000, ), ), ),);

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
            $data[$k]['con6'] = "";
            $con6 = explode(",", $v[6]);
            //print_r($con6);
            //echo count($con6);
            if(count($con6) > 1){
                $i = 1;
                while(true){
                    if(count($con6) <= $i){
                        break;
                    }
                    if($con6[$i-1] > 100000){
                        $data[$k]['con6'] .= "{装备:". $con6[$i-1]. ",数量:" .$con6[$i]. "} // ";
                        $i+=2;
                    }elseif($con6[$i-1] == 5){
                        $data[$k]['con6'] .= "{英雄:". $con6[$i]. ",品质:". $con6[$i+1]."} // ";
                        $i+=2;
                    }elseif($con6[$i-1] == 2){
                        $data[$k]['con6'] .= "{钻石:". $con6[$i]. "} // ";
                        $i+=2;
                    }else if($con6[$i-1] == 3){
                        $data[$k]['con6'] .= "{幸运星:". $con6[$i]. "} // ";
                        $i+=2;
                    }else if($con6[$i-1] == 7){
                        $data[$k]['con6'] .= "{疲劳值:". $con6[$i]. "} // ";
                        $i+=2;
                    }else if($con6[$i-1] == 8){
                        $data[$k]['con6'] .= "{喇叭:". $con6[$i]. "} // ";
                        $i+=2;
                    }else{
                        $data[$k]['con6'] .= "{道具:". $con6[$i]. "数量:" .$con6[$i+1]. "} // ";
                        $i+=2;
                    }
                }
            }
            //print_r($con6);
        }

        //print_r($data);
        $this->assign('data', $data);
        $this->display();
    }

}
