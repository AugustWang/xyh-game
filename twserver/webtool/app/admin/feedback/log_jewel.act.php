<?php

/* -----------------------------------------------------+
 * 宝珠日志统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_jewel extends Page
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
        $this->addParamCache(array('limit'=>$this->limit));
    }

    public function process()
    {
        $db = Db::getInstance();
        $data = array();
        $sqlOrder = " order by `ctime` desc";
        $sqlGroup = " GROUP BY `role_id` ";
        $sql = "SELECT role_id, sum(case when num=-3 then 1 else 0 end) sum3, sum(case when num=-15 then 1 else 0 end) sum15, sum(case when num=-30 then 1 else 0 end) sum30, sum(case when num=-50 then 1 else 0 end) sum50, sum(case when num=-80 then 1 else 0 end) sum80, abs(sum(num)) as num FROM log_diamond WHERE type = 8 ";
        if($this->input['kw']['time_st'] && $this->input['kw']['time_et']){
            $sql .= " and ctime > ". strtotime($this->input['kw']['time_st'])." and ctime < ". strtotime($this->input['kw']['time_et']);
        }
        $totalRecord = $db->getOne(preg_replace("|^SELECT.*?FROM|i", "SELECT COUNT(DISTINCT role_id) as total FROM", $sql));
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

        $sql = $sql . $sqlGroup . $sqlOrder . " limit ".$this->page * $this->limit.", ".$this->limit;
        $data1 = $db->getAll($sql);
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
            $data_pay = $this->dbh->getOne($sql2);
            $data1[$k]['pay'] = $data_pay ? $data_pay : 0;
            $sql3 = "SELECT COUNT(*) as count18 , abs(sum(num)) as sum18 FROM log_diamond WHERE type = 18 and role_id = ". $v['role_id'];
            $data_refresh = $this->dbh->getAll($sql3);
            // print_r($data_refresh);
            foreach($data_refresh as $vv){
                $data1[$k]['count18'] = $vv['count18'] ? $vv['count18'] : 0;
                $data1[$k]['sum18'] = $vv['sum18'] ? $vv['sum18'] : 0;
            }
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
            ->setCellValue('B1','3钻石')
            ->setCellValue('C1','15钻石')
            ->setCellValue('D1','30钻石')
            ->setCellValue('E1','50钻石')
            ->setCellValue('F1','80钻石')
            ->setCellValue('G1','抽宝珠消耗钻石')
            ->setCellValue('H1','刷新酒馆次数')
            ->setCellValue('I1','刷新消耗钻石')
            ->setCellValue('J1','是否付费');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['role_id'])
                ->setCellValue('B'.$i,$v['sum3'])
                ->setCellValue('C'.$i,$v['sum15'])
                ->setCellValue('D'.$i,$v['sum30'])
                ->setCellValue('E'.$i,$v['sum50'])
                ->setCellValue('F'.$i,$v['sum80'])
                ->setCellValue('G'.$i,$v['num'])
                ->setCellValue('H'.$i,$v['count18'])
                ->setCellValue('I'.$i,$v['sum18'])
                ->setCellValue('J'.$i,$v['pay']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('宝珠数据');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('jewel_data').'_'.date('Y-m-dHis');

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
