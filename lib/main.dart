import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/screens/loginScreen.dart';
import 'package:collectors_app/screens/ticketInvestigationScreen.dart';
import 'package:collectors_app/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  String url = "http://192.168.7.239/wa_server";
  // String url = "https://wasteaway.000webhostapp.com";
  String googleApiKey = "AIzaSyCZZ_8RSLTF0eQIyjXpjXb51AwanWMm-yg";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Color(primaryBlueColor)),
          primaryColor: Color(primaryBlueColor),
          fontFamily: "Urbanist",
          textTheme: textTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          inputDecorationTheme: inputFormTheme,
          textButtonTheme: textButtonTheme,
          appBarTheme: appBarTheme,
          scaffoldBackgroundColor: Colors.white
      ),
      home: LoginScreen(),
      routes: {
        '/login' : (context) => LoginScreen(),
        '/dashboard' : (context) => DashboardScreen(),
      },
    );
  }
}
