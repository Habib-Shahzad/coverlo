import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/screens/form_step_1_screen/form_step_1_screen.dart';
import 'package:coverlo/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody(
      {super.key, required this.loggedIn, required this.loading});

  final bool loggedIn;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            onBoardingImage,
            width: ResponsiveValue(
              context,
              defaultValue: kDefaultImageWidth,
              valueWhen: [
                const Condition.largerThan(
                  name: MOBILE,
                  value: 24.0,
                ),
              ],
            ).value,
          ),
        ),
        const SizedBox(height: kMinSpacing),
        const MainHeading(
            headingText: 'Ab healthy precautions\nkay saath saath Coverlo.',
            color: kTextColor,
            fontWeight: FontWeight.w400),
        const SizedBox(height: kMinSpacing),
        CustomButton(
          buttonText: loading ? 'Please wait...' : 'Get Started',
          onPressed: () {
            if (loading) {
              return;
            }
            
            if (loggedIn) {
              Navigator.pushNamed(context, FormStep1Screen.routeName);
            } else {
              Navigator.pushNamed(context, LoginScreen.routeName);
            }
          },
          buttonColor: kSecondaryColor,
        ),
        const SizedBox(height: kMaxSpacing),
      ],
    );
  }
}
