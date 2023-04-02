import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/networking/api_operations.dart';

class CountryRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Country>> getCountries() async {
    final requestBody = await getXML(GET_COUNTRIES_API);

    // print("Fetching countries...");
    if (requestBody == null) throw Exception('Error!');
    final responseJson = await _provider.post(GET_COUNTRIES_API, requestBody);

    final countries = (responseJson['_Country'] as List)
        .map((country) => Country.fromJson(country))
        .toList();

    // print("fetchd countries...");

    return countries;
  }

  toDropdown(List<Country> countries) {
    return convertToDropDown(countries, (Country country) => country.countryName);
  }
}
