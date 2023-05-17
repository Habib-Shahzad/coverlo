import 'dart:convert';

import 'package:coverlo/constants.dart';
import 'package:coverlo/des/des.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

encryptItem(String item) {
  return Des.encrypt(item);
}

decryptItem(String item) {
  return Des.decrypt(item);
}

selectedProductIsCar(productName) {
  return productName == thirdParty || productName == privateCar;
}

String generateUUID() {
  var now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = now.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String hour = now.hour.toString();
  if (hour.length == 1) {
    hour = '0$hour';
  }
  String minute = now.minute.toString();
  if (minute.length == 1) {
    minute = '0$minute';
  }
  String second = now.second.toString();
  if (second.length == 1) {
    second = '0$second';
  }
  String uuidN = "$year$month${day}0$hour$minute$second";
  return uuidN;
}

List<DropdownMenuItem<Object>> convertToDropDown<T>(
    List<T> items, Function(T) getKey) {
  return List.generate(items.length, (i) {
    T item = items[i];
    return DropdownMenuItem(value: i, child: Text(getKey(item)));
  });
}

mapToString(Map map, {bool uriEncode = false}) {
  String result = '';
  map.forEach((key, value) {
    if (uriEncode) {
      value = Uri.encodeComponent(value);
    }
    result += '$key=$value&';
  });
  return result.substring(0, result.length - 1);
}

Future<Map> getDeviceInfo() async {
  final prefs = await SharedPreferences.getInstance();
  String? deviceUniqueIdentifier = prefs.getString('deviceUniqueIdentifier');
  String? uniqueID = prefs.getString('uniqueID');
  return {
    'uniqueID': uniqueID,
    'device_unique_identifier': deviceUniqueIdentifier,
  };
}

getUrl(String operation, Map data, {bool uriEncode = false}) {
  return '$operation?${mapToString(data, uriEncode: uriEncode)}';
}

getOperationUrl(String operation) async {
  return getUrl(operation, await getDeviceInfo());
}

String bytesToBase64(List<int>? imageBytes) {
  return imageBytes != null ? base64Encode(imageBytes) : "";
}



String removeQueryParams(String url) {
  final uri = Uri.parse(url);
  final uriWithoutQueryParams = Uri(
    scheme: uri.scheme,
    userInfo: uri.userInfo,
    host: uri.host,
    port: uri.port,
    path: uri.path,
  );
  return uriWithoutQueryParams.toString();
}
