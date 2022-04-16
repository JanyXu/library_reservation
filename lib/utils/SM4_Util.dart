import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sm_crypto/sm_crypto.dart';

class SM4Utils{
  static String getEncryptptData(String dataParam,String keyPara) {
     String key = SM4.createHexKey(key: keyPara);
    // List<int> encryptOutArray = SM4.encryptOutArray(data: dataParam, key: key);
    String ebcEncryptData = SM4.encrypt(data: dataParam, key: key);
    List<int> encryptOutArray = SM4.encryptOutArray(data: dataParam, key: key,padding: SM4PaddingMode.PKCS5);
    print('byte字节数组======${encryptOutArray}');
    String base64Encry = base64Encode(encryptOutArray);
    print('byte数组======${base64Encry}');
    return base64Encode(encryptOutArray);
  }

  static Future<String?> getEncryptDataFromPlatform(String dataParam,String keyPara) async {
    print('byte数组======${keyPara}');
    String key = SM4.createHexKey(key: keyPara);
    print('byte数组======${key}');
    // 创建渠道
    const channel = const MethodChannel("encrypt");

   // String callNativeMethod(String msg) {
      try {
        // 通过渠道，调用原生代码代码的方法
        String result = await channel.invokeMethod("encrypt", {"data": dataParam,'key':key} );
        if(result == null) {
          return "null result";
        }
        return result;

        // 打印执行的结果
        //return(future.toString());
      } on PlatformException catch(e) {
        print(e.toString());
        return 'null';
      }
    //}
  }

  static String getDecryptData(String ebcEncryptData,String key) {
    Uint8List base64Decrypt = base64.decode(ebcEncryptData);
    return SM4.decryptOutFromArray(data: base64Decrypt, key: key,padding: SM4PaddingMode.PKCS5);
  }
  void sm4Example() {
    String key = SM4.createHexKey(key: '约定的key');
    String data = 'Hello! SM-CRYPTO @Greenking19';
    print('👇 ECB Encrypt Mode:');
    String ebcEncryptData = SM4.encrypt(data: data, key: key);
    print('🔒 EBC EncryptptData:\n $ebcEncryptData');
    String ebcDecryptData = SM4.decrypt(data: ebcEncryptData, key: key);
    print('🔑 EBC DecryptData:\n $ebcDecryptData');

    print('👇 CBC Encrypt Mode:');
    String iv = SM4.createHexKey(key: '1234567890987654');
    String cbcEncryptData = SM4.encrypt(
      data: data,
      key: key,
      mode: SM4CryptoMode.CBC,
      iv: iv,
    );
    print('🔒 CBC EncryptptData:\n $cbcEncryptData');
    String cbcDecryptData = SM4.decrypt(
      data: cbcEncryptData,
      key: key,
      mode: SM4CryptoMode.CBC,
      iv: iv,
    );
    print('🔑 CBC DecryptData:\n $cbcDecryptData');
  }
}
