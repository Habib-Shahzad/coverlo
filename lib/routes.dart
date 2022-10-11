import 'package:coverlo/screens/form_step_1_screen/form_step_1_screen.dart';
import 'package:coverlo/screens/form_step_2_screen/form_step_2_screen.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:coverlo/screens/login_screen/login_screen.dart';
import 'package:coverlo/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  FormStep1Screen.routeName: (context) => const FormStep1Screen(),
  FormStep2Screen.routeName: (context) => FormStep2Screen(),
  FormStep3Screen.routeName: (context) => const FormStep3Screen(),
};
