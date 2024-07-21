<?php
/**
 *
 * 导入Excel数据
 */
set_time_limit(0);
ini_set('memory_limit','512M');

class Act_From_Excel extends Page{
    private
        $excel_dir = "",
        $import_count_s = 0,
        $import_count_c = 0,
        $version = "simple", // yinni
        $server_data = array(),
        // $client_data = array(),
        $excel_name = "",
        $excel_data = array(),
        $server_dst_path = "",
        $client_dst_path = "",
        $dst_file_id = "",
        $is_changed_s = false,
        $is_changed_c = false,
        $link_url = "",
        $keys = array('id', 'id1', 'id2', 'id3', 'id4', 'id5'),
        $info = "";


    public function __construct(){
        parent::__construct();
    }

    public function get_files(){
        $dir = $this->excel_dir;
        if (is_dir($dir)) {
            if ($dh = opendir($dir)) {
                $i = 0;
                while (($file = readdir($dh)) !== false) {
                    $encode = mb_detect_encoding($file, array('UTF-8', 'GB2312','GBK', 'CP936', 'EUC-CN'), true); 
                    // var_dump($encode);
                    $file = iconv($encode, 'UTF-8', $file);
                    $ext_pos = strpos($file, '.xls');
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
            //array_multisort($name,SORT_DESC,SORT_STRING, $files);//按名字排序
            //array_multisort($size,SORT_DESC,SORT_NUMERIC, $files);//按大小排序
            $this->assign('files', $files);
        }
    }

    public function process(){
        $this->excel_dir = WEB_DIR . "/" . $this->version . "_xls/";
        if($this->input['files']){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt1 = $erl -> get('u', 'update_client_data');
                $rt3 = $erl -> get('u', 'update_erlang_data');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn update(client)：" . print_r($rt1, TRUE) . "</font>";
                $this->info .= "<br/><font color='green'>svn update(server)：" . print_r($rt3, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            $this->version = "simple";
            $this->import_files();
            if (extension_loaded('ropeb')) {
                $rt = $erl -> get('u', 'make_and_update_data');
                if($rt == "[]"){
                    $this->info .= "<h5><font color='red'>No changed!</h5></font>";
                }else{
                    $this->info .= "<br/><font color='green'>更新成功：" . $rt . "</font>";
                }
                // svn web
                $rt2 = $erl -> get('u', 'commit_client_data');
                if(is_array($rt2) && count($rt2) == 0){
                    $rt2 = "No changed!";
                }
                // svn server
                $rt4 = $erl -> get('u', 'commit_erlang_data');
                if(is_array($rt4) && count($rt4) == 0){
                    $rt4 = "No changed!";
                }
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn commit(client)：<br/>" . print_r($rt2, TRUE) . "</font>";
                $this->info .= "<br/><font color='green'>svn commit(server)：<br/>" . print_r($rt4, TRUE) . "</font>";
                $this->info .= "</pre>";
                $log = '[server:' . $this->import_count_s . ' | client:' . $this->import_count_c . ']';
                Admin::log(10, $log .'\n'. $rt .'\n'. $rt2 .'\n'. $rt4);
            }else{
                $this->info .= "<h5><font color='red'>No ropeb module!</h5></font>";
            }
        }
        $this->get_files();
        $this->assign('info', $this->info);
        $this->display();
    }

    public function upload_file(){
        $excel_name = $_FILES["upfile"]["name"];
        if($excel_name){
            $encode = mb_detect_encoding($excel_name, array('ASCII','GB2312','GBK','UTF-8')); 
            $excel_name = iconv($encode, 'GB2312', $excel_name);
            move_uploaded_file($_FILES["upfile"]["tmp_name"], $this->excel_dir . $excel_name);
            $this->info .= "<font color='green'>成功上传【" . $_FILES["upfile"]["name"] . "】</font>";
            $this->bat_import();
        }
    }

    protected function import_files(){
        if(count($this->input['files']) > 0){
            foreach($this->input['files'] as $file){
                $file = $this->excel_dir . $file;
                // clear start
                $this->excel_data = array();
                $this->excel_name = "";
                $this->server_dst_path = "";
                $this->client_dst_path = "";
                $this->dst_file_id = "";
                $this->is_changed_s = false;
                $this->is_changed_c = false;
                // clear end
                // 获取UTF-8文件名
                // $excel_name = str_replace(".xls", "", $file);
                // $encode = mb_detect_encoding($excel_name, array('ASCII','GB2312','GBK','UTF-8')); 
                // $this->excel_name = iconv($encode, 'UTF-8', $excel_name);
                $this->excel_name = str_replace(".xls", "", $file);
                // read start
                // $data = new Spreadsheet_Excel_Reader();
                // $data->setOutputEncoding('UTF-8');
                // $data->read($excel_dir . $file);
                // $this->excel_data = $data->sheets;
                // include 'PHPExcel/IOFactory.php';
                // $objReader = PHPExcel_IOFactory::createReader('Excel5');
                // $objReader->setReadDataOnly(true);
                // $objPHPExcel = $objReader->load($excel_dir . $file);
                // $sheetData = $objPHPExcel->getAllSheets();
                $filePath = $excel_dir . $file;
                $PHPReader = new PHPExcel_Reader_Excel2007(); 
                if(!$PHPReader->canRead($filePath)){ 
                    $PHPReader = new PHPExcel_Reader_Excel5(); 
                    if(!$PHPReader->canRead($filePath)){ 
                        echo 'no Excel'; 
                        return ; 
                    } 
                } 
                $PHPExcel = $PHPReader->load($filePath);
                $this->excel_data[0] = $PHPExcel->getSheet(0)->toArray('', true, true, false); 
                $this->excel_data[1] = $PHPExcel->getSheet(1)->toArray('', true, true, false); 
                // read end
                $this->get_dst_path();
                $this->is_changed($excel_dir . $file);
                if(($this->server_dst_path != "" || $this->client_dst_path != "") && 
                    ($this->is_changed_s || $this->is_changed_c))
                {
                    $this->sheet_to_kvs();
                    $this->import();
                } else {
                    if($this->server_dst_path == "" && $this->client_dst_path == "" )
                    {
                        $this->info .= "<br/><font color='red'>【" . $this->excel_name . "】未定义目标文件名！请填写Sheet2：[B1=客户端名字]　[B2=服务端名字]</font>";
                    }
                }
            }
        }else{
            $this->info .= "<br/><font color='red'>请选择文件...</font>";
        }
    }


    protected function bat_import(){
        $excel_dir = WEB_DIR . "/" . $this->version . "_xls/";
        if ($handle = opendir($excel_dir)) {
            while (false !== ($file = readdir($handle))) {
                $ext_pos = strpos($file, '.xls');
                if ($ext_pos !== false && $ext_pos > 0) {
                    // clear start
                    $this->excel_data = array();
                    $this->excel_name = "";
                    $this->server_dst_path = "";
                    $this->client_dst_path = "";
                    $this->dst_file_id = "";
                    $this->is_changed_s = false;
                    $this->is_changed_c = false;
                    // clear end
                    // 获取UTF-8文件名
                    // $excel_name = str_replace(".xls", "", $file);
                    // $encode = mb_detect_encoding($excel_name, array('ASCII','GB2312','GBK','UTF-8')); 
                    // $this->excel_name = iconv($encode, 'UTF-8', $excel_name);
                    $this->excel_name = str_replace(".xls", "", $file);
                    // read start
                    // $data = new Spreadsheet_Excel_Reader();
                    // $data->setOutputEncoding('UTF-8');
                    // $data->read($excel_dir . $file);
                    // $this->excel_data = $data->sheets;
                    // include 'PHPExcel/IOFactory.php';
                    // $objReader = PHPExcel_IOFactory::createReader('Excel5');
                    // $objReader->setReadDataOnly(true);
                    // $objPHPExcel = $objReader->load($excel_dir . $file);
                    // $sheetData = $objPHPExcel->getAllSheets();
                    $filePath = $excel_dir . $file;
                    $PHPReader = new PHPExcel_Reader_Excel2007(); 
                    if(!$PHPReader->canRead($filePath)){ 
                        $PHPReader = new PHPExcel_Reader_Excel5(); 
                        if(!$PHPReader->canRead($filePath)){ 
                            echo 'no Excel'; 
                            return ; 
                        } 
                    } 
                    $PHPExcel = $PHPReader->load($filePath);
                    $this->excel_data[0] = $PHPExcel->getSheet(0)->toArray('', true, true, false); 
                    $this->excel_data[1] = $PHPExcel->getSheet(1)->toArray('', true, true, false); 
                    // read end
                    $this->get_dst_path();
                    $this->is_changed($excel_dir . $file);
                    if(($this->server_dst_path != "" || $this->client_dst_path != "") && 
                        ($this->is_changed_s || $this->is_changed_c))
                    {
                        $this->sheet_to_kvs();
                        $this->import();
                    } else {
                        if($this->server_dst_path == "" && $this->client_dst_path == "" )
                        {
                            $this->info .= "<br/><font color='red'>【" . $this->excel_name . "】未定义目标文件名！请填写Sheet2：[B1=客户端名字]　[B2=服务端名字]</font>";
                        }
                    }
                }
            }
            closedir($handle);			
            //$this->info .= "<font color='green'><BR/>OK!</font>";
        }else{
            $this->info .= "目录（" . $excel_dir . "）不可读！";
            return;
        }
    }

    protected function sheet_to_kvs(){
        $this->server_data = array();
        // 转成key-val数据
        $excel_data = $this->excel_data[0];
        $server_row = $excel_data[2];
        $i = 0;
        $j = 0;
        foreach($excel_data as $row){
            if($i >= 3 && $row[0] != ''){
                foreach($row as $key => $val){
                    $name = $server_row[$key];
                    if($name){
                        if(is_numeric($val)){
                            $val = round($val, 4);
                        }
                        $this->server_data[$j][$name] = $val;
                    }
                }
                $j++;
            }
            $i++;
        }
    }

    protected function import(){
        $data_s = "";
        $data_c = "";
        $count_s = 0;
        $count_c = 0;
        $keys = array();
        $type = $this->excel_data[1][2][1];
        if ($type == 'merge')
        {
            $data_array = array();
            foreach($this->server_data as $row){
                $key = array();
                $val_row = array();
                foreach($row as $k => $v){
                    $v = trim($v);
                    if(in_array($k, $this->keys)){
                        $key[] = $v;
                    }else if($v !== ''){
                        $val_row[] = $v;
                    }
                }
                $val_row_string = implode(",", $val_row);
                $key_string = "";
                $key_len = count($key);
                if($key_len > 1){
                    $key_string = "{" . implode(",", $key) . "}";
                }else if($key_len == 1){
                    $key_string = $key[0];
                }
                $data_array[$key_string][] = "{".$val_row_string."}";
            }
            foreach($data_array as $key => $val_array){
                $val_string = implode(",", $val_array);
                $data_s .= "get(" . $key .") -> [" . trim($val_string) . "];\n";
                $keys[] = $key;
                $count_s++;
            }
        }else if($type == 'list' || $type == 'tuple'){
            foreach($this->server_data as $row){
                $key = array();
                $val = array();
                foreach($row as $k => $v){
                    $v = trim($v);
                    if(in_array($k, $this->keys)){
                        $key[] = $v;
                    }else if($v !== ''){
                        $val[] = $v;
                    }
                }
                $key_string = "";
                $val_string = "";
                $key_len = count($key);
                if($key_len > 1){
                    $key_string = "{" . implode(",", $key) . "}";
                }else if($key_len == 1){
                    $key_string = $key[0];
                }
                $val_string = implode(",", $val);
                if($type == 'list'){
                    $data_s .= "get(" . $key_string .") -> [" . trim($val_string) . "];\n";
                }else{
                    $data_s .= "get(" . $key_string .") -> {" . trim($val_string) . "};\n";
                }
                $keys[] = $key_string;
                $count_s++;
            }
        }else if($type == 'range'){
            $last_id = 1;
            foreach($this->server_data as $row){
                $key = array();
                $val = array();
                foreach($row as $k => $v){
                    $v = trim($v);
                    if(in_array($k, $this->keys)){
                        // $last_id = max($last_id, $v);
                        $last_id = $v;
                        $key[] = $v;
                    }else if($v !== ''){
                        $val[] = $v;
                    }
                }
                $key_string = "";
                $val_string = "";
                $key_len = count($key);
                if($key_len > 1){
                    $key_string = "{" . implode(",", $key) . "}";
                }else if($key_len == 1){
                    $key_string = $key[0];
                }
                $val_string = implode(",", $val);
                $data_s .= "get(" . $key_string .") -> {" . trim($val_string) . "};\n";
                $keys[] = $key_string;
                $count_s++;
            }
            $data_s .= "get(range) -> {1, " . $last_id . "};\n";
        }else if($type == 'kvs'){
            // 生成键值对数据：get(Key) -> Val;
            foreach($this->server_data as $row){
                $key_string = $this->get_key_string($row);
                $val_string = $this->get_val_string($row);
                $data_s .= "get(" . $key_string .") -> " . $val_string . ";\n";
                $count_s++;
            }
        }else if($type == 'fun'){
            $keys = array();
            foreach($this->server_data as $row){
                if($row['arg']) $argc = count(explode(',', $row['arg']));
                else $argc = 0;
                $keys[] = $row['name'] . '/' . $argc;
                $data_s .= $row['name'] . "(" . $row['arg'] .") -> " . trim($row['fun']) . ".\n";
                $count_s++;
            }
        }else{
            foreach($this->server_data as $row){
                $key = array();
                $val = array();
                foreach($row as $k => $v){
                    $v = trim($v);
                    if(in_array($k, $this->keys)){
                        $key[] = $v;
                    }else if($v !== ''){
                        $val[] = " {".$k.", ".$v."}";
                    }
                }
                $key_string = "";
                $val_string = "";
                $key_len = count($key);
                if($key_len > 1){
                    $key_string = "{" . implode(",", $key) . "}";
                }else if($key_len == 1){
                    $key_string = $key[0];
                }
                $val_string = implode(",", $val);
                $data_s .= "get(" . $key_string .") -> [" . trim($val_string) . "];\n";
                $keys[] = $key_string;
                $count_s++;
            }
        }
        #############
        if($type == 'fun'){
            $server_header = "-module(data_" . $this->dst_file_id . ").\n";
            $export = "-export([\n     " . implode(",\n     ", $keys) . "\n]).\n\n";
            $data_s = $server_header . $export . $data_s;
        }else{
            $server_header = "-module(data_" . $this->dst_file_id . ").\n-export([get/1]).\n";
            $keys_string = 'get(ids) -> [' . implode(",", $keys) . "];\n";
            $server_bottom .= "get(_) -> undefined.";
            $data_s = $server_header . $keys_string . $data_s . $server_bottom;
        }
        // 生成客户端文件
        $excel_data = $this->excel_data[0];
        $client_row = $this->excel_data[0][1];
        // 写入首行
        foreach($client_row as $val){
            if($val){
                $data_c .= $val . "	";
            }
        }
        if($data_c){
            $data_c =  trim($data_c) . "\n";
            // --- 
            $i = 0;
            foreach($excel_data as $row){
                if($i >= 3 && $row[0] != ''){
                    foreach($row as $key => $val){
                        if($client_row[$key]){
                            if(is_numeric($val)){
                                $val = round($val, 4);
                            }
                            $data_c .= $val . "	";
                        }
                    }
                    $data_c =  trim($data_c) . "\n";
                    $count_c++;
                }
                $i++;
            }
        }
        if(!$count_s && !$count_c){
            $this->info .= "<h5><font color='red'>【" . $this->excel_name . "】数据为空！</h5></font>";
            return;
        }
        if($this->is_changed_s && $count_s && $this->server_dst_path){
            $this->info .= "<br/> $this->server_dst_path";
            file_put_contents($this->server_dst_path, $data_s);
            $this->info .= "<br/><font color='green'>服务端：成功导入<b><font color='red'>{$count_s}</font></b>条【" . $this->excel_name . "】数据！</font>";
            $this->import_count_s++;
        }
        if($this->is_changed_c && $count_c && $this->client_dst_path){
            file_put_contents($this->client_dst_path, $data_c);
            $this->info .= "<br/><font color='green'>客户端：成功导入<b><font color='red'>{$count_c}</font></b>条【" . $this->excel_name . "】数据！</font>";
            $this->info .= "URL： <a href='$this->link_url' target='_blank'>$this->link_url</a>";
            $this->import_count_c++;
        }
    }

    protected function is_changed($excel_file){
        $this->is_changed_s = file_exists($this->server_dst_path) ? filemtime($excel_file) > filemtime($this->server_dst_path) : true;
        $this->is_changed_c = file_exists($this->client_dst_path) ? filemtime($excel_file) > filemtime($this->client_dst_path) : true;
    }

    protected function get_dst_path(){
        $this->server_dst_path = "";
        $this->client_dst_path = "";
        $this->dst_file_id = "";
        $this->link_url = "";
        $name_c = $this->excel_data[1][0][1];
        $name_s = $this->excel_data[1][1][1];
        $this->dst_file_id = $name_s;
        if($name_s){
            // $dst_path = '';
            $dst_path = "/home/myserver/src/data/";
            // if($_SERVER['SERVER_ADDR'] == '127.0.0.1'){
            //     $dst_path = "/Users/rolong/work/myserver/src/data/";
            // }else{
            //     $dst_path = "/data/myserver/src/data/";
            // }
            $this->server_dst_path = $dst_path . "data_" . $name_s . ".erl";
        }
        // if($name_s){
        //     $this->server_dst_path = WEB_DIR . "/" . $this->version . "_xls/data_" . $name_s . ".erl";
        // }
        if($name_c){
            $this->client_dst_path = WEB_DIR . "/" . $this->version . "_xls/" . $name_c . ".txt";
            $this->link_url = "/" . $this->version . "_xls/" . $name_c . ".txt";
        }
    }

    protected function get_key_string($row){
        $key = array();
        foreach($row as $k => $v){
            $v = trim($v);
            if(in_array($k, $this->keys)){
                $key[] = $v;
            }
        }
        $len = count($key);
        if($len > 1){
            return "{" . implode(",", $key) . "}";
        }else{
            return $key[0];
        }
    }

    protected function get_val_string($row){
        $val = array();
        foreach($row as $k => $v){
            $v = trim($v);
            if(!in_array($k, $this->keys)){
                $val[] = $v;
            }
        }
        $len = count($val);
        if($len > 1){
            return "{" . implode(",", $val) . "}";
        }else{
            return $val[0];
        }
    }
}
