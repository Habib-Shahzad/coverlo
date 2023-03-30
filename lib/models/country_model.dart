import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Country {
  String countryName;
  String countryCode;

  Country({required this.countryName, required this.countryCode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        countryName: decryptItem(json['countryName']),
        countryCode: decryptItem(json['countryCode']));
  }

  factory Country.fromXml(XmlElement xml) {
    final countryName = xml.findElements('countryName').single.text;
    final countryCode = xml.findElements('countryCode').single.text;

    return Country(
        countryName: decryptItem(countryName),
        countryCode: decryptItem(countryCode));
  }
}
