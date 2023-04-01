import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/respository/model_repository.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ModelsState {}

class ModelsInitial extends ModelsState {}

class ModelsLoading extends ModelsState {}

class ModelsLoaded extends ModelsState {
  final List<Model> models;
  final List<DropdownMenuItem<Object>> dropdownItems;

  ModelsLoaded({required this.models, required this.dropdownItems});
}

class ModelsError extends ModelsState {
  final String message;

  ModelsError({required this.message});
}

class ModelsCubit extends MyCubit<ModelsState> {
  final ModelRepository modelRepository = ModelRepository();

  ModelsCubit() : super(ModelsInitial());

  @override
  Type getInitState() {
    return ModelsInitial;
  }

  @override
  Type getErrState() {
    return ModelsError;
  }

  @override
  Future<void> getData() async {
    emit(ModelsLoading());

    try {
      final models = await modelRepository.getCarModels();
      final dropdownItems = modelRepository.toDropdown(models);

      emit(ModelsLoaded(models: models, dropdownItems: dropdownItems));
    } catch (e) {
      emit(ModelsError(message: e.toString()));
    }
  }
}
