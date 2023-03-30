import 'dart:typed_data';

import 'package:coverlo/constants.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/des/des.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:image/image.dart' as img;

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

decryptItem(String item) {
  return Des.decrypt(Env.appKey, item);
}

convertJsonToXML(Map jsonData, String operation) {
  var builder = XmlBuilder();

  builder.processing('xml', 'version="1.0" encoding="utf-8"');
  builder.element('soap:Envelope', nest: () {
    builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
    builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
    builder.attribute(
        'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
    builder.element('soap:Body', nest: () {
      builder.element(operation, nest: () {
        builder.attribute('xmlns', 'http://tempuri.org/');
        for (var key in jsonData.keys) {
          builder.element(key, nest: jsonData[key]);
        }
      });
    });
  });

  return (builder.buildDocument().toXmlString(pretty: true, indent: '  '));
}

getXML(String operation) async {
  final prefs = await SharedPreferences.getInstance();
  String deviceUniqueIdentifier =
      prefs.getString('deviceUniqueIdentifier') ?? '';
  String uniqueID = prefs.getString('uniqueID') ?? '';

  if (deviceUniqueIdentifier == '' || uniqueID == '') {
    return null;
  }

  return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$operation xmlns="http://tempuri.org/">
      <uniqueID>$uniqueID</uniqueID>
      <device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier>
    </$operation>
  </soap:Body>
</soap:Envelope>
''';
}

getVehicleXML(String operation, String vtype) async {
  final prefs = await SharedPreferences.getInstance();
  String deviceUniqueIdentifier =
      prefs.getString('deviceUniqueIdentifier') ?? '';
  String uniqueID = prefs.getString('uniqueID') ?? '';

  return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$operation xmlns="http://tempuri.org/">
      <uniqueID>$uniqueID</uniqueID>
      <device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier>
      <vtype>$vtype</vtype>
    </$operation>
  </soap:Body>
</soap:Envelope>
''';
}

getLoginXML(String operation, String username, String password) async {
  final prefs = await SharedPreferences.getInstance();
  String deviceUniqueIdentifier =
      prefs.getString('deviceUniqueIdentifier') ?? '';
  String uniqueID = prefs.getString('uniqueID') ?? '';

  return '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$operation xmlns="http://tempuri.org/">
      <uniqueID>$uniqueID</uniqueID>
      <device_unique_identifier>$deviceUniqueIdentifier</device_unique_identifier>
      <userName>${Des.encrypt(Env.serverKey, username)}</userName>
      <password>${Des.encrypt(Env.serverKey, password)}</password>
    </$operation>
  </soap:Body>
</soap:Envelope>
''';
}

selectedProductIsCar(productName) {
  return productName == thirdParty || productName == privateCar;
}

encryptVehicleType(VehicleType vtype) {
  String vehicleString = vtype == VehicleType.Car ? "Vehicle" : "Motorcycle";
  return Des.encrypt(Env.serverKey, vehicleString);
}

String generateUUID() {
  var now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = now.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String hour = now.hour.toString();
  if (hour.length == 1) {
    hour = '0$hour';
  }
  String minute = now.minute.toString();
  if (minute.length == 1) {
    minute = '0$minute';
  }
  String second = now.second.toString();
  if (second.length == 1) {
    second = '0$second';
  }
  String uuidN = "$year$month${day}0$hour$minute$second";
  return uuidN;
}

Uint8List? imageBytesResize(List<int>? imageBytes) {
  if (imageBytes == null) return null;
  Uint8List bytes = Uint8List.fromList(imageBytes);
  img.Image? image = img.decodeImage(bytes);
  if (image == null) return null;
  int width = image.width;
  int height = image.height;

  if (width > 1000 || height > 1000) {
    double scale = width > height ? 1000 / width : 1000 / height;
    int newWidth = (width * scale).floor();
    int newHeight = (height * scale).floor();
    img.Image resizedImage =
        img.copyResize(image, width: newWidth, height: newHeight);

    print(newWidth);
    print(newHeight);
    bytes = Uint8List.fromList(img.encodePng(resizedImage));
  }
  return bytes;
}
