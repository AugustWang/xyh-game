<?php


// [2014-08-26 13:56:59] 126.126.184.126, Apache-HttpClient/UNAVAILABLE (java 1.4), http://42.62.14.78/charge.php?mod=callback&act=a_fun&data=%7B%22orderId%22%3A%2212999763169054705758.1344503535104316%22%2C%22packageName%22%3A%22com.turbotech.mengshoutang.fun%22%2C%22productId%22%3A%22com.mst.diamond_60%22%2C%22purchaseTime%22%3A1409032613661%2C%22purchaseState%22%3A0%2C%22purchaseToken%22%3A%22dbpbbadecnmekmbklcjphohe.AO-J1OzLcWzz50uJVVoTmNqOuHquaOwriBvVy5nWTWHXQv8BAg8qzi1aIx69Scg0oHxUwAtZa3CqF-P0cxgtWMlkwSbUsaNRpUvZaGyoOs6bg4ErZY87ovcl87_rkAbxdDs28e4setr6NpSalsZ7q3vnhZ6PbTfs7A%22%7D&sign=LxgUEj%2BCe4GDD9GClpGzXsFM4bWaLABUr1BV8ST%2BCFwQUDoF4JbaYLaTHqZOEj%2BfzZLvWJrW8QnX%2Bd7nVYIUjvUmwNjbrn1QCGWmyzpeU%2BO50KiWBDQNpIpie%2FBQecNWYKvQj5WBWCGpFeQYazNkRnAmhNIgXWCsJlS8qILkM39t9Hzk%2BS9d45xoDZIsXWNm2r%2B0Pb2gI3FSRL41RlfJc0MyGmX96i%2BZzbb9aFX%2F5uUoZY6vWoqDNe8iSWN%2Fxyi3fpNpSR2UpUQNm05CXG0hT4HOQOvFsrDIyxsvCfQZxKBK9x26qAwVVAeBIEuMgy28m%2B8R8SUw3%2FGBNh5iahV%2F8w%3D%3D
$params = array (
  'data' => '{\\"orderId\\":\\"12999763169054705758.1344503535104316\\",\\"packageName\\":\\"com.turbotech.mengshoutang.fun\\",\\"productId\\":\\"com.mst.diamond_60\\",\\"purchaseTime\\":1409032613661,\\"purchaseState\\":0,\\"purchaseToken\\":\\"dbpbbadecnmekmbklcjphohe.AO-J1OzLcWzz50uJVVoTmNqOuHquaOwriBvVy5nWTWHXQv8BAg8qzi1aIx69Scg0oHxUwAtZa3CqF-P0cxgtWMlkwSbUsaNRpUvZaGyoOs6bg4ErZY87ovcl87_rkAbxdDs28e4setr6NpSalsZ7q3vnhZ6PbTfs7A\\"}',
  'sign' => 'LxgUEj+Ce4GDD9GClpGzXsFM4bWaLABUr1BV8ST+CFwQUDoF4JbaYLaTHqZOEj+fzZLvWJrW8QnX+d7nVYIUjvUmwNjbrn1QCGWmyzpeU+O50KiWBDQNpIpie/BQecNWYKvQj5WBWCGpFeQYazNkRnAmhNIgXWCsJlS8qILkM39t9Hzk+S9d45xoDZIsXWNm2r+0Pb2gI3FSRL41RlfJc0MyGmX96i+Zzbb9aFX/5uUoZY6vWoqDNe8iSWN/xyi3fpNpSR2UpUQNm05CXG0hT4HOQOvFsrDIyxsvCfQZxKBK9x26qAwVVAeBIEuMgy28m+8R8SUw3/GBNh5iahV/8w==',
);
$signture_data = stripslashes($params['data']);

echo "<pre>";

$signture = $params['sign'];

//google app 提供的public key
$public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomchDNqoGHCj+uKX1wpo4OFhyDQYMVWzj1+NlJvf3rv8Fx8gXKAWm+5FmX7uF1EPOBoXzi94WwNaZuvHQUFwJMkU+Q9/h6k+wLwnygJFEhc5+9NuAPjHRd8rSTkvBZqSfzJKuRPt7U2Lt4CQPbiDK9ltcquAC7x8ovwC30G0xI/ItonQ7+cQmIbDsDgHo2kkZLhyuXX00JRHlBgMCBst0F6LhhRR43SVdy/yQAAO5BXrQGuDJghz3iRmTDBl/vsClKnqjmAUyN7VgaKy1/dDHISSpMGQNavZJT/EGWelndDrbKTX8DqB2EGrgDyOl4yU0rTYNo5EkGa2Z87uMDvY6QIDAQAB";
$public_key = "-----BEGIN PUBLIC KEY-----\n" . chunk_split($public_key, 64, "\n") .  "-----END PUBLIC KEY-----";

$public_key_handle = openssl_get_publickey($public_key);
$result = openssl_verify($signture_data, base64_decode($signture), $public_key_handle, OPENSSL_ALGO_SHA1);
if ($result == 1)
{
    echo "good";
}
elseif ($ok == 0)
{
    echo "bad";
}
else
{
    echo "ugly, error checking signature";
}
echo "</pre>";


// $rsa = new MyRSA;
// $rsa->setPubKey($public_key);
// $a = $rsa->check($signture_data, $signature);
// if ($a == 1)
// {
//     echo "good";
// }
// elseif ($a == 0)
// {
//     echo "bad";
// }
// else
// {
//     echo "ugly, error checking signature";
// }

/*-----------------------------------------------------+
 * RSA
 * 需要 openssl 支持
 * @author Rolong<rolong@vip.qq.com>
 +-----------------------------------------------------*/

class MyRSA
{
    private $_privKey;
    private $_pubKey;

    public function __construct() {

    }

    /**
     * * setup the private key
     */
    public function setPrivKey($key) {
        $pem = chunk_split($key, 64, "\n");
        $pem = "-----BEGIN PRIVATE KEY-----\n".$pem."-----END PRIVATE KEY-----\n";
        $this->_privKey = openssl_pkey_get_private ( $pem );
        return true;
    }

    /**
     * * setup the public key
     */
    public function setPubKey($key) {
        $pem = chunk_split($key, 64, "\n");
        $pem = "-----BEGIN PUBLIC KEY-----\n".$pem."-----END PUBLIC KEY-----\n";
        $this->_pubKey = openssl_pkey_get_public ( $pem );
        return true;
    }

    /**
     * 签名
     * @param 被签名数据 $dataString
     * @return string
     */
    public function sign($dataString){
        $signature = false;
        openssl_sign($dataString, $signature, $this->_privKey);
        return base64_encode($signature);
    }

    /**
     * 验证签名
     * @param 被签名数据 $dataString
     * @param 已经签名的字符串 $signString
     * @return 1 if the signature is correct, 0 if it is incorrect, and -1 on error.
     */
    public function verify($dataString, $signString) {
        $signature =base64_decode($signString);
        return openssl_verify($dataString, $signature, $this->_pubKey, OPENSSL_ALGO_SHA1);
    }

    public function check($dataString,$signString) {
        if($this->verify($dataString, $signString)==1) return true;
        return false;
    }

    /**
     * * encrypt with the private key
     */
    public function privEncrypt($data) {
        $r = openssl_private_encrypt ( $data, $encrypted, $this->_privKey );
        if ($r) {
            return base64_encode ( $encrypted );
        }
        return null;
    }

    /**
     * * decrypt with the private key
     */
    public function privDecrypt($encrypted) {
        $encrypted = base64_decode ( $encrypted );
        $r = openssl_private_decrypt ( $encrypted, $decrypted, $this->_privKey );
        if ($r) {
            return $decrypted;
        }
        return null;
    }

    /**
     * * encrypt with public key
     */
    public function pubEncrypt($data) {
        $r = openssl_public_encrypt ( $data, $encrypted, $this->_pubKey );
        if ($r) {
            return base64_encode ( $encrypted );
        }
        return null;
    }

    /**
     * * decrypt with the public key
     */
    public function pubDecrypt($crypted) {
        $crypted = base64_decode ( $crypted );
        $r = openssl_public_decrypt ( $crypted, $decrypted, $this->_pubKey );
        if ($r) {
            return $decrypted;
        }
        return null;
    }

    public function __destruct() {
        @ openssl_free_key ( $this->_privKey );
        @ openssl_free_key ( $this->_pubKey );
    }

}
