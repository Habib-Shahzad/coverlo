// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/model_repository.dart';
import 'package:flutter/material.dart';

class ModelBloc extends Bloc with ChangeNotifier {
  late ModelRepository _modelRepository;
  late StreamController _modelListController;

  static const String GET_MODELS_CAR = 'GET_MODELS_CAR';
  static const String GET_MODELS_MOTORCYCLE = 'GET_MODELS_MOTORCYCLE';

  @override
  StreamSink<Response<ModelModel>> get getSink =>
      _modelListController.sink as StreamSink<Response<ModelModel>>;

  @override
  Stream<Response<ModelModel>> get getStream =>
      _modelListController.stream as Stream<Response<ModelModel>>;

  ModelBloc() {
    _modelListController = StreamController<Response<ModelModel>>();
    _modelRepository = ModelRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_MODELS_CAR:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
          _fetchData(map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '',
              VehicleType.Car);
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      case GET_MODELS_MOTORCYCLE:
        PairBloc pairBloc = PairBloc(WAITING, CITY_BLOC, () {
          _fetchData(map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '',
              VehicleType.Motorcycle);
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
      ModelModel data =
          await _modelRepository.fetchData(uniqueID, deviceUniqueIdentifier, vehicleType);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_modelListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _modelListController.close();
    super.dispose();
  }
}
