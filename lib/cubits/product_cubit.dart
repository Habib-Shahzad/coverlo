import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/respository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository productRepository = ProductRepository();

  ProductsCubit() : super(ProductsInitial());

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
