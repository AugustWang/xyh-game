<?php

/* -----------------------------------------------------+
 * 运营活动操作数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_mail_list extends Page
{

    private
        $log_type,
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        include(WEB_DIR . "/protocol/log_type.php");
        $this->log_type = $log_type;

        $this->input = trimArr($this->input);
        $this->dbh = Db::getInstance();

        $this->clearParamCache();

        if (
            isset($this->input['limit'])
            && is_numeric($this->input['limit'])
            && $this->input['limit'] <= 1000
        )
        {
            $this->limit = $this->input['limit'];
        }

        if (
            isset($this->input['page'])
            && is_numeric($this->input['page'])
        )
        {
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
        $sqlOrder = " order by `ctime` desc";
        $sql = "select `role_id`, `type_id`, `enclosure`, `ctime` from `email`";
        if($this->input['type']) {
            $sql .= " where `type_id` = ". $this->input['type'];
        }

        $data222=array(
            0=>array(
                'id'=>1001,
                'username'=>'张飞',
                'password'=>'123456',
                'address'=>'三国时高老庄250巷101室'
            ),
            1=>array(
                'id'=>1002,
                'username'=>'关羽',
                'password'=>'123456',
                'address'=>'三国时花果山'
            ),
            2=>array(
                'id'=>1003,
                'username'=>'曹操',
                'password'=>'123456',
                'address'=>'延安西路2055弄3号'
            ),
            3=>array(
                'id'=>1004,
                'username'=>'刘备',
                'password'=>'654321',
                'address'=>'愚园路188号3309室'
            )
        );
        // if(isset($this->input['expload'])){
        //     if($this->input['expload'] == "导出数据"){
        //         $this->expload_excel2($data222);
        //     } else {
        //         $this->assign('alert', "ERROR");
        //     }
        // }

        // if(isset($this->input['expload'])){
        //     if($this->input['expload'] == "导出数据"){
        //         $this->expload_excel($sql);
        //     } else {
        //         $this->assign('alert', "ERROR");
        //     }
        // }

        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere));
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);

        if(isset($this->input['expload'])){
            if($this->input['expload'] == "导出数据"){
                $this->expload_excel3($data['list']);
            } else {
                $this->assign('alert', "ERROR");
            }
        }

        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->assign('type', Form::select('type', $this->log_type, $this->input['type']));
        $this->display();
    }

    /**
     * 取得搜索关键字
     * @return array
     */
    private function getKeyword()
    {
        $kw = array();
        if (($this->input['kw']['type_id']))
        {
            $kw['kw_type_id'] = $this->input['kw']['type_id'];
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
        $this->addParamCache(array('limit'=>$this->limit));

        $list = array();
        $predefine = Defines::init();
        $now = time();
        $menu = Admin::getAdminMenu();
        $gm = $menu[32]['sub'];
        while ($row = $this->dbh->fetch_array($rs)) {
            if($gm){
                $action = '';
                foreach($gm as $v){
                    $action .= " | <a href=\"{$v['url']}&from_mod=online&id={$row['id']}\">{$v['title']}</a>";
                }
                $row['action'] = $action . ' |';
            }else{
                $row['action'] = '';
            }

            if($row['enclosure'] == ""){
                $row['havetime'] = 7 * 86400 - (time() - $row['ctime']);
            }else{
                $row['havetime'] = 15 * 86400 - (time() - $row['ctime']);
            }
            $type = $row['type_id'];
            $row['type'] = $this->log_type[$type];

            $length = strlen($row['enclosure']);
            if(strlen($row['enclosure']) > 0){
                $binary = new Binary($row['enclosure']);
                $reststring = ($length - 1) / 12;
                $version = $binary->read_uint8();
                for($i=1; $i <= $reststring; $i++){
                    $en[$i][0] = $binary->read_uint32_big();
                    $en[$i][1] = $binary->read_uint32_big();
                    $en[$i][2] = $binary->read_uint32_big();
                }
                foreach($en as $v){
                    if($v[0] == 5){
                        $row['en'] .= "{". $v[0]. ",{". $v[1]. ",". $v[2]. "}}";
                    }else{
                        $row['en'] .= "{". $v[0]. ",". $v[1]. "}";
                    }
                }
            }else{
                $row['en'] = "{}";
            }

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
            $sqlWhere = " where `role_id` = " . $kw['kw_id'];
            if (isset($kw['kw_type_id']) && strlen($kw['kw_type_id']))
            {
                $sqlWhere .= " and `type_id` = ". $kw['kw_type_id'];
            }
            if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
            {
                $sqlWhere .= " and `ctime` >= {$kw['kw_reg_st']} and `ctime` <= {$kw['kw_reg_et']}";
            }
        } elseif($this->input['type'] == 0){
            $sqlWhere = " where 1";
        } else{
            $sqlWhere = " ";
        }

        // echo $sqlWhere;
        return $sqlWhere;
    }

    /**
     * 生成批量处理按钮
     */
    private function op()
    {
        $btns = array(
            'send_email' => array(
                '发送邮件',
                '?mod=feedback&act=timeing',
                // '确定发送邮件？',
            ),
        );
        return Form::batchSelector($btns);
    }

    function expload_excel($sql){
        $savename = date("YmjHis");
        $file_type = "vnd.ms-excel";
        $file_ending = "xls";
        header("Content-Type: application/$file_type;charset=big5");
        header("Content-Disposition: attachment; filename=".$savename.".$file_ending");
        $result = mysql_query($sql) or die(mysql_error());

        $sep = "\t";
        for ($i = 0; $i < mysql_num_fields($result); $i++) {
            echo mysql_field_name($result,$i) . "\t";
        }
        print("\n");
        $i = 0;
        while($row = mysql_fetch_row($result)) {
            $schema_insert = "";
            for($j=0; $j<mysql_num_fields($result); $j++) {
                if(!isset($row[$j]))
                    $schema_insert .= "NULL".$sep;
                elseif ($row[$j] != "")
                    $schema_insert .= "$row[$j]".$sep;
                else
                    $schema_insert .= "".$sep;
            }
            $schema_insert = str_replace($sep."$", "", $schema_insert);
            $schema_insert .= "\t";
            print(trim($schema_insert));
            print "\n";
            $i++;
        }
        return (true);
    }

    function expload_excel2($data){
        $objPHPExcel=new PHPExcel();
        $objPHPExcel->getProperties()->setCreator('http://www.phpernote.com')
            ->setLastModifiedBy('http://www.phpernote.com')
            ->setTitle('Office 2007 XLSX Document')
            ->setSubject('Office 2007 XLSX Document')
            ->setDescription('Document for Office 2007 XLSX, generated using PHP classes.')
            ->setKeywords('office 2007 openxml php')
            ->setCategory('Result file');
        $objPHPExcel->setActiveSheetIndex(0)
            ->setCellValue('A1','ID')
            ->setCellValue('B1','用户名')
            ->setCellValue('C1','密码')
            ->setCellValue('D1','地址');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['id'])
                ->setCellValue('B'.$i,$v['username'])
                ->setCellValue('C'.$i,$v['password'])
                ->setCellValue('D'.$i,$v['address']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('三年级2班');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('学生信息统计表').'_'.date('Y-m-dHis');

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

    function expload_excel3($data){
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
            ->setCellValue('B1','类型ID')
            ->setCellValue('C1','类型')
            ->setCellValue('D1','附件')
            ->setCellValue('E1','发送时间');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['role_id'])
                ->setCellValue('B'.$i,$v['type_id'])
                ->setCellValue('C'.$i,$v['type'])
                ->setCellValue('D'.$i,$v['en'])
                ->setCellValue('E'.$i,date('Y-m-d H:i:s', $v['ctime']));
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('邮件列表');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('mst_email').'_'.date('Y-m-dHis');

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

}
