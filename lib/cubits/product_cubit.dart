import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/respository/product_repository.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<DropdownMenuItem<Object>> dropdownItems;

  ProductsLoaded({required this.products, required this.dropdownItems});
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}

class ProductsCubit extends MyCubit<ProductsState> {
  final ProductRepository productRepository = ProductRepository();

  ProductsCubit() : super(ProductsInitial());

  @override
  Type getInitState() {
    return ProductsInitial;
  }

  @override
  Type getErrState() {
    return ProductsError;
  }

  @override
  Future<void> getData() async {
    emit(ProductsLoading());

    try {
      final products = await productRepository.getProducts();
      final dropdownItems = productRepository.toDropdown(products);

      emit(ProductsLoaded(products: products, dropdownItems: dropdownItems));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}
