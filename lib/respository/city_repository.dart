import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
import 'package:coverlo/models/city_model.dart';

import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class CityRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<City>> getCities() async {
    final requestBody = await getXML(GET_CITIES_API);
    if (requestBody == null) throw Exception('Error!');
    final responseJson = await _provider.post(GET_CITIES_API, requestBody);

    final cities = (responseJson['_City'] as List)
        .map((city) => City.fromJson(city))
        .toList();

    return cities;
  }

  toDropdown(List<City> cities) {
    return convertToDropDown(cities, (City city) => city.cityName);
  }
}
