import 'package:coverlo/constants.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class ProductRepository {
  final BaseAPI _provider = ApiProvider();

  Future<ProductModel> fetchData(
      String uniqueID, String deviceUniqueIdentifier) async {
    final response = await _provider.post(GET_PRODUCT_API,
        _bodyInterpolateFetch(uniqueID, deviceUniqueIdentifier));
    return ProductModel.fromJson(response);
  }

  String _bodyInterpolateFetch(String uniqueID, String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetProducts xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></CoverLo_GetProducts></soap:Body></soap:Envelope>';
    return body;
  }
}
