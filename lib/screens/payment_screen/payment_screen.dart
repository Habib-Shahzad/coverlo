import 'dart:convert';
import 'dart:io';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/step_navigator.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/respository/insurance_repository.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:coverlo/screens/payment_screen/data_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
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
  String? transactionNumber;

  bool generatingInsurance = false;
  String? responseMessage;

  String? contribution;
  String paymentData = '';
  List vehicleImages = [];

  String? linkHBL;
  String? linkJazzCash;

  bool loading = false;

  String removeQueryParams(String url) {
    final uri = Uri.parse(url);
    final uriWithoutQueryParams = Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.port,
      path: uri.path,
    );
    return uriWithoutQueryParams.toString();
  }

  late Future<Map<String, dynamic>> userInfoFuture;

  Future<Map<String, dynamic>> _loadInfo() async {
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

  @override
  void initState() {
    contribution = contributionController.text;
    userInfoFuture = _loadInfo();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> jsonData = snapshot.data!;

          final contribution = jsonData['Insurance Amount'];
          final linkHBL = removeQueryParams(jsonData['linkHBL']);
          final linkJazzCash = removeQueryParams(jsonData['linkJazzCash']);

          if (showHBLWebView) {
            return MyWebView(
                paymentData: paymentData,
                webUrl:
                    "$linkHBL?amount=$contribution&txnNumber=$sessionInsuranceId",
                webViewName: "HBL Payment");
          } else if (showJazzCashWebView) {
            return MyWebView(
                paymentData: paymentData,
                webUrl:
                    "$linkJazzCash?amount=$contribution&txnNumber=$sessionInsuranceId",
                webViewName: "JazzCash Payment");
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
                        stepNavigatorComponent(
                          onPressedStep1: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          onPressedStep2: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          onPressedStep3: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: kDefaultSpacing),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            if (sessionInsuranceId != null)
                              CustomText(
                                text: "Insurance ID: $sessionInsuranceId",
                                color: kFormTextColor,
                              ),
                            if (sessionInsuranceId != null)
                              const SizedBox(
                                height: 20,
                              ),
                            if (sessionInsuranceId != null)
                              CustomButton(
                                onPressed: () async {
                                  _showModal(context);
                                },
                                buttonText: 'View Data',
                                buttonColor: kSecondaryColor,
                                disabled: generatingInsurance || loading,
                              ),
                            if (sessionInsuranceId != null)
                              const SizedBox(
                                height: 20,
                              ),
                            if (sessionInsuranceId != null)
                              CustomButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await insuranceRepository
                                      .deleteInsuranceInfo();
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                buttonText: 'Delete Transaction',
                                buttonColor: kSecondaryColor,
                                disabled: generatingInsurance || loading,
                              ),
                            if (sessionInsuranceId != null)
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
                              disabled: generatingInsurance ||
                                  loading ||
                                  sessionInsuranceId == null,
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
                              disabled: generatingInsurance ||
                                  loading ||
                                  sessionInsuranceId == null,
                            ),
                            const SizedBox(height: kDefaultSpacing),
                            if (generatingInsurance)
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
        }
      },
    );
  }

  copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  openFileContainingData(jsonData, {fileType = 'json'}) async {
    jsonData = json.encode(jsonData);

    String filename = 'data.$fileType';
    String saveDir =
        await getExternalStorageDirectory().then((value) => value!.path);

    File file = File('$saveDir/$filename');
    await file.writeAsString(jsonData.toString());

    await OpenFile.open(file.path);
  }
}
