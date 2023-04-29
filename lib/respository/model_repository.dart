import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/networking/api_operations.dart';

class ModelRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Model>> getModelsData(responseJson) async {
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

  toDropdown(List<Model> models) {
    return convertToDropDown(models, (Model model) => model.modelName);
  }
}
