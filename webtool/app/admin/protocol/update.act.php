<?php
/**
 * 生成协议
 * @author rolong@vip.qq.com
 */

class Act_Update extends Page{
    private
        $protocol_dir = "",
        $protocol_dir_as = "/data/yingxiong/src/game/net/data/",
        $protocol_dir_erl = "/data/myserver/src/pt/",
        $server_rule_c2s = array(),
        $server_rule_s2c = array(),
        $src_vo = array(),
        $pts_vo = array(),
        $protocol_names = array(),
        $obj_names = array(),
        $info = "";

    public function __construct(){
        parent::__construct();
        $this->protocol_dir = WEB_DIR . "/protocol/";
    }

    public function process(){
        if(isset($this->input['myaction'])){
            if($this->input['myaction'] == "生成协议"){
                $this->update_protocol();
            } else {
                $this->info = 'ERROR';
            }
        }
        $this->clearTemplate();
        $this->addTemplate('update');
        $this->assign('info', $this->info);
        $this->display();
    }

    public function update_protocol(){
        // 导入PHP协议文件
        $protocol_files = glob($this->protocol_dir . "*.php");
        $protocol = array();
        foreach($protocol_files as $protocol_file_name){
            include($protocol_file_name);
        }
        $this->protocol = $protocol;
        if(count($this->protocol) > 0){
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                $rt1 = $erl -> get('u', 'update_client_pt');
                $rt3 = $erl -> get('u', 'update_erlang_pt');
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn update(client)：" . print_r($rt1, TRUE) . "</font>";
                $this->info .= "<br/><font color='green'>svn update(server)：" . print_r($rt3, TRUE) . "</font>";
                $this->info .= "</pre>";
            }
            // gen client
            $this->gen_as();
            $this->gen_add_cmd();
            $this->info .= '<br/>----------------------------';
            // gen server
            $this->gen_erlang_pt();
            //$server_c2s_content = '';
            //$server_s2c_content = '';
            // foreach($this->protocol as $protocol_id => $protocol_val)
            // {
            //     $data = $this->parse_server_protocol($protocol_id, $protocol_val);
            //     if($data['c2s']) $server_c2s_content .= $data['c2s'] . "\n";
            //     if($data['s2c']) $server_s2c_content .= $data['s2c'] . "\n";
            // }
            // file_put_contents($this->server_c2s_file, $server_c2s_content);
            // file_put_contents($this->server_s2c_file, $server_s2c_content);
            // $this->info .= "<br/>【server.c2s】" . $this->server_c2s_file;
            // $this->info .= "<br/>【server.s2c】" . $this->server_s2c_file;
            // $this->info .= "<br/><font color='green'>【done】</font>";
            // $this->info .= "<br/><a href='/protocol/server_c2s.txt' target='_blank'>点击这里查看[服务端]协议文件(server_c2s.txt)</a>";
            // $this->info .= "<br/><a href='/protocol/server_s2c.txt' target='_blank'>点击这里查看[服务端]协议文件(server_s2c.txt)</a>";
            if (extension_loaded('ropeb')) {
                $erl = new Erlang();
                $erl -> connect();
                // svn web
                $rt2 = $erl -> get('u', 'commit_client_pt');
                if(is_array($rt2) && count($rt2) == 0){
                    $rt2 = "No changed!";
                }
                // svn server
                $rt4 = $erl -> get('u', 'commit_erlang_pt');
                if(is_array($rt4) && count($rt4) == 0){
                    $rt4 = "No changed!";
                }
                $this->info .= "<pre>";
                $this->info .= "<br/><font color='green'>svn commit(client)：<br/>" . print_r($rt2, TRUE) . "</font>";
                $this->info .= "<br/><font color='green'>svn commit(server)：<br/>" . print_r($rt4, TRUE) . "</font>";
                $this->info .= "</pre>";
                Admin::log(11, $rt2 .'\n'. $rt4);
            }else{
                $this->info .= "<h5><font color='red'>No peb module!</h5></font>";
            }
        }else{
            $this->info .= "<font color='red'>【生成协议文件失败】</font>";
        }
    }

    public function gen_add_cmd(){
        $cmd_list = array();
        foreach($this->protocol as $id => $val){
            if(array_key_exists('s2c', $val)){
                $cmd_list[] = array(
                    'id' => $id,
                    'name' => $val['name'],
                );
            }
        }
        $data['list'] = $cmd_list;
        $this->assign('data', $data);
        $this->clearTemplate();
        $this->addTemplate('add_cmd');
        $content = $this->fetch();
        file_put_contents($this->protocol_dir_as . "AddCmd.as", $content);
        $this->info .= "<br/>【client】" . $this->protocol_dir_as . "AddCmd.as";
    }

    public function gen_as(){
        $pts_c2s = array();
        $pts_s2c = array();
        foreach($this->protocol as $id => $val){
            $this->check_protocol_name($val['name'], $val);
            if(array_key_exists('c2s', $val)){
                $vars_c2s = array();
                foreach($val['c2s'] as $k => $v){
                    $vars_c2s[] = array(
                        'name' => $k,
                        'type' => $this->var_type($v),
                        'de_fun' => $this->de_fun($v),
                        'se_fun' => $this->se_fun($v),
                        'arg' => $this->get_arg($v, $id, $val),
                    );
                }
                $pts_c2s[] = array(
                    'id' => $id,
                    'name' => $val['name'],
                    'vars' => $vars_c2s,
                );
            }
            if(array_key_exists('s2c', $val)){
                $vars_s2c = array();
                foreach($val['s2c'] as $k => $v){
                    $vars_s2c[] = array(
                        'name' => $k,
                        'type' => $this->var_type($v),
                        'de_fun' => $this->de_fun($v),
                        'se_fun' => $this->se_fun($v),
                        'arg' => $this->get_arg($v, $id, $val),
                    );
                }
                $pts_s2c[] = array(
                    'id' => $id,
                    'name' => $val['name'],
                    'vars' => $vars_s2c,
                );
            }
        }
        foreach($this->src_vo as $kvs){
            $this->gen_vo($kvs);
        }

        //gen c2s
        $this->clearTemplate();
        $this->addTemplate('c2s');
        foreach($pts_c2s as $v){
            $this->assign('data', $v);
            $content = $this->fetch();
            $file_name = $this->protocol_dir_as . "c/C" . ucfirst($v['name']) . '.as';
            file_put_contents($file_name, $content);
            $this->info .= "<br/>【client.c2s】" . $file_name;
        }

        //gen s2c
        $this->clearTemplate();
        $this->addTemplate('s2c');
        foreach($pts_s2c as $v){
            $this->assign('data', $v);
            $content = $this->fetch();
            $file_name = $this->protocol_dir_as . "s/S" . ucfirst($v['name']) . '.as';
            file_put_contents($file_name, $content);
            $this->info .= "<br/>【client.s2c】" . $file_name;
        }

        //gen vo
        $this->clearTemplate();
        $this->addTemplate('vo');
        foreach($this->pts_vo as $v){
            $this->assign('data', $v);
            $content = $this->fetch();
            $file_name = $this->protocol_dir_as . "vo/" . $v['_obj_name'] . '.as';
            file_put_contents($file_name, $content);
            $this->info .= "<br/>【client.vo】" . $file_name;
        }
    }

    function check_protocol_name($name, $vars){
        if(in_array($name, $this->protocol_names)){
            var_dump($vars);
            exit('[ERROR] Repeated protocol_name: '.$name);
        }
        $this->protocol_names[] = $name;
    }

    function check_obj_name($_obj_name, $vars){
        if(in_array($_obj_name, $this->obj_names)){
            var_dump($vars);
            exit('[ERROR] Repeated obj_name: '.$_obj_name);
        }
        $this->obj_names[] = $_obj_name;
    }

    public function gen_vo($kvs){
        $_obj_name = $kvs['_obj_name'];
        $vars = array();
        foreach($kvs as $k => $v){
            if($k != '_obj_name'){
                $vars[] = array(
                    'name' => $k,
                    'type' => $this->var_type_vo($v),
                    'de_fun' => $this->de_fun($v),
                    'se_fun' => $this->se_fun($v),
                    'arg' => $this->get_arg($v, 'VO', $kvs),
                );
            }
        }
        $this->pts_vo[$_obj_name] = array(
            '_obj_name' => $kvs['_obj_name'],
            'vars' => $vars,
        );
    }

    function de_fun($v){
        if(is_array($v)){
            if(count($v) == 1 && in_array('int32', $v)){
                $v = 'readArrayInt';
            }else{
                $v = 'readObjectArray';
            }
        }else if($v == 'int32'){
            $v = 'readInt';
        }else if($v == 'int16'){
            $v = 'readShort';
        }else if($v == 'int8'){
            $v = 'readUnsignedByte';
        }else if($v == 'string'){
            $v = 'readUTF';
        }
        return $v;
    }

    function se_fun($v){
        if(is_array($v)){
            if(count($v) == 1 && in_array('int32', $v)){
                $v = 'writeInts';
            }else{
                $v = 'writeObjects';
            }
        }else if($v == 'int32'){
            $v = 'writeInt';
        }else if($v == 'int16'){
            $v = 'writeShort';
        }else if($v == 'int8'){
            $v = 'writeByte';
        }else if($v == 'string'){
            $v = 'writeUTF';
        }
        return $v;
    }

    function get_arg($v, $id, $data){
        if(is_array($v)){
            if(count($v) == 1 && in_array('int32', $v)){
                return '';
            }else{
                $_obj_name = $v['_obj_name'];
                if(!$_obj_name || !isset($_obj_name) || $_obj_name == '' ){
                    var_dump($data);
                    exit('[ERROR] obj_name (@'.$id.') is empty!');
                }
                return $_obj_name;
            }
        }
        return '';
    }

    function var_type($v){
        if(is_array($v)){
            if(count($v) == 1 && in_array('int32', $v)){
                $v = 'Vector.<int>';
            }else{
                $_obj_name = $v['_obj_name'];
                $this->check_obj_name($_obj_name, $v);
                $this->src_vo[$_obj_name] = $v;
                $v = 'Vector.<IData>';
            }
        }else if($v == 'string'){
            $v = 'String';
        }else if($v == 'int32'){
            $v = 'int';
        }else if($v == 'int16'){
            $v = 'int';
        }else if($v == 'int8'){
            $v = 'int';
        }
        return $v;
    }

    function var_type_vo($v){
        if(is_array($v)){
            if(count($v) == 1 && in_array('int32', $v)){
                $v = 'Vector.<int>';
            }else{
                $this->check_obj_name($v['_obj_name'], $v);
                $this->gen_vo($v);
                $v = 'Vector.<IData>';
            }
        }else if($v == 'string'){
            $v = 'String';
        }else if($v == 'int32'){
            $v = 'int';
        }else if($v == 'int16'){
            $v = 'int';
        }else if($v == 'int8'){
            $v = 'int';
        }
        return $v;
    }

    public function gen_erlang_pt(){
        $pts_c2s = array();
        $pts_s2c = array();
        foreach($this->protocol as $protocol_id => $protocol_val)
        {
            $type = 0;
            $c2s_fields = '';
            $rule = $this->parse_server_protocol($protocol_id, $protocol_val);
            if($rule['c2s']) {
                if($this->check_c2s_type($rule['c2s'])){
                    $type = 1;
                }else{
                    $c2s_fields = $this->parse_c2s_field($protocol_val['c2s'], 0);
                }
                $pts_c2s[] = array(
                    'id' => $protocol_id,
                    'rule' => $rule['c2s'],
                    'type' => $type,
                    'fields' => $c2s_fields,
                );
            }
            if($rule['s2c']) {
                $s2c_fields = $this->parse_s2c_field($protocol_val['s2c'], '', '', '', 0);
                $pts_s2c[] = array(
                    'id' => $protocol_id,
                    'fields' => $s2c_fields,
                );
            }
        }
        $this->assign('data', $pts_c2s);
        $this->clearTemplate();
        $this->addTemplate('erlang_c2s');
        $content = $this->fetch();
        $file_name = $this->protocol_dir_erl . 'pt_unpack.erl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【server.c2s】" . $file_name;
        /////
        $this->assign('data', $pts_s2c);
        $this->clearTemplate();
        $this->addTemplate('erlang_s2c');
        $content = $this->fetch();
        $file_name = $this->protocol_dir_erl . 'pt_pack.erl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【server.c2s】" . $file_name;
        $this->gen_erlang_client_pt();
    }

    private function parse_c2s_field($data, $index){
        $arg = array();
        $code = '';
        $rt = array();
        $i = '';
        if($index) $i = $index;
        foreach($data as $k => $v){
            $k1 = 'V' . $k . $i;
            if($v == 'int32') 
            {
                $arg[] = $k1 . ':32';
                $rt[] = $k1;
            }
            else if($v == 'int16') 
            {
                $arg[] = $k1 . ':16';
                $rt[] = $k1;
            }
            else if($v == 'int8') 
            {
                $arg[] = $k1 . ':8';
                $rt[] = $k1;
            }
            else if($v == 'string') 
            {
                $arg[] = "{$k1}L_:16,{$k1}:{$k1}L_/binary";
                $rt[] = $k1;
            }
            else if($k == '_obj_name') 
            {
            }
            else if(is_array($v))
            {
                $al = $k1.'AL_';
                $rt_name = $k1 . 'R_';
                $arg[] = "$al:16,$k1/binary";
                $code = $this->get_c2s_code($k1, $al, $v, $rt_name, $index+1);
                $rt[] = $rt_name;
            }
        }
        $arg = join(',', $arg);
        $rt = join(',', $rt);
        return array(
            'arg' => $arg, 
            'code' => $code, 
            'rt' => $rt,
        );
    }

    private function get_c2s_code($k, $len, $data, $rt_name, $index){
        $kvs1 = $this->parse_c2s_field($data, $index);
        $arg = $kvs1['arg'];
        $rt = $kvs1['rt'];
        $fun_name = $k . 'F_';
        return "    {$k}F_ = fun({B_, R_}) ->
            << $arg,RB_/binary >> = B_, 
            {RB_, [[{$rt}]|R_]}
    end,
    {_, {$rt_name}} = protocol_fun:for($len, $fun_name, {{$k}, []}),
";
    }

    private function check_c2s_type($rule){
        if(strpos($rule, '],') || strpos($rule, ']]]'))
        {
            return 1;
        }
        return 0;
    }

    public function gen_erlang_client_pt(){
        $pts_s2c = array();
        $pts_c2s = array();
        foreach($this->protocol as $protocol_id => $protocol_val)
        {
            $type = 0;
            $c2s_fields = '';
            $rule = $this->parse_server_protocol($protocol_id, $protocol_val);
            if($rule['c2s']) {
                $c2s_fields = $this->parse_s2c_field($protocol_val['c2s'], '', '', '', 0);
                $pts_c2s[] = array(
                    'id' => $protocol_id,
                    'fields' => $c2s_fields,
                );
            }
            if($rule['s2c']) {
                if($this->check_c2s_type($rule['s2c'])){
                    $type = 1;
                }else{
                    $s2c_fields = $this->parse_c2s_field($protocol_val['s2c'], 0);
                }
                $pts_s2c[] = array(
                    'id' => $protocol_id,
                    'fields' => $s2c_fields,
                    'rule' => $rule['s2c'],
                    'type' => $type,
                );
            }
        }
        $this->assign('data', $pts_c2s);
        $this->clearTemplate();
        $this->addTemplate('erlang_s2c_2');
        $content = $this->fetch();
        $file_name = $this->protocol_dir_erl . 'pt_pack_client.erl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【server.c2s】" . $file_name;
        /////
        $this->assign('data', $pts_s2c);
        $this->clearTemplate();
        $this->addTemplate('erlang_c2s_2');
        $content = $this->fetch();
        $file_name = $this->protocol_dir_erl . 'pt_unpack_client.erl';
        file_put_contents($file_name, $content);
        $this->info .= "<br/>【server.c2s】" . $file_name;
    }

    private function parse_server_protocol($protocol_id, $protocol_val){
        $c2s = '';
        $s2c = '';
        if(array_key_exists('c2s', $protocol_val)){
            if(count($protocol_val['c2s'])){
                $c2s = $this->parse_server_field($protocol_val['c2s']);
                //$c2s = '{' . $protocol_id . ', ' . $c2s . '}.';
            }
        }
        if(array_key_exists('s2c', $protocol_val)){
            if(count($protocol_val['s2c'])){
                $s2c = $this->parse_server_field($protocol_val['s2c']);
                //$s2c = '{' . $protocol_id . ', ' . $s2c . '}.';
            }
        }
        return array('c2s' => $c2s, 's2c' => $s2c);
    }

    private function parse_server_field($data){
        if(count($data) > 0){
            $result = array();
            foreach($data as $k => $v){
                if(is_array($v)){
                    if(count($v) == 1 && in_array('int32', $v)){
                        $result[] = '[int32]';
                    }else{
                        $result[] = $this->parse_server_field($v);
                    }
                }else if($k != '_obj_name'){
                    $result[] = $v;
                }
            }
            return '[' . join(',', $result) . ']';
        }else{
            return '[]';
        }
    }

    public function parse_s2c_field($data, $arg, $code, $rt, $index){
        $args = array();
        $codes = array();
        $rts = array();
        $i = '';
        $space = '';
        if($index) {
            $i = $index;
            //$space = str_repeat('    ', $index);
        }
        foreach($data as $k => $v){
            $k1 = ucfirst($k) . $i;
            if($v == 'int32') 
            {
                $args[] = $k1;
                $rts[] = $k1 . ':32';
            }
            else if($v == 'int16') 
            {
                $args[] = $k1;
                $rts[] = $k1 . ':16';
            }
            else if($v == 'int8') 
            {
                $args[] = $k1;
                $rts[] = $k1 . ':8';
            }
            else if($v == 'string') 
            {
                $args[] = $k1;
                $len_name = $k1 . 'L_';
                $code .= "    $len_name = byte_size($k1),";
                $rts[] = "$len_name:16,$k1:$len_name/binary";
            }
            else if($k == '_obj_name') 
            {
            }
            else if(is_array($v))
            {
                $args[] = $k1;
                $len_name = $k1 .'AL_';
                $rt_name = $k1 . 'R_';
                $simple_array = 0;
                if(count($v) == 1 && (in_array('int32', $v) || 
                    in_array('int16', $v) || in_array('int8', $v))){
                        $vv = each($v);
                        $simple_array = substr($vv['value'], 3);
                }
                if($simple_array > 0){
                    $code .= "    $len_name = length($k1),
    $rt_name = list_to_binary([<<X:$simple_array>>||X <- $k1]),
";
                }else{
                    $rt_sub = $this->parse_s2c_field($v, '', '', '', $index + 1);
                    $arg1 = $rt_sub['arg'];
                    $code1 = $rt_sub['code'];
                    $rt1 = $rt_sub['rt'];
                    $fun_name = $k1 . 'F_';
                    $code .= "    $len_name = length($k1),
    $fun_name = fun
        ([$arg1]) ->
            {$code1}<< $rt1 >>;
        ({{$arg1}}) ->
            {$code1}<< $rt1 >>
    end,
    $rt_name = list_to_binary([$fun_name(X)||X <- $k1]),
";
                }
                $rts[] = "$len_name:16,$rt_name/binary";
            }
        }
        $arg = join(',', $args);
        $rt = join(',', $rts);
        return array(
            'arg' => $arg, 
            'code' => $code, 
            'rt' => $rt,
        );
    }

}
