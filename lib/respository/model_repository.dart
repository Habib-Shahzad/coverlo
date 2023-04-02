import 'package:coverlo/enums.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
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

  Future<List<Model>> getCarModels() async {
    final requestBody =
        await getVehicleXML(GET_MODEL_API, encryptVehicleType(VehicleType.car));
    final responseJson = await _provider.post(GET_MODEL_API, requestBody);
    return getModelsData(responseJson);
  }

  Future<List<Model>> getBikeModels() async {
    final requestBody = await getVehicleXML(
        GET_MODEL_API, encryptVehicleType(VehicleType.motorCycle));
    final responseJson = await _provider.post(GET_MODEL_API, requestBody);
    return getModelsData(responseJson);
  }

  toDropdown(List<Model> models) {
    return convertToDropDown(models, (Model model) => model.modelName);
  }
}
