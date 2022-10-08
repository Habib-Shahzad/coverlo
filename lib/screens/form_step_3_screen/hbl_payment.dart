import 'dart:convert';

import 'package:coverlo/env/env.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

String secretKey = Env.hblSecretKey;

getUniqueString() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyyMMddHHmmss');
  String formatted = formatter.format(now);
  return formatted;
}

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

String findHash(String someString) {
  // calculate sha256 hash based on secret key
  final key = utf8.encode(secretKey);
  final bytes = utf8.encode(someString);
  final hmacSha256 = Hmac(sha256, key);
  final hash2 = hmacSha256.convert(bytes);
  final encodedHash = base64.encode(hash2.bytes);
  return encodedHash;
}

String getSignedData(Map<String, String> data) {
  List<String>? signFields = data['signed_field_names']?.split(',');
  String signData = '';
  signFields?.forEach((element) {
    signData += '$element=${data[element]},';
  });
  signData = signData.substring(0, signData.length - 1);
  return signData;
}

paymentHBL(Function displayHblPaymentWebView) async {
  String uniqueString = getUniqueString();
  String uuid = idGenerator();
  String today =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

  var data = {
    "access_key": Env.hblAccessKey,
    "profile_id": Env.hblProfileId,
    "transaction_uuid": uuid,
    "signed_field_names":
        "access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency",
    "signed_date_time": today,
    "unsigned_field_names": "",
    "locale": "en",
    "transaction_type": "authorization",
    "reference_number": uniqueString,
    "amount": "100.00",
    "currency": "USD",
  };

  String signedData = getSignedData(data);
  String signature = findHash(signedData);

  data["signature"] = signature;

  String postData = "";
  data.forEach((k, v) {
    postData += '$k=$v&';
  });
  postData = postData.substring(0, postData.length - 1);
  displayHblPaymentWebView(postData);

  // setState(() {
  //   showHBLPaymentWebView = true;
  //   paymentData = returnString;
  // });
}
