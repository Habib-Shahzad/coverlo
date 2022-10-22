import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';

SliderTheme sliderThemeMethod(
    BuildContext context, double radius, Function(double) onChanged, int minCap, int maxCap) {
  return SliderTheme(
    data: const SliderThemeData(
        thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 3)),
    child: Slider(
      min: minCap.toDouble(),
      max: maxCap.toDouble(),
      divisions: maxCap - 1 ,
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
