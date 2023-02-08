import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';


class TrackingCompanyModel {
  List<TrackingCompanyResponse> trackingCompanyList = [];

  TrackingCompanyModel({
    required this.trackingCompanyList,
  });

  factory TrackingCompanyModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return TrackingCompanyModel(
        trackingCompanyList: (json['_TrackingCompany'] as List)
            .map((trackingCompany) =>
                TrackingCompanyResponse.fromJson(trackingCompany))
            .toList(),
      );
    }
    return TrackingCompanyModel(
      trackingCompanyList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'trackingCompanyList':
            List<dynamic>.from(trackingCompanyList.map((x) => x.toJson())),
      };
}

class TrackingCompanyResponse {
  String trackingCompanyName;
  String trackingCompanyCode;

  TrackingCompanyResponse({
    required this.trackingCompanyName,
    required this.trackingCompanyCode,
  });

  factory TrackingCompanyResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(Env.appKey, {
      'trackingCompanyName': json['TCName'],
      'trackingCompanyCode': json['TCCode'],
    });

    return TrackingCompanyResponse(
      trackingCompanyName: decryptedData['trackingCompanyName'] ?? '',
      trackingCompanyCode: decryptedData['trackingCompanyCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'trackingCompanyName': trackingCompanyName,
        'trackingCompanyCode': trackingCompanyCode,
      };
}
