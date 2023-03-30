import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/cubits/city_cubit.dart';
import 'package:coverlo/cubits/country_cubit.dart';
import 'package:coverlo/cubits/profession_cubit.dart';
import 'package:coverlo/screens/login_screen/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<CitiesCubit>().state is CitiesInitial ||
          context.read<CitiesCubit>().state is CitiesError)
        await context.read<CitiesCubit>().getData();

      if (context.read<ProfessionsCubit>().state is ProfessionsInitial ||
          context.read<ProfessionsCubit>().state is ProfessionsError)
        await context.read<ProfessionsCubit>().getData();

      if (context.read<CountriesCubit>().state is CountriesInitial ||
          context.read<CountriesCubit>().state is CountriesError)
        await context.read<CountriesCubit>().getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: Column(
            children: [
              const SizedBox(height: kMaxSpacing),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  loginImage,
                  width: ResponsiveValue(
                    context,
                    defaultValue: kDefaultImageWidth,
                    valueWhen: [
                      const Condition.largerThan(
                        name: MOBILE,
                        value: 24.0,
                      ),
                    ],
                  ).value,
                ),
              ),
              const SizedBox(height: kMinSpacing),
              const MainHeading(
                headingText: 'Sign In',
                color: kTextColor,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: kMinSpacing),
              const CustomText(
                  text: 'Enter your details to login to your account'),
              const SizedBox(height: kMinSpacing),
              const LoginForm(),
              const SizedBox(height: kMinSpacing),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
