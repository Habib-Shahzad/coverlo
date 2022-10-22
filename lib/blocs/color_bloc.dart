// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/color_repository.dart';
import 'package:flutter/material.dart';

class ColorBloc extends Bloc with ChangeNotifier {
  late ColorRepository _colorRepository;
  late StreamController _colorListController;

  static const String GET_COLORS = 'GET_COLORS';

  @override
  StreamSink<Response<ColorModel>> get getSink =>
      _colorListController.sink as StreamSink<Response<ColorModel>>;

  @override
  Stream<Response<ColorModel>> get getStream =>
      _colorListController.stream as Stream<Response<ColorModel>>;

  ColorBloc() {
    _colorListController = StreamController<Response<ColorModel>>();
    _colorRepository = ColorRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_COLORS:
        PairBloc pairBloc = PairBloc(WAITING, COLOR_BLOC, () {
          _fetchData(
              map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '');
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      default:
    }
  }

  _fetchData(String uniqueID, String deviceUniqueIdentifier) async {
    try {
      getSink.add(Response.loading('Loading data...'));
      ColorModel data =
          await _colorRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_colorListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _colorListController.close();
    super.dispose();
  }
}
