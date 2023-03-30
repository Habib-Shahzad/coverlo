import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class TrackingCompanyRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<TrackingCompany>> getTrackingCompanies() async {
    final requestBody = await getXML(GET_TRACKING_COMPANIES_API);
    final responseJson =
        await _provider.post(GET_TRACKING_COMPANIES_API, requestBody);

    final trackingCompanies = (responseJson['_TrackingCompany'] as List)
        .map((company) => TrackingCompany.fromJson(company))
        .toList();

    return trackingCompanies;
  }

  toDropdown(List<TrackingCompany> companies) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < companies.length; i++) {
      TrackingCompany company = companies[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(company.trackingCompanyName)),
      );
    }

    return items;
  }
}
