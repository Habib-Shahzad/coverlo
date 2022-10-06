import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  MakeResponse({
    required this.makeName,
  });

  factory MakeResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'makeName': json['makeName'],
    });

    return MakeResponse(
      makeName: decryptedData['makeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'makeName': makeName,
      };
}
