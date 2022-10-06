import 'package:coverlo/constants.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class UserRepository {
  final BaseAPI _provider = ApiProvider();

  Future<UserModel> loginUser(String uniqueID, String deviceUniqueIdentifier,
      String userName, String password) async {
    final response = await _provider.post(
        LOGIN_API,
        _bodyInterpolateLogin(
            uniqueID, deviceUniqueIdentifier, userName, password));
    return UserModel.fromJson(response);
  }

  registerDevice(String deviceUniqueIdentifier) async {
    final response = await _provider.post(
        DEVICE_REGISTER_API, _bodyInterpolateDevice(deviceUniqueIdentifier));
    return UserMessageResponse.fromJson(response, deviceUniqueIdentifier);
  }

  String _bodyInterpolateLogin(String uniqueID, String deviceUniqueIdentifier,
      String userName, String password) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_Login xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier><userName>$userName</userName><password>$password</password></CoverLo_Login></soap:Body></soap:Envelope>';
    return body;
  }

  String _bodyInterpolateDevice(String deviceUniqueIdentifier) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><Device_Registration xmlns="http://tempuri.org/"><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier></Device_Registration></soap:Body></soap:Envelope>';
    return body;
  }
}
