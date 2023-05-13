import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsuranceRepository {
  final BaseAPI _provider = ApiProvider();
  final UserRepository userRepository = UserRepository();

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

  deleteInsuranceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('insuranceID');
    prefs.remove('insuranceInfo');
    sessionInsuranceId = null;
  }

  generateInsurance(User user, String transationID) async {
    Map<String, dynamic> data = {
      "ByAgentID": encryptItem(user.agentCode),
      "uniqueRef": encryptItem(transationID),
      ...getEncryptedFormData(),
    };

    data = {
      ...data,
      ...await getDeviceInfo(),
      ...getFormData(),
    };

    var url = getUrl(GENERATE_INSURANCE_API, data);
    final response = await _provider.get(url);
    var insuranceID = response["insuranceID"];
    return insuranceID;
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
