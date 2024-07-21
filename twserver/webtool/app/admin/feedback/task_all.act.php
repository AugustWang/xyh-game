<?php

/* -----------------------------------------------------+
 * 任务统计数据
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_task_all extends Page
{

    public $day = '';
    private
        $dbh,
        $limit = 30,
        $page = 0;

    public function __construct()
    {
        parent::__construct();

        include(WEB_DIR . "/protocol/log_task.php");
        $this->log_task = $task_tid;
        // $prize_type[0]  = "未完成";
        // $prize_type[1]  = "可领取";
        // $prize_type[2]  = "已领取";
        // $this->prize_type = $prize_type;

        if ($this->input['day'] > 0)
            $this->day = $this->input['day'];
        else
            $this->day = date('Ym');

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
        $sqlOrder1 = " order by FROM_UNIXTIME(`ctime`,'%Y%m%d') desc";
        $sql1 = "SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d') as ctime FROM role WHERE 1 ";
        $sql2 = "SELECT task FROM task WHERE 1 ";

        if($this->input['day']) {
            $sql1 .= " AND FROM_UNIXTIME(`ctime`,'%Y%m%d') = ". $this->input['day'];
        }

        $totalRecord = $this->dbh->getOne(preg_replace("|^SELECT.*?FROM\s|i", "SELECT COUNT(DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d')) as total FROM ", $sql1));
        $data['days'] = $this->dbh->getAll($sql1 . $sqlOrder1 ." limit ". $this->page * $this->limit. ", ". $this->limit);
        // print_r($data['days']);

        foreach($data['days'] as $k => $v){
            $sqlWhere2 = " AND id in (SELECT id FROM role WHERE FROM_UNIXTIME(`ctime`,'%Y%m%d') = ". $v['ctime'] .") ";
            $task = $this->dbh->getAll($sql2 . $sqlWhere2);
            // echo $sql2 . $sqlWhere2;
            $data['list'][$k]['ctime'] = $v['ctime'];
            $n0 = array();
            $s0 = array();
            $o0 = array();
            foreach($task as $kt => $vt){
                $rt = $this->unzip_task($vt['task']);
                // print_r($rt);
                foreach((array)$rt as $rvv){
                    if($rvv['st'] == 0){
                        $n0[$rvv['id']] += 1;
                    }else if($rvv['st'] == 1){
                        $s0[$rvv['id']] += 1;
                    }else{
                        $o0[$rvv['id']] += 1;
                    }
                    $n0[$rvv['id']] = $n0[$rvv['id']] ? $n0[$rvv['id']] : 0;
                    $s0[$rvv['id']] = $s0[$rvv['id']] ? $s0[$rvv['id']] : 0;
                    $o0[$rvv['id']] = $o0[$rvv['id']] ? $o0[$rvv['id']] : 0;
                    $data['list'][$k][$rvv['id']] = $n0[$rvv['id']] ."/". $s0[$rvv['id']] ."/". $o0[$rvv['id']];
                }
            }

            // $n0 = array();
            // $s0 = array();
            // $o0 = array();
            // foreach((array)$rt as $rv){
            //     foreach($rv['t'] as $rvv){
            //         if($rvv['st'] == 0){
            //             $n0[$rvv['id']] += 1;
            //         }else if($rvv['st'] == 1){
            //             $s0[$rvv['id']] += 1;
            //         }else{
            //             $o0[$rvv['id']] += 1;
            //         }
            //         $n0[$rvv['id']] = $n0[$rvv['id']] ? $n0[$rvv['id']] : 0;
            //         $s0[$rvv['id']] = $s0[$rvv['id']] ? $s0[$rvv['id']] : 0;
            //         $o0[$rvv['id']] = $o0[$rvv['id']] ? $o0[$rvv['id']] : 0;
            //         $data['list'][$k][$rvv['id']] = $n0[$rvv['id']] ."/". $s0[$rvv['id']] ."/". $o0[$rvv['id']];
            //     }
            // }
        }

        $i = 1;
        foreach($this->log_task as $k => $v){
            $data['tids'][$i]['tid'] = $k;
            $i++;
        }

        // $sss = $this->dbh->getAll("SELECT task FROM task WHERE 1 AND id in (SELECT id FROM role WHERE FROM_UNIXTIME(`ctime`,'%Y%m%d') = 20140819) ");
        // foreach($sss as $kt => $vt){
        //     $ssss[$kt]['t'] = $this->unzip_task($vt['task']);
        // }
        // print_r($ssss);
        // $n = 0;
        // $s = 0;
        // $o = 0;
        // foreach($ssss as $rv){
        //     foreach($rv['t'] as $rvv){
        //         if($rvv['st'] == 0){
        //             $n += 1;
        //         }else if($rvv['st'] == 1){
        //             $s += 1;
        //         }else{
        //             $o += 1;
        //         }
        //     }
        // }
        // echo $n."...".$s."...".$o.";";

        // print_r($data['list']);

        // if(isset($this->input['expload'])){
        //     if($this->input['expload'] == "导出数据"){
        //         $this->expload_excel($data);
        //     } else {
        //         $this->assign('alert', "ERROR");
        //     }
        // }

        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        // 生成日期选择下拉列表
        $date_data = $this->dbh->getAll("SELECT DISTINCT FROM_UNIXTIME(`ctime`,'%Y%m%d') as day_date FROM `role` WHERE 1 order by `ctime` desc limit 100");
        foreach ($date_data as $v){
            $dates[$v['day_date']] = $v['day_date'];
        }
        $this->assign('dates', Form::select("day", $dates, $this->input['day']));
        $this->display();
    }

    function unzip_task($task){
        $task = substr($task,1);
        $i=1;
        while($task){
            if (strlen($task) <= 0){
                break;
            } else {
                $binary = new Binary($task);
                $rt[$i]['id'] = $binary->read_uint32_big();
                // $rt[$i]['name'] = $this->log_task[$rt[$i]['id']];
                $rt[$i]['target'] = $binary->read_uint8();
                $rt[$i]['len'] = $binary->read_uint8();
                $con = array();
                for($l=1; $l <= $rt[$i]['len'];$l++){
                    $con[$l]['t'] = $binary->read_uint32_big();
                    $con[$l]['n'] = $binary->read_uint32_big();
                }
                $rt[$i]['st'] = $binary->read_uint8();
                //$rt[$i]['type'] = $this->prize_type[$rt[$i]['st']];
                $num = 4 + 1 + 1 + $rt[$i]['len'] * 8 + 1;
                $i++;
                $task = substr($task, $num);
            }
        }
        return $rt;
    }

    function array_implode($arrays, &$target = array()) {
        foreach ($arrays as $item) {
            if (is_array($item)) {
                array_implode($item, $target);
            } else {
                $target[] = $item;
            }
        }
        return $target;
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
