import 'package:coverlo/constants.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

Theme dateTimeFormFieldMethod(
    BuildContext context, String hintText, Function(DateTime?) setDate) {
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
      dateFormat: DateFormat('dd-MM-yyyy'),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      dateTextStyle: TextStyle(
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
        hintText: hintText,
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
    ),
  );
}
