import 'package:coverlo/helpers/helper_functions.dart';

class Profession {
  String professionName;
  String professionCode;

  Profession({required this.professionName, required this.professionCode});

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      professionName: decryptItem(json['ProfessionName']),
      professionCode: decryptItem(json['ProfessionCode'])
    );
  }


}
