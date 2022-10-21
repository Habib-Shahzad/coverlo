import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:coverlo/env/env.dart';

String integritySalt = Env.jazzCashSalt;

String hashingFunc(Map<String, String> data) {
  Map<String, String> temp2 = {};
  data.forEach((k, v) {
    if (v != "") v += "&";
    temp2[k] = v;
  });
  var sortedKeys = temp2.keys.toList(growable: false)
    ..sort((k1, k2) => k1.compareTo(k2));
  Map<String, String> sortedMap = {
    for (var k in sortedKeys) k: temp2[k].toString()
  };

  var values = sortedMap.values;
  String toBePrinted = values.reduce((str, ele) => str += ele);

  toBePrinted = toBePrinted.substring(0, toBePrinted.length - 1);
  toBePrinted = '$integritySalt&$toBePrinted';
  var key = utf8.encode(integritySalt);
  var bytes = utf8.encode(toBePrinted);
  var hash2 = Hmac(sha256, key);
  var digest = hash2.convert(bytes);
  var hash = digest.toString();
  data["pp_SecureHash"] = hash;
  String returnString = "";
  data.forEach((k, v) {
    returnString += '$k=$v&';
  });
  returnString = returnString.substring(0, returnString.length - 1);

  return returnString;
}

paymentJazzCash(Function showJazzCashWebView, String? contribution) async {
  String fixedContribution = contribution.toString().replaceAll('.', '');

  String returnURL = "https://coverlo-returnurl.herokuapp.com/test.php";
  String currentDate = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
  String expDate = DateFormat("yyyyMMddHHmmss")
      .format(DateTime.now().add(const Duration(days: 1)));

  String refNo = "T$currentDate";

  var data = {
    "pp_Amount": fixedContribution.toString(),
    "pp_BillReference": "billRef",
    "pp_Description": "Description of transaction",
    "pp_Language": "EN",
    "pp_MerchantID": Env.jazzCashMerchantId,
    "pp_Password": Env.jazzCashPassword,
    "pp_ReturnURL": returnURL,
    "pp_TxnCurrency": "PKR",
    "pp_TxnDateTime": currentDate.toString(),
    "pp_TxnExpiryDateTime": expDate.toString(),
    "pp_TxnRefNo": refNo,
    "pp_TxnType": "",
    "pp_Version": "1.1",
    "pp_BankID": "TBANK",
    "pp_ProductID": "RETL",
    "ppmpf_1": "1",
    "ppmpf_2": "2",
    "ppmpf_3": "3",
    "ppmpf_4": "4",
    "ppmpf_5": "5",
  };

  String postData = hashingFunc(data);
  showJazzCashWebView(postData);
}
