// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/body_type_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/body_type_repository.dart';
import 'package:flutter/material.dart';

class BodyTypeBloc extends Bloc with ChangeNotifier {
  late BodyTypeRepository _bodyTypeRepository;
  late StreamController _bodyTypeListController;

  static const String GET_BODY_TYPES = 'GET_BODY_TYPES';

  @override
  StreamSink<Response<BodyTypeModel>> get getSink =>
      _bodyTypeListController.sink as StreamSink<Response<BodyTypeModel>>;

  @override
  Stream<Response<BodyTypeModel>> get getStream =>
      _bodyTypeListController.stream as Stream<Response<BodyTypeModel>>;

  BodyTypeBloc() {
    _bodyTypeListController = StreamController<Response<BodyTypeModel>>();
    _bodyTypeRepository = BodyTypeRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case GET_BODY_TYPES:
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
      BodyTypeModel data =
          await _bodyTypeRepository.fetchData(uniqueID, deviceUniqueIdentifier);
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_bodyTypeListController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _bodyTypeListController.close();
    super.dispose();
  }
}
