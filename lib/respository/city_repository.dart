import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/city_model.dart';

import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class CityRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<City>> getCities() async {
    final url = await getOperationUrl(GET_CITIES_API);
    final responseJson = await _provider.get(url);

    final cities = (responseJson['_City'] as List)
        .map((city) => City.fromJson(city))
        .toList();

    return cities;
  }

  toDropdown(List<City> cities) {
    return convertToDropDown(cities, (City city) => city.cityName);
  }
}
