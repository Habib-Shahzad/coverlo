import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';

class ColorModel {
  List<ColorResponse> colorList = [];

  ColorModel({
    required this.colorList,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {

    if (json['responseCode'] == 200) {
      return ColorModel(
        colorList: (json['_ColorsN'] as List)
            .map((country) => ColorResponse.fromJson(country))
            .toList(),
      );
    }
    return ColorModel(
      colorList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'colorList': List<dynamic>.from(colorList.map((x) => x.toJson())),
      };
}

class ColorResponse {
  String colorName;
  String colorCode;

  ColorResponse({
    required this.colorName,
    required this.colorCode,
  });

  factory ColorResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData = Des.decryptMap(Env.appKey, {
      'colorName': json['colorName'],
      'colorCode': json['colorCode'],
    });

    return ColorResponse(
      colorName: decryptedData['colorName'] ?? '',
      colorCode: decryptedData['colorCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'colorName': colorName,
        'colorCode': colorCode,
      };
}
