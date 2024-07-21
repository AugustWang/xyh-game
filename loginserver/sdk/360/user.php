<?php
// AppId:201455056
// App-Key:59f1d452986e40591409a231640a90fa
// App-Secret:1c78501c188cd427ad828e0c3b8f0958

/**
 * 客户端调用本接口能通过code获取access_token和用户信息
 * 也可以查询token信息
 * 
 * 用户接口，在common.inc.php中设置参数后，便可测试
 * 1.获取code (正常流程中，code由客户端获取,传到服务端),这一步只在测试服务端程序时需要
 * 将链接中的59f1d452986e40591409a231640a90fa替换为实际的app_key，即可。
 * https://openapi.360.cn/oauth2/authorize?client_id=59f1d452986e40591409a231640a90fa&response_type=code&redirect_uri=oob&scope={SCOPE}&display=default
 *
 * https://openapi.360.cn/oauth2/authorize?client_id=59f1d452986e40591409a231640a90fa&response_type=code&redirect_uri=oob
 *
 * 在浏览器中访问后，会跳转到类似地址
 * https://openapi.360.cn/page/oauth2_succeed?code=8504247790e445ad3275c26d9f8801083ecdff9f55c43b1dd
 * 将其中的code参数复制出来，就得到了一个code. code有效期比较短，拿到code后，马上进入第2步
 * 
 * 2.使用code换取token和用户信息
 * 访问
 * http://118.192.91.108/sdk/360/user.php?act=get_info&app_key=59f1d452986e40591409a231640a90fa&code={CODE}&scope=basic
 * 返回结果格式为
 * {
  "access_token": "18271776353e88b0afb6c17665e7338b82df8a5f5890415c8", //本次得到的token
  "user": {
  "id": "182717763",//360用户id
  "name": "adamsunyu", //360用户昵称
  "avatar": "http://u1.qhimg.com/qhimg/quc/48_48/29/02/73/290273aq114f3.92d56f.jpg?f=8689e00460eabb1e66277eb4232fde6f" //用户头像
  }
  }
 * 
 * 3.使用token获取用户信息
 * 请求地址格式为
 * http://118.192.91.108/sdk/360/user.php?act=get_user&app_key=59f1d452986e40591409a231640a90fa&token=8504247790dbc72bdedd8e7aa56e6ae9ac96017291187dbdf
 * 返回:
 * {
  "id": "182717763",
  "name": "adamsunyu",
  "avatar": "http://u1.qhimg.com/qhimg/quc/48_48/29/02/73/290273aq114f3.92d56f.jpg?f=8689e00460eabb1e66277eb4232fde6f"
  }
 * 
 * 4.查询token信息：从token获取应用和用户id
 * 请求地址格式为
 * http://118.192.91.108/sdk/360/user.php?act=get_token_info&app_key=59f1d452986e40591409a231640a90fa&token={ACCESS_TOKEN}
 * 返回:
 * {
  "app_key": "8689e00460eabb1e66277eb4232fde6f",//应用app_key
  "user_id": "182717763",//360用户id
  "expires_at": "1370787930", //过期时间
  "expres_in": "35647",//有效时长
  }
 */
require_once dirname(__FILE__) . '/common.inc.php';
/**
 * 
 */
$scope = empty($_REQUEST['scope']) ? '' : $_REQUEST['scope'];
$qihooOauth2 = new Qihoo_OAuth2(QIHOO_APP_KEY, QIHOO_APP_SECRET, $scope);
if (QIHOO_MSDK_DEBUG) {
    //打开调试日志
    $logger = Qihoo_Logger_File::getInstance();
    //设置日志路径
    $logger->setLogPath(QIHOO_MSDK_LOG);
    $qihooOauth2->setLogger($logger);
}

header('Content-Type: application/json; charset=utf-8');
try {
    $act = isset($_REQUEST['act']) ? $_REQUEST['act'] : 'getInfo';
    $data = processRequest($qihooOauth2, $act);
    echo json_encode($data);
} catch (Qihoo_Exception $e) {
    echo json_encode(array(
        'error_code' => $e->getCode(),
        'error' => $e->getMessage(),
    ));
}

/**
 * 
 * @param Qihoo_OAuth2 $qihooOauth2
 * @return array
 */
function processRequest($qihooOauth2, $act)
{
    switch ($act) {

        //获取token信息,app_key, user_id
        case 'get_token_info':
            $tokenStr = isset($_REQUEST['token']) ? $_REQUEST['token'] : '';
            if (empty($tokenStr)) {
                throw new Qihoo_Exception(Qihoo_Exception::CODE_NEED_TOKEN);
            }
            $tokenInfo = $qihooOauth2->getTokenInfo($tokenStr);
            return $tokenInfo;
        //用token获取用户信息
        case 'get_user':

            $token = isset($_GET['token']) ? $_GET['token'] : '';
            if (empty($token)) {
                throw new Qihoo_Exception(Qihoo_Exception::CODE_NEED_TOKEN);
            }
            $userArr = $qihooOauth2->userMe($token);
            return $userArr;
        //用code获取用户信息和token
        case 'get_info':
            $code = isset($_REQUEST['code']) ? $_REQUEST['code'] : '';
            if (empty($code)) {
                throw new Qihoo_Exception(Qihoo_Exception::CODE_NEED_CODE);
            }

            $data = $qihooOauth2->getInfoByCode($code);

            if (isset($data['token']) && $data['token']['access_token']) {
                //TODO::将$token中的token过期时间，refresh_token存起来
                //token过期时，调用Qihoo_OAuth2::getAccessTokenByRefreshToken 来刷新token
                $token = $data['token'];
                unset($data['token']);
                $data['access_token'] = $token['access_token'];
            }
            return $data;
        default:
            throw new Qihoo_Exception(Qihoo_Exception::CODE_BAD_PARAM);
    }
}

