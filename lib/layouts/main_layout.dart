import 'package:coverlo/constants.dart';
import 'package:coverlo/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLayout extends StatefulWidget {
  final Widget body;
  const MainLayout({super.key, required this.body});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  void navigateToLoginScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Image.asset(
                    logoImage,
                    fit: BoxFit.cover,
                    width: ResponsiveValue(
                      context,
                      defaultValue: kDefaultLogoWidth,
                      valueWhen: [
                        const Condition.largerThan(
                          name: MOBILE,
                          value: 20.0,
                        ),
                      ],
                    ).value,
                  ),
                ],
              ),
            ),
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.checklist,
                  color: kIconColor,
                  size: ResponsiveValue(
                    context,
                    defaultValue: kDefaultIconSize,
                    valueWhen: [
                      const Condition.largerThan(
                        name: MOBILE,
                        value: 20.0,
                      ),
                    ],
                  ).value,
                ),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: kIconColor,
                    size: ResponsiveValue(
                      context,
                      defaultValue: kDefaultIconSize,
                      valueWhen: [
                        const Condition.largerThan(
                          name: MOBILE,
                          value: 20.0,
                        ),
                      ],
                    ).value,
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('user');
                    navigateToLoginScreen();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
