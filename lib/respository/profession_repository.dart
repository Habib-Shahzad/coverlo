import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/helpers/xml_helpers.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class ProfessionRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Profession>> getProfessions() async {
    final requestBody = await getXML(GET_PROFESSIONS_API);
    if (requestBody == null) throw Exception('Error!');
    final responseJson = await _provider.post(GET_PROFESSIONS_API, requestBody);

    final professions = (responseJson['_Profession'] as List)
        .map((profession) => Profession.fromJson(profession))
        .toList();

    return professions;
  }

  toDropdown(List<Profession> professions) {
    return convertToDropDown(
        professions, (Profession profession) => profession.professionName);
  }
}
