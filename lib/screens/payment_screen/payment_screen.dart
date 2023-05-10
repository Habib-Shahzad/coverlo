import 'dart:convert';
import 'dart:io';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/step_navigator.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:coverlo/helpers/helper_functions.dart';

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

  bool showJazzCashWebView = false;
  bool showHBLWebView = false;
  String? transactionNumber;

  bool imagesLoading = true;
  bool generatingInsurance = false;
  String? responseMessage;

  String? contribution;
  String paymentData = '';
  List vehicleImages = [];

  String bytesToBase64(List<int>? imageBytes) {
    if (imageBytes == null) {
      return '';
    }
    return base64Encode(imageBytes);
  }

  void getImages() {
    if (productValue != null) {
      bool isCar = productValue! == privateCar || productValue! == thirdParty;

      if (isCar) {
        vehicleImages = [
          if (bytesCarFront != null)
            {
              "IMAGE_NAME": "car-front.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarFront)
            },
          if (bytesCarBack != null)
            {
              "IMAGE_NAME": "car-back.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarBack)
            },
          if (bytesCarLeft != null)
            {
              "IMAGE_NAME": "car-left.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarLeft)
            },
          if (bytesCarRight != null)
            {
              "IMAGE_NAME": "car-right.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarRight)
            },
          if (bytesCarHood != null)
            {
              "IMAGE_NAME": "car-hood.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarHood)
            },
          if (bytesCarBoot != null)
            {
              "IMAGE_NAME": "car-boot.jpg",
              "IMAGE_STRING": bytesToBase64(bytesCarBoot)
            },
        ];
      } else {
        vehicleImages = [
          if (bytesBikeFront != null)
            {
              "IMAGE_NAME": "bike-front.jpg",
              "IMAGE_STRING": bytesToBase64(bytesBikeFront)
            },
          if (bytesBikeBack != null)
            {
              "IMAGE_NAME": "bike-back.jpg",
              "IMAGE_STRING": bytesToBase64(bytesBikeBack)
            },
          if (bytesBikeLeft != null)
            {
              "IMAGE_NAME": "bike-left.jpg",
              "IMAGE_STRING": bytesToBase64(bytesBikeLeft)
            },
          if (bytesBikeRight != null)
            {
              "IMAGE_NAME": "bike-right.jpg",
              "IMAGE_STRING": bytesToBase64(bytesBikeRight)
            },
        ];
      }
      setState(() {
        imagesLoading = false;
      });
    }
  }

  String? linkHBL;
  String? linkJazzCash;

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

  @override
  void initState() {
    contribution = contributionController.text;
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showHBLWebView) {
      return MyWebView(
          paymentData: paymentData,
          webUrl: "$linkHBL?amount=$contribution&txnNumber=$transactionNumber",
          webViewName: "HBL Payment");
    } else if (showJazzCashWebView) {
      return MyWebView(
          paymentData: paymentData,
          webUrl:
              "$linkJazzCash?amount=$contribution&txnNumber=$transactionNumber",
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
                  imagesLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            CustomButton(
                              onPressed: () async {
                                if (generatingInsurance) return;
                                await sendInsuranceRequest();
                                if (transactionNumber != null) {
                                  setState(() {
                                    showJazzCashWebView = true;
                                  });
                                }
                              },
                              buttonText: 'Pay with JazzCash',
                              buttonColor: kSecondaryColor,
                              disabled: generatingInsurance,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onPressed: () async {
                                if (generatingInsurance) return;
                                await sendInsuranceRequest();
                                if (transactionNumber != null) {
                                  setState(() {
                                    showHBLWebView = true;
                                  });
                                }
                              },
                              buttonText: 'Pay with Debit / Credit Card',
                              buttonColor: kSecondaryColor,
                              disabled: generatingInsurance,
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

  sendInsuranceRequest() async {
    setState(() {
      generatingInsurance = true;
    });

    UserResponse? user = await userRepository.getAuthenticatedUser();
    if (user == null) return;
    setState(() {
      linkHBL = removeQueryParams(user.linkHBL);
      linkJazzCash = removeQueryParams(user.linkJazzCash);
    });

    String transactionID = idGenerator();
    var insuranceID = await generateInsurance(user, transactionID);
    bool imageUploadSuccess = await uploadImages(insuranceID);

    String message = '';

    if (!imageUploadSuccess) {
      message = 'Something went wrong';
    }

    setState(() {
      generatingInsurance = false;
      transactionNumber = transactionID;
      responseMessage = message;
    });
  }

  generateInsurance(UserResponse user, String transationID) async {
    Map<String, dynamic> data = {
      "ByAgentID": encryptItem(user.agentCode),
      "uniqueRef": encryptItem(transationID),
      ...getEncryptedFormData(),
    };

    data = {
      ...data,
      ...await getDeviceInfo(),
      ...getFormData(),
    };

    final BaseAPI provider = ApiProvider();
    var url = getUrl(GENERATE_INSURANCE_API, data);
    final response = await provider.get(url);
    var insuranceID = response["insuranceID"];

    return insuranceID;
  }

  Future<bool> uploadImages(insuranceID) async {
    final BaseAPI provider = ApiProvider();

    for (var i = 0; i < vehicleImages.length; i++) {
      Map<String, String> request = {
        "insuranceID": encryptItem(insuranceID.toString()),
        "picNo": encryptItem((i + 1).toString()),
      };

      request = {
        ...request,
        ...await getDeviceInfo(),
        "imageStr": vehicleImages[i]["IMAGE_STRING"],
      };

      final response = await provider.post(UPLOAD_PICS_API, request);
      if (response["responseCode"] != 200) {
        return false;
      }
    }
    return true;
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
