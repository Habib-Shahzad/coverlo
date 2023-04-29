import 'package:coverlo/helpers/helper_functions.dart';

class City {
  final String cityID;
  final String cityName;
  final String countryName;
  final String cityCode;

  City(
      {required this.cityID,
      required this.cityName,
      required this.countryName,
      required this.cityCode});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        cityID: decryptItem(json['ID']),
        cityName: decryptItem(json['CityName']),
        countryName: decryptItem(json['CountryName']),
        cityCode: decryptItem(json['CityCode']));
  }

}
