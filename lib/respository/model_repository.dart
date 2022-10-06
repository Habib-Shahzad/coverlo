import 'package:coverlo/constants.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class ModelRepository {
  final BaseAPI _provider = ApiProvider();

  Future<ModelModel> fetchData(
      String uniqueID, String deviceUniqueIdentifier) async {
    final response = await _provider.post(
        GET_MODEL_API, _bodyInterpolateFetch(uniqueID, deviceUniqueIdentifier));
    return ModelModel.fromJson(response);
  }

  String _bodyInterpolateFetch(String uniqueID, String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetModelLists xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></CoverLo_GetModelLists></soap:Body></soap:Envelope>';
    return body;
  }
}
