import 'package:coverlo/des/des.dart';

class User {
  String userID;
  String userName;
  String userEmail;
  String agentCode;
  String linkJazzCash;
  String linkHBL;

  User({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.agentCode,
    required this.linkJazzCash,
    required this.linkHBL,
  });

  toJson() {
    return {
      'userID': userID,
      'userName': userName,
      'userEmail': userEmail,
      'agentCode': agentCode,
      'linkJazzCash': linkJazzCash,
      'linkHBL': linkHBL,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      agentCode: json['agentCode'],
      linkJazzCash: json['linkJazzCash'],
      linkHBL: json['linkHBL'],
    );
  }

  factory User.fromJsonResponse(Map<String, dynamic> responseJson) {
    Map<String, String> decryptedData = Des.decryptMap({
      'userID': responseJson['userID'],
      'userName': responseJson['userName'],
      'userEmail': responseJson['userEmail'],
      'agentCode': responseJson['agentCode'],
    });

    Map<String, String> json = {
      ...decryptedData,
      "linkHBL": responseJson['linkHBL'],
      "linkJazzCash": responseJson['linkJazzCash'],
    };

    return User.fromJson(json);
  }
}
