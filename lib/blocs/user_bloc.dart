// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/des/des.dart';
import 'package:coverlo/env/env.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:flutter/material.dart';

class UserBloc extends Bloc with ChangeNotifier {
  late UserRepository _userRepository;
  late StreamController _userController;

  static const String LOGIN = 'login';
  static const String DEVICE_REGISTER = 'deviceRegister';

  @override
  StreamSink<Response<dynamic>> get getSink =>
      _userController.sink as StreamSink<Response<dynamic>>;

  @override
  Stream<Response<dynamic>> get getStream =>
      _userController.stream as Stream<Response<dynamic>>;

  UserBloc() {
    _userController = StreamController<Response<dynamic>>();
    _userRepository = UserRepository();
  }

  @override
  connect(Map<String, dynamic> map, String function) async {
    switch (function) {
      case LOGIN:
        PairBloc pairBloc = PairBloc(WAITING, USER_BLOC, () {
          _loginUser(map['uniqueID'] ?? '', map['deviceUniqueIdentifier'] ?? '',
              map['userName'] ?? '', map['password'] ?? '');
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      case DEVICE_REGISTER:
        PairBloc pairBloc = PairBloc(WAITING, USER_BLOC, () {
          _registerDevice(map['deviceUniqueIdentifier'] ?? '');
        });
        StaticGlobal.blocs.value.add(pairBloc);
        StaticGlobal.blocs.notifyListeners();
        break;
      default:
    }
  }

  _loginUser(String uniqueID, String deviceUniqueIdentifier, String userName,
      String password) async {
    try {
      getSink.add(Response.loading('Loading User...'));
      Map<String, String> encryptedData = Des.encryptMap(
          Env.serverKey, {'UserName': userName, 'Password': password});

      UserModel user = await _userRepository.loginUser(
          uniqueID,
          deviceUniqueIdentifier,
          encryptedData['UserName'] ?? '',
          encryptedData['Password'] ?? '');
      getSink.add(Response.completed(user));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_userController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  _registerDevice(String deviceUniqueIdentifier) async {
    try {
      getSink.add(Response.loading('Registering Device...'));
      Map<String, String> encryptedData = Des.encryptMap(
          Env.serverKey, {'deviceUniqueIdentifier': deviceUniqueIdentifier});

      UserMessageResponse data = await _userRepository
          .registerDevice(encryptedData['deviceUniqueIdentifier'] ?? '');
      getSink.add(Response.completed(data));
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
    } catch (e) {
      StaticGlobal.blocs.value.removeAt(0);
      StaticGlobal.blocs.notifyListeners();
      if (!_userController.isClosed) {
        getSink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  dispose() {
    _userController.close();
    super.dispose();
  }
}
