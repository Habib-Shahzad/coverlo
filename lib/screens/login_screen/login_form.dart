import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/user_bloc.dart';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
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

  late Bloc _userBloc;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorUserName;
  String? errorPassword;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc();
    StaticGlobal.blocs.addListener(checkBlocsQueue);
    _userBloc.getStream.listen(loginListener);
  }

  @override
  void dispose() {
    _userBloc.dispose();
    StaticGlobal.blocs.removeListener(checkBlocsQueue);
    _usernameController.dispose();
    _passwordController.dispose();
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

  loginListener(Response response) async {
    if (response.status == Status.COMPLETED) {
      if (response.data?.user != null) {
        StaticGlobal.user = response.data?.user;
        Navigator.pushNamed(context, FormStep1Screen.routeName);
      } else {
        setState(() {
          loading = false;
          buttonText = 'Login';
          errorUserName = "Username is incorrect";
          errorPassword = "Password is incorrect";
        });
      }
    } else if (response.status == Status.ERROR) {
      setState(() {
        loading = false;
        buttonText = 'Login';
        errorUserName = "Username is incorrect";
        errorPassword = "Password is incorrect";
      });
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      setState(() {
        loading = false;
        buttonText = 'Login';
        errorUserName = "Username is incorrect";
        errorPassword = "Password is incorrect";
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
          CustomButton(
            buttonText: buttonText,
            onPressed: () async {
              if (loading) {
                return;
              }
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                  buttonText = 'Logging in...';
                  errorUserName = null;
                  errorPassword = null;
                });
                final prefs = await SharedPreferences.getInstance();
                String? deviceUniqueIdentifier =
                    prefs.getString('deviceUniqueIdentifier');
                String? uniqueID = prefs.getString('uniqueID');
                String userName = _usernameController.text;
                String password = _passwordController.text;
                _userBloc.connect({
                  'uniqueID': uniqueID ?? '',
                  'deviceUniqueIdentifier': deviceUniqueIdentifier ?? '',
                  'userName': userName,
                  'password': password,
                }, UserBloc.LOGIN);
              }
            },
            buttonColor: kSecondaryColor,
          ),
        ],
      ),
    );
  }

  TextFormField usernameTextFormField() {
    return TextFormField(
      cursorColor: kTextColor,
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
      cursorColor: kTextColor,
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
