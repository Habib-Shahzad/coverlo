import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

dropDownFormFieldMethod(
  BuildContext context,
  GlobalKey<FormFieldState> key,
  String hintText,
  Object? val,
  List<DropdownMenuItem<Object>> items,
  List<Map<String, String>> itemMap,
  String name,
  bool isReadOnly,
  Function(Object?)? callBack, {
  bool nullValidation = false,
  bool controlled = false,
  int? dropDownValue,
}) {
  return DropdownButtonFormField(
    items: items,
    validator: (value) {
      if (nullValidation) {
        if (value == null) {
          return "$hintText is required";
        }
      }
      return null;
    },
    isExpanded: true,
    // optional value param based on controlled bool
    value: controlled ? dropDownValue : null,
    key: key,
    onChanged: isReadOnly
        ? null
        : (value) {
            if (callBack != null) {
              callBack(value);
            }
          },
    iconSize: 5,
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
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: Icon(
        Icons.arrow_drop_down,
        color: kFormIconColor,
        size: ResponsiveValue(
          context,
          defaultValue: kFormArrowIconFontSize,
          valueWhen: [
            const Condition.largerThan(
              name: MOBILE,
              value: 24.0,
            ),
          ],
        ).value,
      ),
      suffixIconColor: kFormLabelColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kDefaultFontSize,
      ),
      fillColor: kFormFieldBackgroundColor,
      filled: true,
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
        color: kFormLabelColor,
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
