<?php
/*-----------------------------------------------------+
 * 查看条件活动
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/
class Act_Check_extra extends Page{

    public function __construct(){
        parent::__construct();
    }

    public function process()
    {
        if (extension_loaded('ropeb')) {
            $erl = new Erlang();
            $erl->connect();
            $rt = $erl->get('extra', 'get');
        }else{
            $this->assign('alert', "没有安装Erlang扩展");
        }

        //$rt = Array (
        //    0 => Array (
        //        0 => 0,
        //        1 => "rmb",
        //        2 => Array (
        //            0 => Array ( 0 => 98, 1 => Array ( 0 => Array ( 0 => 15002, 1 => 10, ), 1 => Array ( 0 => 15003, 1 => 5, ), 2 => Array ( 0 => 7, 1 => 100, ), ), ),
        //            1 => Array ( 0 => 308, 1 => Array ( 0 => Array ( 0 => 15002, 1 => 35, ), 1 => Array ( 0 => 15003, 1 => 20, ), 2 => Array ( 0 => 7, 1 => 400, ), ), ),
        //            2 => Array ( 0 => 408, 1 => Array ( 0 => Array ( 0 => 15002, 1 => 50, ), 1 => Array ( 0 => 15003, 1 => 30, ), 2 => Array ( 0 => 7, 1 => 600, ), ), ),
        //            3 => Array ( 0 => 618, 1 => Array ( 0 => Array ( 0 => 15002, 1 => 80, ), 1 => Array ( 0 => 15003, 1 => 50, ), 2 => Array ( 0 => 7, 1 => 900, ), ), ),),
        //        3 => "萌亲,您成功充值~w人民币,获得~w个中级深渊卷,~w个高级深渊卷,~w体力值的奖励!",
        //        4 => Array ( ),
        //        5 => Array ( ), ),
        //    1 => Array (
        //        0 => 1,
        //        1 => "hero",
        //        2 => Array (
        //            0 => Array ( 0 => 30015, 1 => Array ( 0 => Array ( 0 => 2, 1 => 300, ), 1 => Array ( 0 => 7, 1 => 100, ), ), ),
        //            1 => Array ( 0 => 30016, 1 => Array ( 0 => Array ( 0 => 2, 1 => 300, ), 1 => Array ( 0 => 7, 1 => 100, ), ), ),
        //            2 => Array ( 0 => 30022, 1 => Array ( 0 => Array ( 0 => 2, 1 => 300, ), 1 => Array ( 0 => 7, 1 => 100, ), ), ),
        //            3 => Array ( 0 => 30024, 1 => Array ( 0 => Array ( 0 => 2, 1 => 300, ), 1 => Array ( 0 => 7, 1 => 100, ), ), ),
        //            4 => Array ( 0 => 30025, 1 => Array ( 0 => Array ( 0 => 2, 1 => 600, ), 1 => Array ( 0 => 7, 1 => 200, ), ), ),
        //            5 => Array ( 0 => 30012, 1 => Array ( 0 => Array ( 0 => 2, 1 => 600, ), 1 => Array ( 0 => 7, 1 => 200, ), ), ),
        //            6 => Array ( 0 => 30013, 1 => Array ( 0 => Array ( 0 => 2, 1 => 600, ), 1 => Array ( 0 => 7, 1 => 200, ), ), ),
        //            7 => Array ( 0 => 30023, 1 => Array ( 0 => Array ( 0 => 2, 1 => 600, ), 1 => Array ( 0 => 7, 1 => 200, ), ), ), ),
        //        3 => "萌亲,您抽到“~s”英雄,获得~w钻石和~w体力值奖励!" ,
        //        4 => Array ( ) ,
        //        5 => Array (0=>3,1=>4,2=>5, ), ),
        //);

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

        function array_prize($array, &$prize = "") {
            foreach($array as $k => $v){
                if($v[0]==1){
                    $prize .= "(金币:". $v[1] .")";
                } else if($v[0]==2){
                    $prize .= "(钻石:". $v[1] .")";
                } else if($v[0]==3){
                    $prize .= "(幸运星:". $v[1] .")";
                } else if($v[0]==5){
                    $prize .= "(英雄:". $v[0] . "-品质:". $v[1] .")";
                } else if($v[0]==7){
                    $prize .= "(疲劳:". $v[1] .")";
                } else if($v[0]==8){
                    $prize .= "(喇叭:". $v[1] .")";
                } else {
                    $prize .= "(装备:". $v[0] . "-数量:". $v[1] .")";
                }
            }
            return $prize;
        }

        foreach($rt as $k => $v){
            $data[$k]['key'] = $v[0];
            $data[$k]['type'] = $v[1];
            //$data[$k]['val'] = $v[2];
            if(is_array($v[2])){
                foreach($v[2] as $k2 => $v2){
                    $val[$k] .= $v2[0] . "=>" . array_prize($v2[1]) . " || ";
                }
                $data[$k]['val'] = $val[$k];
            }
            $data[$k]['cont'] = $v[3];
            $data[$k]['num'] = sizeof($v[5]);
        }

        // foreach($rt as $k => $v){
        //     if(is_array($v)){
        //         foreach($v as $k2 => $v2){
        //             if(is_array($v2)){
        //                 $data[$k][$k2] = join(",", array_implode($v2));
        //             }else{
        //                 $data[$k][$k2] = $v2;
        //             }
        //         }
        //     }
        // }


        // print_r($data);
        $this->assign('data', $data);
        $this->display();
    }

}
