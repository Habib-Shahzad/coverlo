import 'package:coverlo/constants.dart';
import 'package:coverlo/models/city_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class CityRepository {
  final BaseAPI _provider = ApiProvider();

  Future<CityModel> fetchData(
      String uniqueID, String deviceUniqueIdentifier) async {
    final response = await _provider.post(GET_CITIES_API,
        _bodyInterpolateFetch(uniqueID, deviceUniqueIdentifier));
    return CityModel.fromJson(response);
  }

  String _bodyInterpolateFetch(String uniqueID, String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetCities xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></CoverLo_GetCities></soap:Body></soap:Envelope>';
    return body;
  }
}
