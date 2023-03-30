import 'package:flutter/material.dart';

List<DropdownMenuItem<Object>> genderList = [];
List<Map<String, String>> genderListMap = [];

List<DropdownMenuItem<Object>> modelList = [];
List<Map<String, String>> modelListMap = [];

getYears(numYears) {
  final List<DropdownMenuItem<Object>> newModelList = [];
  final List<Map<String, String>> newModelListMap = [];

  for (int i = 0; i < numYears; i++) {
    String dateYear = (DateTime.now().year - i).toString();
    newModelList.add(DropdownMenuItem(value: i, child: Text(dateYear)));
    newModelListMap.add({'value': i.toString(), 'label': dateYear});
  }

  return [newModelList, newModelListMap];
}

var carModels = getYears(10);
final List<DropdownMenuItem<Object>> carModelsList = carModels[0];
final List<Map<String, String>> carModelsListMap = carModels[1];

var bikeModels = getYears(5);
final List<DropdownMenuItem<Object>> bikeModelsList = bikeModels[0];
final List<Map<String, String>> bikeModelsListMap = bikeModels[1];
