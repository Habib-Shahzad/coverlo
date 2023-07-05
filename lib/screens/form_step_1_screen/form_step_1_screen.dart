import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/step_navigator.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/form_step_1_screen/step_1_data.dart';
import 'package:coverlo/screens/form_step_1_screen/step_1_form.dart';
import 'package:coverlo/screens/form_step_2_screen/form_step_2_screen.dart';
import 'package:flutter/material.dart';

class FormStep1Screen extends StatelessWidget {
  static const String routeName = '/form_step_1_screen';
  final _formKey = GlobalKey<FormState>();
  FormStep1Screen({Key? key}) : super(key: key);

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
                  onPressedStep2: () async {
                    bool validMobile = mobileValidated();
                    bool validCnic = cnicValidated();
                    bool formValidated = validMobile &&
                        validCnic &&
                        _formKey.currentState!.validate();

                    if (formValidated) {
                      await saveStep1Data();
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          FormStep2Screen.routeName,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill all the fields')),
                      );
                    }
                  },
                  step1Color: kStepButtonActiveColor,
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
                Step1Form(formKey: _formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
