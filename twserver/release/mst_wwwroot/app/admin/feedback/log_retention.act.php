<?php

/* -----------------------------------------------------+
 * 留存数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_retention extends Page
{

    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();
        if ($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = (int)date('Ymd');

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

        $sqlWhere = " where 1 ";
        if (($this->input['kw']['reg_st']) && ($this->input['kw']['reg_et']))
        {
            $kw['kw_reg_st'] = date('Ymd',strtotime($this->input['kw']['reg_st']));
            $kw['kw_reg_et'] = date('Ymd',strtotime($this->input['kw']['reg_et']));
            $sqlWhere .= " and reg_date >= ".$kw['kw_reg_st']." and reg_date <= ".$kw['kw_reg_et'];
        }
        $sqlOrder = " order by reg_date desc ";
        $sql1 = "select distinct reg_date from log_retention ";
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM|i", "SELECT COUNT(DISTINCT `reg_date`) as total FROM", $sql1 . $sqlWhere));
        $data['list'] = $this->dbh->getAll($sql1 . $sqlWhere . $sqlOrder . " limit ". $this->page * $this->limit.", ". $this->limit);
        foreach($data['list'] as $k => $v){
            $sql2 = "select reg_num, nth_day, rate from log_retention where reg_date = ". $v['reg_date'] ." order by reg_date desc";
            $reg_date = $this->dbh->getAll($sql2);
            //print_r($reg_date);
            foreach($reg_date as $v2){
                $data['list'][$k]['reg_num'] = $v2['reg_num'];
                $data['list'][$k][$v2['nth_day']] = $v2['rate'] . "%";
            }
        }


        if(isset($this->input['expload'])){
            if($this->input['expload'] == "导出数据"){
                $this->expload_excel($data['list']);
            } else {
                $this->assign('alert', "ERROR");
            }
        }

        //print_r($data);
        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));

        // $date_data = $this->dbh->getAll("SELECT DISTINCT reg_date FROM `log_retention` WHERE 1 order by `reg_date` desc limit 100");
        // foreach ($date_data as $v){
        //     $dates[$v['reg_date']] = $v['reg_date'];
        // }
        // $this->assign('dates', Form::select("day", $dates, $this->input['day']));

        $this->display();
    }

    function expload_excel($data){
        $data['list'] = $data;
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
            ->setCellValue('C1','2日留存')
            ->setCellValue('D1','3日留存')
            ->setCellValue('E1','4日留存')
            ->setCellValue('F1','5日留存')
            ->setCellValue('G1','6日留存')
            ->setCellValue('H1','7日留存')
            ->setCellValue('I1','8日留存')
            ->setCellValue('J1','9日留存')
            ->setCellValue('K1','10日留存')
            ->setCellValue('L1','15日留存')
            ->setCellValue('M1','30日留存');
        $i=2;
        foreach($data['list'] as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['reg_date'])
                ->setCellValue('B'.$i,$v['reg_num'])
                ->setCellValue('C'.$i,$v[2])
                ->setCellValue('D'.$i,$v[3])
                ->setCellValue('E'.$i,$v[4])
                ->setCellValue('F'.$i,$v[5])
                ->setCellValue('G'.$i,$v[6])
                ->setCellValue('H'.$i,$v[7])
                ->setCellValue('I'.$i,$v[8])
                ->setCellValue('J'.$i,$v[9])
                ->setCellValue('K'.$i,$v[10])
                ->setCellValue('L'.$i,$v[15])
                ->setCellValue('M'.$i,$v[30]);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('留存统计');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('log_retention').'_'.date('Y-m-dHis');

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
