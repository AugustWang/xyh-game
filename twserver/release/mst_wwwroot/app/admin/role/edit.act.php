<?php
/********************************************************
 *
 * 编辑角色相关属性
 *
 * @package admin
 * @module role
 * @author Tim <mianyangone@gmail.com> 
 * @date 2009-12-11 下午04:11:53
 * @todo 编辑功能
 *
 *******************************************************/
class Act_Edit extends Page {
    private $roleId = null;

    public function  __construct() {
        parent::__construct();
        if (!isset($this->input['id'])) Admin::redirect($this->goBack());
        $this->roleId = $this->input['id'];
    }

    // private function editRole()
    // {
    //     $db = Db::getInstance();
    //     if($this->input['do'] == 'rename' && $this->input['id'] > 0 && $this->input['val']){
    //         if(!Admin::hasP(10012))
    //             return Admin::alert("您没有此权限！");
    //         $id = (int)$this->input['id'];
    //         $name = htmlspecialchars(trim($this->input['val']));
    //         if($db->getOne("select id from role where name='{$name}'"))
    //             return Admin::alert("该角色名已经存在！");
    //         $db->query("update role set name='{$name}' where id = {$id}");
    //         return Admin::redirect($_SERVER['HTTP_REFERER']);
    //     }elseif($this->input['do'] == 'coin' && $this->input['id'] > 0 && $this->input['val']
    //         && $this->input['t'] > 0 && $this->input['t'] <= 4){
    //             if(!Admin::hasP(1001))
    //                 return Admin::alert("您没有此权限！");
    //             $id = (int)$this->input['id'];
    //             $coin = (int)$this->input['val'];
    //             $type = (int)$this->input['t'];
    //             $erl = new Erlang();
    //             $rt = $erl ->getAll('lib_admin', 'edit_coin', '[~u, ~u, ~u]', array($id, $type, $coin));
    //             $opt = array(
    //                 'val' => $coin,
    //                 'role_id' => $id,
    //             );
    //             switch ($type)
    //             {
    //             case 1:
    //                 $opt['type'] = 1;
    //                 $opt['field']  = '绑定铜';
    //                 break;
    //             case 2:
    //                 $opt['type'] = 2;
    //                 $opt['field']  = '绑定铜';
    //                 break;
    //             case 3:
    //                 $opt['type'] = 1;
    //                 $opt['field']  = '铜钱';
    //                 break;
    //             case 4:
    //                 $opt['type'] = 2;
    //                 $opt['field']  = '铜钱';
    //                 break;
    //             }
    //             AdminLog::editRole($opt);
    //             $isonline = false;
    //             if(!$erl -> getError())
    //             {
    //                 foreach($rt as $val)
    //                 {
    //                     if($val[0] > 0 || $val[1] > 0)
    //                     {
    //                         $isonline = true;
    //                         Admin::alert("玩家在线，数据库不会实时更新和本页面不会打印实时结果，实时返回结果：非绑定铜钱{$val[0]}   绑定铜{$val[1]} ", 'href');
    //                         exit;
    //                     }
    //                 }
    //             }else{
    //                 Admin::alert($erl -> getError());
    //             }
    //             if(!$isonline)
    //             {
    //                 $coins = $db->getRow("select coin,binding_coin from role where id = {$id}");
    //                 if(!$coins)Admin::alert("找不到该玩家！");
    //                 $set = '';
    //                 switch($type)
    //                 {
    //                 case 1 :
    //                     $set = "binding_coin = binding_coin + {$coin}";
    //                     break;
    //                 case 2:
    //                     $set = "binding_coin = binding_coin - {$coin}";
    //                     if($coins['binding_coin'] - $coin < 0 )
    //                         return Admin::alert("铜钱减为负数了，请修正！");
    //                     break;
    //                 case 3:
    //                     $set = "coin = coin + {$coin}";
    //                     break;
    //                 case 4:
    //                     $set = "coin = coin - {$coin}";
    //                     if($coins['coin'] - $coin < 0 )
    //                         return Admin::alert("铜钱减为负数了，请修正！");
    //                     break;
    //                 }
    //                 if($set)
    //                     $db -> query("update role set $set where id={$id}");
    //                 return Admin::redirect($_SERVER['HTTP_REFERER']);
    //             }
    //         }elseif($this->input['do'] == 'gold' && $this->input['id'] > 0 && $this->input['val']
    //             && $this->input['t'] > 0 && $this->input['t'] <= 2){
    //                 if(!Admin::hasP(1001))
    //                     return Admin::alert("您没有此权限！");
    //                 $id = (int)$this->input['id'];
    //                 $gold = (int)$this->input['val'];
    //                 $type = (int)$this->input['t'];
    //                 $erl = new Erlang();
    //                 $rt = $erl ->getAll('lib_admin', 'edit_gold', '[~u, ~u, ~u]', array($id, $type, $gold));

    //                 $opt = array(
    //                     'val' => $gold,
    //                     'role_id'=>$id,
    //                     'type'=>$type,
    //                     'field'=>'金币',
    //                 );
    //                 AdminLog::editRole($opt);
    //                 $isonline = false;
    //                 if(!$erl -> getError())
    //                 {
    //                     foreach($rt as $val)
    //                     {
    //                         if($val > 0)
    //                         {
    //                             $isonline = true;
    //                             Admin::alert("玩家在线，数据库不会实时更新和本页面不会打印实时结果，实时返回结果：金币{$val} ", 'href');
    //                             exit;
    //                         }
    //                     }
    //                 }else{
    //                     Admin::alert($erl -> getError());
    //                 }
    //                 if(!$isonline)
    //                 {
    //                     $set = '';
    //                     $golds = $db->getRow("select gold from role where id = {$id}");
    //                     if(!$golds)Admin::alert("找不到该玩家！");
    //                     switch($type)
    //                     {
    //                     case 1 :
    //                         $set = "gold = gold + {$gold}";
    //                         break;
    //                     case 2:
    //                         $set = "gold = gold - {$gold}";
    //                         if($golds['gold'] - $gold < 0 )
    //                             return Admin::alert("金币减为负数了，请修正！");
    //                         break;
    //                     }
    //                     if($set)
    //                         $db -> query("update role set $set where id={$id}");
    //                     return Admin::redirect($_SERVER['HTTP_REFERER']);
    //                 }
    //             }
    // }

    public function process(){
        $this->assign('title', '角色详细属性(上次离线时的数据，非实时)');
        //$this->editRole();
        $data = $this->getData();
        if (!$data) Admin::redirect($this->goBack());//角色不存在
        $this->assign('data',$data);
        $this->display();
    }

    private function getData(){
        $sql = "select * from role where id = {$this->roleId}";
        $db=Db::getInstance();
        $data = $db->getRow($sql);
        $match = array();
        preg_match_all('/{([a-z]+),([0-9]+)}/', $data['kvs'], $match);
        foreach($match[1] as $k => $v){
            $data[$v] = $match[2][$k];
        }
        // {Win, Lost, Draw, Escape}
        preg_match_all('/{game_count,{([0-9]+),([0-9]+),([0-9]+),([0-9]+)}}/', $data['kvs'], $match);
        $data['win'] = $match[1][0];
        $data['lost'] = $match[2][0];
        $data['draw'] = $match[3][0];
        $data['reg_time'] =  date('Y-m-d H:i:s',$data['reg_time']);
        $data['login_times'] =  $db->getOne("select count(*) from log_login where role_id = {$this->roleId}");
        return $data;
    }

    /**
     * 页面跳转地址
     */
    private function goBack(){
        return Admin::url('list','','',true);
    }
}
?>
