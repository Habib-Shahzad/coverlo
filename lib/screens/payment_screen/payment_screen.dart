import 'dart:convert';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/image_operations.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/models/insurance_model.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/respository/insurance_repository.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:coverlo/screens/form_step_1_screen/form_step_1_screen.dart';
import 'package:coverlo/screens/form_step_2_screen/step_2_data.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:coverlo/screens/payment_screen/data_list.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment_screen';

  const PaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final UserRepository userRepository = UserRepository();
  final InsuranceRepository insuranceRepository = InsuranceRepository();

  bool showJazzCashWebView = false;
  bool showHBLWebView = false;
  String paymentData = '';

  bool loading = false;

  late Future<void> _future;
  Map<String, dynamic>? userInfo;
  Insurance? insuranceInfo;

  generateInsurance() async {
    List images = getImages(productNameValue);
    int? insuranceID = await insuranceRepository.sendInsuranceRequest(images);
    sessionInsuranceId = insuranceID;
  }

  Future<Map<String, dynamic>> getSavedUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> json = {};

    final info = prefs.getString('insuranceInfo');
    if (info != null) {
      final decodedInsuranceInfo = jsonDecode(info);
      json = {
        ...json,
        ...decodedInsuranceInfo,
      };
    }

    User? user = await userRepository.getAuthenticatedUser();
    if (user != null) {
      json = {
        ...json,
        ...user.toJson(),
      };
    }

    return json;
  }

  Future<Insurance> getSavedInsuranceInfo() async {
    // return Insurance.fromJson({
    //   "TranscationNumber": "206",
    //   "PolicyNo": "HOVCCDP00285/23",
    //   "PaymentGateway": "JAZZ",
    //   "TranscationDateTime": "2023-07-03 15:50:14",
    //   "TranscationID": "230703359138"
    // });
    return insuranceRepository.getInsuranceDetails(sessionInsuranceId);
  }

  Future<void> _loadInfo() async {
    userInfo = await getSavedUserInfo();
    insuranceInfo = await getSavedInsuranceInfo();

    if (insuranceInfo?.policyNo != null &&
        insuranceInfo?.transactionID != null) {
      // await insuranceRepository.deleteSavedInsuranceInfo();
    }
  }

  @override
  void initState() {
    _future = _loadInfo();
    super.initState();
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insurance Data'),
          content: const SingleChildScrollView(
            child: SizedBox(
              height: 300,
              width: 300,
              child: JsonList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String getJazzCashLink(data) {
    String linkJazzCash = removeQueryParams(data['linkJazzCash']);
    linkJazzCash = getUrl(
        linkJazzCash,
        {
          "amount": data['Insurance Amount'],
          "txnNumber": sessionInsuranceId.toString(),
        },
        uriEncode: true);

    return linkJazzCash;
  }

  String getHblLink(data) {
    String linkHBL = removeQueryParams(data['linkHBL']);

    linkHBL = getUrl(
        linkHBL,
        {
          "amount": data['Insurance Amount'],
          "txnNumber": sessionInsuranceId.toString(),
          "customerName": data['First Name'],
          "customerLastName": data['Last Name'],
          "customerAddress": data['Address'],
          "customerAddressCity": data['City'],
          "customerAddressCountry": data['Country'],
          "customerEmail": data['Email'],
        },
        uriEncode: true);

    return linkHBL;
  }

  createNewPolicy() async {
    setState(() {
      loading = true;
    });
    await insuranceRepository.deleteSavedInsuranceInfo();
    resetFormData();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        Navigator.pushNamed(context, FormStep1Screen.routeName);
        setState(() {
          loading = false;
        });
      });
    });
  }

  retryInsuranceRequest() async {
    setState(() {
      loading = true;
    });
    await insuranceRepository.deleteSavedInsuranceInfo();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        Navigator.pushReplacementNamed(
          context,
          FormStep3Screen.routeName,
          arguments: {
            "retryingInsurance": true,
          },
        );
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        Map<String, dynamic> jsonData = userInfo ?? {};
        String linkJazzCash = "";
        String linkHBL = "";

        bool loadingFuture =
            snapshot.connectionState == ConnectionState.waiting;

        bool paymentSuccess = false;
        bool policyIssued = false;

        if (!loadingFuture) {
          linkJazzCash = getJazzCashLink(jsonData);
          linkHBL = getHblLink(jsonData);

          paymentSuccess = insuranceInfo?.transactionID != null;
          policyIssued = insuranceInfo?.policyNo != null;
        }

        if (showHBLWebView) {
          return MyWebView(webUrl: linkHBL, webViewName: "HBL Payment");
        } else if (showJazzCashWebView) {
          return MyWebView(
              webUrl: linkJazzCash, webViewName: "JazzCash Payment");
        } else {
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
                      const SizedBox(height: kDefaultSpacing),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          if (!loadingFuture) ...[
                            CustomText(
                              text:
                                  "Transaction Number: ${insuranceInfo?.transactionNumber}",
                              color: kFormTextColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (!paymentSuccess) ...[
                              const CustomText(
                                text: "Payment Not recieved.",
                                color: kFormTextColor,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                            if (paymentSuccess) ...[
                              const CustomText(
                                  text: 'Payment processed successfully',
                                  color: kFormTextColor),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                text:
                                    "Transaction ID: ${insuranceInfo?.transactionID}",
                                color: kFormTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            if (paymentSuccess && !policyIssued) ...[
                              const CustomText(
                                text:
                                    "Policy issuance failed, Please contact back-office",
                                color: kFormTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            if (policyIssued) ...[
                              const CustomText(
                                text: "Policy issued successfully",
                                color: kFormTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                text:
                                    "Policy Number: ${insuranceInfo?.policyNo}",
                                color: kFormTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]
                          ],
                          ...[
                            CustomButton(
                              onPressed: () {
                                _showModal(context);
                              },
                              buttonText: 'View submitted data',
                              buttonColor: kSecondaryColor,
                              disabled: loading || loadingFuture,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () async {
                                await createNewPolicy();
                              },
                              buttonText: 'New Policy',
                              buttonColor: kSecondaryColor,
                              disabled: loading || loadingFuture,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                          if (!paymentSuccess) ...[
                            CustomButton(
                              onPressed: () async {
                                retryInsuranceRequest();
                              },
                              buttonText: 'Retry',
                              buttonColor: kSecondaryColor,
                              disabled: loading || loadingFuture,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () async {
                                setState(() {
                                  showJazzCashWebView = true;
                                });
                              },
                              buttonText: 'Pay with JazzCash',
                              buttonColor: kSecondaryColor,
                              disabled: loading || loadingFuture,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () async {
                                setState(() {
                                  showHBLWebView = true;
                                });
                              },
                              buttonText: 'Pay with Debit / Credit Card',
                              buttonColor: kSecondaryColor,
                              disabled: loading || loadingFuture,
                            ),
                            const SizedBox(height: kDefaultSpacing),
                          ],
                          if (loading || loadingFuture)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
