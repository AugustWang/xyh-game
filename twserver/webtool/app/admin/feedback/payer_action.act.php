<?php

/* -----------------------------------------------------+
 * 用户付费行为统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_payer_action extends Page
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
        $data = array();
        $sqlOrder = " order by FROM_UNIXTIME(`ctime`,'%Y%m%d') desc";
        $sqlGroup = " GROUP BY FROM_UNIXTIME(`ctime`,'%Y%m%d') ";
        $sqlWhere = "";
        $sql = "SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d') as `ctime` FROM `role` WHERE 1 ";

        // if($this->input['kw']['time_st'] && $this->input['kw']['time_et']){
        //     $sqlWhere = " and `role_id` in (SELECT `id` FROM `role` WHERE 1 ";
        //     $sqlWhere .= " and ctime > ". strtotime($this->input['kw']['time_st'])." and ctime < ". strtotime($this->input['kw']['time_et']) . ")";
        // }
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d')) as total FROM", $sql . $sqlWhere));
        //echo $totalRecord;

        $sql = $sql . $sqlWhere . $sqlOrder . " limit ".$this->page * $this->limit.", ".$this->limit;
        $data['time'] = $this->dbh->getAll($sql);
        $data = $this->get_sublist($data);

        if(isset($this->input['submit_type'])){
            if($this->input['submit_type'] == "export"){
                if ($this->input['kw']['time_st'] && $this->input['kw']['time_et']) {
                    $this->expload_excel($data);
                }else {
                    $this->assign('alert', "没有填注册日期");
                }
            }
        }

        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

    function get_sublist($data){
        for($i=1;$i<=7;$i++){
            $data['day'][$i]['d'] = $i;
        }
        $data['day'][14]['d'] = 14;
        $data['day'][30]['d'] = 30;
        // echo strtotime(20140820);
        // print_r($data['time']);
        foreach($data['time'] as $k => $v){
            $sql1 = "SELECT id FROM role WHERE FROM_UNIXTIME(`ctime`,'%Y%m%d') = " . $v['ctime'];
            $data_ids = $this->dbh->getAll($sql1);
            $data['list'][$k]['ctime'] = $v['ctime'];
            $data['list'][$k]['num'] = count($data_ids);
            foreach($data['day'] as $vd){
                $num = 0;
                $sql3 = "SELECT role_id FROM app_store ";
                $sql3_where = "";
                if($vd['d'] == 30){
                    $sql3_where = " WHERE ctime >= ". (strtotime($v['ctime']) + 86400 * $vd['d']);
                } elseif ($vd['d'] == 14){
                    $sql3_where = " WHERE ctime >= ". (strtotime($v['ctime']) + 86400 * $vd['d']) . " and ctime <= ". (strtotime($v['ctime']) + 86400 * 30);
                } else {
                    $sql3_where = " WHERE ctime >= ". (strtotime($v['ctime']) + 86400 * ($vd['d']-1)) . " and ctime <= ". (strtotime($v['ctime']) + 86400 * $vd['d']);
                }
                $payer_ids = $this->dbh->getAll($sql3.$sql3_where);
                foreach($payer_ids as $vp){
                    foreach($data_ids as $vi){
                        if($vp['role_id'] == $vi['id']){
                            $num += 1;
                        }
                    }
                }
                $data['list'][$k][$vd['d']] = $num;
            }
        }
        return $data;
    }

    function expload_excel($data){
        //$data = $this->dbh->getAll($sql);
        //$data = $this->get_sublist($data);
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
            ->setCellValue('B1','注册用户数')
            ->setCellValue('C1','第1天')
            ->setCellValue('D1','第2天')
            ->setCellValue('E1','第3天')
            ->setCellValue('F1','第4天')
            ->setCellValue('G1','第5天')
            ->setCellValue('H1','第6天')
            ->setCellValue('I1','第7天')
            ->setCellValue('J1','第14天')
            ->setCellValue('K1','第30天');
        $i=2;
        foreach($data['list'] as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['ctime'])
                ->setCellValue('B'.$i,$v['num'])
                ->setCellValue('C'.$i,$v['1'])
                ->setCellValue('D'.$i,$v['2'])
                ->setCellValue('E'.$i,$v['3'])
                ->setCellValue('F'.$i,$v['4'])
                ->setCellValue('G'.$i,$v['5'])
                ->setCellValue('H'.$i,$v['6'])
                ->setCellValue('I'.$i,$v['7'])
                ->setCellValue('J'.$i,$v['14'])
                ->setCellValue('K'.$i,$v['30']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('付费行为');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('payer_action').'_'.date('Y-m-dHis');

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
