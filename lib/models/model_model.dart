import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  String modelName;
  String makeName;

  ModelResponse({
    required this.modelName,
    required this.makeName,
  });

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'modelName': json['modelName'],
      'makeName': json['makeName'],
    });

    return ModelResponse(
      modelName: decryptedData['modelName'] ?? '',
      makeName: decryptedData['makeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'modelName': modelName,
        'makeName': makeName,
      };
}
