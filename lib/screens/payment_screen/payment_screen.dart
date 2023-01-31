import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/payment_screen/hbl_payment.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/screens/payment_screen/jazz_cash.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = '/payment_screen';

  const PaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool showPaymentWebView = false;
  bool showHBLPaymentWebView = false;

  bool loaded = false;
  String? contribution;
  String paymentData = '';
  List vehicleImages = [];

  // ignore: non_constant_identifier_names
  Future<String> XfileToBase64(XFile? imageFile) async {
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    }
    return "";
  }

  // ignore: non_constant_identifier_names
  Future<String> XfileToMultipart(XFile? imageFile, String filename) async {
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      MultipartFile myFile =
          MultipartFile.fromBytes('files.myimage', bytes, filename: filename);
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (productValue != null) {
        bool isCar = productValue!.toLowerCase().contains('car');
        if (isCar) {
          vehicleImages = [
            if (imageCarFront != null)
              {
                "IMAGE_NAME": "car-front.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarFront)
              },
            if (imageCarBack != null)
              {
                "IMAGE_NAME": "car-back.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarBack)
              },
            if (imageCarLeft != null)
              {
                "IMAGE_NAME": "car-left.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarLeft)
              },
            if (imageCarRight != null)
              {
                "IMAGE_NAME": "car-right.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarRight)
              },
            if (imageCarHood != null)
              {
                "IMAGE_NAME": "car-hood.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarHood)
              },
            if (imageCarBoot != null)
              {
                "IMAGE_NAME": "car-boot.jpg",
                "IMAGE_STRING": await XfileToBase64(imageCarBoot)
              },
          ];
        } else {
          vehicleImages = [
            if (imageBikeFront != null)
              {
                "IMAGE_NAME": "bike-front.jpg",
                "IMAGE_STRING": await XfileToBase64(imageBikeFront)
              },
            if (imageBikeBack != null)
              {
                "IMAGE_NAME": "bike-back.jpg",
                "IMAGE_STRING": await XfileToBase64(imageBikeBack)
              },
            if (imageBikeLeft != null)
              {
                "IMAGE_NAME": "bike-left.jpg",
                "IMAGE_STRING": await XfileToBase64(imageBikeLeft)
              },
            if (imageBikeRight != null)
              {
                "IMAGE_NAME": "bike-right.jpg",
                "IMAGE_STRING": await XfileToBase64(imageBikeRight)
              },
          ];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (vehicleImages.isNotEmpty) {}
    if (!loaded) {
      setState(() {
        contribution = contributionController.text;
        loaded = true;
      });
    }

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
                        NavigateButton(
                          text: 'Step 3',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: kStepButtonColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kDefaultSpacing),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    onPressed: () {
                      paymentJazzCash(displayJazzCashWebView, contribution);
                    },
                    buttonText: 'Pay with JazzCash',
                    buttonColor: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    onPressed: () {
                      paymentHBL(displayHblPaymentWebView, contribution);
                    },
                    buttonText: 'Pay with Debit / Credit Card',
                    buttonColor: kSecondaryColor,
                  ),
                  const SizedBox(height: kDefaultSpacing),
                  CustomButton(
                    onPressed: () async {
                      String formattedIssuedDate = DateFormat('dd-MM-yyyy')
                          .format(insurancePeriodIssueDate);
                      String formattedExpiryDate = DateFormat('dd-MM-yyyy')
                          .format(insurancePeriodExpiryDate);

                      // String formattedDob =
                      //     DateFormat('dd-MM-yyyy').format(dateOfBirthValue!);

                      String cnicText = cnicController.text.toString();

                      if (countryValue?.toLowerCase() == 'pakistan') {
                        cnicText =
                            '${cnicText.substring(0, 5)}-${cnicText.substring(5, 12)}-${cnicText.substring(12, 13)}';
                      }

                      Object jsonData = {
                        "ORGANIZATION_CODE": "001001",
                        "LOCATION_CODE": "10101",
                        "DEPARTMENT_CODE": "13",
                        "BUSINESS_CLASS_CODE": "V0201",
                        "INSURANCE_TYPE": "D",
                        "DOCUMENT_TYPE": "P",
                        "DOCUMENT_NO": "",
                        "RECORD_TYPE": "O",
                        "YEAR": insurancePeriodIssueDate.year.toString(),
                        "ISSUE_DATE": formattedIssuedDate,
                        "COMMENCEMENT_DATE": formattedIssuedDate,
                        "EXPIRY_DATE": formattedExpiryDate,
                        "CURRENCY_CODE": "001",
                        "SUM_INSURED":
                            insuredEstimatedValueController.text.toString(),
                        "GROSS_PREMIUM": "",
                        "POLICY_CHARGES": "0",
                        "NET_PREMIUM": contributionController.text.toString(),
                        "INDIVIDUAL_CLIENT": nameController.text.toString(),
                        "CLIENT_CODE": "",
                        "PPS_CNIC_NO": cnicText,
                        "FOLIO_CNIC": cnicText,
                        "FOLIO_CODE": "",
                        "COUNTRY_CODE": countryCodeValue,
                        "AGENT_CODE": "210001000001",
                        "PARTY_CODE": "",
                        "PRODUCT_CODE": "V0201",
                        "REVERSE_TAG": "Y",
                        "IA_ADDRESS1": addressController.text.toString(),
                        "IA_CITY": cityValue,
                        "IA_EMAIL": emailController.text.toString(),
                        "IA_PHONE1": mobileNoController.text,
                        "ONLINE_PAYMENT_NATURE": "CC",
                        "GATEWAY": "JAZZ",
                        "Items": [
                          {
                            "ITEM_NO": "1",
                            "SUM_INSURED":
                                insuredEstimatedValueController.text.toString(),
                            "GROSS_PREMIUM": "",
                            "Perils": [
                              {
                                "CODE": "001",
                                "BASE_VALUE": "180000",
                                "RATE": "0",
                                "FLAT_AMOUNT": "",
                                "AMOUNT": ""
                              }
                            ],
                            "Item_Detail": [
                              {
                                "columnName": "GID_BENEFICIARY_NAME",
                                "columnValue": nameController.text.toString()
                              },
                              {
                                "columnName": "GID_REGISTRATION",
                                "columnValue": appliedForRegistartion == 'yes'
                                    ? registrationNoController.text.toString()
                                    : ''
                              },
                              {
                                "columnName": "GID_ENGINENO",
                                "columnValue":
                                    engineNoController.text.toString()
                              },
                              {
                                "columnName": "GID_CHASISNO",
                                "columnValue":
                                    chasisNoController.text.toString()
                              },
                              {
                                "columnName": "PMK_MAKE_CODE",
                                "columnValue": "1000103"
                              },
                              {
                                "columnName": "GID_POWER",
                                "columnValue":
                                    cubicCapacityController.text.toString()
                              },
                              {
                                "columnName": "GID_YEAROFMFG",
                                "columnValue": vehicleModelValue
                              },
                              {
                                "columnName": "GID_PASSENGER",
                                "columnValue":
                                    seatingCapacityController.text.toString()
                              },
                              {
                                "columnName": "PIT_BODYTYPE",
                                "columnValue": "008"
                              },
                              {
                                "columnName": "GID_ACCESSORIES",
                                "columnValue": additionalAccessories
                              },
                              {"columnName": "PTV_CODE", "columnValue": "011"},
                              {"columnName": "PLR_CODE", "columnValue": "00009"}
                            ]
                          }
                        ],
                        "Clauses": [],
                        "Warranty": [],
                        "Charges": [],
                        "Wakala": [],
                        "Agents": [
                          {
                            "CODE": "210001000001",
                            "RATE": "22",
                            "AMOUNT": "",
                            "PERIL_TYPE": "",
                            "CONTRIBUTION": ""
                          }
                        ],
                        "Images": vehicleImages
                      };

                      jsonData = json.encode(jsonData);

                      // String dataUrl =
                      //     base64Encode(utf8.encode(jsonEncode(jsonData)));
                      // dataUrl = "data:application/json;base64,$dataUrl";

                      String filename = 'data.json';
                      String saveDir = await getExternalStorageDirectory()
                          .then((value) => value!.path);

                      File file = File('$saveDir/$filename');
                      await file.writeAsString(jsonData.toString());

                      await OpenFile.open(file.path);
                    },
                    buttonText: 'Open File containing form data',
                    buttonColor: kSecondaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (showHBLPaymentWebView) {
      return MyWebView(
          paymentData: paymentData,
          webUrl: "https://testsecureacceptance.cybersource.com/pay",
          webViewName: "HBL Payment");
    } else if (showPaymentWebView) {
      return MyWebView(
          paymentData: paymentData,
          webUrl:
              "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/",
          webViewName: "JazzCash Payment");
    } else {
      return const Scaffold(
        body: Center(
          child: Text("Something went wrong"),
        ),
      );
    }
  }

  displayHblPaymentWebView(data) {
    setState(() {
      showHBLPaymentWebView = true;
      paymentData = data;
    });
  }

  displayJazzCashWebView(data) {
    setState(() {
      showPaymentWebView = true;
      paymentData = data;
    });
  }
}
