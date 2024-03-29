import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:flutter/material.dart';
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

class TrackingCompaniesCubit extends MyCubit<TrackingCompaniesState> {
  final TrackingCompanyRepository trackingCompanyRepository =
      TrackingCompanyRepository();

  TrackingCompaniesCubit() : super(TrackingCompaniesInitial());

  @override
  Type getInitState() {
    return TrackingCompaniesInitial;
  }

  @override
  Type getErrState() {
    return TrackingCompaniesError;
  }

  @override
  Future<void> getData() async {
    emit(TrackingCompaniesLoading());

    try {
      final companies = await trackingCompanyRepository.getTrackingCompanies();
      final dropdownItems = trackingCompanyRepository.toDropdown(companies);

      emit(TrackingCompaniesLoaded(
          companies: companies, dropdownItems: dropdownItems));
    } catch (e) {
      emit(TrackingCompaniesError(message: e.toString()));
    }
  }
}
