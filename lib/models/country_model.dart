import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  CountryResponse({
    required this.countryName,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'countryName': json['countryName'],
    });

    return CountryResponse(
      countryName: decryptedData['countryName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'countryName': countryName,
      };
}
