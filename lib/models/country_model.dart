import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class CountryModel {
  List<CountryResponse> countryList = [];

  CountryModel({
    required this.countryList,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return CountryModel(
        countryList: (json['_Country'] as List)
            .map((country) => CountryResponse.fromJson(country))
            .toList(),
      );
    }
    return CountryModel(
      countryList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'countryList': List<dynamic>.from(countryList.map((x) => x.toJson())),
      };
}

class CountryResponse {
  String countryName;
  String countryCode;

  CountryResponse({
    required this.countryName,
    required this.countryCode,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'countryName': json['countryName'],
      'countryCode': json['countryCode'],
    });

    return CountryResponse(
      countryName: decryptedData['countryName'] ?? '',
      countryCode: decryptedData['countryCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'countryName': countryName,
        'countryCode': countryCode,
      };
}
