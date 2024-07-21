<?php

/* -----------------------------------------------------+
 * 后台帐号列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_List extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct(){
        parent::__construct();
        //var_dump($this->input);

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if(
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        ){
            $this->limit = $this->input['limit'];
        }

        if(
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        ){
            $this->page = $this->input['page'];
        }

        $this->assign('limit', $this->limit);
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process()
    {
        $data = array();
        $kw = $this->getKeyword();
        $sqlWhere = $this->getSqlWhere($kw);
        $sqlOrder = " order by tollgate_newid desc";
        $sql = "select `id`, `gold`, `diamond`, `tollgate_newid`, `ctime`, `aid`, `name`, `login_time` from role";
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere));
        //echo $totalRecord;
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);
        foreach($data['list'] as $k => $v){
            $sql1 = "select COUNT(*) from `vip` where `role_id` = ". $v['id'];
            $num = $this->dbh->getOne($sql1);
            //echo $v['id']."-".$num.",";
            if($num == 0){
                $data['list'][$k]['vip'] = 0;
            }else{
                $sql2 = "select `vip` from `vip` where `role_id` = ". $v['id'];
                $vip = $this->dbh->getOne($sql2);
                $binary = new Binary($vip);
                $version = $binary->read_uint8();
                $vip = $binary->read_uint8();
                //echo $vip.",";
                $viptime = $binary->read_uint32_big();
                $data['list'][$k]['vip'] = $vip - 1;
            }

            $sql3 = "select COUNT(*) from `app_store` where `role_id` = ". $v['id'];
            $buyrecord = $this->dbh->getOne($sql3);
            if($buyrecord == 0){
                $data['list'][$k]['rmb'] = 0;
            }else{
                $sql4 = "select SUM(`rmb`) from `app_store` where `role_id` = ". $v['id'];
                $rmb = $this->dbh->getOne($sql4);
                //echo $rmb.",";
                $data['list'][$k]['rmb'] = $rmb;
            }

            $sql5 = "select `kvs` from `role` where `id` = ". $v['id'];
            $kvs = $this->dbh->getOne($sql5);
            $BagMatMax = ord(substr($kvs,8,1)) * pow(2,8) + ord(substr($kvs,9,1));
            $BagPropMax = ord(substr($kvs,10,1)) * pow(2,8) + ord(substr($kvs,11,1));
            $BagEquMax = ord(substr($kvs,12,1)) * pow(2,8) + ord(substr($kvs,13,1));
            $data['list'][$k]['bag'] = ($BagMatMax + $BagPropMax + $BagEquMax - 48)/8;

            $sql6 = "select MAX(`logout_time`) from `log_login` where `role_id` =  ". $v['id'];
            $logout_time = $this->dbh->getOne($sql6);
            $data['list'][$k]['logout_time'] = $logout_time;

            //echo $data['list'][$k]['bag'].",";
            //$vbs = substr($kvs,8,6);
            //for($i; $i < strlen($vbs); $i++){
            //    $vb = substr($vbs,$i,1);
            //    echo ord($vb).",";
            //}
        }

        if(isset($this->input['submit_type'])){
            if($this->input['submit_type'] == "export"){
                //if ($kw['kw_reg_st'] != '' && $kw['kw_reg_et'] != '') {
                if (isset($kw['kw_reg_st']) && isset($kw['kw_reg_et'])) {
                    //$this->expload_excel($data['list']);
                    $this->expload_excel($sql . $sqlWhere . $sqlOrder);
                }else {
                    $this->assign('alert', "没有填注册日期");
                }
            }
        }

        //print_r($data['list']);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->assign('actions', Admin::getGmActions());
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword()
    {
        $kw = array();
        if (($this->input['kw']['name']))
        {
            $kw['kw_name'] = $this->input['kw']['name'];
        }
        if (($this->input['kw']['accname']))
        {
            $kw['kw_accname'] = $this->input['kw']['accname'];
        }
        if (($this->input['kw']['id']))
        {
            $kw['kw_id'] = $this->input['kw']['id'];
        }
        if (($this->input['kw']['reg_st']) && ($this->input['kw']['reg_et']))
        {
            $kw['kw_reg_st'] = strtotime($this->input['kw']['reg_st']);
            $kw['kw_reg_et'] = strtotime($this->input['kw']['reg_et']);
        }
        if (($this->input['kw']['login_st']) && ($this->input['kw']['login_et']))
        {
            $kw['kw_login_st'] = strtotime($this->input['kw']['login_st']);
            $kw['kw_login_et'] = strtotime($this->input['kw']['login_et']);
        }
        $kw['kw_nonelike'] = isset($this->input['kw']['nonelike']) ? true : false;
        return $kw;
    }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($sql)
    {
        $rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);
        $this->addParamCache(array('page'=>$this->page));
        $list = array();
        while ($row = $this->dbh->fetch_array($rs)) {
            $list[] = $row;
        }
        return $list;
    }

    /**
     * 构造SQL where字串
     * @param array $kw 搜索关键字
     */
    private function getSqlWhere($kw)
    {
        if ($kw['kw_id']){
            $sqlWhere = " where id = " . $kw['kw_id'];
        } else {
            $sqlWhere = " where 1";
            if (isset($kw['kw_name']) && strlen($kw['kw_name']))
            {
                $sqlWhere .= " and name like('%{$kw['kw_name']}%')";
            }
            if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
            {
                $sqlWhere .= " and ctime >= {$kw['kw_reg_st']} and ctime <= {$kw['kw_reg_et']}";
            }
            if (isset($kw['kw_login_st']) && strlen($kw['kw_login_et']))
            {
                $sqlWhere .= " and login_time >= {$kw['kw_login_st']} and login_time <= {$kw['kw_login_et']}";
            }
            $sqlWhere .= isset($kw['kw_accname']) && strlen($kw['kw_accname']) ? " and aid like('%{$kw['kw_accname']}%')" : '';
            if($this->input['kw']['lv_st'] && $this->input['kw']['lv_et'])
            {
                $sqlWhere .= " and tollgate_newid >= ".intval($this->input['kw']['lv_st'])." and tollgate_newid <= ".intval($this->input['kw']['lv_et']);
            }
        }

        return $sqlWhere;
    }

    /**
     * 构造SQL where字串
     * @param array $kw 搜索关键字
     */
    // private function getSqlWhere($kw)
    // {
    //     if ($kw['kw_id']){
    //         $sqlWhere = " where id = " . $kw['kw_id'];
    //     } else {
    //         $sqlWhere = " where 1";
    //         if (isset($kw['kw_name']) && strlen($kw['kw_name']))
    //         {
    //             $sqlWhere .= " and name like('%{$kw['kw_name']}%')";
    //         }
    //         if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
    //         {
    //             $sqlWhere .= " and ctime >= {$kw['kw_reg_st']} and ctime <= {$kw['kw_reg_et']}";
    //         }
    //         $sqlWhere .= isset($kw['kw_accname']) && strlen($kw['kw_accname']) ? " and aid like('%{$kw['kw_accname']}%')" : '';
    //         if($this->input['kw']['lv_st'] && $this->input['kw']['lv_et'])
    //         {
    //             $sqlWhere .= " and tollgate_newid >= ".intval($this->input['kw']['lv_st'])." and tollgate_newid <= ".intval($this->input['kw']['lv_et']);
    //         }
    //     }

    //     return $sqlWhere;
    // }

    /**
     * 生成批量处理按钮
     */
    private function op()
    {
        $btns = array(
            'send_email' => array(
                '发送邮件',
                '?mod=role&act=send_email',
                // '确定发送邮件？',
            ),
        );
        return Form::batchSelector($btns);
    }

    function expload_excel($sql){
    //function expload_excel($data){
        set_time_limit(0); // 设置脚本执行最大时间,0为无限制;默认配置为php.ini:max_execution_time = 30;
        ini_set('memory_limit','512M');
        $datafirst = $this->dbh->getAll($sql);
        $data = $this->get_sublist($datafirst);
        $objPHPExcel=new PHPExcel();
        $objPHPExcel->getProperties()->setCreator('http://www.phpernote.com')
            ->setLastModifiedBy('http://www.phpernote.com')
            ->setTitle('Office 2007 XLSX Document')
            ->setSubject('Office 2007 XLSX Document')
            ->setDescription('Document for Office 2007 XLSX, generated using PHP classes.')
            ->setKeywords('office 2007 openxml php')
            ->setCategory('Result file');
        $objPHPExcel->setActiveSheetIndex(0)
            ->setCellValue('A1','角色ID')
            ->setCellValue('B1','帐号名称')
            ->setCellValue('C1','角色名称')
            ->setCellValue('D1','金币')
            ->setCellValue('E1','钻石')
            ->setCellValue('F1','VIP')
            ->setCellValue('G1','RMB')
            ->setCellValue('H1','BAG')
            ->setCellValue('I1','关卡')
            ->setCellValue('J1','注册时间')
            ->setCellValue('K1','最后登陆')
            ->setCellValue('L1','登出时间');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['id'])
                ->setCellValue('B'.$i,$v['aid'])
                ->setCellValue('C'.$i,$v['name'])
                ->setCellValue('D'.$i,$v['gold'])
                ->setCellValue('E'.$i,$v['diamond'])
                ->setCellValue('F'.$i,$v['vip'])
                ->setCellValue('G'.$i,$v['rmb'])
                ->setCellValue('H'.$i,$v['bag'])
                ->setCellValue('I'.$i,$v['tollgate_newid'])
                ->setCellValue('J'.$i,date('Y-m-d H:i:s',$v['ctime']))
                ->setCellValue('K'.$i,date('Y-m-d H:i:s',$v['login_time']))
                ->setCellValue('L'.$i,date('Y-m-d H:i:s',$v['logout_time']));
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('角色数据');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('role_data').'_'.date('Y-m-dHis');

        /*
         *生成xlsx文件
         */
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="'.$filename.'.xlsx"');
        header('Cache-Control: max-age=0');
        $objWriter=PHPExcel_IOFactory::createWriter($objPHPExcel,'Excel2007');

        /*
         *生成xls文件
         header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="'.$filename.'.xls"');
        header('Cache-Control: max-age=0');
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
         */

        $objWriter->save('php://output');
        exit;
    }

    function get_sublist($data){
        $data['list'] = $data;
        foreach($data['list'] as $k => $v){
            $sql1 = "select COUNT(*) from `vip` where `role_id` = ". $v['id'];
            $num = $this->dbh->getOne($sql1);
            //echo $v['id']."-".$num.",";
            if($num == 0){
                $data['list'][$k]['vip'] = 0;
            }else{
                $sql2 = "select `vip` from `vip` where `role_id` = ". $v['id'];
                $vip = $this->dbh->getOne($sql2);
                $binary = new Binary($vip);
                $version = $binary->read_uint8();
                $vip = $binary->read_uint8();
                //echo $vip.",";
                $viptime = $binary->read_uint32_big();
                $data['list'][$k]['vip'] = $vip - 1;
            }

            $sql3 = "select COUNT(*) from `app_store` where `role_id` = ". $v['id'];
            $buyrecord = $this->dbh->getOne($sql3);
            if($buyrecord == 0){
                $data['list'][$k]['rmb'] = 0;
            }else{
                $sql4 = "select SUM(`rmb`) from `app_store` where `role_id` = ". $v['id'];
                $rmb = $this->dbh->getOne($sql4);
                //echo $rmb.",";
                $data['list'][$k]['rmb'] = $rmb;
            }

            $sql5 = "select `kvs` from `role` where `id` = ". $v['id'];
            $kvs = $this->dbh->getOne($sql5);
            $BagMatMax = ord(substr($kvs,8,1)) * pow(2,8) + ord(substr($kvs,9,1));
            $BagPropMax = ord(substr($kvs,10,1)) * pow(2,8) + ord(substr($kvs,11,1));
            $BagEquMax = ord(substr($kvs,12,1)) * pow(2,8) + ord(substr($kvs,13,1));
            $data['list'][$k]['bag'] = ($BagMatMax + $BagPropMax + $BagEquMax - 48)/8;

            $sql6 = "select MAX(`logout_time`) from `log_login` where `role_id` =  ". $v['id'];
            $logout_time = $this->dbh->getOne($sql6);
            $data['list'][$k]['logout_time'] = $logout_time;
        }
        return $data['list'];
    }
}
