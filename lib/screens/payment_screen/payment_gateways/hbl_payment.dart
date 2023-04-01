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

paymentHBL(Function displayHblPaymentWebView, String? contribution) async {
  String uniqueString = getUniqueString();
  String uuid = idGenerator();
  String today =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

  var data = {
    "transaction_type": "sale",
    "reference_number": uniqueString,
    "bill_to_forename": "Habib",
    "bill_to_surname": "Shahzad",
    "bill_to_email": "habibshahzad484@gmail.com",
    "bill_to_address_line1": "House 1",
    "bill_to_address_city": "Lahore",
    "bill_to_address_postal_code": "38000",
    "bill_to_address_state": "SD",
    "bill_to_address_country": "PK",
    "ship_to_forename": "Habib",
    "ship_to_surname": "Shahzad",
    "ship_to_email": "habibshahzad484@gmail.com",
    "ship_to_address_line1": "House 1",
    "ship_to_address_city": "Lahore",
    "ship_to_address_postal_code": "38000",
    "ship_to_address_state": "SD",
    "ship_to_address_country": "PK",
    "amount": contribution.toString(),
    "currency": "PKR",
    
    "access_key": Env.hblAccessKey,
    "profile_id": Env.hblProfileId,
    "transaction_uuid": uuid,
    "signed_field_names":
        "signed_field_names,access_key,profile_id,transaction_uuid,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency",
    "signed_date_time": today,
    "unsigned_field_names": "",
    "locale": "en",
    "bill_address1": "Address 1",
    "bill_city": "City",
    "bill_country": "PK",
    "customer_email": "murtazashafi11@gmail.com",
    "customer_lastname": "Shafi",
  };

  String signedData = getSignedData(data);
  String signature = findHash(signedData);

  data["signature"] = signature;

  String postData = "";
  data.forEach((k, v) {
    postData += '$k=$v&';
  });
  postData = postData.substring(0, postData.length - 1);

  // String cardNumber = '5200000000000007';
  displayHblPaymentWebView(postData);
}
