import 'dart:convert';

import 'package:coverlo/form_fields/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();

TextEditingController addressController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
TextEditingController cnicController = TextEditingController();

DateTime? cnicIssueDateValue;
DateTime? dateOfBirthValue;

// dropdowns
TextEditingController cityController = TextEditingController();
String? cityNameValue;
String? cityCodeValue;

TextEditingController countryController = TextEditingController();
String? countryCodeValue;
String? countryNameValue;

TextEditingController genderController = TextEditingController();
String? genderValue;

TextEditingController professionController = TextEditingController();
String? professionValue;

resetStep1Data() {
  firstNameController.clear();
  lastNameController.clear();
  addressController.clear();
  emailController.clear();
  mobileNoController.clear();
  cnicController.clear();
  cityController.clear();
  countryController.clear();
  genderController.clear();
  professionController.clear();

  cnicIssueDateValue = null;
  dateOfBirthValue = null;
  cityCodeValue = null;
  countryCodeValue = null;
  countryNameValue = null;
  genderValue = null;
  professionValue = null;
}

String pkPhoneRegex =
    r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';
String cnicRegex = r'^[0-9]{1,13}$';
String passportRegex = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
String emailRegex =
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

bool cnicValidated() {
  String regexToCheck =
      countryNameValue == "PAKISTAN" ? cnicRegex : passportRegex;
  return regexMatched(cnicController.text, regexToCheck) &&
      cnicController.text.isNotEmpty &&
      cnicController.text.length == (countryNameValue == "PAKISTAN" ? 13 : 9);
}

bool mobileValidated() {
  return regexMatched(mobileNoController.text, pkPhoneRegex) &&
      mobileNoController.text.isNotEmpty;
}

saveStep1Data() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cnicText = cnicController.text.toString();

  if (countryNameValue?.toLowerCase() == 'pakistan') {
    cnicText =
        '${cnicText.substring(0, 5)}-${cnicText.substring(5, 12)}-${cnicText.substring(12, 13)}';
  }

  var toBeEncryptedData = {
    "PName": '${firstNameController.text} ${lastNameController.text}',
    "PAddress": addressController.text.toString(),
    "PCity": cityCodeValue ?? '',
    "PNationality": countryCodeValue ?? '',
    "PPassportNo": cnicText,
    "PGender": genderValue ?? '',
    "PProfession": professionValue ?? '',
    "PMobileNo": mobileNoController.text.toString(),
    "PEmail": emailController.text.toString(),
  };

  var data = {
    "PCNICDate": cnicIssueDateValue?.toIso8601String(),
    "PDOB": dateOfBirthValue?.toIso8601String(),
  };

  prefs.setString('step1DataE', jsonEncode(toBeEncryptedData));
  prefs.setString('step1Data', jsonEncode(data));
}
