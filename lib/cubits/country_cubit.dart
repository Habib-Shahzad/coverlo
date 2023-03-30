import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coverlo/respository/country_repository.dart';
import 'package:coverlo/models/country_model.dart';

@immutable
abstract class CountriesState {}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<Country> countries;
  final List<DropdownMenuItem<Object>> dropdownItems;

  CountriesLoaded({required this.countries, required this.dropdownItems});
}

class CountriesError extends CountriesState {
  final String message;

  CountriesError({required this.message});
}

class CountriesCubit extends Cubit<CountriesState> {
  final CountryRepository countryRepository = CountryRepository();

  CountriesCubit() : super(CountriesInitial());

  Future<void> getData() async {
    emit(CountriesLoading());

    try {
      final countries = await countryRepository.getCountries();
      final dropdownItems = countryRepository.toDropdown(countries);

      emit(CountriesLoaded(countries: countries, dropdownItems: dropdownItems));
    } catch (e) {
      print(e.toString());
      emit(CountriesError(message: e.toString()));
    }
  }
}
