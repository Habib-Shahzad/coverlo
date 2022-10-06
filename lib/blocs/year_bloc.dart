// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/year_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/year_repository.dart';
import 'package:flutter/material.dart';

class YearBloc extends Bloc with ChangeNotifier {
  late YearRepository _yearRepository;
  late StreamController _yearListController;

  static const String GET_YEARS = 'GET_YEARS';

  @override
  StreamSink<Response<YearModel>> get getSink =>
      _yearListController.sink as StreamSink<Response<YearModel>>;

  @override
  Stream<Response<YearModel>> get getStream =>
      _yearListController.stream as Stream<Response<YearModel>>;

  YearBloc() {
    _yearListController = StreamController<Response<YearModel>>();
    _yearRepository = YearRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_YEARS:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
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
      YearModel data =
          await _yearRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_yearListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _yearListController.close();
    super.dispose();
  }
}
