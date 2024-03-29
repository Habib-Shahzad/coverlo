import 'package:coverlo/networking/api_operations.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/networking/api_provider.dart';
import 'package:coverlo/networking/base_api.dart';

class ProductRepository {
  final BaseAPI _provider = ApiProvider();

  Future<List<Product>> getProducts() async {
    final url = await getOperationUrl(GET_PRODUCTS_API);

    final responseJson = await _provider.get(url);

    final products = (responseJson['_Product'] as List)
        .map((product) => Product.fromJson(product))
        .toList();

    return products;
  }

  toDropdown(List<Product> products) {
    return convertToDropDown(
        products, (Product product) => product.productName);
  }
}
