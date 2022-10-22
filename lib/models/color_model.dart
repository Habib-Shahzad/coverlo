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

  ColorResponse({
    required this.colorName,
  });

  factory ColorResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData = Des.decryptMap(Env.appKey, {
      'colorName': json['colorName'],
    });

    return ColorResponse(
      colorName: decryptedData['colorName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'colorName': colorName,
      };
}
