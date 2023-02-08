import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';

class ProductModel {
  List<ProductResponse> productList = [];

  ProductModel({
    required this.productList,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['responseCode'] == 200) {
      return ProductModel(
        productList: (json['_Product'] as List)
            .map((product) => ProductResponse.fromJson(product))
            .toList(),
      );
    }
    return ProductModel(
      productList: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'productList': List<dynamic>.from(productList.map((x) => x.toJson())),
      };
}

class ProductResponse {
  String productName;
  String productCode;

  ProductResponse({
    required this.productName,
    required this.productCode,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData = Des.decryptMap(Env.appKey, {
      'productName': json['productName'],
      'productCode': json['productCode'],
    });

    return ProductResponse(
      productName: decryptedData['productName'] ?? '',
      productCode: decryptedData['productCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productCode': productCode,
      };
}
