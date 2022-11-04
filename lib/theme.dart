import 'package:flutter/material.dart';

//Colors
int primaryBlueColor = 0xff282d46;
int secondaryGreenColor = 0xff67bf75;
int thirdYellowColor = 0xffEDC676;
int greyishBlueColor = 0xff838BA1;
int offWhiteColor = 0xffF7F8F9;
int borderGreyColor = 0xffE8ECF4;
int fontGreyColor = 0xff8391A1;
int palateGreenColor = 0xffB0E2B6;
int palateBlueColor = 0xff6E90C6;
int cancelRedColor = 0xffDE2222;
int iconButtonBackgroundColor = 0xffEBF4F3;
int lightGreenColor = 0xffE8F4EA;
int lightGreyColor = 0xffE8ECF4;
int tealColor = 0xff23c798;
int infoCyanColor = 0xff169DB2;

//themes
var textTheme = TextTheme(
  headline1: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
      color: Color(primaryBlueColor)),
  headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(fontGreyColor)),
  headline4: TextStyle(fontSize: 12.0, color: Color(fontGreyColor)),
  headline5: TextStyle(fontSize: 20, color: Colors.white),
  headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(primaryBlueColor)),
  bodyText1: TextStyle(fontSize: 16.0, color: Color(fontGreyColor),fontWeight: FontWeight.w600),
  bodyText2: TextStyle(fontSize: 16.0, color: Color(fontGreyColor)),
  subtitle1: TextStyle(fontSize: 24.0, color: Colors.white,fontWeight: FontWeight.w600),
  subtitle2: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w600),
  caption: TextStyle(fontSize: 16.0, color: Color(primaryBlueColor),fontWeight: FontWeight.w600),
  button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
);
var inputFormTheme = InputDecorationTheme(
  filled: true,
  fillColor: Colors.grey[100],
  border: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Color(borderGreyColor))),
  labelStyle: TextStyle(
    fontSize: 16.0,
    color: Color(greyishBlueColor),
  ),
  hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
);
var elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: Color(primaryBlueColor),
        textStyle: TextStyle(fontWeight: FontWeight.w500)));
var textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
        primary: Color(0xFF7C7C7C),
        textStyle: TextStyle(fontWeight: FontWeight.w600)));
//AppBar Theme
var appBarTheme = AppBarTheme(
  color: Colors.white,
  centerTitle: true,
  iconTheme: IconThemeData(
    color: Color(secondaryGreenColor),
    size: 24,
  ),
  titleTextStyle: TextStyle(
    color: Color(primaryBlueColor),
    fontSize: 24,
  ),
  elevation: 0,

);


var dashboardDrawerIconTheme = IconThemeData(
    color: Color(primaryBlueColor)
);