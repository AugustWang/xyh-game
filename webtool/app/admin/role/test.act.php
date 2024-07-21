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

        // string sprintf ( string $format [, mixed $args [, mixed $... ]] )
        //% - a literal percent character. No argument is required.
        //b - the argument is treated as an integer, and presented as a binary number.
        //c - the argument is treated as an integer, and presented as the character with that ASCII value.
        //d - the argument is treated as an integer, and presented as a (signed) decimal number.
        //e - the argument is treated as scientific notation (e.g. 1.2e+2). The precision specifier stands for the number of digits after the decimal point since PHP 5.2.1. In earlier versions, it was taken as number of significant digits (one less).
        //E - like %e but uses uppercase letter (e.g. 1.2E+2).
        //f - the argument is treated as a float, and presented as a floating-point number (locale aware).
        //F - the argument is treated as a float, and presented as a floating-point number (non-locale aware). Available since PHP 4.3.10 and PHP 5.0.3.
        //g - shorter of %e and %f.
        //G - shorter of %E and %f.
        //o - the argument is treated as an integer, and presented as an octal number.
        //s - the argument is treated as and presented as a string.
        //u - the argument is treated as an integer, and presented as an unsigned decimal number.
        //x - the argument is treated as an integer and presented as a hexadecimal number (with lowercase letters).
        //X - the argument is treated as an integer and presented as a hexadecimal number (with uppercase letters).

        $a = sprintf("%d %s", 1, "abc");
        var_dump($a);


        // $link = ropeb_connect('myserver1@127.0.0.1',  'myserver0755'); 
        // if (!$link) { 
        //     die('Could not connect: ' . ropeb_error()); 
        // } 

        // // $msg = ropeb_encode('[~p,~a]', array( 
        // //     array($link,'getinfo')
        // // ) 
        // $msg = ropeb_encode('[]', array()); 
        // //The sender must include a reply address.  use ~p to format a link identifier to a valid Erlang pid.

        // ropeb_send_byname('pong',$msg,$link); 

        // $message = ropeb_receive($link);
        // $rs= ropeb_decode( $message) ;
        // print_r($rs);

        // $serverpid = $rs[0][0];

        // $message = ropeb_encode('[~s]', 
        //     array(
        //         array( 'how are you')
        //     )
        // );
        // ropeb_send_bypid($serverpid,$message,$link); 
        // //just demo for how to use ropeb_send_bypid

        // ropeb_close($link); 
    }

}
