import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class MakeRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Make>> getMakesData(responseJson) async {
    final makes = (responseJson['_Make'] as List)
        .map((make) => Make.fromJson(make))
        .toList();

    return makes;
  }

  Future<List<Make>> getCarMakes() async {
    final requestBody =
        await getVehicleXML(GET_MAKE_API, encryptVehicleType(VehicleType.Car));
    final responseJson = await _provider.post(GET_MAKE_API, requestBody);
    return getMakesData(responseJson);
  }

  Future<List<Make>> getBikeMakes() async {
    final requestBody = await getVehicleXML(
        GET_MAKE_API, encryptVehicleType(VehicleType.Motorcycle));
    final responseJson = await _provider.post(GET_MAKE_API, requestBody);
    return getMakesData(responseJson);
  }

  toDropdown(List<Make> countries) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < countries.length; i++) {
      Make make = countries[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(make.makeName)),
      );
    }

    return items;
  }
}
