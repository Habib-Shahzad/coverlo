import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Model {
  String modelCode;
  String modelName;
  String makeName;

  Model({
    required this.modelCode,
    required this.modelName,
    required this.makeName,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      modelCode: decryptItem(json['modelCode']),
      modelName: decryptItem(json['modelName']),
      makeName: decryptItem(json['makeName']),
    );
  }

  factory Model.fromXml(XmlElement xml) {
    final modelCode = xml.findElements('modelCode').single.text;
    final modelName = xml.findElements('modelName').single.text;
    final makeName = xml.findElements('makeName').single.text;

    return Model(
      modelCode: decryptItem(modelCode),
      modelName: decryptItem(modelName),
      makeName: decryptItem(makeName),
    );
  }
}
