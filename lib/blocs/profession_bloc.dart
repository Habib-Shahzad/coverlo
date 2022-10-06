// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/profession_repository.dart';
import 'package:flutter/material.dart';

class ProfessionBloc extends Bloc with ChangeNotifier {
  late ProfessionRepository _professionRepository;
  late StreamController _professionListController;

  static const String GET_PROFESSIONS = 'GET_PROFESSIONS';

  @override
  StreamSink<Response<ProfessionModel>> get getSink =>
      _professionListController.sink as StreamSink<Response<ProfessionModel>>;

  @override
  Stream<Response<ProfessionModel>> get getStream =>
      _professionListController.stream as Stream<Response<ProfessionModel>>;

  ProfessionBloc() {
    _professionListController = StreamController<Response<ProfessionModel>>();
    _professionRepository = ProfessionRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_PROFESSIONS:
        PairBloc pairBloc = PairBloc(WAITING, PROFESSION_BLOC, () {
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
      ProfessionModel data = await _professionRepository.fetchData(
          uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_professionListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _professionListController.close();
    super.dispose();
  }
}
