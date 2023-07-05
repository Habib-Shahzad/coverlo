import 'dart:convert';

import 'package:coverlo/constants.dart';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/screens/form_step_1_screen/step_1_data.dart';
import 'package:coverlo/screens/form_step_2_screen/step_2_data.dart';
import 'package:coverlo/screens/form_step_3_screen/step_3_data.dart';
import 'package:coverlo/screens/payment_screen/data_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? sessionInsuranceId;

void setStep1Data() {
  firstNameController.text = 'Muhammad';
  lastNameController.text = 'Ali';
  addressController.text = 'House 232';
  emailController.text = 'ok@ok.com';
  mobileNoController.text = '03001234567';
  cnicController.text = '1234567890123';

  cnicIssueDateValue = DateTime.now();
  dateOfBirthValue = DateTime.now();

  cityController.text = '0';
  cityCodeValue = '00101001';
  cityNameValue = 'Islamabad';

  countryController.text = '0';
  countryCodeValue = 'PK';
  countryNameValue = 'PAKISTAN';

  genderController.text = '0';
  genderValue = 'Male';

  professionController.text = '0';
  professionValue = 'Accountant';
}

void setStep2Data() {
  productNameController.text = '0';
  productNameValue = privateCar;
  productCodeValue = 'V001';

  engineNoController.text = '1234567890123';
  chasisNoController.text = '1234567890123';

  vehicleMakeController.text = '0';
  vehicleMakeNameValue = 'HYUNDAI';
  vehcileMakeCodeValue = 'HYUNDAI';

  vehicleModelController.text = '0';
  vehicleModelValue = '2023';

  colorController.text = '0';
  colorValue = 'Black';

  bodyTypeController.text = '0';
  bodyTypeValue = 'Sedan';

  vehicleVariantController.text = '0';
  vehcileMakeCodeValue = '0300101';
  vehicleVariantNameValue = 'HYUNDAI  SANTRO CLUB';

  trackingCompanyController.text = '0';
  trackingCompanyCodeValue = '001';

  registrationNoController.text = 'ABC-123';

  cubicCapacityController.text = '1800';

  contributionController.text = '10000';

  insuredEstimatedValueController.text = '100000';
}

Map<String, String> _convertToStringMap(Map<dynamic, dynamic> map) {
  var result = <String, String>{};
  map.forEach((key, value) {
    result[key.toString()] = value.toString();
  });
  return result;
}

Future<Map<String, String>> getFormData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map step1Data = jsonDecode(prefs.getString('step1Data') ?? '{}');
  Map step1EncryptedData = (jsonDecode(prefs.getString('step1DataE') ?? '{}'));

  step1EncryptedData = Des.encryptMap(_convertToStringMap(step1EncryptedData));

  Map step2Data = jsonDecode(prefs.getString('step2Data') ?? '{}');
  Map step2EncryptedData = (jsonDecode(prefs.getString('step2DataE') ?? '{}'));
  step2EncryptedData = Des.encryptMap(_convertToStringMap(step2EncryptedData));

  Map formData = {};
  formData.addAll(step1Data);
  formData.addAll(step1EncryptedData);
  formData.addAll(step2Data);
  formData.addAll(step2EncryptedData);

  // copyToClipboard(jsonEncode(_convertToStringMap(formData)));

  return _convertToStringMap(formData);
}

void setDebuggingFormData() {
  setStep1Data();
  setStep2Data();
}

void resetFormData() async {
  try {
    resetStep1Data();
    resetStep2Data();
    resetStep3Data();
  } catch (e) {
    // print("ERROR");
    // print(e.toString());
  }
}

saveInformation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> json = {
    "First Name": firstNameController.text,
    "Last Name": lastNameController.text,
    "Email": emailController.text,
    "Mobile Number": mobileNoController.text,
    "Address": addressController.text,
    "Country": "PK",
    "City": cityNameValue ?? "",
    "Product Code": productCodeValue ?? "",
    "Vehicle Make Code": vehcileMakeCodeValue ?? "",
    "Vehicle Model": vehicleModelValue ?? "",
    "Insurance Amount": contributionController.text,
  };

  prefs.setString('insuranceInfo', jsonEncode(json));
}
