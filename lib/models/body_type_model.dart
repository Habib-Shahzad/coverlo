import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class BodyTypeModel {
  List<BodyTypeResponse> bodyTypeList = [];

  BodyTypeModel({
    required this.bodyTypeList,
  });

  factory BodyTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return BodyTypeModel(
        bodyTypeList: (json['_Model'] as List)
            .map((bodyType) => BodyTypeResponse.fromJson(bodyType))
            .toList(),
      );
    }
    return BodyTypeModel(
      bodyTypeList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'bodyTypeList': List<dynamic>.from(bodyTypeList.map((x) => x.toJson())),
      };
}

class BodyTypeResponse {
  String bodyType;
  String modelName;

  BodyTypeResponse({
    required this.bodyType,
    required this.modelName,
  });

  factory BodyTypeResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'bodyType': json['bodyType'],
      'modelName': json['modelName'],
    });

    return BodyTypeResponse(
      bodyType: decryptedData['bodyType'] ?? '',
      modelName: decryptedData['modelName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'bodyType': bodyType,
        'modelName': modelName,
      };
}
