import 'package:camera/camera.dart';
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
