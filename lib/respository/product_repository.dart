import 'package:coverlo/constants.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Product>> getProducts() async {
    final requestBody = await getXML(GET_PRODUCT_API);
    final responseJson = await _provider.post(GET_PRODUCT_API, requestBody);

    final products = (responseJson['_Product'] as List)
        .map((product) => Product.fromJson(product))
        .toList();

    return products;
  }

  toDropdown(List<Product> products) {
    List<DropdownMenuItem<Object>> items = [];

    for (var i = 0; i < products.length; i++) {
      Product product = products[i];

      items.add(
        DropdownMenuItem(value: i, child: Text(product.productName)),
      );
    }

    return items;
  }
}
