<?php

/* -----------------------------------------------------+
 * 兑换码数据列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_Activate extends Page
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
        $kw = $this->getKeyword();
        $sqlWhere = $this->getSqlWhere($kw);
        $sqlOrder = " order by `time` desc";
        $sql = "SELECT `key`, `type`, `time`, `role_id` FROM `activate_key`";
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as `total` FROM', $sql . $sqlWhere));
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);

        if(isset($this->input['submit_type'])){
            if($this->input['submit_type'] == "expload"){
                if (isset($kw['kw_reg_st']) && isset($kw['kw_reg_et'])) {
                    //$this->expload_excel($data['list']);
                    $this->expload_excel($sql.$sqlWhere.$sqlOrder);
                }else {
                    $this->assign('alert', "没有填注册日期");
                }
            }
        }

        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('op', $this->op());
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
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
        if (($this->input['kw']['id']))
        {
            $kw['kw_id'] = $this->input['kw']['id'];
        }
        if (($this->input['kw']['type']))
        {
            $kw['kw_type'] = $this->input['kw']['type'];
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
        //echo $sql;
        $rs = $this->dbh->selectLimit($sql, $this->page * $this->limit, $this->limit);

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
            $sqlWhere = " WHERE `role_id` = " . $kw['kw_id'];
        } else {
            $sqlWhere = " WHERE 1 ";
            if (isset($kw['kw_name']) && strlen($kw['kw_name']))
            {
                $sqlWhere .= " and `key` like('%{$kw['kw_name']}%')";
            }
            if (isset($kw['kw_type']) && strlen($kw['kw_type']))
            {
                $sqlWhere .= " and `type` = {$kw['kw_type']}";
            }
            if (isset($kw['kw_reg_st']) && strlen($kw['kw_reg_et']))
            {
                $sqlWhere .= " and `time` >= {$kw['kw_reg_st']} and `time` <= {$kw['kw_reg_et']}";
            }
            if (isset($kw['kw_login_st']) && strlen($kw['kw_login_et']))
            {
                $sqlWhere .= " and `time` >= ({$kw['kw_login_st']} - 30 * 86400) and `time` <= ({$kw['kw_login_et']} - 30 * 86400)";
            }
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
        );
        return Form::batchSelector($btns);
    }

    function expload_excel($sql){
        //set_time_limit(0); // 设置脚本执行最大时间,0为无限制;默认配置为php.ini:max_execution_time = 30;
        //ini_set('memory_limit','512M');
        $data = $this->dbh->getAll($sql);
        $objPHPExcel=new PHPExcel();
        $objPHPExcel->getProperties()->setCreator('http://www.phpernote.com')
            ->setLastModifiedBy('http://www.phpernote.com')
            ->setTitle('Office 2007 XLSX Document')
            ->setSubject('Office 2007 XLSX Document')
            ->setDescription('Document for Office 2007 XLSX, generated using PHP classes.')
            ->setKeywords('office 2007 openxml php')
            ->setCategory('Result file');
        $objPHPExcel->setActiveSheetIndex(0)
            ->setCellValue('A1','兑换码ID')
            ->setCellValue('B1','奖励类型')
            ->setCellValue('C1','账号ID')
            ->setCellValue('D1','创建时间');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['key'])
                ->setCellValue('B'.$i,$v['type'])
                ->setCellValue('C'.$i,$v['role_id'])
                ->setCellValue('D'.$i,date('Y-m-d H:i:s',$v['time']));
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('兑换码');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('activate_key_data').'_'.date('Y-m-dHis');

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
