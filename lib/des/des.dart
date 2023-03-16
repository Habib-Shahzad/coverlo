import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_des/dart_des.dart';
import 'package:pointycastle/digests/md5.dart';

class Des {
  static String encrypt(String key, String data) {
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);
    List<int> bytes = utf8.encode(data);
    List<int> encryptedChyper = desECB.encrypt(bytes);
    String value = base64Encode(encryptedChyper);
    return value;
  }

  static String encryptImage(String key, List<int> data) {
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);

    List<int> encryptedChyper = desECB.encrypt(data);
    String value = base64Encode(encryptedChyper);

    return value;
  }

  static String decrypt(String key, String data) {
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);
    List<int> bytes = base64Decode(data);
    List<int> decryptedChyper = desECB.decrypt(bytes);
    String value = utf8.decode(decryptedChyper);
    return value;
  }

  static String decryptImage(String key, String data) {
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);
    List<int> bytes = base64Decode(data);
    List<int> decryptedChyper = desECB.decrypt(bytes);
    String value = base64Encode(decryptedChyper);
    return value;
  }

  static Map<String, String> encryptMap(String key, Map<String, String> data) {
    Map<String, String> encryptedData = {};
    data.forEach((k, value) {
      encryptedData[k] = encrypt(key, value);
    });
    return encryptedData;
  }

  static Map<String, String> decryptMap(String key, Map<String, dynamic> data) {
    Map<String, String> decryptedData = {};
    data.forEach((k, value) {
      decryptedData[k] = decrypt(key, value);
    });
    return decryptedData;
  }
}
