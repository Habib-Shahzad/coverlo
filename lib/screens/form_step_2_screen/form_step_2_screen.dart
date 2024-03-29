import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/step_navigator.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/components/message_dialog.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/form_step_2_screen/step_2_data.dart';
import 'package:coverlo/screens/form_step_2_screen/step_2_form.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:flutter/material.dart';

class FormStep2Screen extends StatefulWidget {
  static const String routeName = '/form_step_2_screen';

  const FormStep2Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<FormStep2Screen> createState() => _FormStep2ScreenState();
}

class _FormStep2ScreenState extends State<FormStep2Screen> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stepNavigatorComponent(
                  step2Color: kStepButtonActiveColor,
                  onPressedStep1: () {
                    Navigator.pop(context);
                  },
                  onPressedStep3: () async {
                    if (contributionController.text.isNotEmpty &&
                        productNameValue != null &&
                        productNameValue!.isNotEmpty) {
                      await saveStep2Data();

                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          FormStep3Screen.routeName,
                          arguments: {
                            "contribution": contributionController.text,
                            "productName": productNameValue,
                          },
                        );
                      }
                    } else {
                      AlertDialog alert = messageDialog(
                          context, "Error", "Please fill all fields");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: kDefaultSpacing),
                const Center(
                  child: MainHeading(
                      headingText: 'Motor Vehicle Cover',
                      color: kDarkTextColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: kDefaultSpacing),
                const SubHeading(
                    headingText: 'Vehicle Details', color: kDarkTextColor),
                const SizedBox(height: kMinSpacing),
                const Step2Form(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
