import 'package:coverlo/des/des.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  ProductResponse({
    required this.productName,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    Map<String, String> decryptedData =
        Des.decryptMap(dotenv.env['APP_KEY'] ?? '', {
      'productName': json['productName'],
    });

    return ProductResponse(
      productName: decryptedData['productName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'productName': productName,
      };
}
