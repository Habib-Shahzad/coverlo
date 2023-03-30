import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Profession {
  String professionName;
  String professionCode;

  Profession({required this.professionName, required this.professionCode});

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      professionName: decryptItem(json['ProfessionName']),
      professionCode: decryptItem(json['ProfessionCode'])
    );
  }

  factory Profession.fromXml(XmlElement xml) {
    final professionName = xml.findElements('ProfessionName').single.text;
    final professionCode = xml.findElements('ProfessionCode').single.text;

    return Profession(
        professionName: decryptItem(professionName),
        professionCode: decryptItem(professionCode)
    );
  }
}
