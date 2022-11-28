import 'package:coverlo/constants.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

Theme dateTimeFormFieldMethod(
  BuildContext context,
  String hintText,
  Function(DateTime?) setDate, {
  bool disabled = false,
  bool ignoreFuture = false,
  DateTime? inititalDate,
  DateTime? disabledValue,
  bool nullValidation = false,
}) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        onPrimary: Colors.white,
        onSurface: kFormTextColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
      ),
    ),
    child: DateTimeFormField(
      onSaved: (value) {
        setDate(value);
      },
      onDateSelected: (value) => {
        setDate(value),
      },
          validator: (value) {
        if (nullValidation) {
          if (value == null) {
            return "$hintText is required";
          }
        }
        return null;
      },
      enabled: !disabled,
      initialValue: inititalDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: ignoreFuture ? DateTime.now() : null,
      dateFormat: DateFormat('dd-MM-yyyy'),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      dateTextStyle: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: kFormTextColor,
        fontSize: disabled ? 14.0 : kDefaultFontSize,
        fontWeight: FontWeight.w400,
      ),
      mode: DateTimeFieldPickerMode.date,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          maxWidth: kFormCalendarIconFontSize,
        ),
        suffixIcon: Icon(
          Icons.calendar_month,
          color: kFormIconColor,
          size: ResponsiveValue(
            context,
            defaultValue: kFormCalendarIconFontSize,
            valueWhen: [
              const Condition.largerThan(
                name: MOBILE,
                value: 24.0,
              ),
            ],
          ).value,
        ),
        hintText: disabled
            ? disabledValue != null
                ? DateFormat('dd-MM-yyyy').format(disabledValue)
                : ''
            : hintText,
        // remove padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
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
          color: disabled ? Colors.black : kFormLabelColor,
          fontSize: ResponsiveValue(
            context,
            defaultValue: disabled ? 14.0 : kDefaultFontSize,
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
    ),
  );
}
