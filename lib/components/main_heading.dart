import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainHeading extends StatelessWidget {
  final String headingText;
  final Color color;
  final FontWeight fontWeight;
  const MainHeading({
    Key? key,
    required this.headingText,
    required this.color,
    required this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: ResponsiveValue(
          context,
          defaultValue: kMainHeadingFontSize,
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
