import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/respository/make_repository.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MakesState {}

class MakesInitial extends MakesState {}

class MakesLoading extends MakesState {}

class MakesLoaded extends MakesState {
  final List<Make> makes;
  final List<DropdownMenuItem<Object>> dropdownItems;

  MakesLoaded({required this.makes, required this.dropdownItems});
}

class MakesError extends MakesState {
  final String message;

  MakesError({required this.message});
}

class MakesCubit extends MyCubit<MakesState> {
  final MakeRepository makeRepository = MakeRepository();

  MakesCubit() : super(MakesInitial());

  @override
  Type getInitState() {
    return MakesInitial;
  }

  @override
  Type getErrState() {
    return MakesError;
  }

  @override
  Future<void> getData() async {
    try {
      final makes = await makeRepository.getMakes();
      final dropdownItems = makeRepository.toDropdown(makes);

      emit(MakesLoaded(makes: makes, dropdownItems: dropdownItems));
    } catch (e) {
      emit(MakesError(message: e.toString()));
    }
  }

  Future<void> getDataByProduct(String productCode) async {
    emit(MakesLoading());

    try {
      final makes = await makeRepository.getMakesByProduct(productCode);
      final dropdownItems = makeRepository.toDropdown(makes);

      emit(MakesLoaded(makes: makes, dropdownItems: dropdownItems));
    } catch (e) {
      emit(MakesError(message: e.toString()));
    }
  }
}
