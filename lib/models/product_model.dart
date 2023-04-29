import 'package:coverlo/helpers/helper_functions.dart';

class Product {
  String productName;
  String productCode;
  String businessCode;

  Product(
      {required this.productName,
      required this.productCode,
      required this.businessCode});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productName: decryptItem(json['ProductName']),
        productCode: decryptItem(json['ProductCode']),
        businessCode: decryptItem(json['BusinessCode']));
  }
}
