// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/country_repository.dart';
import 'package:flutter/material.dart';

class CountryBloc extends Bloc with ChangeNotifier {
  late CountryRepository _countryRepository;
  late StreamController _countryListController;

  static const String GET_COUNTRIES = 'GET_COUNTRIES';

  @override
  StreamSink<Response<CountryModel>> get getSink =>
      _countryListController.sink as StreamSink<Response<CountryModel>>;

  @override
  Stream<Response<CountryModel>> get getStream =>
      _countryListController.stream as Stream<Response<CountryModel>>;

  CountryBloc() {
    _countryListController = StreamController<Response<CountryModel>>();
    _countryRepository = CountryRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_COUNTRIES:
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
      CountryModel data =
          await _countryRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_countryListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _countryListController.close();
    super.dispose();
  }
}
