import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';

SliderTheme sliderThemeMethod(
    BuildContext context, double radius, Function(double) onChanged) {
  return SliderTheme(
    data: const SliderThemeData(
        thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 3)),
    child: Slider(
      min: 1,
      max: 2,
      value: radius,
      activeColor: kFormRadioActiveColor,
      inactiveColor: kTextColor,
      thumbColor: kFormRadioActiveColor,
      onChanged: (value) {
        onChanged(value);
      },
    ),
  );
}
