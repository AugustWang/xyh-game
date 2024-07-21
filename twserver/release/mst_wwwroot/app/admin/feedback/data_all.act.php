<?php

/* -----------------------------------------------------+
 * 统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_data_all extends Page
{

    public $month = '';
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if ($this->input['month'] > 0)
            $this->month = $this->input['month'];
        else
            $this->month = date('Ym');

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
    }

    public function process()
    {
        $db = Db::getInstance();
        $data = array();
        $sqlOrder1 = " order by FROM_UNIXTIME(`ctime`,'%Y%m') desc";
        $sqlGroup1 = " GROUP BY FROM_UNIXTIME(`ctime`,'%Y%m') ";
        $sqlGroup2 = " GROUP BY FROM_UNIXTIME(`login_time`,'%Y%m') ";
        //$sqlGroup3 = " GROUP BY FROM_UNIXTIME(`purchase_date`/1000, '%Y%m') ";
        //$sqlGroup4 = " GROUP BY FROM_UNIXTIME(`purchase_date`/1000, '%Y%m') ";
        $sqlGroup3 = " GROUP BY FROM_UNIXTIME(`ctime`, '%Y%m') ";
        $sqlGroup4 = " GROUP BY FROM_UNIXTIME(`ctime`, '%Y%m') ";
        $sql1 = "SELECT COUNT(*) as regnum, FROM_UNIXTIME(`ctime`,'%Y%m') as time FROM `role` WHERE 1 ";
        $sql2 = "SELECT COUNT(*) as loginnum, FROM_UNIXTIME(`login_time`,'%Y%m') as time FROM `role`  WHERE 1 ";
        //$sql3 = "SELECT COUNT(DISTINCT `role_id`) as paynum, FROM_UNIXTIME(`purchase_date`/1000, '%Y%m') as time FROM `app_store` WHERE 1 ";
        //$sql4 = "SELECT SUM(`rmb`) as rmbnum, FROM_UNIXTIME(`purchase_date`/1000, '%Y%m') as time FROM `app_store` WHERE 1 ";
        $sql3 = "SELECT COUNT(DISTINCT `role_id`) as paynum, FROM_UNIXTIME(`ctime`, '%Y%m') as time FROM `app_store` WHERE 1 ";
        $sql4 = "SELECT SUM(`rmb`) as rmbnum, FROM_UNIXTIME(`ctime`, '%Y%m') as time FROM `app_store` WHERE 1 ";
        $sql5 = "SELECT COUNT(*) as namenum, FROM_UNIXTIME(`ctime`,'%Y%m') as time FROM `role` WHERE 1 AND `name` <> '' ";
        if($this->input['month']) {
            $sql1 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m') = ". $this->input['month'];
            $sql2 .= " AND FROM_UNIXTIME(`login_time`,'%Y%m') = ". $this->input['month'];
            //$sql3 .= " AND FROM_UNIXTIME(`purchase_date`/1000,'%Y%m') = ". $this->input['month'];
            //$sql4 .= " AND FROM_UNIXTIME(`purchase_date`/1000,'%Y%m') = ". $this->input['month'];
            $sql3 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m') = ". $this->input['month'];
            $sql4 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m') = ". $this->input['month'];
            $sql5 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m') = ". $this->input['month'];
        }
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m')) as total FROM", $sql1));
        $data1 = $db->getAll($sql1 . $sqlGroup1 . $sqlOrder1);
        $data2 = $db->getAll($sql2 . $sqlGroup2);
        $data3 = $db->getAll($sql3 . $sqlGroup3);
        $data4 = $db->getAll($sql4 . $sqlGroup4);
        $data5 = $db->getAll($sql5 . $sqlGroup1);
        //$data = $data1 + $data2 + $data3 + $data4 + $data5;
        foreach($data1 as $k => $v){
            //echo $k . "=>". $v['regnum']. ",";
            foreach($data2 as $v2){
                if($v['time'] == $v2['time']){
                    $data1[$k]['loginnum'] = $v2['loginnum'];
                    break;
                }else{
                    $data1[$k]['loginnum'] = 0;
                }
            }
            foreach($data3 as $v3){
                if($v['time'] == $v3['time']){
                    $data1[$k]['paynum'] = $v3['paynum'];
                    break;
                }else{
                    $data1[$k]['paynum'] = 0;
                }
            }
            foreach($data4 as $v4){
                if($v['time'] == $v4['time']){
                    $data1[$k]['rmbnum'] = $v4['rmbnum'];
                    break;
                }else{
                    $data1[$k]['rmbnum'] = 0;
                }
            }
            foreach($data5 as $v5){
                if($v['time'] == $v5['time']){
                    $data1[$k]['namenum'] = $v5['namenum'];
                    break;
                }else{
                    $data1[$k]['namenum'] = 0;
                }
            }
        }

        if(isset($this->input['expload'])){
            if($this->input['expload'] == "导出数据"){
                $this->expload_excel($data1);
            } else {
                $this->assign('alert', "ERROR");
            }
        }
        //print_r($data);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data1);
        $this->assign('formAction', Admin::url('', '', '', true));
        // 生成日期选择下拉列表
        //$date_data = $db->getAll("select distinct mon_date from log_economy order by day_stamp desc limit 100");
        //$sql1 = "SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m') as mon_date FROM `role` WHERE 1 order by `ctime` desc limit 100";
        $date_data = $db->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m') as mon_date FROM `role` WHERE 1 order by `ctime` desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['mon_date']] = $v['mon_date'];
        }
        $this->assign('dates', Form::select("month", $dates, $this->input['month']));
        $this->display();
    }

    function expload_excel($data){
        $objPHPExcel=new PHPExcel();
        $objPHPExcel->getProperties()->setCreator('http://www.phpernote.com')
            ->setLastModifiedBy('http://www.phpernote.com')
            ->setTitle('Office 2007 XLSX Document')
            ->setSubject('Office 2007 XLSX Document')
            ->setDescription('Document for Office 2007 XLSX, generated using PHP classes.')
            ->setKeywords('office 2007 openxml php')
            ->setCategory('Result file');
        $objPHPExcel->setActiveSheetIndex(0)
            ->setCellValue('A1','日期')
            ->setCellValue('B1','注册人数')
            ->setCellValue('C1','登录人数')
            ->setCellValue('D1','付费人数')
            ->setCellValue('E1','累计收入')
            ->setCellValue('F1','创建角色人数');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['time'])
                ->setCellValue('B'.$i,$v['regnum'])
                ->setCellValue('C'.$i,$v['loginnum'])
                ->setCellValue('D'.$i,$v['paynum'])
                ->setCellValue('E'.$i,$v['rmbnum'])
                ->setCellValue('F'.$i,$v['namenum']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('统计数据');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('data_all').'_'.date('Y-m-dHis');

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
