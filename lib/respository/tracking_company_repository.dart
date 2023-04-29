import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class TrackingCompanyRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<TrackingCompany>> getTrackingCompanies() async {
    final url = await getOperationUrl(GET_TRACKING_COMPANIES_API);
    final responseJson = await _provider.get(url);

    final companies = (responseJson['_TrackingCompany'] as List)
        .map((company) => TrackingCompany.fromJson(company))
        .toList();

    return companies;
  }

  toDropdown(List<TrackingCompany> companies) {
    return convertToDropDown(
        companies, (TrackingCompany company) => company.trackingCompanyName);
  }
}
