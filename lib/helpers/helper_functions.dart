import 'package:coverlo/constants.dart';
import 'package:coverlo/enums.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/des/des.dart';
import 'package:flutter/material.dart';

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

decryptItem(String item) {
  return Des.decrypt(Env.appKey, item);
}

selectedProductIsCar(productName) {
  return productName == thirdParty || productName == privateCar;
}

encryptVehicleType(VehicleType vtype) {
  String vehicleString = vtype == VehicleType.car ? "Vehicle" : "Motorcycle";
  return Des.encrypt(Env.serverKey, vehicleString);
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
