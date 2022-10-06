import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/form_step_1_screen/step_1_form.dart';
import 'package:coverlo/screens/form_step_2_screen/form_step_2_screen.dart';
import 'package:flutter/material.dart';

class FormStep1Screen extends StatelessWidget {
  static const String routeName = '/form_step_1_screen';
  const FormStep1Screen({
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Row(
                    children: [
                      const NavigateButton(
                          text: 'Step 1',
                          onPressed: null,
                          color: kStepButtonActiveColor),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      NavigateButton(
                        text: 'Step 2',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            FormStep2Screen.routeName,
                          );
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
                    headingText: 'Personal Details', color: kDarkTextColor),
                const SizedBox(height: kMinSpacing),
                const Step1Form(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
