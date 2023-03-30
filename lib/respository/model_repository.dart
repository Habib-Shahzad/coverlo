import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class ModelRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Model>> getModelsData(responseJson) async {
    final models = (responseJson['_Model'] as List)
        .map((model) => Model.fromJson(model))
        .toList();

    return models;
  }

  Future<List<Model>> getCarModels() async {
    final requestBody =
        await getVehicleXML(GET_MODEL_API, encryptVehicleType(VehicleType.Car));
    final responseJson = await _provider.post(GET_MODEL_API, requestBody);
    return getModelsData(responseJson);
  }

  Future<List<Model>> getBikeModels() async {
    final requestBody = await getVehicleXML(
        GET_MODEL_API, encryptVehicleType(VehicleType.Motorcycle));
    final responseJson = await _provider.post(GET_MODEL_API, requestBody);
    return getModelsData(responseJson);
  }

  toDropdown(List<Model> models) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < models.length; i++) {
      Model model = models[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(model.modelName)),
      );
    }

    return items;
  }
}
