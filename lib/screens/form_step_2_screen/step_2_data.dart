import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime insurancePeriodIssueDate = DateTime.now();
DateTime insurancePeriodExpiryDate =
    insurancePeriodIssueDate.add(const Duration(days: 364));

bool showTrackers = true;
String appliedForRegistartion = 'yes';
double seatingCapacity = 1;
String trackerInstalled = 'yes';

String additionalAccessories = 'no';
String personalAccidentValue = 'yes';

TextEditingController registrationNoController = TextEditingController();
TextEditingController engineNoController = TextEditingController();
TextEditingController chasisNoController = TextEditingController();
TextEditingController insuredEstimatedValueController = TextEditingController();
TextEditingController cubicCapacityController = TextEditingController();
TextEditingController contributionController = TextEditingController();

// dropdowns
TextEditingController productNameController = TextEditingController();
String? productNameValue;
String? productCodeValue;

TextEditingController vehicleMakeController = TextEditingController();
String? vehicleMakeNameValue;
String? vehcileMakeCodeValue;

TextEditingController vehicleModelController = TextEditingController();
String? vehicleModelValue;

TextEditingController colorController = TextEditingController();
String? colorValue;

TextEditingController bodyTypeController = TextEditingController();
String? bodyTypeValue;

TextEditingController vehicleVariantController = TextEditingController();
String? vehcileVariantCodeValue;
String? vehicleVariantNameValue;

TextEditingController trackingCompanyController = TextEditingController();
String? trackingCompanyCodeValue;

resetStep2Data() {
  showTrackers = true;
  appliedForRegistartion = 'yes';
  seatingCapacity = 1;
  trackerInstalled = 'yes';
  additionalAccessories = 'no';
  personalAccidentValue = 'yes';

  registrationNoController.clear();
  engineNoController.clear();
  chasisNoController.clear();
  insuredEstimatedValueController.clear();
  cubicCapacityController.clear();
  contributionController.clear();
  productNameController.clear();

  vehicleModelController.clear();
  vehicleMakeController.clear();
  colorController.clear();
  bodyTypeController.clear();
  vehicleVariantController.clear();
  trackingCompanyController.clear();

  productNameValue = null;
  productCodeValue = null;
  vehicleMakeNameValue = null;
  vehcileMakeCodeValue = null;
  vehicleModelValue = null;
  colorValue = null;
  bodyTypeValue = null;
  vehicleVariantNameValue = null;
  trackingCompanyCodeValue = null;
}

saveStep2Data() async {
  String registrationNoText = appliedForRegistartion != 'yes'
      ? registrationNoController.text.toString()
      : '';

  SharedPreferences prefs = await SharedPreferences.getInstance();

  var toBeEncryptedData = {
    "VProductID": productCodeValue ?? '',
    "VRegNo": registrationNoText,
    "VEngineNo": engineNoController.text.toString(),
    "VChasisNo": chasisNoController.text.toString(),
    "VVMake": vehcileMakeCodeValue ?? '',
    "VVVariant": vehicleVariantNameValue ?? '',
    "VVModel": vehicleModelValue ?? '',
    "VColor": colorValue ?? '',
    "VCubicCapacity": cubicCapacityController.text.toString(),
    "VSeatingCapacity": seatingCapacity.toInt().toString(),
    "VTrackingCompany": trackingCompanyCodeValue ?? '',
    "VIEV": insuredEstimatedValueController.text.toString(),
    "VContr": contributionController.text.toString(),
  };

  var data = {
    "VAFR": appliedForRegistartion == 'yes',
    "VTrackerInstalled": trackerInstalled == 'yes',
    "VAdditionalAcces": additionalAccessories != "no",
    "VPersonalAccident": personalAccidentValue == 'yes',
    "VFrom": insurancePeriodIssueDate.toIso8601String(),
    "VTo": insurancePeriodExpiryDate.toIso8601String(),
    "RecordDateTime": DateTime.now().toIso8601String(),
  };

  prefs.setString('step2DataE', jsonEncode(toBeEncryptedData));
  prefs.setString('step2Data', jsonEncode(data));
}
