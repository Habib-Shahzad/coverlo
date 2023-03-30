import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/respository/make_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class MakesCubit extends Cubit<MakesState> {
  final MakeRepository makeRepository = MakeRepository();

  MakesCubit() : super(MakesInitial());

  Future<void> getData() async {
    emit(MakesLoading());

    try {
      final makes = await makeRepository.getCarMakes();
      final dropdownItems = makeRepository.toDropdown(makes);

      emit(MakesLoaded(makes: makes, dropdownItems: dropdownItems));
    } catch (e) {
      emit(MakesError(message: e.toString()));
    }
  }
}
