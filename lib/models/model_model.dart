import 'package:coverlo/helpers/helper_functions.dart';

class Model {
  String modelCode;
  String modelName;
  String makeName;
  String bodyType;

  Model({
    required this.modelCode,
    required this.modelName,
    required this.makeName,
    required this.bodyType,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      modelCode: decryptItem(json['ModelCode']),
      modelName: decryptItem(json['ModelName']),
      makeName: decryptItem(json['MakeName']),
      bodyType: decryptItem(json['BodyType']),
    );
  }
}
