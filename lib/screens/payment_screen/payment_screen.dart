import 'dart:convert';
import 'dart:io';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/screens/payment_screen/hbl_payment.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/screens/payment_screen/jazz_cash.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

// ignore: depend_on_referenced_packages
// import 'package:image/image.dart' as img;

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

  bool imagesLoading = true;
  bool generatingInsurance = false;
  String? responseMessage;

  bool loaded = false;
  String? contribution;
  String paymentData = '';
  List vehicleImages = [];

  String bytesToBase64(List<int>? imageBytes) {
    return base64Encode(imageBytes!);
  }

  void getImages() {
    if (productValue != null) {
      bool isCar = productValue!.toLowerCase().contains('car');

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

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      setState(() {
        contribution = contributionController.text;
        loaded = true;
      });
    }

    if (loaded && imagesLoading) {
      getImages();
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
                  if (imagesLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!imagesLoading)
                    Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            paymentJazzCash(
                                displayJazzCashWebView, contribution);
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
                            await sendAPI();
                          },
                          buttonText: 'Generate Insurance',
                          buttonColor: kSecondaryColor,
                        ),
                        const SizedBox(height: kDefaultSpacing),
                        if (generatingInsurance)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        const SizedBox(height: kDefaultSpacing),
                        if (responseMessage != null)
                          Text(
                            responseMessage!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                      ],
                    )
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

  convertJsonToXML(Map jsonData, coverloApiAction) {
    var builder = XmlBuilder();

    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element(coverloApiAction, nest: () {
          builder.attribute('xmlns', 'http://tempuri.org/');
          for (var key in jsonData.keys) {
            builder.element(key, nest: jsonData[key]);
          }
        });
      });
    });

    return (builder.buildDocument().toXmlString(pretty: true, indent: '  '));
  }

  sendAPI() async {
    setState(() {
      generatingInsurance = true;
    });

    String cnicText = cnicController.text.toString();

    String registrationNoText = appliedForRegistartion != 'yes'
        ? registrationNoController.text.toString()
        : '';

    if (countryValue?.toLowerCase() == 'pakistan') {
      cnicText =
          '${cnicText.substring(0, 5)}-${cnicText.substring(5, 12)}-${cnicText.substring(12, 13)}';
    }

    final prefs = await SharedPreferences.getInstance();
    String? deviceUniqueIdentifier = prefs.getString('deviceUniqueIdentifier');
    String? uniqueID = prefs.getString('uniqueID');

    // --------------------------------------
    Map<String, String> apiJsonData = {
      "ByAgentID": "210001000001",
      "PName": nameController.text.toString(),
      "PAddress": addressController.text.toString(),
      "PCity": cityValue ?? '',
      "PNationality": countryCodeValue ?? '',
      "PPassportNo": cnicText,
      "PGender": genderValue ?? '',
      "PProfession": professionValue ?? '',
      "PMobileNo": mobileNoController.text.toString(),
      "PEmail": emailController.text.toString(),
      "VProductID": productCodeValue ?? '',
      "VRegNo": registrationNoText,
      "VEngineNo": engineNoController.text.toString(),
      "VChasisNo": chasisNoController.text.toString(),
      "VVMake": vehcileMakeCodeValue ?? '',
      "VVVariant": vehicleVariantValue ?? '',
      "VVModel": vehicleModelValue ?? '',
      "VColor": colorValue ?? '',
      "VCubicCapacity": cubicCapacityController.text.toString(),
      "VSeatingCapacity": seatingCapacity.toInt().toString(),
      "VTrackingCompany": trackingCompanyValue ?? '',
      "VIEV": "",
      "VContr": contributionController.text.toString(),
    };

    Map<String, dynamic> encodedApiJsonData =
        Des.encryptMap(Env.serverKey, apiJsonData);

    encodedApiJsonData = {
      ...encodedApiJsonData,
      "VAFR": appliedForRegistartion == 'yes',
      "VTrackerInstalled": trackerInstalled == 'yes',
      "VAdditionalAcces": additionalAccessories != "no",
      "VPersonalAccident": personalAccidentValue == 'yes',
      "uniqueID": uniqueID,
      "device_unique_identifier": deviceUniqueIdentifier,
      "VFrom": insurancePeriodIssueDate.toIso8601String(),
      "VTo": insurancePeriodExpiryDate.toIso8601String(),
      "PCNICDate": cnicIssueDateValue?.toIso8601String(),
      "PDOB": dateOfBirthValue?.toIso8601String(),
      "RecordDateTime": DateTime.now().toIso8601String(),
    };

    final BaseAPI provider = ApiProvider();

    var jsontoXmlFormBody =
        convertJsonToXML(encodedApiJsonData, 'CoverLo_GenrateInsurance');

    final response =
        await provider.post('CoverLo_GenrateInsurance', jsontoXmlFormBody);

    var insuranceID = response["insuranceID"];

    for (var i = 0; i < vehicleImages.length; i++) {
      Map<String, String> uploadPicsRequest = {
        "insuranceID": insuranceID.toString(),
        "picNo": (i + 1).toString(),
      };

      Map<String, dynamic> encodedUploadPicsRequest =
          Des.encryptMap(Env.serverKey, uploadPicsRequest);

      encodedUploadPicsRequest = {
        ...encodedUploadPicsRequest,
        "uniqueID": uniqueID,
        "device_unique_identifier": deviceUniqueIdentifier,
        "imageStr": vehicleImages[i]["IMAGE_STRING"],
      };

      var jsontoXmlFormBody =
          convertJsonToXML(encodedUploadPicsRequest, 'CoverLo_UploadPics');

      final response =
          await provider.post('CoverLo_UploadPics', jsontoXmlFormBody);

      if (response["responseCode"] != 200) {
        setState(() {
          responseMessage = "Something went wrong.";
          generatingInsurance = false;
        });
        return;
      }
    }

    setState(() {
      responseMessage = "Successfully generated insurance.";
      generatingInsurance = false;
    });
  }

  displayHblPaymentWebView(data) {
    setState(() {
      showHBLPaymentWebView = true;
      paymentData = data;
    });
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

  displayJazzCashWebView(data) {
    setState(() {
      showPaymentWebView = true;
      paymentData = data;
    });
  }

  // --------------------------------------

  sendAPIClient() async {
    String formattedIssuedDate =
        DateFormat('dd-MM-yyyy').format(insurancePeriodIssueDate);

    String formattedExpiryDate =
        DateFormat('dd-MM-yyyy').format(insurancePeriodExpiryDate);

    String cnicText = cnicController.text.toString();

    if (countryValue?.toLowerCase() == 'pakistan') {
      cnicText =
          '${cnicText.substring(0, 5)}-${cnicText.substring(5, 12)}-${cnicText.substring(12, 13)}';
    }

    Object jsonData = {
      "ORGANIZATION_CODE": "001001",
      "LOCATION_CODE": "10101",
      "DEPARTMENT_CODE": "13",
      "BUSINESS_CLASS_CODE": productCodeValue,
      "INSURANCE_TYPE": "D",
      "DOCUMENT_TYPE": "P",
      "DOCUMENT_NO": "",
      "RECORD_TYPE": "O",
      "YEAR": insurancePeriodIssueDate.year.toString(),
      "ISSUE_DATE": formattedIssuedDate,
      "COMMENCEMENT_DATE": formattedIssuedDate,
      "EXPIRY_DATE": formattedExpiryDate,
      "CURRENCY_CODE": "001",
      "SUM_INSURED": insuredEstimatedValueController.text.toString(),
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
      "PRODUCT_CODE": productCodeValue,
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
          "SUM_INSURED": insuredEstimatedValueController.text.toString(),
          "GROSS_PREMIUM": "",
          "Perils": [
            {
              "CODE": "001",
              "BASE_VALUE": insuredEstimatedValueController.text.toString(),
              "RATE": "0",
              "FLAT_AMOUNT": "",
              "AMOUNT": ""
            }
          ],
          "Item_Detail": [
            {
              "columnName": "GID_BENEFICIARY_NAME",
              "columnValue": appliedForRegistartion != 'yes' ? 'N' : 'Y'
            },
            {
              "columnName": "GID_REGISTRATION",
              "columnValue": appliedForRegistartion != 'yes'
                  ? registrationNoController.text.toString()
                  : ''
            },
            {
              "columnName": "GID_ENGINENO",
              "columnValue": engineNoController.text.toString()
            },
            {
              "columnName": "GID_CHASISNO",
              "columnValue": chasisNoController.text.toString()
            },
            {
              "columnName": "PMK_MAKE_CODE",
              "columnValue": vehcileMakeCodeValue
            },
            {
              "columnName": "GID_POWER",
              "columnValue": cubicCapacityController.text.toString()
            },
            {"columnName": "GID_YEAROFMFG", "columnValue": vehicleModelValue},
            {
              "columnName": "GID_PASSENGER",
              "columnValue": seatingCapacity.toInt().toString()
            },
            {"columnName": "PIT_BODYTYPE", "columnValue": "008"},
            {
              "columnName": "GID_ACCESSORIES",
              "columnValue": additionalAccessories
            },
            {"columnName": "PTV_CODE", "columnValue": trackingCompanyValue},
            {"columnName": "PLR_CODE", "columnValue": colorValue}
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

    openFileContainingData(jsonData, fileType: 'data.json');
  }
}
