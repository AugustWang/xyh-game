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
        //$erl = new Erlang();
        //$erl->connect();
        //$rt = $erl->get('lib_admin', 'check_custom');
        $rt = array (
            0 => array (
                0 => 2 ,
                1 => array ( 0 => array ( 0 => "custom_tollgate", 1 => 40, 2 => 451 ), ) ,
                2 => "都没人来玩这个功能啊，谁来玩一下拉，上线有BUG就惨了 ",
                3 => array ( 0 => array ( 0 => 5, 1 => array ( 0 => 30009, 1 => 2, ), ), 1 => array ( 0 => 2, 1 => 2000, ), ),
                4 => array ( 0 => 4350, 1 => 4261, 2 => 3465, 3 => 4341, 4 => 4341, 5 => 4341, 6 => 4341, ), ), );
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
        //print_r($data);
        //$this->assign('data', $rt);
        $this->assign('data', $data);
        $this->display();
    }

}
