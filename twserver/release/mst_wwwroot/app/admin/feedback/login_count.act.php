<?php

/* -----------------------------------------------------+
 * 登录次数列表
 * @author yeahoo2000@gmail.com
 * @author Tim <mianyangone@gmail.com>
  +----------------------------------------------------- */

class Act_login_count extends Page
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
        //echo strtotime(date("Y-m-d",time()));
        //echo strtotime(date("Y-m-d"));
        //echo strtotime(date("Y-m-d", strtotime("+1 day")));
        $data = array();
        $sqlWhere = " where 1 ";
        if (($this->input['kw']['login_st']) && ($this->input['kw']['login_et']))
        {
            $kw['kw_login_st'] = strtotime($this->input['kw']['login_st']);
            $kw['kw_login_et'] = strtotime($this->input['kw']['login_et']);
            $sqlWhere .= " and `login_time` >= {$kw['kw_login_st']} and `login_time` <= {$kw['kw_login_et']}";
        } else {
            $kw['kw_login_st'] = strtotime(date("Y-m-d", strtotime("-1 month")));
            $kw['kw_login_et'] = strtotime(date("Y-m-d"));
            $sqlWhere .= " and `login_time` >= {$kw['kw_login_st']} and `login_time` <= {$kw['kw_login_et']}";
            //$this->assign('alert', "没有填注册日期");
        }
        $sqlOrder = " order by `login_time` desc";
        $sql = "select `id`, `name`, `ctime` from role";
        $totalRecord = $this->dbh->getOne(preg_replace('|^SELECT.*?FROM|i', 'SELECT COUNT(*) as total FROM', $sql . $sqlWhere));
        $data['list'] = $this->getList($sql . $sqlWhere . $sqlOrder);
        $data['list'] = $this->get_sublist($data['list'],$sqlWhere);

        if(isset($this->input['submit_type'])){
            if($this->input['submit_type'] == "expload"){
                if (($this->input['kw']['login_st']) && ($this->input['kw']['login_et'])){
                    $this->expload_excel($sql,$sqlWhere,$sqlOrder);
                }else {
                    $this->assign('alert', "没有填注册日期");
                }
            }
        }

        $data['page_index'] = Utils::pager(Admin::url('', '', '', true), $totalRecord, $this->page, $this->limit);
        $this->assign('kw', $kw);
        $this->assign('data', $data);
        $this->assign('formAction', Admin::url('', '', '', true));
        $this->display();
    }

    /**
     * 获取列表数据
     * @param string $sql SQL查询字串
     * @return array
     */
    private function getList($sql)
    {
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

    function expload_excel($sql,$sqlWhere,$sqlOrder){
        //set_time_limit(0); // 设置脚本执行最大时间,0为无限制;默认配置为php.ini:max_execution_time = 30;
        //ini_set('memory_limit','512M');
        $data = $this->dbh->getAll($sql.$sqlWhere.$sqlOrder);
        $data = $this->get_sublist($data,$sqlWhere);
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
            ->setCellValue('B1','角色名称')
            ->setCellValue('C1','注册时间')
            ->setCellValue('D1','登出时间')
            ->setCellValue('E1','登录次数');
        $i=2;
        foreach($data as $k=>$v){
            $objPHPExcel->setActiveSheetIndex(0)
                ->setCellValue('A'.$i,$v['id'])
                ->setCellValue('B'.$i,$v['name'])
                ->setCellValue('C'.$i,date('Y-m-d H:i:s',$v['ctime']))
                ->setCellValue('D'.$i,date('Y-m-d H:i:s',$v['login_time']))
                ->setCellValue('E'.$i,$v['login_count']);
            $i++;
        }
        $objPHPExcel->getActiveSheet()->setTitle('登录次数');
        $objPHPExcel->setActiveSheetIndex(0);
        $filename=urlencode('login_count').'_'.date('Y-m-dHis');

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

    function get_sublist($data,$sqlWhere){
        foreach($data as $k => $v){
            $sql = "select COUNT(*) as login_count, max(`logout_time`) as logout_time from `log_login` ";
            $sqlWhere1 = " and `role_id` = ". $v['id'];
            $login_count = $this->dbh->getAll($sql.$sqlWhere.$sqlWhere1);
            //print_r($login_count);
            $data[$k]['login_count'] = $login_count[0]['login_count'];
            $data[$k]['logout_time'] = $login_count[0]['logout_time'];
        }
        return $data;
    }

}
