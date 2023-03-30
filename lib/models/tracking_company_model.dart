import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class TrackingCompany {
  String trackingCompanyName;
  String trackingCompanyCode;

  TrackingCompany(
      {required this.trackingCompanyName, required this.trackingCompanyCode});

  factory TrackingCompany.fromJson(Map<String, dynamic> json) {
    return TrackingCompany(
        trackingCompanyName: decryptItem(json['TCName']),
        trackingCompanyCode: decryptItem(json['TCCode']));
  }

  factory TrackingCompany.fromXml(XmlElement xml) {
    final trackingCompanyName = xml.findElements('TCName').single.text;
    final trackingCompanyCode = xml.findElements('TCCode').single.text;

    return TrackingCompany(
        trackingCompanyName: decryptItem(trackingCompanyName),
        trackingCompanyCode: decryptItem(trackingCompanyCode));
  }
}
