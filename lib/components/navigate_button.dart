import 'package:coverlo/constants.dart';
import 'package:flutter/material.dart';

class NavigateButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color color;
  const NavigateButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kMaxBorderRadius),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: kTextColor,
          fontSize: kDefaultFontSize,
        ),
      ),
    );
  }
}
