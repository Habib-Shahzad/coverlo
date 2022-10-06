// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/city_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/city_repository.dart';
import 'package:flutter/material.dart';

class CityBloc extends Bloc with ChangeNotifier {
  late CityRepository _cityRepository;
  late StreamController _cityListController;

  static const String GET_CITIES = 'GET_CITIES';

  @override
  StreamSink<Response<CityModel>> get getSink =>
      _cityListController.sink as StreamSink<Response<CityModel>>;

  @override
  Stream<Response<CityModel>> get getStream =>
      _cityListController.stream as Stream<Response<CityModel>>;

  CityBloc() {
    _cityListController = StreamController<Response<CityModel>>();
    _cityRepository = CityRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_CITIES:
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
      CityModel data =
          await _cityRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_cityListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _cityListController.close();
    super.dispose();
  }
}
