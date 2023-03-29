import 'package:coverlo/models/body_type_model.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:flutter/material.dart';

List<DropdownMenuItem<Object>> cityList = [];
List<Map<String, String>> cityListMap = [];

List<DropdownMenuItem<Object>> countryList = [];
List<Map<String, String>> countryListMap = [];

List<DropdownMenuItem<Object>> genderList = [];
List<Map<String, String>> genderListMap = [];

List<DropdownMenuItem<Object>> professionList = [];
List<Map<String, String>> professionListMap = [];

// -------------
List<DropdownMenuItem<Object>> colorList = [];
List<Map<String, String>> colorListMap = [];

List<DropdownMenuItem<Object>> colorCarList = [];
List<Map<String, String>> colorCarListMap = [];

List<DropdownMenuItem<Object>> colorBikeList = [];
List<Map<String, String>> colorBikeListMap = [];

List<DropdownMenuItem<Object>> productList = [];
List<Map<String, String>> productListMap = [];

List<DropdownMenuItem<Object>> makeList = [];
List<Map<String, String>> makeListMap = [];

List<DropdownMenuItem<Object>> makeCarList = [];
List<Map<String, String>> makeCarListMap = [];

List<DropdownMenuItem<Object>> makeBikeList = [];
List<Map<String, String>> makeBikeListMap = [];

ModelModel variants = ModelModel(modelList: []);

ModelModel variantsCar = ModelModel(modelList: []);
ModelModel variantsBike = ModelModel(modelList: []);

List<DropdownMenuItem<Object>> variantList = [];
List<Map<String, String>> variantListMap = [];

List<DropdownMenuItem<Object>> modelList = [];
List<Map<String, String>> modelListMap = [];

BodyTypeModel bodyTypesM = BodyTypeModel(bodyTypeList: []);
List<Map<String, String>> bodyTypeListMap = [];

List<DropdownMenuItem<Object>> trackingCompanyList = [];
List<Map<String, String>> trackingCompanyListMap = [];

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