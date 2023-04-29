import 'package:coverlo/helpers/helper_functions.dart';

class Country {
  String countryName;
  String countryCode;

  Country({required this.countryName, required this.countryCode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: decryptItem(json['CountryName']),
        countryCode: decryptItem(json['CCode']));
  }
}
