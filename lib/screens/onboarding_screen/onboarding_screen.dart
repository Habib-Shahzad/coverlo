import 'dart:convert';
import 'dart:io';
import 'package:coverlo/cubits/country_cubit.dart';
import 'package:coverlo/cubits/profession_cubit.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/cubits/city_cubit.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/models/user_model.dart';
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<CitiesCubit>().state is CitiesInitial) {
        await context.read<CitiesCubit>().getData();
      }

      if (context.read<ProfessionsCubit>().state is ProfessionsInitial) {
        await context.read<ProfessionsCubit>().getData();
      }

      if (context.read<CountriesCubit>().state is CountriesInitial) {
        await context.read<CountriesCubit>().getData();
      }
    });
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
        if (Platform.isIOS) {
          await userRepository.registerDevice(generateUUID());
          setState(() {
            loading = false;
          });
        } else if (Platform.isAndroid) {
          await userRepository.registerDevice(generateUUID());
          setState(() {
            loading = false;
          });
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
      userRepository.registerDevice(generateUUID());
    }
    if (!mounted) return;
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
