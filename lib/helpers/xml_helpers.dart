import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/des/des.dart';

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

getXML(String operation, {Map? data}) async {
  final prefs = await SharedPreferences.getInstance();
  String deviceUniqueIdentifier =
      prefs.getString('deviceUniqueIdentifier') ?? '';
  String uniqueID = prefs.getString('uniqueID') ?? '';

  if (deviceUniqueIdentifier == '' || uniqueID == '') {
    return null;
  }

  return convertJsonToXML({
    'uniqueID': uniqueID,
    'device_unique_identifier': deviceUniqueIdentifier,
    if (data != null) ...data
  }, operation);
}

getVehicleXML(String operation, String vtype) async {
  return getXML(operation, data: {
    'vtype': vtype,
  });
}

getLoginXML(String operation, String username, String password) async {
  return getXML(operation, data: {
    'userName': Des.encrypt(Env.serverKey, username),
    'password': Des.encrypt(Env.serverKey, password),
  });
}
