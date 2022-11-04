import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

//text input box
class textInputBox extends StatelessWidget {
  textInputBox({required this.controller,required this.inputLabel,required this.inputType});

  final TextEditingController controller;
  final String inputLabel;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value) {
          if (value != null && value
              .trim()
              .length < 3) {
            return 'This field requires a minimum of 3 characters';
          }
          return null;
        },
      style: TextStyle(
          color: Color(greyishBlueColor),
            fontWeight: FontWeight.normal,
            fontSize: 16
        ),
        autofocus: false,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          filled: false,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(greyishBlueColor)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(lightGreyColor)),
            ),
            label: Text(inputLabel)
        ),
      );
  }
}

//password input box
class passwordInputBox extends StatefulWidget {
  passwordInputBox({required this.passwordController});
  final TextEditingController passwordController;
  bool _isObscured = true;

  @override
  State<passwordInputBox> createState() => _passwordInputBoxState();
}

class _passwordInputBoxState extends State<passwordInputBox> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          color: Color(greyishBlueColor),
          fontWeight: FontWeight.normal,
          fontSize: 16
      ),
      autofocus: false,
      controller: widget.passwordController,
      obscureText: widget._isObscured,
      decoration: InputDecoration(
        filled: false,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(greyishBlueColor)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(lightGreyColor)),
        ),
        label: Text("Password"),
        suffixIcon: IconButton(
          color: Color(greyishBlueColor),
          icon: Icon(widget._isObscured ? EvaIcons.eyeOutline : EvaIcons.eyeOff2Outline),
          onPressed: () {
            setState((){
              widget._isObscured = !widget._isObscured;
            });
          },
          focusColor: Color(greyishBlueColor),
        ),
      ),
    );
  }
}