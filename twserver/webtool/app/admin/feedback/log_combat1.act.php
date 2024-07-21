<?php

/* -----------------------------------------------------+
 * main战斗日志统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_log_combat1 extends Page
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
        $sqlOrder = " order by `ctime` desc";
        $sqlGroup = " GROUP BY `role_id` ";
        $sqlWhere = " and `tollgate_id` >= 1 and `tollgate_id` <= 264 ";
        $sql = "SELECT `role_id` FROM `log_combat` WHERE 1 ";
        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM|i", "SELECT COUNT(DISTINCT role_id) as total FROM", $sql . $sqlWhere));

        // if(isset($this->input['submit_type'])){
        //     if($this->input['submit_type'] == "export"){
        //         if ($this->input['kw']['time_st'] && $this->input['kw']['time_et']) {
        //             $this->expload_excel($sql.$sqlGroup);
        //         }else {
        //             $this->assign('alert', "没有填注册日期");
        //         }
        //     }
        // }

        $sql = $sql . $sqlWhere . $sqlGroup . $sqlOrder . " limit ".$this->page * $this->limit.", ".$this->limit;
        $data['list'] = $this->dbh->getAll($sql);
        foreach($data['list'] as $k => $v){
            $sql2 = "SELECT `tollgate_id`, `num`, `ctime` FROM `log_combat` WHERE `role_id` = " . $v['role_id'];
            $sql3 = "SELECT `tollgate_newid` as tollgate_id FROM `role` WHERE `id` = " . $v['role_id'];
            $data['list'][$k]['tollgate_id'] = $this->dbh->getOne($sql3);
            $data['gate'][$v['role_id']] = $this->dbh->getAll($sql2);
            foreach($data['gate'][$v['role_id']] as $k2 => $v2){
                $data['gate1'][$v['role_id']][$v2['tollgate_id']] = $v2['num'];
            }
        }

        for($i=1;$i<=264;$i++){
            $data['tollgate'][$i]['t'] = $i;
        }
        // print_r( $data['tollgate']);
        // print_r($data['gate1']);

        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
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
