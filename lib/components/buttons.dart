import 'package:flutter/material.dart';
import '../theme.dart';

class SecondaryGreenButton extends StatelessWidget {
  SecondaryGreenButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(secondaryGreenColor)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
              )
          ),
        ),
      ),
    );
  }
}

class PrimaryBlueButton extends StatelessWidget {
  PrimaryBlueButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(primaryBlueColor)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )
          ),
        ),
      ),
    );
  }
}

class CancelRedButton extends StatelessWidget {
  CancelRedButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(cancelRedColor)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
          ),
    ));
  }
}


class GenericButton extends StatelessWidget {
  GenericButton({required this.buttonText, required this.onPressed, required this.color});

  final String buttonText;
  final VoidCallback onPressed;
  final int color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(color)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
          ),
        ));
  }
}