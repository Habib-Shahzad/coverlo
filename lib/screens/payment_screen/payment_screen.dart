import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/web_view.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/payment_screen/hbl_payment.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/screens/payment_screen/jazz_cash.dart';

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

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        contribution = args['contribution'];
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
                    buttonText: 'Pay with HBL',
                    buttonColor: kSecondaryColor,
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
