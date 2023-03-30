import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coverlo/respository/profession_repository.dart';
import 'package:coverlo/models/profession_model.dart';

@immutable
abstract class ProfessionsState {}

class ProfessionsInitial extends ProfessionsState {}

class ProfessionsLoading extends ProfessionsState {}

class ProfessionsLoaded extends ProfessionsState {
  final List<Profession> professions;
  final List<DropdownMenuItem<Object>> dropdownItems;

  ProfessionsLoaded({required this.professions, required this.dropdownItems});
}

class ProfessionsError extends ProfessionsState {
  final String message;

  ProfessionsError({required this.message});
}

class ProfessionsCubit extends Cubit<ProfessionsState> {
  final ProfessionRepository professionRepository = ProfessionRepository();

  ProfessionsCubit() : super(ProfessionsInitial());

  Future<void> getData() async {
    emit(ProfessionsLoading());

    try {
      final professions = await professionRepository.getProfessions();
      
      final dropdownItems = professionRepository.toDropdown(professions);

      emit(ProfessionsLoaded(professions: professions, dropdownItems: dropdownItems));
    } catch (e) {
      emit(ProfessionsError(message: e.toString()));
    }
  }
}
