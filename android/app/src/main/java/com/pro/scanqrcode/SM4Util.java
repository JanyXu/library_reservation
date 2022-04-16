package com.pro.scanqrcode;

import android.os.Build;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.nio.charset.StandardCharsets;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import com.pro.scanqrcode.Util;
/**
 * @author mtj
 * @date 2021/8/12
 * @desc 国产对称加密算法
 * @email mtjsoft3@gmail.com
 *
 * 国产加密算法可有效规避老外的RSA算法等存在的脆弱性和“预置后门”的安全风险
 * 另一方面确保密码算法这一关键环节的自主可控
 *
 * SM4分组密码算法是我国自主设计的分组对称密码算法
 */
public class SM4Util {
    public static final String SM4_CBC_NOPADDING = "SM4/CBC/NoPadding";

    public static final String SM4_CBC_PKCS5 = "SM4/CBC/PKCS5Padding";

    public static final String SM4_ECB_NOPADDING = "SM4/ECB/NoPadding";

    public static final String SM4_ECB_PKCS5 = "SM4/ECB/PKCS5Padding";

    private static final BouncyCastleProvider BC_PROVIDER = new BouncyCastleProvider();

    private SM4Util() {
        throw new UnsupportedOperationException("util class cant be instantiation");
    }

    /**
     * 获取随机密钥
     */
    public static byte[] createSM4Key() {
        return Util.genRandomBytes(16);
    }


    public static byte[] encrypt(byte[] source, byte[] key) {
        return encrypt(source, key, SM4_CBC_PKCS5, new byte[16]);
    }

    public static byte[] decrypt(byte[] source, byte[] key) {
        return decrypt(source, key, SM4_CBC_PKCS5, new byte[16]);
    }

    public static String encrypt(String source, String key, String mode, byte[] iv) {
        return Base64Util.encode(doSM4(true, source.getBytes(), Util.hexStr2Bytes(key), mode, null));
    }

    public static byte[] encrypt(byte[] source, byte[] key, String mode, byte[] iv) {
        return doSM4(true, source, key, mode, iv);
    }

    public static byte[] decrypt(byte[] source, byte[] key, String mode, byte[] iv) {
        return doSM4(false, source, key, mode, iv);
    }

    private static byte[] doSM4(boolean forEncryption, byte[] source, byte[] key, String mode, byte[] iv) {
        try {
            int cryptMode = forEncryption ? 1 : 2;
            SecretKeySpec sm4Key = new SecretKeySpec(key, "SM4");
            Cipher cipher = Cipher.getInstance(mode, BC_PROVIDER);
            if (iv == null) {
                cipher.init(cryptMode, sm4Key);
            } else {
                IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
                cipher.init(cryptMode, sm4Key, ivParameterSpec);
            }
            return cipher.doFinal(source);
        } catch (Exception var9) {
            var9.printStackTrace();
            return new byte[0];
        }
    }

//    @android.support.annotation.RequiresApi(api = Build.VERSION_CODES.KITKAT)
//    public static void main(String[] args) {
//        SM4Util.encrypt("6000001010644929.YKM11650033425V01.02.9140E3E75C8B6AFFD066F3B72CB90C99".
//                getBytes(StandardCharsets.UTF_8), Util.hexStr2Bytes("B3E4142F55124B92"),
//                SM4Util.SM4_ECB_PKCS5, new byte[16]);
//    }
}
