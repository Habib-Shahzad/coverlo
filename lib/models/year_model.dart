import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class YearModel {
  List<YearResponse> yearList = [];

  YearModel({
    required this.yearList,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return YearModel(
        yearList: (json['_ModelYear'] as List)
            .map((year) => YearResponse.fromJson(year))
            .toList(),
      );
    }
    return YearModel(
      yearList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'yearList': List<dynamic>.from(yearList.map((x) => x.toJson())),
      };
}

class YearResponse {
  String yearName;
  String modelName;

  YearResponse({
    required this.yearName,
    required this.modelName,
  });

  factory YearResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'yearName': json['yearName'],
      'modelName': json['modelName'],
    });

    return YearResponse(
      yearName: decryptedData['yearName'] ?? '',
      modelName: decryptedData['modelName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'yearName': yearName,
        'modelName': modelName,
      };
}
