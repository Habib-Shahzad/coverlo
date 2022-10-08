import 'dart:convert';

import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/screens/form_step_3_screen/jazz_cash.dart';
import 'package:coverlo/components/web_view2.dart';
import 'package:intl/intl.dart';

class FormStep3Screen extends StatefulWidget {
  static const String routeName = '/form_step_3_screen';

  const FormStep3Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<FormStep3Screen> createState() => _FormStep3ScreenState();
}

class _FormStep3ScreenState extends State<FormStep3Screen> {
  bool showPaymentWebView = false;
  bool showHBLPaymentWebView = false;
  String paymentData = '';

  @override
  Widget build(BuildContext context) {
    if (!showPaymentWebView && !showHBLPaymentWebView) {
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
                      paymentJazzCash(showJazzCashWebView);
                    },
                    child: const Text("Pay with JazzCash"),
                  ),
                  TextButton(
                    onPressed: () {
                      paymentHBL();
                    },
                    child: const Text("Pay with HBL"),
                  ),
                  const SizedBox(height: kDefaultSpacing),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (showHBLPaymentWebView) {
      return MyWebView2(paymentData: paymentData);
    } else if (showPaymentWebView) {
      return MyWebView(
        paymentData: paymentData,
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text("Something went wrong"),
        ),
      );
    }
  }

  String secretKey =
      "254255dead6640cc9d5be642e7b33b82cfbc9cb085484645a96c99462f98d9cfc217e0cbb648494badf9cdcb63a5fe0deab1eed0da794eb291f46c02266a6aecbe2cf1b02b014f69bc5d6dca7ee7699cd59dba1abfd94abea42c4a453741611fa31a8aff20364ee1b4ed4e4883148414b565b5b9685e40589ae79025c95173b7";

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

  paymentHBL() async {
    String uniqueString = getUniqueString();
    String uuid = idGenerator();
    String today =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

    var data = {
      "access_key": "9a8d20dad5f03d7f9aaba9e89f3b88be",
      "profile_id": "438EC5DE-0516-4CFB-A6FD-B35EAE0B7512",
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

    String returnString = "";
    data.forEach((k, v) {
      returnString += '$k=$v&';
    });
    returnString = returnString.substring(0, returnString.length - 1);

    setState(() {
      showHBLPaymentWebView = true;
      paymentData = returnString;
    });
  }

  showJazzCashWebView(data) {
    setState(() {
      showPaymentWebView = true;
      paymentData = data;
    });
  }
}
