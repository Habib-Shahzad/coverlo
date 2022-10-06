import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.buttonText,
    this.onPressed,
    required this.buttonColor,
  }) : super(key: key);

  final String buttonText;
  final Function()? onPressed;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        minimumSize: const Size.fromHeight(55),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveValue(
              context,
              defaultValue: kDefaultFontSize,
              valueWhen: [
                const Condition.largerThan(
                  name: MOBILE,
                  value: 20.0,
                ),
              ],
            ).value),
      ),
    );
  }
}
