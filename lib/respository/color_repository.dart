import 'package:coverlo/constants.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';

class ColorRepository {
  final BaseAPI _provider = ApiProvider();

  Future<ColorModel> fetchData(String uniqueID, String deviceUniqueIdentifier,
      VehicleType vehicleType) async {
    String vehicleString = "";

    if (vehicleType == VehicleType.Car) {
      vehicleString = "Vehicle";
    } else if (vehicleType == VehicleType.Motorcycle) {
      vehicleString = "Motorcycle";
    }

    String encryptedVehicleType =
        Des.encryptMap(Env.serverKey, {'vtype': vehicleString})['vtype'] ?? "";

    final response = await _provider.post(
        GET_COLOR_API,
        _bodyInterpolateFetch(
            uniqueID, deviceUniqueIdentifier, encryptedVehicleType));

    return ColorModel.fromJson(response);
  }

  String _bodyInterpolateFetch(
      String uniqueID, String deviceUniqueIdentifier, String vehicleType) {
    String body =
        '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><CoverLo_GetColors xmlns="http://tempuri.org/"><uniqueID>$uniqueID</uniqueID><device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier><vtype>$vehicleType</vtype>  </CoverLo_GetColors></soap:Body></soap:Envelope>';
    return body;
  }
}
