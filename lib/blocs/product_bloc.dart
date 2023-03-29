// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductBloc extends Bloc with ChangeNotifier {
  late ProductRepository _productRepository;
  late StreamController _productListController;

  static const String GET_PRODUCTS = 'GET_PRODUCTS';

  @override
  StreamSink<Response<ProductModel>> get getSink =>
      _productListController.sink as StreamSink<Response<ProductModel>>;

  @override
  Stream<Response<ProductModel>> get getStream =>
      _productListController.stream as Stream<Response<ProductModel>>;

  ProductBloc() {
    _productListController = StreamController<Response<ProductModel>>();
    _productRepository = ProductRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_PRODUCTS:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
          _fetchData(
              map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '');
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      default:
    }
  }

  _fetchData(String uniqueID, String deviceUniqueIdentifier) async {
    try {
      getSink.add(Response.loading('Loading data...'));

      ProductModel data =
          await _productRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_productListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _productListController.close();
    super.dispose();
  }
}
