<?php
/**
 * 生成协议
 * @author Rolong<rolong@vip.qq.com>
 */

class Act_Protocol extends Page{
    private
        $source_dir = "",
        $import_count = 0,
        $module_map = array(),
        $src_kvs = array(),
        $protocol_data = array(),
        $target_php_file = "",
        $target_bin_file = "",
        $target_str_file = "",
        $file_id = "", // 去掉后缀的文件名
        $is_changed_php = false,
        $is_changed_bin = false,
        $is_changed_str = false,
        $keys = array('id', 'id1', 'id2', 'id3', 'id4', 'id5'),
        $string_array = array(),
        $string_count = 0,
        $record_count = 0,
        $info = "";


    public function __construct(){
        parent::__construct();
    }

    public function process(){
        $this->source_dir = WEB_DIR . "/data/protocol/";
        if($this->input['files']){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt = $erl -> get('u', 'update_xyh_protocol');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn add：" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            $this->import_files();
            if($this->info == '') {
                $this->info = '没有需要更新的文件！';
            }
            if (extension_loaded('ropeb')) {
                $rt = $erl -> get('u', 'commit_xyh_protocol');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn commit：<br/>" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
                // $log = '[' . $this->import_count . ']';
                // Admin::log(10, $log .'\n'. $rt .'\n'. $rt2 .'\n'. $rt4);
            }else{
                $this->info .= "<h5><font color='red'>No ropeb module!</h5></font>";
            }
        }
        $this->get_files();
        $this->assign('info', $this->info);
        $this->clearTemplate();
        $this->addTemplate('protocol');
        $this->display();
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
                    $ext_pos = strpos($file, '.h');
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
            // array_multisort($name,SORT_DESC,SORT_STRING, $files);//按名字排序
            //array_multisort($size,SORT_DESC,SORT_NUMERIC, $files);//按大小排序
            $this->assign('files', $files);
        }
    }

    protected function import_files(){
        // echo "<pre>";
        if(count($this->input['files']) > 0){
            foreach($this->input['files'] as $file){
                $file_name_no_ext = str_replace(".h", "", $file);
                $file_name_array = explode('.', $file_name_no_ext);
                $file_id = $file_name_array[0];
                $cmd_index = $file_name_array[1] * 100;
                if(!(is_numeric($cmd_index) && $cmd_index > 0)) {
                    exit('Error Cmd Index:' . $file);
                }
                $filePath = $this->source_dir . $file;
                $str = file_get_contents($filePath);
                $se = array(
                    '/\/\/.*[\\n | $]?/', // 去掉注释及换行
                    '/^[\s]*/', // 去掉空行
                    '/[\s\\t\\r\\n]+/', // 去掉换行及制表符
                );
                $re = array(
                    "",
                    "",
                    " ",
                );
                $str = preg_replace($se,$re,$str);
                $rule = '/struct[\s]+([A-Za-z0-9_]+)\s*([<\->]*)\s*\{(.*)\}/U';
                //$rule = '/struct[\s]+(.*)};/';
                preg_match_all($rule,$str,$match);
                // echo "<br>--<br>";
                // print_r($match);
                $count = count($match[0]);
                $protocol_data = array();
                for($i = 0; $i < $count; $i++){
                    $fields_data = array();
                    $fields_str = explode(';', $match[3][$i]);
                    foreach($fields_str as $v){
                        $v = preg_replace('/[\s]+/',' ', $v);
                        $v = trim($v);
                        if(!$v) continue;
                        $v1 = explode(' ', $v);
                        // if(!$v1[0]) continue;
                        $field_key = trim($v1[1]);
                        $field_val = trim($v1[0]);
                        if(!$field_key || !$field_val){
                            exit('Error field: '.$field_val.' => '.$field_key);
                        }
                        $fields_data[$field_key] = $field_val;
                    }
                    $cmd_index += 1;
                    $mod_code = (int)($cmd_index / 100);
                    $this->module_map[$mod_code] = $file_id;
                    $protocol_data[] = array(
                        'cmd' => $cmd_index,
                        'name' => $match[1][$i],
                        'type' => $match[2][$i],
                        'data' => $fields_data,
                    );
                    // echo "<br>protocol_data:<br>";
                    // print_r($protocol_data);
                }

                if(count($protocol_data) > 0){
                    // $this->gen_erlang_code_h($file_id, $protocol_data);
                    // $this->gen_erlang_code($file_id, $protocol_data);
                    $this->gen_protocol_file($file_id, $protocol_data);
                }else{
                    $this->info .= "<br/><font color='red'>【" . $file_id . "】什么也没有...</font>";
                }
            }
        }else{
            $this->info .= "<br/><font color='red'>请选择文件...</font>";
        }
        // echo "<br>module_map:<br>";
        // print_r($this->module_map);
        // echo "</pre>";
    }

    public function gen_erlang_code_h($file_id, $data){
        $this->clearTemplate();
        $this->assign('file_id', $file_id);
        $this->assign('data', $data);
        $this->addTemplate('pt_record');
        $content = $this->fetch();
        $file_name = WEB_DIR . "/data/protocol/erlang/pack_" . $file_id . '.hrl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【erlang】" . $file_name;
    }

    public function gen_erlang_code($file_id, $data){
        $this->clearTemplate();
        $this->assign('file_id', $file_id);
        $this->assign('data', $data);
        $this->addTemplate('pt_msg');
        $content = $this->fetch();
        $file_name = WEB_DIR . "/data/protocol/erlang/msg_" . $file_id . '.erl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【erlang】" . $file_name;
    }

    public function gen_protocol_file($file_id, $data){
        $this->assign('file_id', $file_id);
        $this->assign('data', $data);
        // pack_xxx.hrl
        $file_name = WEB_DIR . "/data/protocol/erlang/pack_" . $file_id . '.hrl';
        $this->save_file('ERLANG', $file_name, 'pt_record');
        // msg_xxx.erl
        $file_name = WEB_DIR . "/data/protocol/erlang/msg_" . $file_id . '.erl';
        $this->save_file('ERLANG', $file_name, 'pt_msg');
        // msg_xxx.h
        $file_name = WEB_DIR . "/data/protocol/c++/msg_" . $file_id . '.h';
        $this->save_file('C++', $file_name, 'pt_msg_h');
        // msg_xxx.cpp
        $file_name = WEB_DIR . "/data/protocol/c++/msg_" . $file_id . '.cpp';
        $this->save_file('C++', $file_name, 'pt_msg_cpp');
        // pk_xxx.h
        $file_name = WEB_DIR . "/data/protocol/c++/pk_" . $file_id . '.h';
        $this->save_file('C++', $file_name, 'pt_pk_h');
        // pk_xxx.cpp
        $file_name = WEB_DIR . "/data/protocol/c++/pk_" . $file_id . '.cpp';
        $this->save_file('C++', $file_name, 'pt_pk_cpp');
    }

    public function save_file($type, $file_name, $tpl){
        $this->clearTemplate();
        $this->addTemplate($tpl);
        $content = $this->fetch();
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【{$type}】" . $file_name;
    }

}

