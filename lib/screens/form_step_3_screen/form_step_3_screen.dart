import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/form_step_3_screen/hbl_payment.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/screens/form_step_3_screen/jazz_cash.dart';

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
                      paymentJazzCash(displayJazzCashWebView);
                    },
                    child: const Text("Pay with JazzCash"),
                  ),
                  TextButton(
                    onPressed: () {
                      paymentHBL(displayHblPaymentWebView);
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
