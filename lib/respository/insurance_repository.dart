import 'dart:convert';

import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:coverlo/screens/payment_screen/data_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coverlo/models/insurance_model.dart';

class InsuranceRepository {
  final BaseAPI _provider = ApiProvider();
  final UserRepository userRepository = UserRepository();

  Future<Insurance> getInsuranceDetails(insuranceID) async {
    Map<String, dynamic> data = {
      "txnNumber": insuranceID,
    };
    var url = getUrl(GET_INSURANCE_INFO, data);
    final response = await _provider.get(url);

    return Insurance.fromJson(response);
  }

  sendInsuranceRequest(images) async {
    String transactionID = idGenerator();
    User? user = await userRepository.getAuthenticatedUser();

    if (user == null) return;
    var insuranceID = await generateInsurance(user, transactionID);

    var imageUploadSuccess = await uploadImages(insuranceID, images);

    if (imageUploadSuccess && insuranceID != null) {
      await _saveInsuranceInfo(insuranceID);
      return insuranceID;
    }
  }

  _saveInsuranceInfo(int insuranceID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('insuranceID', insuranceID.toString());
    await saveInformation();
  }

  deleteSavedInsuranceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('insuranceID');
    prefs.remove('insuranceInfo');
    sessionInsuranceId = null;
  }

  generateInsurance(User user, String transationID) async {
    Map<String, dynamic> data = {
      "ByAgentID": encryptItem(user.agentCode),
      "uniqueRef": encryptItem(transationID),
      ...await getFormData(),
      ...await getDeviceInfo(),
    };

    var url = getUrl(GENERATE_INSURANCE_API, data);
    final response = await _provider.get(url);

    var insuranceID = response["insuranceID"];
    return insuranceID;
  }

  viewInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map step1Data = jsonDecode(prefs.getString('step1Data') ?? '{}');
    Map step1EncryptedData =
        (jsonDecode(prefs.getString('step1DataE') ?? '{}'));

    Map step2Data = jsonDecode(prefs.getString('step2Data') ?? '{}');
    Map step2EncryptedData =
        (jsonDecode(prefs.getString('step2DataE') ?? '{}'));

    Map formData = {};
    formData.addAll(step1Data);
    formData.addAll(step1EncryptedData);
    formData.addAll(step2Data);
    formData.addAll(step2EncryptedData);

    copyToClipboard(jsonEncode(formData));
  }

  Future<bool> uploadImages(insuranceID, vehicleImages) async {
    for (var i = 0; i < vehicleImages.length; i++) {
      Map<String, String> request = {
        "insuranceID": encryptItem(insuranceID.toString()),
        "picNo": encryptItem((i + 1).toString()),
      };

      request = {
        ...request,
        ...await getDeviceInfo(),
        "imageStr": vehicleImages[i]["IMAGE_STRING"],
      };

      final response = await _provider.post(UPLOAD_PICS_API, request);
      if (response["responseCode"] != 200) {
        return false;
      }
    }
    return true;
  }
}
