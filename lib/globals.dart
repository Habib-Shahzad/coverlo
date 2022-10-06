import 'package:coverlo/pairbloc.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/models/user_model.dart';

class StaticGlobal extends ChangeNotifier {
  static ValueNotifier<List<PairBloc>> blocs = ValueNotifier([]);
  static UserResponse? user;
  static List<Function> disposeFunctions = [];
}
