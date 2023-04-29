import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class ProfessionRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Profession>> getProfessions() async {
    final url = await getOperationUrl(GET_PROFESSIONS_API);

    final responseJson = await _provider.get(url);

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
