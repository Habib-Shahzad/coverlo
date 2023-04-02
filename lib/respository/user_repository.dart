import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class UserRepository {
  final BaseAPI _provider = ApiProvider();

  Future<UserModel> loginUser(String userName, String password) async {
    final requestBody = await getLoginXML(LOGIN_API, userName, password);
    final responseJson = await _provider.post(LOGIN_API, requestBody);

    return UserModel.fromJson(responseJson);
  }

  registerDevice(String deviceUniqueIdentifier) async {
    var requestBody =
        getDeviceRegisterationXML(DEVICE_REGISTER_API, deviceUniqueIdentifier);
    final response = await _provider.post(DEVICE_REGISTER_API, requestBody);
    
    return UserMessageResponse.fromJson(response, deviceUniqueIdentifier);
  }

  String getDeviceRegisterationXML(
      String operation, String deviceUniqueIdentifier) {
    return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$operation xmlns="http://tempuri.org/">
      <device_unique_identifier>${Des.encrypt(Env.serverKey, deviceUniqueIdentifier)}</device_unique_identifier>
    </$operation>
  </soap:Body>
</soap:Envelope>
''';
  }
}
