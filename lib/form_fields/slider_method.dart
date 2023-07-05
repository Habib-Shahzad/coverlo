import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';

SliderTheme sliderThemeMethod(BuildContext context, double radius,
    Function(double) onChanged, int minCap, int maxCap,
    {bool readOnly = false}) {
  return SliderTheme(
    data: SliderThemeData(
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 10,
        elevation: 3,
      ),
      trackShape: readOnly ? const RoundedRectSliderTrackShape() : null,
      // Additional properties based on `readOnly` value...
    ),
    child: Slider(
      min: minCap.toDouble(),
      max: maxCap.toDouble(),
      divisions: maxCap - 1,
      value: radius,
      activeColor: kFormRadioActiveColor,
      inactiveColor: kTextColor,
      thumbColor: kFormRadioActiveColor,
      onChanged: readOnly ? null : onChanged,
    ),
  );
}
