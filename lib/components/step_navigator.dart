import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';

stepNavigatorComponent(
    {dynamic Function()? onPressedStep1,
    dynamic Function()? onPressedStep2,
    dynamic Function()? onPressedStep3,
    Color step1Color = kStepButtonColor,
    Color step2Color = kStepButtonColor,
    Color step3Color = kStepButtonColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: kDefaultPadding,
    ),
    child: Row(
      children: [
        NavigateButton(
          text: 'Step 1',
          onPressed: onPressedStep1,
          color: step1Color,
        ),
        const Expanded(
          child: Divider(
            color: kStepButtonColor,
            thickness: 4,
          ),
        ),
        NavigateButton(
          text: 'Step 2',
          onPressed: onPressedStep2,
          color: step2Color,
        ),
        const Expanded(
          child: Divider(
            color: kStepButtonColor,
            thickness: 4,
          ),
        ),
        NavigateButton(
          text: 'Step 3',
          onPressed: onPressedStep3,
          color: step3Color,
        ),
      ],
    ),
  );
}
