import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class MakeModel {
  List<MakeResponse> makeList = [];

  MakeModel({
    required this.makeList,
  });

  factory MakeModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return MakeModel(
        makeList: (json['_Make'] as List)
            .map((make) => MakeResponse.fromJson(make))
            .toList(),
      );
    }
    return MakeModel(
      makeList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'makeList': List<dynamic>.from(makeList.map((x) => x.toJson())),
      };
}

class MakeResponse {
  String makeName;
  String makeCode;

  MakeResponse({
    required this.makeName,
    required this.makeCode,
  });

  factory MakeResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'makeName': json['makeName'],
      'makeCode': json['makeCode'],
    });

    return MakeResponse(
      makeName: decryptedData['makeName'] ?? '',
      makeCode: decryptedData['makeCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'makeName': makeName,
        'makeCode': makeCode,
      };
}
