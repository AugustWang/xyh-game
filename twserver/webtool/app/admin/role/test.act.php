<?php
/*-----------------------------------------------------+
 * Test
 * @author yeahoo2000@gmail.com
 +-----------------------------------------------------*/

class Act_Test extends Page{
    private
        $dbh;

    public function __construct(){
        parent::__construct();
        $this->dbh = Db::getInstance();
    }

    public function process(){

        $node = 'myserver1@42.121.111.191';
        $cookie = 'myserver0755';
        // $erl = new Erlang();
        // $erl -> connect();
        // $roleId = $erl -> get('lib_admin', 'get_online_roleid');
        // var_dump($roleId);
        // ropeb_status();
        $link = ropeb_connect($node, $cookie, 10000);
        var_dump($link);
        // $err = ropeb_error();
        // var_dump($err);
        // $x = ropeb_encode('[]', array());
        // $y = ropeb_rpc('t', 'sys_info', $x, $link);
        // echo 'sys_info:';
        // var_dump($y);
        ropeb_status();
        ropeb_close($link);

        echo 'OK';
    }

}
