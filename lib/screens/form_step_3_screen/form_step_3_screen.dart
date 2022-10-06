import 'dart:convert';

import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                // TextButton(
                //   onPressed: () {
                //     payment();
                //   },
                //   child: const Text("Pay with JazzCash"),
                // ),
                const SizedBox(height: kDefaultSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  payment() async {
    // // var digest;
    // String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    // String dexpiredate = DateFormat("yyyyMMddHHmmss")
    //     .format(DateTime.now().add(const Duration(days: 1)));
    // String tre = "T$dateandtime";
    // String ppAmount = "100000";
    // String ppBillReference = "billRef";
    // String ppDescription = "Product test description";
    // String ppLanguage = "EN";
    // String ppMerchantID = "00678965";
    // String subMerchantID = "";
    // String bankID = "";
    // String productID = "";
    // String ppPassword = "3fw2x88xsh";
    // String ppIsRegisteredCustomer = "No";

    // String ppReturnURL =
    //     "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    // String ppVer = "1.1";
    // String ppTxnCurrency = "PKR";
    // String ppTxnDateTime = dateandtime.toString();
    // String ppTxnExpiryDateTime = dexpiredate.toString();
    // String ppTxnRefNo = tre.toString();
    // String ppTxnType = "";
    // String ppmpf_1 = "";
    // String integeritySalt = "11vfahhy5w";
    // String and = '&';
    // String superdata = integeritySalt +
    //     and +
    //     ppAmount +
    //     and +
    //     ppBillReference +
    //     and +
    //     ppDescription +
    //     and +
    //     ppLanguage +
    //     and +
    //     subMerchantID +
    //     and +
    //     bankID +
    //     and +
    //     productID +
    //     and +
    //     ppIsRegisteredCustomer +
    //     and +
    //     ppMerchantID +
    //     and +
    //     ppPassword +
    //     and +
    //     ppReturnURL +
    //     and +
    //     ppTxnCurrency +
    //     and +
    //     ppTxnDateTime +
    //     and +
    //     ppTxnExpiryDateTime +
    //     and +
    //     ppTxnRefNo +
    //     and +
    //     ppTxnType +
    //     and +
    //     ppVer +
    //     and +
    //     ppmpf_1;

    // var key = utf8.encode(integeritySalt);
    // var bytes = utf8.encode(superdata);
    // var hmacSha256 = Hmac(sha256, key);
    // Digest sha256Result = hmacSha256.convert(bytes);
    // var url =
    //     'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    // var response = await http.post(Uri.parse(url), body: {
    //   "pp_Version": ppVer,
    //   "pp_TxnType": ppTxnType,
    //   "pp_Language": ppLanguage,
    //   "pp_MerchantID": ppMerchantID,
    //   "pp_Password": ppPassword,
    //   "pp_TxnRefNo": tre,
    //   "pp_Amount": ppAmount,
    //   "pp_TxnCurrency": ppTxnCurrency,
    //   "pp_TxnDateTime": dateandtime,
    //   "pp_BillReference": ppBillReference,
    //   "pp_Description": ppDescription,
    //   "pp_TxnExpiryDateTime": dexpiredate,
    //   "pp_ReturnURL": ppReturnURL,
    //   "pp_SecureHash": sha256Result.toString(),
    //   "ppmpf_1": "",
    // });

    // print("response=>");
    // print(response.body);
    // Production/Sandbox Credentials

 

    // $MerchantID    = ""; //Your Merchant from transaction Credentials

    // $Password      = ""; //Your Password from transaction Credentials

    // $HashKey = ""; //Your HashKey/integrity salt from transaction Credentials    

    // $ReturnURL     = ""; //Your Return URL, It must be static

 

 

    // *** for sandbox testing environment

    // $PostURL = "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/";

 

    // // *** for production environment

    // //$PostURL = "https://payments.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform";

 

    // date_default_timezone_set("Asia/karachi");

    // $Amount = 1 * 100; //Last two digits will be considered as Decimal

    // $BillReference = "billRef"; //use AlphaNumeric only

    // $Description = "Product test description"; //use AlphaNumeric only

    // $IsRegisteredCustomer = "No"; // do not change it

    // $Language = "EN"; // do not change it

    // $TxnCurrency = "PKR"; // do not change it

    // $TxnDateTime = date('YmdHis');

    // $TxnExpiryDateTime = date('YmdHis', strtotime('+1 Days'));

    // $TxnRefNumber = "TR" . date('YmdHis') . mt_rand(10, 100); // You can customize it (only Max 20 Alpha-Numeric characters)

    // $TxnType = ""; // Leave it empty

    // $Version = '2.0';

    // $SubMerchantID = ""; // Leave it empty

    // $BankID = ""; // Leave it empty

    // $ProductID = ""; // Leave it empty

    // $ppmpf_1 = ""; // use to store extra details (use AlphaNumeric only)

    // $ppmpf_2 = ""; // use to store extra details (use AlphaNumeric only)

    // $ppmpf_3 = ""; // use to store extra details (use AlphaNumeric only)

    // $ppmpf_4 = ""; // use to store extra details (use AlphaNumeric only)

    // $ppmpf_5 = ""; // use to store extra details (use AlphaNumeric only)

 

    // $HashArray = [$Amount, $BankID, $BillReference, $Description, $IsRegisteredCustomer, $Language, $MerchantID, $Password, $ProductID, $ReturnURL, $TxnCurrency, $TxnDateTime, $TxnExpiryDateTime, $TxnRefNumber, $TxnType, $Version, $ppmpf_1, $ppmpf_2, $ppmpf_3, $ppmpf_4, $ppmpf_5];

 

    // $SortedArray = $HashKey;

    // for ($i = 0; $i < count($HashArray); $i++) {

    //     if ($HashArray[$i] != 'undefined' and $HashArray[$i] != null and $HashArray[$i] != "") {

 

    //         $SortedArray .= "&" . $HashArray[$i];

    //     }

    // }

 

    // $Securehash = hash_hmac('sha256', $SortedArray, $HashKey);
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(const Duration(days: 1)));
    String env = "sandbox";
    String postURL = env == "sandbox"
        ? "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/"
        : "https://payments.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform";
    String merchantID = "00678965";
    String password = "3fw2x88xsh";
    String hashKey = "11vfahhy5w";
    String returnURL = "https://www.google.com";

    String amount = "100000";
    String billReference = "billRef";
    String description = "Product test description";
    String isRegisteredCustomer = "No";
    String language = "EN";
    String txnCurrency = "PKR";
    String txnDateTime = dateandtime.toString();
    String txnExpiryDateTime = dexpiredate.toString();
    String txnRefNumber = "TR$dateandtime";
    String txnType = "";
    String version = "2.0";
    String subMerchantID = "";
    String bankID = "";
    String productID = "";
    String ppmpf_1 = "";
    String ppmpf_2 = "";
    String ppmpf_3 = "";
    String ppmpf_4 = "";
    String ppmpf_5 = "";

    List<String> HashArray = [
      amount,
      bankID,
      billReference,
      description,
      isRegisteredCustomer,
      language,
      merchantID,
      password,
      productID,
      returnURL,
      txnCurrency,
      txnDateTime,
      txnExpiryDateTime,
      txnRefNumber,
      txnType,
      version,
      subMerchantID,
      ppmpf_1,
      ppmpf_2,
      ppmpf_3,
      ppmpf_4,
      ppmpf_5
    ];

    String sortedArray = hashKey;
    for (int i = 0; i < HashArray.length; i++) {
      if (HashArray[i] != 'undefined' &&
          HashArray[i] != null &&
          HashArray[i] != "") {
        sortedArray += "&${HashArray[i]}";
      }
    }

    String securehash = sha256.convert(utf8.encode(sortedArray)).toString();

    var response = await http.post(Uri.parse(postURL), body: {
      "pp_Amount": amount,
      "pp_BankID": bankID,
      "pp_BillReference": billReference,
      "pp_Description": description,
      "pp_IsRegisteredCustomer": isRegisteredCustomer,
      "pp_Language": language,
      "pp_MerchantID": merchantID,
      "pp_Password": password,
      "pp_ProductID": productID,
      "pp_ReturnURL": returnURL,
      "pp_TxnCurrency": txnCurrency,
      "pp_TxnDateTime": txnDateTime,
      "pp_TxnExpiryDateTime": txnExpiryDateTime,
      "pp_TxnRefNo": txnRefNumber,
      "pp_TxnType": txnType,
      "pp_Version": version,
      "pp_SubMerchantID": subMerchantID,
      "ppmpf_1": ppmpf_1,
      "ppmpf_2": ppmpf_2,
      "ppmpf_3": ppmpf_3,
      "ppmpf_4": ppmpf_4,
      "ppmpf_5": ppmpf_5,
      "pp_SecureHash": securehash
    });

    print('Response status: ${response.statusCode}');
    print(response.body);
  }
}
