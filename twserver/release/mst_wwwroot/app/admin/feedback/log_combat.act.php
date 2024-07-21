<?php

/* -----------------------------------------------------+
 * 战斗日志统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_combat extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();

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
        $data = array();
        $sqlOrder = " order by `ctime` desc";
        $sqlGroup = " GROUP BY `role_id` ";
        $sql = "SELECT `role_id`, sum(`num`) as num, max(`ctime`) as ctime FROM `log_combat` WHERE 1 ";
        $sqlWhere = "";
        if($this->input['kw']['time_st'] && $this->input['kw']['time_et']){
            $sqlWhere = " and `role_id` in (SELECT `id` FROM `role` WHERE 1 ";
            $sqlWhere .= " and ctime > ". strtotime($this->input['kw']['time_st'])." and ctime < ". strtotime($this->input['kw']['time_et']) . ")";
        }
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM|i", "SELECT COUNT(DISTINCT role_id) as total FROM", $sql . $sqlWhere));
        //echo $totalRecord;

        if(isset($this->input['submit_type'])){
            if($this->input['submit_type'] == "export"){
                if ($this->input['kw']['time_st'] && $this->input['kw']['time_et']) {
                    $this->expload_excel($sql.$sqlGroup);
                }else {
                    $this->assign('alert', "没有填注册日期");
                }
            }
        }

        $sql = $sql . $sqlWhere . $sqlGroup . $sqlOrder . " limit ".$this->page * $this->limit.", ".$this->limit;
        // echo $sql;
        $data1 = $this->dbh->getAll($sql);
        $data1 = $this->get_sublist($data1);

        //echo $sql;
        // $data1 = $db->getAll($sql . $sqlGroup . $sqlOrder );
        // $data1 = $db->selectLimit($sql. $sqlGroup. $sqlOrder, $this->page * $this->limit, $this->limit);
        //echo $sql . $sqlGroup . $sqlOrder;
        //print_r($data1);
        $data1['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data1);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

    function get_sublist($data1){
        foreach($data1 as $k => $v){
            $sql2 = "SELECT 1 FROM app_store WHERE role_id = ". $v['role_id']. " LIMIT 1";
            $sql3 = "SELECT count(*) FROM app_store WHERE role_id = ". $v['role_id'];
            $sql4 = "SELECT num as num0 FROM log_combat WHERE role_id = ". $v['role_id'] . " and tollgate_id = 0 ";
            $data_pay = $this->dbh->getOne($sql2);
            $data_pays = $this->dbh->getOne($sql3);
            $data_num0 = $this->dbh->getOne($sql4);
            $data1[$k]['pay'] = $data_pay ? $data_pay : 0;
            $data1[$k]['pays'] = $data_pays ? $data_pays : 0;
            $data1[$k]['num0'] = $data_num0 ? $data_num0 : 0;
        }
        return $data1;
    }

    function expload_excel($sql){
        $data1 = $this->dbh->getAll($sql);
        $data = $this->get_sublist($data1);
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
            ->setCellValue('B1','付费用户')
            ->setCellValue('C1','付费次数')
            ->setCellValue('D1','挑战次数');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['role_id'])
                ->setCellValue('B'.$i,$v['pay'])
                ->setCellValue('C'.$i,$v['pays'])
                ->setCellValue('D'.$i,$v['num']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('战斗统计');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('log_combat').'_'.date('Y-m-dHis');

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
