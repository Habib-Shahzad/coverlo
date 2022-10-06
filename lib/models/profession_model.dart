import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfessionModel {
  List<ProfessionResponse> professionList = [];

  ProfessionModel({
    required this.professionList,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return ProfessionModel(
        professionList: (json['_Profession'] as List)
            .map((profession) => ProfessionResponse.fromJson(profession))
            .toList(),
      );
    }
    return ProfessionModel(
      professionList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'professionList': List<dynamic>.from(professionList.map((x) => x.toJson())),
      };
}

class ProfessionResponse {
  String professionName;

  ProfessionResponse({
    required this.professionName,
  });

  factory ProfessionResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'professionName': json['ProfessionName'],
    });

    return ProfessionResponse(
      professionName: decryptedData['professionName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'professionName': professionName,
      };
}
