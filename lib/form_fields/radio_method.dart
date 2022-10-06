import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

Row radioMethod(BuildContext context, String label, String value,
    String groupValue, Function(String) onChanged) {
  return Row(
    children: [
      Radio(
        value: value,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeColor: kFormRadioActiveColor,
        groupValue: groupValue,
        onChanged: (String? value) {
          onChanged(value!);
        },
      ),
      Text(
        label,
        style: TextStyle(
          color: kFormTextColor,
          fontSize: ResponsiveValue(
            context,
            defaultValue: kDefaultFontSize,
            valueWhen: [
              const Condition.largerThan(
                name: MOBILE,
                value: 18.0,
              ),
            ],
          ).value,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
