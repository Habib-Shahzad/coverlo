import 'package:coverlo/cubits/city_cubit.dart';
import 'package:coverlo/cubits/colors_cubit.dart';
import 'package:coverlo/cubits/country_cubit.dart';
import 'package:coverlo/cubits/make_cubit.dart';
import 'package:coverlo/cubits/model_cubit.dart';
import 'package:coverlo/cubits/product_cubit.dart';
import 'package:coverlo/cubits/profession_cubit.dart';
import 'package:coverlo/cubits/tracking_company_cubit.dart';
import 'package:coverlo/routes.dart';
import 'package:coverlo/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CitiesCubit>(
          create: (context) => CitiesCubit(),
        ),
        Provider<CountriesCubit>(
          create: (context) => CountriesCubit(),
        ),
        Provider<ProfessionsCubit>(
          create: (context) => ProfessionsCubit(),
        ),
        Provider<ProductsCubit>(
          create: (context) => ProductsCubit(),
        ),
        Provider<MakesCubit>(
          create: (context) => MakesCubit(),
        ),
        Provider<ModelsCubit>(
          create: (context) => ModelsCubit(),
        ),
        Provider<ColorsCubit>(
          create: (context) => ColorsCubit(),
        ),
        Provider<TrackingCompaniesCubit>(
          create: (context) => TrackingCompaniesCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, child!),
            breakpoints: const [
              ResponsiveBreakpoint.resize(350, name: MOBILE),
              ResponsiveBreakpoint.autoScale(600, name: TABLET),
            ]),
        title: 'Coverlo',
        home: const OnboardingScreen(),
        routes: routes,
      ),
    );
  }
}
