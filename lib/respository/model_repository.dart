import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/networking/api_operations.dart';

class ModelRepository {
  final BaseAPI _provider = ApiProvider();
  final Map<String, List<Model>> _cache = {};

  List<Model> getModelsData(responseJson) {
    final models = (responseJson['_Model'] as List)
        .map((model) => Model.fromJson(model))
        .toList();

    return models;
  }

  Future<List<Model>> getModels() async {
    Map data = {
      'vtype': '',
      ...(await getDeviceInfo()),
    };

    final url = getUrl(GET_MODELS_API, data);

    final responseJson = await _provider.get(url);

    final makes = getModelsData(responseJson);
    return makes;
  }

  Future<List<Model>> getModelsByProduct(String productCode) async {
    if (_cache.containsKey(productCode)) {
      return _cache[productCode]!;
    }

    Map data = {
      'vtype': '',
      'productCode': Des.encrypt(Env.serverKey, productCode),
      ...(await getDeviceInfo()),
    };
    final url = getUrl(GET_MODELS_BY_PRODUCT_API, data);
    final responseJson = await _provider.get(url);

    final models = getModelsData(responseJson);

    if (models.isNotEmpty) {
      _cache[productCode] = models;
    }

    return models;
  }

  toDropdown(List<Model> models) {
    return convertToDropDown(models, (Model model) => model.modelName);
  }
}
