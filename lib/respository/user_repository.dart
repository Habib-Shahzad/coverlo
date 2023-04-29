import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class UserRepository {
  final BaseAPI _provider = ApiProvider();

  Future<UserModel> loginUser(String userName, String password) async {
    Map data = {
      "userName": Des.encrypt(Env.serverKey, userName),
      "password": Des.encrypt(Env.serverKey, password),
      ...(await getDeviceInfo()),
    };
    final url = getUrl(LOGIN_API, data);
    final responseJson = await _provider.get(url);
    return UserModel.fromJson(responseJson);
  }

  registerDevice(String deviceUniqueIdentifier) async {
    final data = {'device_unique_identifier': deviceUniqueIdentifier};
    var url = getUrl(DEVICE_REGISTER_API, data);
    final response = await _provider.get(url);
    return UserMessageResponse.fromJson(response, deviceUniqueIdentifier);
  }
}
