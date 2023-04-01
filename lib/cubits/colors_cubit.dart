import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/respository/color_repository.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ColorsState {}

class ColorsInitial extends ColorsState {}

class ColorsLoading extends ColorsState {}

class ColorsLoaded extends ColorsState {
  final List<Color> colors;
  final List<DropdownMenuItem<Object>> dropdownItems;

  ColorsLoaded({required this.colors, required this.dropdownItems});
}

class ColorsError extends ColorsState {
  final String message;

  ColorsError({required this.message});
}

class ColorsCubit extends MyCubit<ColorsState> {
  final ColorRepository colorRepository = ColorRepository();

  ColorsCubit() : super(ColorsInitial());

  @override
  Type getInitState() {
    return ColorsInitial;
  }

  @override
  Type getErrState() {
    return ColorsError;
  }

  @override
  Future<void> getData() async {
    emit(ColorsLoading());

    try {
      final colors = await colorRepository.getCarColors();
      final dropdownItems = colorRepository.toDropdown(colors);

      emit(ColorsLoaded(colors: colors, dropdownItems: dropdownItems));
    } catch (e) {
      // print(e.toString());
      emit(ColorsError(message: e.toString()));
    }
  }
}
