import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class ColorRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Color>> getColorsData(responseJson) async {
    final colors = (responseJson['_ColorsN'] as List)
        .map((color) => Color.fromJson(color))
        .toList();
    return colors;
  }

  Future<List<Color>> getCarColors() async {

    final requestBody =
        await getVehicleXML(GET_COLOR_API, encryptVehicleType(VehicleType.Car));
    final responseJson = await _provider.post(GET_COLOR_API, requestBody);
    
    return getColorsData(responseJson);
  }

  Future<List<Color>> getBikeColors() async {
    final requestBody = await getVehicleXML(
        GET_COLOR_API, encryptVehicleType(VehicleType.Motorcycle));
    final responseJson = await _provider.post(GET_COLOR_API, requestBody);
    return getColorsData(responseJson);
  }

  toDropdown(List<Color> colors) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < colors.length; i++) {
      Color color = colors[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(color.colorName)),
      );
    }

    return items;
  }
}
