import 'dart:convert';
import 'dart:typed_data';
import 'package:coverlo/env/env.dart';
import 'package:dart_des/dart_des.dart';
import 'package:pointycastle/digests/md5.dart';

class Des {
  static String encrypt(String data) {
    String key = Env.serverKey;
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);
    List<int> bytes = utf8.encode(data);
    List<int> encryptedChyper = desECB.encrypt(bytes);
    String value = base64Encode(encryptedChyper);
    return value;
  }

  static String decrypt(String data) {
    String key = Env.appKey;
    var md5 = MD5Digest();
    var keyBytes = md5.process(utf8.encode(key) as Uint8List);
    DES3 desECB = DES3(
        key: keyBytes, mode: DESMode.ECB, paddingType: DESPaddingType.PKCS7);
    List<int> bytes = base64Decode(data);
    List<int> decryptedChyper = desECB.decrypt(bytes);
    String value = utf8.decode(decryptedChyper);
    return value;
  }

  static Map<String, String> encryptMap(Map<String, String> data) {
    Map<String, String> encryptedData = {};
    data.forEach((k, value) {
      encryptedData[k] = encrypt(value);
    });
    return encryptedData;
  }

  static Map<String, String> decryptMap(Map<String, dynamic> data) {
    Map<String, String> decryptedData = {};
    data.forEach((k, value) {
      decryptedData[k] = decrypt(value);
    });
    return decryptedData;
  }
}
