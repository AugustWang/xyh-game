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
        //$erl = new Erlang();
        //$erl->connect();
        //$rt = $erl->get('lib_admin', 'check_timeing');
        $rt = array(
            0 => array(
                0 => 0 ,
                1 => 1399219200,
                2 => 1401551999 ,
                3 => array( 0 => 3517, ),
                4 => array( 0 => 3669, ),
                5 => '450关到451关用户定期活动 ',
                6 => array ( 0 => array ( 0 => 101000, 1 => 2, ), 1 => array ( 0 => 2, 1 => 2000, ), ), ),);
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
