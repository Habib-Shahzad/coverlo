// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/make_repository.dart';
import 'package:flutter/material.dart';

class MakeBloc extends Bloc with ChangeNotifier {
  late MakeRepository _makeRepository;
  late StreamController _makeListController;

  static const String GET_MAKES_VEHICLE = 'GET_MAKES_VEHICLE';
  static const String GET_MAKES_MOTORCYCLE = 'GET_MAKES_MOTORCYCLE';

  @override
  StreamSink<Response<MakeModel>> get getSink =>
      _makeListController.sink as StreamSink<Response<MakeModel>>;

  @override
  Stream<Response<MakeModel>> get getStream =>
      _makeListController.stream as Stream<Response<MakeModel>>;

  MakeBloc() {
    _makeListController = StreamController<Response<MakeModel>>();
    _makeRepository = MakeRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_MAKES_VEHICLE:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
          _fetchData(
              map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '', VehicleType.Car);
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      case GET_MAKES_MOTORCYCLE:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
          _fetchData(
              map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '', VehicleType.Motorcycle);
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      default:
    }
  }

  _fetchData(String uniqueID, String deviceUniqueIdentifier, VehicleType vehicleType) async {
    try {
      getSink.add(Response.loading('Loading data...'));
      MakeModel data =
          await _makeRepository.fetchData(uniqueID, deviceUniqueIdentifier, vehicleType);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_makeListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _makeListController.close();
    super.dispose();
  }
}
