import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class CountryRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Country>> getCountries() async {
    final requestBody = await getXML(GET_COUNTRIES_API);
    if (requestBody == null) throw Exception('Error!');
    final responseJson = await _provider.post(GET_COUNTRIES_API, requestBody);

    final countries = (responseJson['_Country'] as List)
        .map((country) => Country.fromJson(country))
        .toList();

    return countries;
  }

  toDropdown(List<Country> countries) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < countries.length; i++) {
      Country country = countries[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(country.countryName)),
      );
    }

    return items;
  }
}
