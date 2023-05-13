import 'dart:convert';

import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final BaseAPI _provider = ApiProvider();

  Future<User?> loginUser(String userName, String password) async {
    Map data = {
      "userName": encryptItem(userName),
      "password": encryptItem(password),
      ...(await getDeviceInfo()),
    };
    final url = getUrl(LOGIN_API, data);
    final responseJson = await _provider.get(url);
    if (responseJson["responseCode"] == 402) return null;
    User user = User.fromJsonResponse(responseJson);
    await _saveUser(user);
    return user;
  }

  Future<User?> getAuthenticatedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user');
    User? user = User.fromJson(jsonDecode(jsonString ?? ''));
    return user;
  }

  _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  _saveDeviceInfo(String uniqueID, String encryptedIdentifier) async {
    String text = decryptItem(uniqueID);
    uniqueID = encryptItem(text);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceUniqueIdentifier', encryptedIdentifier);
    prefs.setString('uniqueID', uniqueID);
  }

  registerDevice(String deviceUniqueIdentifier) async {
    String encryptedIdentifier = encryptItem(deviceUniqueIdentifier);
    final data = {'device_unique_identifier': encryptedIdentifier};
    var url = getUrl(DEVICE_REGISTER_API, data);
    final response = await _provider.get(url);
    String uniqueID = response['responseMsg'].split(': ')[1];
    await _saveDeviceInfo(uniqueID, encryptedIdentifier);
  }
}
