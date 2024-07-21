<?php
/**
 *
 * 导入Excel数据，生成JS数据
 */
set_time_limit(0);
ini_set('memory_limit','512M');

class Act_Make_js extends Page{
    private
        $excel_dir = "",
        $version = "simple", // yinni
        $excel_name = "",
        $excel_data = array(),
        $js_dst_path = "",
        $is_changed_js = false,
        $link_url = "",
        $info = "";


    public function __construct(){
        parent::__construct();
    }

    protected function getKeys(){
        switch($this->excel_name){
            case 'd道具表': return array('type', 'name');
            case 'y英雄表': return array('type', 'name');
            default: return array('type', 'name');
        }
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
                $rt1 = $erl -> get('u', 'update_js');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn update(js)：" . print_r($rt1, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            $this->version = "simple";
            $this->import_files();
            if (extension_loaded('ropeb')) {
                $rt = $erl -> get('u', 'commit_js');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn commit(client)：<br/>" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
            }else{
                $this->info .= "<h5><font color='red'>No ropeb module!</h5></font>";
            }
        }
        $this->get_files();
        $this->assign('info', $this->info);
        $this->display();
    }

    protected function import_files(){
        if(count($this->input['files']) > 0){
            foreach($this->input['files'] as $file){
                $file = $this->excel_dir . $file;
                // clear start
                $this->excel_data = array();
                $this->excel_name = "";
                $this->js_dst_path = "";
                $this->is_changed_js = false;
                $this->excel_name = str_replace(".xlsx", "", $file);
                $this->excel_name = str_replace(".xls", "", $this->excel_name);
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
                if($this->js_dst_path != "" && $this->is_changed_js)
                {
                    $this->import();
                } else {
                    $this->info .= "<br/><font color='red'>数据没有变化...</font>";
                }
            }
        }else{
            $this->info .= "<br/><font color='red'>请选择文件...</font>";
        }
    }

    protected function import(){
        $count_c = 0;
        $excel_data = $this->excel_data[0];
        $client_row = $this->excel_data[0][1];
        // --- 
        $i = 0;
        $data_js = '';
        $keys = $this->getKeys();
        foreach($excel_data as $row){
            if($i >= 3 && $row[0] != ''){
                $id = '';
                $name = '';
                foreach($row as $key => $val){
                    if($client_row[$key] == $keys[0]) $id = $val; 
                    else if($client_row[$key] == $keys[1]) $name = $val;
                }
                if($data_js != '') $data_js .= ",";
                $data_js .= "\n\"$id $name\"";
                $count_c++;
            }
            $i++;
        }
        $name_s = $this->excel_data[1][1][1];
        $data_js = "var data_{$name_s} = [" .$data_js. "\n];";
        if(!$count_c){
            $this->info .= "<h5><font color='red'>【" . $this->excel_name . "】数据为空！</h5></font>";
            return;
        }
        file_put_contents($this->js_dst_path, $data_js);
        $this->info .= "<br/><font color='green'>自动补全数据：成功导入<b><font color='red'>{$count_c}</font></b>条【" . $this->excel_name . "】数据！</font>";
        $this->info .= "URL： <a href='$this->link_url' target='_blank'>$this->link_url</a>";
    }

    protected function is_changed($excel_file){
        $this->is_changed_js = file_exists($this->js_dst_path) ? filemtime($excel_file) > filemtime($this->js_dst_path) : true;
    }

    protected function get_dst_path(){
        $this->js_dst_path = "";
        $this->link_url = "";
        $name_c = $this->excel_data[1][0][1];
        $name_s = $this->excel_data[1][1][1];
        if($name_s && $name_c){
            $file = "/" . "admin/js/data_" . $name_s . ".js";
            $this->js_dst_path = WEB_DIR . $file;
            $this->link_url = $file;
        }
    }
}
