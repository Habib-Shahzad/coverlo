import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/models/user_model.dart';
import 'package:coverlo/respository/user_repository.dart';
import 'package:coverlo/screens/form_step_1_screen/form_step_1_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String buttonText = 'Login';
  bool loading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;

  Future<void>? _future;

  Future<void> loadScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? insuranceID = prefs.getString('insuranceID');
    if (insuranceID != null) {
      sessionInsuranceId = int.parse(insuranceID);
    }

    // if (context.mounted) await DataManager.fetchMakes(context);
    // if (context.mounted) await DataManager.fetchModels(context);
  }

  @override
  void initState() {
    _future = loadScreen();

    resetFormData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loginUser(String userName, String password) async {
    try {
      UserRepository userRepository = UserRepository();

      if (userName.isEmpty || password.isEmpty) {
        setState(() {
          loading = false;
          buttonText = 'Login';
          errorMessage = "Username or password cannot be empty";
        });
        return;
      }

      User? user = await userRepository.loginUser(userName, password);

      setState(() {
        loading = false;
      });

      if (user == null) {
        setState(() {
          loading = false;
          buttonText = 'Login';
          errorMessage = "Username & password do not match";
        });
      } else {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, FormStep1Screen.routeName);
        }
      }
      return user;
    } catch (e) {
      setState(() {
        loading = false;
        buttonText = 'Login';
        errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          usernameTextFormField(),
          const SizedBox(height: kMinSpacing),
          passwordTextFormField(),
          const SizedBox(height: kMinSpacing),
          FutureBuilder<void>(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CustomButton(
                    buttonText: buttonText,
                    onPressed: () async {
                      if (loading) {
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          buttonText = 'Logging in...';
                          errorMessage = null;
                        });

                        String userName = _usernameController.text;
                        String password = _passwordController.text;
                        await _loginUser(userName, password);
                      }
                    },
                    buttonColor: kSecondaryColor,
                  );
                } else {
                  return CustomButton(
                    buttonText: 'please wait..',
                    onPressed: () async {},
                    buttonColor: kSecondaryColor,
                  );
                }
              }),
          if (errorMessage != null)
            CustomText(
              text: errorMessage!,
              color: kErrorColor,
            ),
        ],
      ),
    );
  }

  TextFormField usernameTextFormField() {
    return TextFormField(
      cursorColor: kCursorColor,
      controller: _usernameController,
      style: TextStyle(
        color: kFormTextColor,
        fontSize: ResponsiveValue(
          context,
          defaultValue: kDefaultFontSize,
          valueWhen: [
            const Condition.largerThan(
              name: MOBILE,
              value: 18.0,
            ),
          ],
        ).value,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kDefaultFontSize,
        ),
        fillColor: kFormFieldBackgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kTextColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kTextColor)),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kErrorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kErrorColor)),
        hintStyle: TextStyle(
          color: kFormLabelColor,
          fontSize: ResponsiveValue(
            context,
            defaultValue: kDefaultFontSize,
            valueWhen: [
              const Condition.largerThan(
                name: MOBILE,
                value: 18.0,
              ),
            ],
          ).value,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  TextFormField passwordTextFormField() {
    return TextFormField(
      obscureText: true,
      cursorColor: kCursorColor,
      controller: _passwordController,
      style: TextStyle(
        color: kFormTextColor,
        fontSize: ResponsiveValue(
          context,
          defaultValue: kDefaultFontSize,
          valueWhen: [
            const Condition.largerThan(
              name: MOBILE,
              value: 18.0,
            ),
          ],
        ).value,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kDefaultFontSize,
        ),
        fillColor: kFormFieldBackgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kFormBorderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kFormBorderColor)),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kErrorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kErrorColor)),
        hintStyle: TextStyle(
          color: kFormLabelColor,
          fontSize: ResponsiveValue(
            context,
            defaultValue: kDefaultFontSize,
            valueWhen: [
              const Condition.largerThan(
                name: MOBILE,
                value: 18.0,
              ),
            ],
          ).value,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
