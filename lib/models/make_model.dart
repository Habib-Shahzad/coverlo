import 'package:coverlo/helpers/helper_functions.dart';

class Make {
  String makeName;
  String makeCode;

  Make({required this.makeName, required this.makeCode});

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
        makeName: decryptItem(json['MakeName']),
        makeCode: decryptItem(json['MakeCode']));
  }

}
