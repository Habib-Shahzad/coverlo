import 'package:coverlo/constants.dart';
import 'package:coverlo/models/year_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class YearRepository {
  final BaseAPI _provider = ApiProvider();

  Future<YearModel> fetchData(
      String uniqueID, String deviceUniqueIdentifier) async {
    final response = await _provider.post(
        GET_YEAR_API, _bodyInterpolateFetch(uniqueID, deviceUniqueIdentifier));
    return YearModel.fromJson(response);
  }

  String _bodyInterpolateFetch(String uniqueID, String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetYears xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></CoverLo_GetYears></soap:Body></soap:Envelope>';
    return body;
  }
}
