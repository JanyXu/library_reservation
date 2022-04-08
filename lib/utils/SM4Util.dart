import 'package:sm_crypto/sm_crypto.dart';

class SM4Utils{
  static String getEncryptptData(String dataParam,String keyPara) {
    String key = SM4.createHexKey(key: keyPara);
    String data = dataParam;
    String ebcEncryptData = SM4.encrypt(data: data, key: key);
    print('🔒 EBC EncryptptData:\n $ebcEncryptData');
    return ebcEncryptData;
  }

  static String getDecryptData(String ebcEncryptData,String key) {
    return SM4.decrypt(data: ebcEncryptData, key: key);
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
