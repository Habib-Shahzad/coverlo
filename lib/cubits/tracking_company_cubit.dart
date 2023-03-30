import 'package:coverlo/models/tracking_company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coverlo/respository/tracking_company_repository.dart';

@immutable
abstract class TrackingCompaniesState {}

class TrackingCompaniesInitial extends TrackingCompaniesState {}

class TrackingCompaniesLoading extends TrackingCompaniesState {}

class TrackingCompaniesLoaded extends TrackingCompaniesState {
  final List<TrackingCompany> companies;
  final List<DropdownMenuItem<Object>> dropdownItems;

  TrackingCompaniesLoaded(
      {required this.companies, required this.dropdownItems});
}

class TrackingCompaniesError extends TrackingCompaniesState {
  final String message;

  TrackingCompaniesError({required this.message});
}

class TrackingCompaniesCubit extends Cubit<TrackingCompaniesState> {
  final TrackingCompanyRepository trackingCompanyRepository =
      TrackingCompanyRepository();

  TrackingCompaniesCubit() : super(TrackingCompaniesInitial());

  Future<void> getData() async {
    emit(TrackingCompaniesLoading());

    try {
      final companies = await trackingCompanyRepository.getTrackingCompanies();
      final dropdownItems =
          trackingCompanyRepository.toDropdown(companies);

      emit(TrackingCompaniesLoaded(
          companies: companies, dropdownItems: dropdownItems));
    } catch (e) {
      emit(TrackingCompaniesError(message: e.toString()));
    }
  }
}
