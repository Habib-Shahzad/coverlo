import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/city_model.dart';

import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class CityRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<City>> getCities() async {
    final requestBody = await getXML(GET_CITIES_API);
    final responseJson = await _provider.post(GET_CITIES_API, requestBody);

    final cities = (responseJson['_City'] as List)
        .map((city) => City.fromJson(city))
        .toList();

    return cities;
  }

  toDropdown(List<City> cities) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < cities.length; i++) {
      City city = cities[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(city.cityName)),
      );
    }

    return items;
  }
}
