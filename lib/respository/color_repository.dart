import 'package:coverlo/enums.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';


class ColorRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Color>> getColorsData(responseJson) async {
    final colors = (responseJson['_ColorsN'] as List)
        .map((color) => Color.fromJson(color))
        .toList();
    return colors;
  }

  Future<List<Color>> getCarColors() async {

    final requestBody =
        await getVehicleXML(GET_COLOR_API, encryptVehicleType(VehicleType.car));
    final responseJson = await _provider.post(GET_COLOR_API, requestBody);
    
    return getColorsData(responseJson);
  }

  Future<List<Color>> getBikeColors() async {
    final requestBody = await getVehicleXML(
        GET_COLOR_API, encryptVehicleType(VehicleType.motorCycle));
    final responseJson = await _provider.post(GET_COLOR_API, requestBody);
    return getColorsData(responseJson);
  }

  toDropdown(List<Color> colors) {
    return convertToDropDown(colors, (Color make) => make.colorName);
  }
}
