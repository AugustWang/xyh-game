<?php
/**
 *
 * 导入Excel数据
 */

set_time_limit(0);
ini_set('memory_limit','512M');

class Act_Excel extends Page{
    private
        $source_dir = "",
        $import_count = 0,
        $src_kvs = array(),
        $excel_data = array(),
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

    public function string_index($str){
        $index = array_search($str, $this->string_array);
        if(!$index){
            $index = ++$this->string_count;
            $this->string_array[$index] = $str;
        }
        return $index;
    }

    public function get_str(){
        $pack_bom = new Pack();
        $pack_bom->uint8(239);
        $pack_bom->uint8(187);
        $pack_bom->uint8(191);
        $bom = $pack_bom->get_binary();
        return $bom . implode('^', $this->string_array) . '^';
    }

    public function get_bin(){
        $pack = new Pack();
        $pack->int32($this->string_index($this->file_id));
        $title_row = $this->excel_data[0][0];
        $field_count = count($title_row);
        $pack->int32($field_count);
        $pack->int32($this->record_count);
        foreach($title_row as $title){
            $pack->int32($this->string_index($title));
        }
        $is_first = 1;
        $count = 0;
        foreach($this->excel_data[0] as $row){
            if($is_first){
                $is_first = 0;
            }else if($row[0] != ''){
                foreach($row as $val){
                    if(!$val) $val = 0; 
                    if(is_numeric($val)){
                        $pack->int32($val);
                    }else{
                        $pack->int32($this->string_index($val));
                    }
                }
                $count++;
            }
        }
        return $pack->get_binary();
    }


    public function process(){
        $this->source_dir = WEB_DIR . "/data/excel/";
        if($this->input['files']){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt = $erl -> get('u', 'update_xyh_bin');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn add：" . print_r($rt, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            $this->import_files();
            if($this->info == '') {
                $this->info = '没有需要更新的文件！';
            }
            if (extension_loaded('ropeb')) {
                $rt = $erl -> get('u', 'commit_xyh_bin');
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

    protected function import_files(){
        if(count($this->input['files']) > 0){
            foreach($this->input['files'] as $file){
                $filePath = $this->source_dir . $file;
                // clear start
                $this->excel_data = array();
                $this->target_php_file = "";
                $this->is_changed_php = false;
                $this->is_changed_bin = false;
                $this->is_changed_str = false;
                $this->string_array = array();
                $this->string_count = 0;
                ## Byte-order mark Description 
                ## EF BB BF UTF-8 
                ## FF FE UTF-16 aka UCS-2, little endian 
                ## FE FF UTF-16 aka UCS-2, big endian 
                ## 00 00 FF FE UTF-32 aka UCS-4, little endian. 
                ## 00 00 FE FF UTF-32 aka UCS-4, big-endian.
                $this->record_count = 0;
                $file_id = str_replace(".xlsx", "", $file);
                $file_id = str_replace(".xls", "", $file_id);
                $this->file_id = $file_id;
                // read start
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
                // read end
                $this->set_dst_path();
                $this->is_changed($filePath);
                if($this->is_changed_php || $this->is_changed_str || $this->is_changed_bin){
                    $this->sheet_to_kvs();
                    $this->import($file);
                }else{
                    $this->info .= "<br/><font color='green'>【" . $this->file_id . "】青春依旧，什么也没有改变！</font>";
                }
            }
        }else{
            $this->info .= "<br/><font color='red'>请选择文件...</font>";
        }
    }

    protected function sheet_to_kvs(){
        $this->src_kvs = array();
        $client_row = $this->excel_data[0][0];
        $is_first = 1;
        $count = 0;
        foreach($this->excel_data[0] as $row){
            if($is_first){
                $is_first = 0;
            }else if($row[0] != ''){
                foreach($row as $key => $val){
                    $name = $client_row[$key];
                    if($name){
                        if(is_numeric($val)){
                            $val = round($val, 4);
                        }
                        $this->src_kvs[$count][$name] = $val;
                    }
                }
                $count++;
            }
        }
        $this->record_count = $count;
    }

    protected function import($file){
        if(!$this->record_count){
            $this->info .= "<br /><font color='red'>【" . $this->file_id . "】空空如也，一行数据都没有！</font>";
            return;
        }
        if($this->is_changed_php){
            $php_data = "";
            $count = 0;
            foreach($this->src_kvs as $row){
                $key = array();
                $val = array();
                foreach($row as $k => $v){
                    $v = trim($v);
                    if(in_array($k, $this->keys)){
                        $key[] = $v;
                    }else if($v !== ''){
                        if(is_numeric($v)){
                            $val[] = "'$k' => $v";
                        }else{
                            $v = addslashes($v);
                            $val[] = "'$k' => '$v'";
                        }
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
                $php_data .= "'" . $key_string . "' => array(" . trim($val_string) . "),\n";
                $keys[] = $key_string;
                $count++;
            }
            $php_data = $php_data == '' ? '' : "<?php\nreturn array(\n" . $php_data . ");";
            file_put_contents($this->target_php_file, $php_data);
            $this->info .= "<br/><font color='green'>成功导入<b><font color='red'>{$count}</font></b>条【" . $this->file_id . "】PHP数据：".$this->target_php_file."</font>";
        }
        if(($this->is_changed_bin || $this->is_changed_str) && $this->record_count > 0){
            if($this->file_id != 'task'){
                file_put_contents($this->target_bin_file, $this->get_bin());
                file_put_contents($this->target_str_file, $this->get_str());
                $this->info .= "<br/><font color='green'>成功导入<b><font color='red'>{$this->record_count}</font></b>条【" . $this->file_id . "】BIN数据：".$this->target_bin_file."</font>";
                $this->info .= "<br/><font color='green'>成功导入<b><font color='red'>{$this->string_count}</font></b>个【" . $this->file_id . "】字符串：".$this->target_str_file."</font>";
            }
        }
        $this->import_count++;
    }

    protected function is_changed($excel_file){
        $this->is_changed_php = file_exists($this->target_php_file) ? filemtime($excel_file) > filemtime($this->target_php_file) : true;
        $this->is_changed_bin = file_exists($this->target_bin_file) ? filemtime($excel_file) > filemtime($this->target_bin_file) : true;
        $this->is_changed_str = file_exists($this->target_str_file) ? filemtime($excel_file) > filemtime($this->target_str_file) : true;
    }

    protected function set_dst_path(){
        $this->target_php_file = WEB_DIR . "/data/php/" . $this->file_id . ".php";
        $this->target_bin_file = WEB_DIR . "/data/bin/" . $this->file_id . ".bin";
        $this->target_str_file = WEB_DIR . "/data/bin/" . $this->file_id . ".str";
    }
}

## Dim strList(10000) As String
## Dim count As Long
## Function StrIndex(fsT As Object, str As String) As Long
##     For i = 1 To count
##         If strList(i - 1) = str Then
##             StrIndex = i
##             Exit Function
##         End If
##     Next
##     fsT.WriteText str
##     fsT.WriteText "^"
##     count = count + 1
##     StrIndex = count
##     strList(count - 1) = str
## End Function
## 
## Sub export_map()
##     KeyString = "npc"
##     FileStr = ThisWorkbook.Path & "\..\data\" & KeyString & ".str"
##     FileData = ThisWorkbook.Path & "\..\data\" & KeyString & ".bin"
##     Dim FileServerData As String
##     FileServerData = ThisWorkbook.Path & "\..\..\server\data\" & KeyString & ".bin"
##     Set MyFile = CreateObject("Scripting.FileSystemObject")
##     If MyFile.FileExists(FileData) = True Then
##       Kill (FileData)
##     End If
##     Open FileData For Binary As #2
##     pos = 1
##     count = 0
##     ' 打开文件
##     Dim fsT As Object
##     Set fsT = CreateObject("ADODB.Stream")
##     fsT.Type = 2 'Specify stream type - we want To save text/string data.
##     fsT.Charset = "utf-8" 'Specify charset For the source text data.
##     fsT.Open 'Open the stream And write binary data To the object
##     For m = 1 To ThisWorkbook.Sheets.count
##         Set curSheet = ThisWorkbook.Sheets(m)
##         Z = StrIndex(fsT, curSheet.Name)
##     Next
##     For m = 1 To ThisWorkbook.Sheets.count
##         Set curSheet = ThisWorkbook.Sheets(m)
##         Dim l As Integer
##         Dim content As String
##         Dim XCount As Integer
##         For i = 1 To 100
##             l = Len(curSheet.Cells(1, i))
##             If l < 1 Then
##                 Exit For
##             End If
##             XCount = i
##         Next
##         Put #2, pos, StrIndex(fsT, curSheet.Name)
##         pos = pos + 4
##         Put #2, pos, XCount
##         pos = pos + 4
##         recordCountPos = pos
##         pos = pos + 4
##         Dim YCount As Integer
##         YCount = 0
##         For i = 1 To 100
##             l = Len(curSheet.Cells(1, i))
##             If l < 1 Then
##                 Exit For
##             End If
##             Put #2, pos, StrIndex(fsT, curSheet.Cells(1, i))
##             pos = pos + 4
##         Next
##         For i = 2 To 1000
##             l = Len(curSheet.Cells(i, 1))
##             If l < 1 Then
##                 Exit For
##             End If
##             YCount = YCount + 1
##             For j = 1 To XCount
##                 Data = curSheet.Cells(i, j)
##                 If TypeName(Data) = "String" Then
##                     Dim DataStr As String
##                     DataStr = Data
##                     Put #2, pos, StrIndex(fsT, DataStr)
##                 Else
##                     Dim DataInt As Long
##                     DataInt = Data
##                     Put #2, pos, DataInt
##                 End If
##                 pos = pos + 4
##             Next
##         Next
##         Put #2, recordCountPos, YCount
##     Next
##     'Save binary data To disk
##     fsT.SaveToFile FileStr, 2
##     Close #2
## End Sub

