import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Make {
  String makeName;
  String makeCode;

  Make({required this.makeName, required this.makeCode});

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
        makeName: decryptItem(json['makeName']),
        makeCode: decryptItem(json['makeCode']));
  }

  factory Make.fromXml(XmlElement xml) {
    final makeName = xml.findElements('makeName').single.text;
    final makeCode = xml.findElements('makeCode').single.text;

    return Make(
        makeName: decryptItem(makeName),
        makeCode: decryptItem(makeCode));
  }
}
