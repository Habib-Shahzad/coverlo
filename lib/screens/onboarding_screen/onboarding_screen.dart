import 'dart:io';
import 'package:coverlo/respository/user_repository.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/screens/onboarding_screen/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coverlo/helpers/helper_functions.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final UserRepository userRepository = UserRepository();

  bool loggedIn = false;
  bool loading = true;

  Future<void> fetchData() async {}

  Future<void>? _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
    initPlatformState();
    // setDebuggingFormData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceUniqueIdentifier =
          prefs.getString('deviceUniqueIdentifier');
      String? uniqueID = prefs.getString('uniqueID');

      if (deviceUniqueIdentifier == null && uniqueID == null) {
        if (Platform.isIOS || Platform.isAndroid) {
          await userRepository.registerDevice(generateUUID());
          setState(() {
            loading = false;
          });
        }
      } else {
        final userString = prefs.getString('user');

        if (userString != null) {
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
      userRepository.registerDevice(generateUUID());
    }
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
          child: FutureBuilder<void>(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return OnboardingBody(
                  loggedIn: loggedIn,
                  loading: snapshot.connectionState != ConnectionState.done,
                );
              }),
        ),
      ),
    );
  }
}
