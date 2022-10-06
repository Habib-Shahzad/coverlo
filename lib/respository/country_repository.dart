import 'package:coverlo/constants.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class CountryRepository {
  final BaseAPI _provider = ApiProvider();

  Future<CountryModel> fetchData(
      String uniqueID, String deviceUniqueIdentifier) async {
    final response = await _provider.post(GET_CITIES_API,
        _bodyInterpolateFetch(uniqueID, deviceUniqueIdentifier));
    return CountryModel.fromJson(response);
  }

  String _bodyInterpolateFetch(String uniqueID, String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetCountries xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></CoverLo_GetCountries></soap:Body></soap:Envelope>';
    return body;
  }
}
