import 'package:camera/camera.dart';
import 'package:coverlo/des/des.dart';
import 'package:flutter/material.dart';

// STEP 01 data
TextEditingController nameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
TextEditingController cnicController = TextEditingController();

DateTime? cnicIssueDateValue;
DateTime? dateOfBirthValue;

// dropdowns
TextEditingController cityController = TextEditingController();
String? cityValue;

TextEditingController countryController = TextEditingController();
String? countryCodeValue;
String? countryValue;

TextEditingController genderController = TextEditingController();
String? genderValue;

TextEditingController professionController = TextEditingController();
String? professionValue;

// STEP 02 data
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
TextEditingController seatingCapacityController = TextEditingController();
TextEditingController contributionController = TextEditingController();

// dropdowns
TextEditingController productNameController = TextEditingController();
String? productValue;
String? productCodeValue;

TextEditingController vehicleMakeController = TextEditingController();
String? vehicleMakeValue;
String? vehcileMakeCodeValue;

TextEditingController vehicleModelController = TextEditingController();
String? vehicleModelValue;

TextEditingController colorController = TextEditingController();
String? colorValue;

TextEditingController bodyTypeController = TextEditingController();
String? bodyTypeValue;

TextEditingController vehicleVariantController = TextEditingController();
String? vehicleVariantValue;

TextEditingController trackingCompanyController = TextEditingController();
String? trackingCompanyValue;

// STEP 03: data
XFile? imageCarFront;
List<int>? bytesCarFront;

XFile? imageCarBack;
List<int>? bytesCarBack;

XFile? imageCarLeft;
List<int>? bytesCarLeft;

XFile? imageCarRight;
List<int>? bytesCarRight;

XFile? imageCarHood;
List<int>? bytesCarHood;

XFile? imageCarBoot;
List<int>? bytesCarBoot;

XFile? imageBikeFront;
List<int>? bytesBikeFront;

XFile? imageBikeBack;
List<int>? bytesBikeBack;

XFile? imageBikeLeft;
List<int>? bytesBikeLeft;

XFile? imageBikeRight;
List<int>? bytesBikeRight;

void setStep1Data() {
  nameController.text = 'Muhammad Usman';
  addressController.text = 'House # 123, Street # 123, Sector # 123';
  emailController.text = 'ok@ok.com';
  mobileNoController.text = '03001234567';
  cnicController.text = '1234567890123';

  cnicIssueDateValue = DateTime.now();
  dateOfBirthValue = DateTime.now();

  cityController.text = '0';
  cityValue = 'Islamabad';

  countryController.text = '0';
  countryCodeValue = 'PK';
  countryValue = 'PAKISTAN';

  genderController.text = '0';
  genderValue = 'Male';

  professionController.text = '0';
  professionValue = 'Accountant';
}

void setStep2Data() {
  productNameController.text = '0';
  productValue = 'Motor';
  productCodeValue = 'MOTOR';

  engineNoController.text = '1234567890123';
  chasisNoController.text = '1234567890123';

  vehicleMakeController.text = '0';
  vehicleMakeValue = 'Honda';
  vehcileMakeCodeValue = 'HONDA';

  vehicleModelController.text = '0';
  vehicleModelValue = 'Civic';

  colorController.text = '0';
  colorValue = 'Black';

  bodyTypeController.text = '0';
  bodyTypeValue = 'Sedan';

  vehicleVariantController.text = '0';
  vehicleVariantValue = '1.8L';

  trackingCompanyController.text = '0';
  trackingCompanyValue = 'GSM';

  registrationNoController.text = 'ABC-123';

  cubicCapacityController.text = '1800';
  seatingCapacityController.text = '5';

  contributionController.text = '10000';

  insuredEstimatedValueController.text = '100000';
}

Map<String, dynamic> getEncryptedFormData() {
  String cnicText = cnicController.text.toString();

  String registrationNoText = appliedForRegistartion != 'yes'
      ? registrationNoController.text.toString()
      : '';

  if (countryValue?.toLowerCase() == 'pakistan') {
    cnicText =
        '${cnicText.substring(0, 5)}-${cnicText.substring(5, 12)}-${cnicText.substring(12, 13)}';
  }

  Map<String, String> data = {
    "PName": nameController.text.toString(),
    "PAddress": addressController.text.toString(),
    "PCity": cityValue ?? '',
    "PNationality": countryCodeValue ?? '',
    "PPassportNo": cnicText,
    "PGender": genderValue ?? '',
    "PProfession": professionValue ?? '',
    "PMobileNo": mobileNoController.text.toString(),
    "PEmail": emailController.text.toString(),
    "VProductID": productCodeValue ?? '',
    "VRegNo": registrationNoText,
    "VEngineNo": engineNoController.text.toString(),
    "VChasisNo": chasisNoController.text.toString(),
    "VVMake": vehcileMakeCodeValue ?? '',
    "VVVariant": vehicleVariantValue ?? '',
    "VVModel": vehicleModelValue ?? '',
    "VColor": colorValue ?? '',
    "VCubicCapacity": cubicCapacityController.text.toString(),
    "VSeatingCapacity": seatingCapacity.toInt().toString(),
    "VTrackingCompany": trackingCompanyValue ?? '',
    "VIEV": insuredEstimatedValueController.text.toString(),
    "VContr": contributionController.text.toString(),
  };

  return Des.encryptMap(data);
}

Map<String, dynamic> getFormData() {
  return {
    "VAFR": appliedForRegistartion == 'yes',
    "VTrackerInstalled": trackerInstalled == 'yes',
    "VAdditionalAcces": additionalAccessories != "no",
    "VPersonalAccident": personalAccidentValue == 'yes',
    "VFrom": insurancePeriodIssueDate.toIso8601String(),
    "VTo": insurancePeriodExpiryDate.toIso8601String(),
    "PCNICDate": cnicIssueDateValue?.toIso8601String(),
    "PDOB": dateOfBirthValue?.toIso8601String(),
    "RecordDateTime": DateTime.now().toIso8601String(),
  };
}

void setDebuggingFormData() {
  setStep1Data();
  setStep2Data();
}

void resetFormData() async {
  try {
    // STEP 01 data
    if (nameController.text.isNotEmpty) nameController.clear();
    if (addressController.text.isNotEmpty) addressController.clear();
    if (emailController.text.isNotEmpty) emailController.clear();
    if (mobileNoController.text.isNotEmpty) mobileNoController.clear();
    if (cnicController.text.isNotEmpty) cnicController.clear();

    if (cnicIssueDateValue != null) cnicIssueDateValue = null;
    if (dateOfBirthValue != null) dateOfBirthValue = null;

    if (cityController.text.isNotEmpty) cityController.clear();
    if (cityValue != null) cityValue = null;

    if (countryController.text.isNotEmpty) countryController.clear();
    if (countryCodeValue != null) countryCodeValue = null;
    if (countryValue != null) countryValue = null;

    if (genderController.text.isNotEmpty) genderController.clear();
    if (genderValue != null) genderValue = null;

    if (professionController.text.isNotEmpty) professionController.clear();
    if (professionValue != null) professionValue = null;

    // STEP 02 data
    // showTrackers = true;
    // appliedForRegistartion = 'yes';
    // seatingCapacity = 1;
    // trackerInstalled = 'yes';
    // additionalAccessories = 'no';
    // personalAccidentValue = 'yes';

    if (registrationNoController.text.isNotEmpty) {
      registrationNoController.clear();
    }
    if (engineNoController.text.isNotEmpty) engineNoController.clear();
    if (chasisNoController.text.isNotEmpty) chasisNoController.clear();
    if (insuredEstimatedValueController.text.isNotEmpty) {
      insuredEstimatedValueController.clear();
    }
    if (cubicCapacityController.text.isNotEmpty) {
      cubicCapacityController.clear();
    }
    if (seatingCapacityController.text.isNotEmpty) {
      seatingCapacityController.clear();
    }
    if (contributionController.text.isNotEmpty) contributionController.clear();
    if (productNameController.text.isNotEmpty) productNameController.clear();
    if (productValue != null) productValue = null;
    if (productCodeValue != null) productCodeValue = null;

    if (vehicleMakeController.text.isNotEmpty) vehicleMakeController.clear();
    if (vehicleMakeValue != null) vehicleMakeValue = null;
    if (vehcileMakeCodeValue != null) vehcileMakeCodeValue = null;

    if (vehicleModelController.text.isNotEmpty) vehicleModelController.clear();
    if (vehicleModelValue != null) vehicleModelValue = null;

    if (colorController.text.isNotEmpty) colorController.clear();
    if (colorValue != null) colorValue = null;

    if (bodyTypeController.text.isNotEmpty) bodyTypeController.clear();
    if (bodyTypeValue != null) bodyTypeValue = null;

    if (vehicleVariantController.text.isNotEmpty) {
      vehicleVariantController.clear();
    }
    if (vehicleVariantValue != null) vehicleVariantValue = null;

    if (trackingCompanyController.text.isNotEmpty) {
      trackingCompanyController.clear();
    }
    if (trackingCompanyValue != null) trackingCompanyValue = null;

    // STEP 03: data
    if (imageCarFront != null) imageCarFront = null;
    if (bytesCarFront != null) imageCarFront = null;

    if (imageCarBack != null) imageCarBack = null;
    if (bytesCarBack != null) imageCarBack = null;

    if (imageCarLeft != null) imageCarLeft = null;
    if (bytesCarLeft != null) imageCarLeft = null;

    if (imageCarRight != null) imageCarRight = null;
    if (bytesCarRight != null) imageCarRight = null;

    if (imageCarHood != null) imageCarHood = null;
    if (bytesCarHood != null) imageCarHood = null;

    if (imageCarBoot != null) imageCarBoot = null;
    if (bytesCarBoot != null) imageCarBoot = null;

    if (imageBikeFront != null) imageBikeFront = null;
    if (bytesBikeFront != null) imageBikeFront = null;

    if (imageBikeBack != null) imageBikeBack = null;
    if (bytesBikeBack != null) imageBikeBack = null;

    if (imageBikeLeft != null) imageBikeLeft = null;
    if (bytesBikeLeft != null) imageBikeLeft = null;

    if (imageBikeRight != null) imageBikeRight = null;
    if (bytesBikeRight != null) imageBikeRight = null;
  } catch (e) {
    // print("ERROR");
    // print(e.toString());
  }
}
