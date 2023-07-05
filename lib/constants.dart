import 'package:flutter/material.dart';

const kGradientColorTop = Color(0xFF8234C3);
const kGradientColorBottom = Color(0xFFBB6245);
const kPrimaryColor = Color(0xFF7F0081);
const kSecondaryColor = Color(0xFF8234C3);
const kBackgroundColor = Color(0xFFE5E5E5);
const kErrorColor = Color(0xFF840000);
const kTextColor = Color.fromRGBO(255, 255, 255, 1);
const kDisabledTextColor = Color.fromRGBO(0, 0, 0, 0.5);
const kCursorColor = Color.fromARGB(255, 0, 0, 0);
const kDarkTextColor = Color(0xFF333333);
const kIconColor = Colors.white;
const kStepButtonColor = Color(0xFF817F82);
const kStepButtonActiveColor = Color(0xFFFEA500);

const kFormLabelColor = Color(0xFFCCCCCC);
const kFormTextColor = Colors.black;
const kFormFieldBackgroundColor = Colors.white;
const kFormBorderColor = Colors.white;
const kFormIconColor = Colors.black;
const kFormRadioActiveColor = Color(0xFFFF3e81);
const kFormSubHeadingColor = Color(0xFF848484);
const kFormReadyOnlyBackgroundColor = Color(0xFF817F82);
const kFormReadOnlyTextColor = Color(0xFF545454);
const kFormLightOpacityBlack = Color.fromRGBO(0, 0, 0, 0.5);

const kDefaultFontSize = 16.0;
const kFormSubHeadingFontSize = 18.0;
const kSubHeadingFontSize = 21.0;
const kMainHeadingFontSize = 26.0;
const kDefaultIconSize = 34.0;

const kDefaultPadding = 20.0;

const kDefaultBorderRadius = 10.0;
const kMaxBorderRadius = 50.0;

const kMinSpacing = 10.0;
const kDefaultSpacing = 20.0;
const kSpacingBottom = 50.0;
const kMaxSpacing = 100.0;

const kDefaultImageWidth = 400.0;
const kDefaultLogoWidth = 90.0;
const kFormArrowIconFontSize = 40.0;
const kFormCalendarIconFontSize = 25.0;

const onBoardingImage = 'assets/images/onboarding_image.png';
const loginImage = 'assets/images/login_image.png';
const logoImage = 'assets/logos/logo.png';

String privateCar = 'PRIVATE CAR (COMPREHENSIVE COVER)';
String thirdParty = 'THIRD PARTY';
String motorCycle = 'MOTOR CYCLE (COMPREHENSIVE COVER)';

class VehicleModel {
  String year;
  VehicleModel({required this.year});
}

List<VehicleModel> getYears(numYears) {
  return List.generate(numYears, (i) {
    String dateYear = (DateTime.now().year - i).toString();
    return VehicleModel(year: dateYear);
  });
}

var carModelsList = getYears(10);

final carModelsDropDownItems = List.generate(carModelsList.length, (i) {
  VehicleModel item = carModelsList[i];
  return DropdownMenuItem(value: i, child: Text(item.year));
});

var bikeModelsList = getYears(5);

final bikeModelsDropDownItems = List.generate(bikeModelsList.length, (i) {
  VehicleModel item = bikeModelsList[i];
  return DropdownMenuItem(value: i, child: Text(item.year));
});
