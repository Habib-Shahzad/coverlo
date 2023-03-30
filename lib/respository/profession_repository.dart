import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class ProfessionRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Profession>> getProfessions() async {
    final requestBody = await getXML(GET_PROFESSIONS_API);
    final responseJson = await _provider.post(GET_PROFESSIONS_API, requestBody);

    final professions = (responseJson['_Profession'] as List)
        .map((profession) => Profession.fromJson(profession))
        .toList();

    return professions;
  }

  toDropdown(List<Profession> professions) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < professions.length; i++) {
      Profession profession = professions[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(profession.professionName)),
      );
    }

    return items;
  }
}
