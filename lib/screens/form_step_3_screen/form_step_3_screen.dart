import 'dart:convert';
import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class FormStep3Screen extends StatelessWidget {
  static const String routeName = '/form_step_3_screen';
  const FormStep3Screen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: const BoxDecoration(color: kBackgroundColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Row(
                    children: [
                      NavigateButton(
                          text: 'Step 1',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          color: kStepButtonColor),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      NavigateButton(
                        text: 'Step 2',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: kStepButtonColor,
                      ),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      const NavigateButton(
                        text: 'Step 3',
                        onPressed: null,
                        color: kStepButtonActiveColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultSpacing),
                const MainHeading(
                    headingText: 'Motor Vehicle Cover',
                    color: kDarkTextColor,
                    fontWeight: FontWeight.w600),
                TextButton(
                  onPressed: () {
                    pay();
                  },
                  child: const Text("Pay with JazzCash"),
                ),
                const SizedBox(height: kDefaultSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final integritySalt = "91sz838003";
  static const platform = MethodChannel('payments.flutter/jazzcash');

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

  Future<void> pay() async {
    // Transaction Start Time
    final currentDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    // Transaction Expiry Time
    final expDate = DateFormat('yyyyMMddHHmmss')
        .format(DateTime.now().add(const Duration(minutes: 5)));
    final refNo = 'T$currentDate';

    // The json map that contains our key-value pairs
    var data = {
      "pp_Amount": "123",
      "pp_BillReference": "billRef",
      "pp_Description": "Description of transaction",
      "pp_Language": "EN",
      "pp_MerchantID": "MC48656",
      "pp_Password": "0d382vf2tc",
      "pp_ReturnURL": "https://www.google.com/",
      "pp_TxnCurrency": "PKR",
      "pp_TxnDateTime": currentDate,
      "pp_TxnExpiryDateTime": expDate,
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
    String responseString = "";
    String result = "";

    try {
      // Trigger native code through channel method
      // The first arguemnt is the name of method that is invoked
      // The second argument is the data passed to the method as input
      final result =
          await platform.invokeMethod('performPayment', {"postData": postData});

      // Await for response from above before moving on
      // The response contains the result of the transaction
      responseString = result.toString();
    } on PlatformException {
      print("ERROR OCCURED");
      // On Channel Method Invocation Failure
      // print("PLATFORM_EXCEPTION: ${e.message.toString()}");
    }

    // Trigger native code through channel method
    // The first arguemnt is the name of method that is invoked
    // The second argument is the data passed to the method as input

    // Await for response from above before moving on
    // The response contains the result of the transaction
    responseString = result.toString();

    // Parse the response now
    List<String> responseStringArray = responseString.split('&');
    Map<String, String> response = {};
    for (var e in responseStringArray) {
      if (e.isNotEmpty) {
        e.trim();
        final c = e.split('=');
        response[c[0]] = c[1];
      }
    }
// Use the transaction response as needed now
    // ignore: avoid_print
    print("RESPONSE: $response");
  }
}
