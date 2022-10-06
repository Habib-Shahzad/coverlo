import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class CityModel {
  List<CityResponse> cityList = [];

  CityModel({
    required this.cityList,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return CityModel(
        cityList: (json['_City'] as List)
            .map((city) => CityResponse.fromJson(city))
            .toList(),
      );
    }
    return CityModel(
      cityList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'cityList': List<dynamic>.from(cityList.map((x) => x.toJson())),
      };
}

class CityResponse {
  String cityID;
  String cityName;
  String countryName;

  CityResponse({
    required this.cityID,
    required this.cityName,
    required this.countryName,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {

    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'cityID': json['cityID'],
      'cityName': json['cityName'],
      'countryName': json['countryName'],
    });

    return CityResponse(
      cityID: decryptedData['cityID'] ?? '',
      cityName: decryptedData['cityName'] ?? '',
      countryName: decryptedData['countryName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'cityID': cityID,
        'cityName': cityName,
        'countryName': countryName,
      };
}
