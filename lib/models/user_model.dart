// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  UserResponse? user;

  UserModel({
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['userID'] == null) {
      return UserModel(
        user: null,
      );
    }

    UserResponse user = UserResponse.fromJson(json);
    _setData(user);
    return UserModel(
      user: user,
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
      };
}

void _setData(UserResponse user) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('user', json.encode(user.toJson()));
}

class UserResponse {
  String userID;
  String userName;
  String userEmail;

  UserResponse({
    required this.userID,
    required this.userName,
    required this.userEmail,
  });

  static UserResponse fromJsonCache(Map<String, dynamic> json) {
    return UserResponse(
      userID: json['userID'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'userID': json['userID'],
      'userName': json['userName'],
      'userEmail': json['userEmail'],
    });

    return UserResponse(
      userID: decryptedData['userID'] ?? '',
      userName: decryptedData['userName'] ?? '',
      userEmail: decryptedData['userEmail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userName': userName,
        'userEmail': userEmail,
      };
}

class UserMessageResponse {
  String code;
  String message;

  UserMessageResponse({
    required this.code,
    required this.message,
  });

  factory UserMessageResponse.fromJson(
      Map<String, dynamic> json, String deviceUniqueIdentifier) {
    try {
      String encryptedText = json['responseMsg'].split(': ')[1];
      String text = Des.decrypt(Env.appKey, encryptedText);
      encryptedText = Des.encrypt(Env.serverKey, text);
      setUniqueIDs(deviceUniqueIdentifier, encryptedText);
    } catch (e) {}
    return UserMessageResponse(
      code: json['responseCode'].toString(),
      message: json['responseMsg'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}

setUniqueIDs(String deviceUniqueIdentifier, String uniqueID) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('deviceUniqueIdentifier', deviceUniqueIdentifier);
  prefs.setString('uniqueID', uniqueID);
}
