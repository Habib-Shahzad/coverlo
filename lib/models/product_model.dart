import 'package:xml/xml.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class Product {
  String productName;
  String productCode;

  Product({required this.productName, required this.productCode});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productName: decryptItem(json['productName']),
        productCode: decryptItem(json['productCode']));
  }

  factory Product.fromXml(XmlElement xml) {
    final productnName = xml.findElements('productName').single.text;
    final productnCode = xml.findElements('productCode').single.text;

    return Product(
        productName: decryptItem(productnName),
        productCode: decryptItem(productnCode));
  }
}
