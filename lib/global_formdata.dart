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

TextEditingController engineNoController = TextEditingController();
TextEditingController chasisNoController = TextEditingController();
TextEditingController insuredEstimatedValueController = TextEditingController();
TextEditingController cubicCapacityController = TextEditingController();
TextEditingController seatingCapacityController = TextEditingController();
TextEditingController contributionController = TextEditingController();

// dropdowns
TextEditingController productNameController = TextEditingController();
String? productValue;

TextEditingController vehicleMakeController = TextEditingController();
String? vehicleMakeValue;

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
XFile? imageCarBack;
XFile? imageCarLeft;
XFile? imageCarRight;
XFile? imageCarHood;
XFile? imageCarBoot;

XFile? imageBikeFront;
XFile? imageBikeBack;
XFile? imageBikeLeft;
XFile? imageBikeRight;
