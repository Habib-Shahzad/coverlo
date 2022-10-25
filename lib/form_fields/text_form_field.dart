import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

bool regexMatched(String value, regexPattern) {
  RegExp regex = RegExp(regexPattern);
  return regex.hasMatch(value);
}

TextFormField textFormFieldMethod(
  BuildContext context,
  String hintText,
  TextEditingController controller,
  bool hasPrefix,
  bool isReadOnly,
  TextInputType type, {
  bool regexValidation = false,
  String regexPattern = "",
  String? regexValidationText,
  bool nullValidation = false,
  FocusNode? focusNode,
  bool fieldInputError = false,
  
}) {
  return TextFormField(
    focusNode: focusNode,
    cursorColor: kCursorColor,
    controller: controller,
    readOnly: isReadOnly,
    keyboardType: type,
    validator: (value) {
      if (focusNode == null) {
        if (nullValidation) {
          if (value != null && value.isEmpty) {
            return "$hintText is required";
          }
        }
        if (regexValidation) {
          if (!regexMatched(value!, regexPattern)) {
            if (regexValidationText != null) {
              return regexValidationText;
            } else {
              return "Please enter valid $hintText";
            }
          }
        }
        return null;
      }
      return null;
    },
    style: TextStyle(
      color: isReadOnly ? kTextColor : kFormTextColor,
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
    decoration: InputDecoration(
      hintText: hintText,
      errorText: fieldInputError ? regexValidationText : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kDefaultFontSize,
      ),
      fillColor: isReadOnly
          ? kFormReadyOnlyBackgroundColor
          : kFormFieldBackgroundColor,
      filled: true,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      prefixIcon: hasPrefix
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
              ),
              child: Text(
                'Rs.',
                style: TextStyle(
                  color: kFormIconColor,
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: const BorderSide(color: kFormBorderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: const BorderSide(color: kFormBorderColor)),
      errorStyle: const TextStyle(color: kErrorColor),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: const BorderSide(color: kErrorColor)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          borderSide: const BorderSide(color: kErrorColor)),
      hintStyle: TextStyle(
        color: isReadOnly ? kFormReadOnlyTextColor : kFormLabelColor,
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
  );
}
