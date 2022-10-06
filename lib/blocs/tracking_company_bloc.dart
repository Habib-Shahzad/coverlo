// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/tracking_company_repository.dart';
import 'package:flutter/material.dart';

class TrackingCompanyBloc extends Bloc with ChangeNotifier {
  late TrackingCompanyRepository _trackingCompanyRepository;
  late StreamController _trackingCompanyListController;

  static const String GET_TRACKING_COMPANIES = 'GET_TRACKING_COMPANIES';

  @override
  StreamSink<Response<TrackingCompanyModel>> get getSink =>
      _trackingCompanyListController.sink
          as StreamSink<Response<TrackingCompanyModel>>;

  @override
  Stream<Response<TrackingCompanyModel>> get getStream =>
      _trackingCompanyListController.stream
          as Stream<Response<TrackingCompanyModel>>;

  TrackingCompanyBloc() {
    _trackingCompanyListController =
        StreamController<Response<TrackingCompanyModel>>();
    _trackingCompanyRepository = TrackingCompanyRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_TRACKING_COMPANIES:
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
      TrackingCompanyModel data = await _trackingCompanyRepository.fetchData(
          uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_trackingCompanyListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _trackingCompanyListController.close();
    super.dispose();
  }
}
