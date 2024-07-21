<?php

//echo "<pre>";
//if (extension_loaded('ropeb')) {
//    $a = ropeb_system("svn status ../../");
//    //$a = ropeb_system("svn co svn://127.0.0.1/myserver/src/pt /home/www/ --username myserver --password 01");
//}else{
//    $a = 'aaa';
//}
//echo "====";
//print_r($a);

//echo "<pre>";
//svn_auth_set_parameter(SVN_AUTH_PARAM_DEFAULT_USERNAME, 'myserver');
//svn_auth_set_parameter(SVN_AUTH_PARAM_DEFAULT_PASSWORD, '01');
////var_dump(svn_commit('Log message of Rolong\'s commit', array('/home/www/pt')));
//
////var_dump(svn_commit('Log message of Rolong\'s commit', array('/home/www/pt')));
////var_dump(svn_update("/data/myserver/"));
//var_dump(svn_status("/data/myserver/"));
//echo "</pre>";
$arr = array("a", 'bb');
$aa = each($arr);

var_dump($aa); // a
$aa = each($arr);

var_dump($aa); // a
