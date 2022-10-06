import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  const CustomText({
    Key? key,
    required this.text,
    this.color = kTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
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
        ).value,
      ),
    );
  }
}
