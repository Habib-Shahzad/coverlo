import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FormSubHeading extends StatelessWidget {
  final String text;
  const FormSubHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: kFormSubHeadingColor,
        fontWeight: FontWeight.w500,
        fontSize: ResponsiveValue(
          context,
          defaultValue: kFormSubHeadingFontSize,
          valueWhen: [
            const Condition.largerThan(
              name: MOBILE,
              value: 20.0,
            ),
          ],
        ).value,
      ),
    );
  }
}
