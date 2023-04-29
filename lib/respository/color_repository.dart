import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
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

  Future<List<Color>> getColors() async {
    final data = {
      'vtype': '',
      ...await getDeviceInfo(),
    };
    final url = await getUrl(GET_COLORS_API, data);
    final responseJson = await _provider.get(url);
    return getColorsData(responseJson);
  }

  toDropdown(List<Color> colors) {
    return convertToDropDown(colors, (Color make) => make.colorName);
  }
}
