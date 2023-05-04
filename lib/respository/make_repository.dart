import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class MakeRepository {
  final BaseAPI _provider = ApiProvider();
  final Map<String, List<Make>> _cache = {};

  List<Make> getMakesData(responseJson) {
    final makes = (responseJson['_Make'] as List)
        .map((make) => Make.fromJson(make))
        .toList();

    return makes;
  }

  Future<List<Make>> getMakes() async {
    Map data = {
      'vtype': '',
      ...(await getDeviceInfo()),
    };

    if (data['device_unique_identifier'] == null) {
      return [];
    }

    final url = getUrl(GET_MAKES_API, data);
    final responseJson = await _provider.get(url);

    final makes = getMakesData(responseJson);
    return makes;
  }

  Future<List<Make>> getMakesByProduct(String productCode) async {
    if (_cache.containsKey(productCode)) {
      return _cache[productCode]!;
    }

    Map data = {
      'vtype': '',
      'productCode': encryptItem(productCode),
      ...(await getDeviceInfo()),
    };
    final url = getUrl(GET_MAKES_BY_PRODUCT_API, data);
    final responseJson = await _provider.get(url);

    final makes = getMakesData(responseJson);

    if (makes.isNotEmpty) {
      _cache[productCode] = makes;
    }

    return makes;
  }

  toDropdown(List<Make> makes) {
    return convertToDropDown(makes, (Make make) => make.makeName);
  }
}
