import 'package:xml/xml.dart';
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
        cityID: decryptItem(json['cityID']),
        cityName: decryptItem(json['cityName']),
        countryName: decryptItem(json['countryName']),
        cityCode: decryptItem(json['cityCode']));
  }

  factory City.fromXml(XmlElement xml) {
    final cityID = xml.findElements('cityID').single.text;
    final cityName = xml.findElements('cityName').single.text;
    final countryName = xml.findElements('countryName').single.text;
    final cityCode = xml.findElements('cityCode').single.text;

    return City(
        cityID: decryptItem(cityID),
        cityName: decryptItem(cityName),
        countryName: decryptItem(countryName),
        cityCode: decryptItem(cityCode));
  }
}
