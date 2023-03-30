import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Color {
  final String colorName;
  final String colorCode;

  Color({required this.colorName, required this.colorCode});

  factory Color.fromJson(Map<String, dynamic> json) {

    
    return Color(
        colorName: decryptItem(json['colorName']),
        colorCode: decryptItem(json['colorCode']));
  }

  factory Color.fromXml(XmlElement xml) {
    final colorName = xml.findElements('colorName').single.text;
    final colorCode = xml.findElements('colorCode').single.text;

    return Color(
        colorName: decryptItem(colorName),
        colorCode: decryptItem(colorCode));
  }
}
