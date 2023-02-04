import 'package:coverlo/des/des.dart';

import 'package:coverlo/env/env.dart';

class ModelModel {
  List<ModelResponse> modelList = [];

  ModelModel({
    required this.modelList,
  });

  factory ModelModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return ModelModel(
        modelList: (json['_Model'] as List)
            .map((model) => ModelResponse.fromJson(model))
            .toList(),
      );
    }
    return ModelModel(
      modelList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'modelList': List<dynamic>.from(modelList.map((x) => x.toJson())),
      };
}

class ModelResponse {
  String modelCode;
  String modelName;
  String makeName;

  ModelResponse({
    required this.modelCode,
    required this.modelName,
    required this.makeName,
  });

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    dynamic modelCode = json['modelCode'];

    modelCode ??= Des.encrypt(Env.appKey, '');

    Map<String, String> decryptedData = Des.decryptMap(Env.appKey, {
      'modelCode': modelCode,
      'modelName': json['modelName'],
      'makeName': json['makeName'],
    });

    return ModelResponse(
      modelCode: decryptedData['modelCode'] ?? '',
      modelName: decryptedData['modelName'] ?? '',
      makeName: decryptedData['makeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'modelCode': modelCode,
        'modelName': modelName,
        'makeName': makeName,
      };
}
