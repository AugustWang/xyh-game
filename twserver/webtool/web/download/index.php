<?php
// @author Rolong<rolong@vip.qq.com>

// 微信访问
if ( strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger') !== false ) { 
?>
<html>
    <head>
        <meta charset="UTF-8">
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
        <title>下载萌兽堂</title>
        <style>
            body{
                background-color:#3B5990;
                color:#FFF;
                font-family: Helvetica, Verdana;
                margin-top:20px;
                text-align: center;
            }
        </style>
    </head>
    <body> 请点击右边的"..."，在弹出的选项中选择[浏览器]打开 </body>
</html>
<?php
    exit();
}

include('./common.php');

if(isset($_GET['android_client']) && $_GET['android_client']){
    $os = 'android';
    $android_client = true;
}else{
    $os = get_os();
    $android_client = false;
}

$dir = '/home/samba/mst_package/';
$files = array();
if (is_dir($dir)) {
    if ($dh = opendir($dir)) {
        $i = 0;
        while (($file = readdir($dh)) !== false) {
            $ext = get_extension($file);
            // filter
            if(strlen($ext) != 3) continue;
            else if($os == 'ios' && $ext != 'ipa') continue;
            else if($os == 'android' && $ext != 'apk') continue;
            // parse name
            $name_str = str_replace('.'.$ext, '', $file);
            $name_array = explode('_', $name_str);
            if(count($name_array) < 4) continue;
            // set var
            $files[$i]["name"] = $file;
            $files[$i]["size"] = round((filesize($dir . $file)/1024/1024),2);
            $files[$i]["time"] = date("m-d H:i",filemtime($dir . $file));
            $files[$i]["platform"] = $name_array[0];
            $files[$i]["version"] = $name_array[1];
            $files[$i]["typeid"] = $name_array[2];
            switch($name_array[2]){
                case 'test': $files[$i]["type"] = '测试包'; break;
                case 'exp': $files[$i]["type"] = '体验包'; break;
                case 'rel': $files[$i]["type"] = '发布包'; break;
                default: $files[$i]["type"] = '';
            }
            $files[$i]["date"] = $name_array[3];
            $i++;
        }
        closedir($dh);
    }
    foreach($files as $k=>$v){
        $size[$k] = $v['size'];
        $time[$k] = $v['time'];
        $name[$k] = $v['name'];
    }
    array_multisort($time, SORT_DESC,SORT_STRING, $files);//按时间排序
    //array_multisort($name,SORT_DESC,SORT_STRING, $files);//按名字排序
    //array_multisort($size,SORT_DESC,SORT_NUMERIC, $files);//按大小排序
}

if($android_client){
    $list_array = array();
    foreach($files as $file){
        $list_array[] = $file['name'].'='.$file['time'];
    }
    $list = implode('&', $list_array);
    echo $list;
    exit();
}

// echo "<pre>";
// print_r($files);
// echo "</pre>";

?>
<html lang="zh-CN">
    <head>
        <meta charset="UTF-8">
        <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
        <title>下载萌兽堂</title>
        <style>
            body{
                background-color:#3B5990;
                color:#FFF;
                font-family: Helvetica, Verdana;
                margin-top:20px;
                text-align: center;
            }
            #viewport{
            }
            #startup {
                margin:10px auto;
                text-align: center;
            }
            a {
                font-size:20px;
                display: block;
                margin:20px auto;
                color:#fff;
                text-decoration:none;
            }
            p {
                text-align: left;
                font-size:12px;
                margin:10px auto;
                color:#fff;
                width:280px;
                line-height:20px;
            }
        </style>
    </head>
    <body>
        <div id="viewport">
        <?php if($os == 'default'):?>
        <h3>扫一扫安装《萌兽堂》</h3>
        <h5>(开发版本)</h5>
        <img src="qrcode.png">
        <p>
        包上传地址：\\192.168.0.8\mst_package<br/>
        包命名规则：平台ID_版本号_版本类型_日期.后缀名<br/>
        包版本类型：test(测试包) | exp(体验包) | rel(发布包)<br/>
        包命名示例：ios_1.5.1_test_0710.ipa<br/>
        包命名示例：ios_1.5.1_exp_0710.ipa<br/>
        包命名示例：360_1.5.2_rel_0714.apk
        </p>
        <?php else:?>
            <h3>安装《萌兽堂》开发版本</h3>
        <?php endif;?>
            <div id="startup" style="display:block">
                <?php foreach($files as $package): ?>
                <?php if($package['platform'] == 'ios' && $os == 'ios'): ?>
                <a href="itms-services://?action=download-manifest&url=https://szturbotech.com/download/<?php echo $package['version'];?>/<?php echo $package['typeid'];?>/<?php echo $package['date'];?>/Mst.plist">iOS <?php echo $package['version'];?> (<?php echo $package['type'];?> <?php echo $package['time'];?>)</a>
                <?php else: ?>
                <a href="http://mstdev.szturbotech.com/download/mst_package/<?php echo $package['name']; ?>"><?php echo $package['platform'].' - '.$package['version'];?> (<?php echo $package['type'];?> <?php echo $package['time'];?>)</a>
                <?php endif; ?>
                <?php endforeach; ?>
        </div>

    </body>
</html>

