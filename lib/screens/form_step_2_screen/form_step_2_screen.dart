import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/layouts/main_layout.dart';
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
  final TextEditingController _contributionController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();

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
                          },
                          color: kStepButtonColor),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      const NavigateButton(
                        text: 'Step 2',
                        onPressed: null,
                        color: kStepButtonActiveColor,
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
                          if (_contributionController.text.isNotEmpty &&
                              _productNameController.text.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              FormStep3Screen.routeName,
                              arguments: {
                                "contribution": _contributionController.text,
                                "productName": _productNameController.text,
                              },
                            );
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
                        color: kStepButtonColor,
                      ),
                    ],
                  ),
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
                Step2Form(
                    contributionController: _contributionController,
                    productNameController: _productNameController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
