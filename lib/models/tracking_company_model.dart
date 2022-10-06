import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  TrackingCompanyResponse({
    required this.trackingCompanyName,
  });

  factory TrackingCompanyResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'trackingCompanyName': json['TCName'],
    });

    return TrackingCompanyResponse(
      trackingCompanyName: decryptedData['trackingCompanyName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'trackingCompanyName': trackingCompanyName,
      };
}
