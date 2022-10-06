import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SubHeading extends StatelessWidget {
  final String headingText;
  final Color color;
  const SubHeading({
    Key? key,
    required this.headingText,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      headingText,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: ResponsiveValue(
          context,
          defaultValue: kSubHeadingFontSize,
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
