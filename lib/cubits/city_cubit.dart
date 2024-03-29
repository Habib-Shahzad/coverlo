import 'package:coverlo/cubits/cubit_base.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/respository/city_repository.dart';
import 'package:coverlo/models/city_model.dart';

@immutable
abstract class CitiesState {}

class CitiesInitial extends CitiesState {}

class CitiesLoading extends CitiesState {}

class CitiesLoaded extends CitiesState {
  final List<City> cities;
  final List<DropdownMenuItem<Object>> dropdownItems;

  CitiesLoaded({required this.cities, required this.dropdownItems});
}

class CitiesError extends CitiesState {
  final String message;

  CitiesError({required this.message});
}

class CitiesCubit extends MyCubit<CitiesState> {
  final CityRepository cityRepository = CityRepository();

  CitiesCubit() : super(CitiesInitial());

  @override
  Type getInitState() {
    return CitiesInitial;
  }

  @override
  Type getErrState() {
    return CitiesError;
  }

  @override
  Future<void> getData() async {
    emit(CitiesLoading());

    try {
      final cities = await cityRepository.getCities();
      final dropdownItems = cityRepository.toDropdown(cities);

      emit(CitiesLoaded(cities: cities, dropdownItems: dropdownItems));
    } catch (e) {
      // print(e.toString());
      emit(CitiesError(message: e.toString()));
    }
  }
}
