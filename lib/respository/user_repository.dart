import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
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
    final response = await _provider.post(
        DEVICE_REGISTER_API, _bodyInterpolateDevice(deviceUniqueIdentifier));
    return UserMessageResponse.fromJson(response, deviceUniqueIdentifier);
  }

  String _bodyInterpolateDevice(String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><Device_Registration xmlns="http://tempuri.org/"><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></Device_Registration></soap:Body></soap:Envelope>';
    return body;
  }
}
