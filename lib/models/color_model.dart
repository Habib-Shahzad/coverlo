import 'package:coverlo/helpers/helper_functions.dart';

class Color {
  final String colorName;
  final String colorCode;

  Color({required this.colorName, required this.colorCode});

  factory Color.fromJson(Map<String, dynamic> json) {

    
    return Color(
        colorName: decryptItem(json['ColorName']),
        colorCode: decryptItem(json['ColorCode']));
  }


}
