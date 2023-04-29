import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/networking/api_operations.dart';

class CountryRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Country>> getCountries() async {
    final url = await getOperationUrl(GET_COUNTRIES_API);
    final responseJson = await _provider.get(url);

    final countries = (responseJson['_Country'] as List)
        .map((country) => Country.fromJson(country))
        .toList();

    return countries;
  }

  toDropdown(List<Country> countries) {
    return convertToDropDown(countries, (Country country) => country.countryName);
  }
}
