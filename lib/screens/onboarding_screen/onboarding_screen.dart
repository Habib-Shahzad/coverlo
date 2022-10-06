import 'dart:convert';
import 'dart:io';

import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/user_bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/screens/onboarding_screen/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late Bloc _userBloc;

  bool loggedIn = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc();
    StaticGlobal.blocs.addListener(checkBlocsQueue);
    _userBloc.getStream.listen(deviceRegisterListener);
    initPlatformState();
    if (StaticGlobal.blocs.value.isNotEmpty) {
      PairBloc pairBloc = StaticGlobal.blocs.value.first;
      if (pairBloc.status == WAITING) {
        pairBloc.status = RUNNING;
        StaticGlobal.blocs.value.removeAt(0);
        StaticGlobal.blocs.value.insert(0, pairBloc);
        pairBloc.func();
      }
    }
  }

  @override
  void dispose() {
    _userBloc.dispose();
    StaticGlobal.blocs.removeListener(checkBlocsQueue);
    super.dispose();
  }

  checkBlocsQueue() {
    if (StaticGlobal.blocs.value.isNotEmpty) {
      PairBloc pairBloc = StaticGlobal.blocs.value.first;
      if (pairBloc.status == WAITING) {
        pairBloc.status = RUNNING;
        StaticGlobal.blocs.value.removeAt(0);
        StaticGlobal.blocs.value.insert(0, pairBloc);
        pairBloc.func();
      } else if (pairBloc.status == COMPLETED) {
        StaticGlobal.blocs.value.removeAt(0);
      }
    }
  }

  deviceRegisterListener(Response response) async {
    if (response.status == Status.COMPLETED) {
      UserMessageResponse userMessageResponse =
          response.data as UserMessageResponse;
      if (userMessageResponse.code == '200') {
        setState(() {
          loading = false;
        });
      } else {
        AlertDialog alert =
            messageDialog(context, 'Error', userMessageResponse.message);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  Future<void> initPlatformState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceUniqueIdentifier =
          prefs.getString('deviceUniqueIdentifier');
      String? uniqueID = prefs.getString('uniqueID');
      if (deviceUniqueIdentifier == null && uniqueID == null) {
        if (Platform.isIOS) {
          _userBloc.connect({
            'deviceUniqueIdentifier': generateUUID(),
          }, UserBloc.DEVICE_REGISTER);
        } else if (Platform.isAndroid) {
          _userBloc.connect({
            'deviceUniqueIdentifier': generateUUID(),
          }, UserBloc.DEVICE_REGISTER);
        }
      } else {
        final jsonString = prefs.getString('user');
        if (jsonString != null) {
          StaticGlobal.user =
              UserResponse.fromJsonCache(jsonDecode(jsonString));
          setState(() {
            loggedIn = true;
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } on PlatformException {
      _userBloc.connect({
        'deviceUniqueIdentifier': generateUUID(),
      }, UserBloc.DEVICE_REGISTER);
    }
    if (!mounted) return;
  }

  String generateUUID() {
    var now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString();
    if (month.length == 1) {
      month = '0$month';
    }
    String day = now.day.toString();
    if (day.length == 1) {
      day = '0$day';
    }
    String hour = now.hour.toString();
    if (hour.length == 1) {
      hour = '0$hour';
    }
    String minute = now.minute.toString();
    if (minute.length == 1) {
      minute = '0$minute';
    }
    String second = now.second.toString();
    if (second.length == 1) {
      second = '0$second';
    }
    String uuidN = "$year$month${day}0$hour$minute$second";
    return uuidN;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [kGradientColorTop, kGradientColorBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: OnboardingBody(
            loggedIn: loggedIn,
            loading: loading,
          ),
        ),
      ),
    );
  }
}
