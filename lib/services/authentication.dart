import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/progressDialog.dart';
import '../main.dart';
import '../theme.dart';

String apiURL = MyApp().url;

void login(email, password, BuildContext context) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  String url = apiURL;
  url = url + "/loginCollector.php";

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Authenticating...");
      },
      barrierDismissible: false);

  var response = await http
      .post(Uri.parse(url), body: {'email': email, 'password': password});
  //if we get a response from server
  if (response.statusCode == 200) {
    print("This is the response " + response.body.toString());
    var jsondata = jsonDecode(response.body.toString());
    if (jsondata["success"]) {
      await Future.delayed(const Duration(seconds: 1), () {});
      sharedPreferences.setString("collector_id", jsondata['collector_id']);
      sharedPreferences.setString("name", jsondata['name']);
      sharedPreferences.setString("phoneNumber", jsondata['phoneNumber']);
      sharedPreferences.setString("balance", jsondata['balance']);
      sharedPreferences.setString("email", jsondata['email']);

      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
      Fluttertoast.showToast(
        msg: "Welcome " + sharedPreferences.getString("name").toString(),
        backgroundColor: Color(secondaryGreenColor),
      );
    } else {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: jsondata["message"],
        backgroundColor: Color(cancelRedColor),
      );
    }
  } else {
    await Future.delayed(const Duration(seconds: 2), () {});
    Fluttertoast.showToast(
      msg: "Error connecting to server",
      backgroundColor: Color(cancelRedColor),
    );
  }
}

void logout(BuildContext context, String path) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  sharedPreferences.remove("collector_id");
  sharedPreferences.remove("name");
  sharedPreferences.remove("phoneNumber");
  sharedPreferences.remove("balance");
  sharedPreferences.remove("email");

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Logging Out...");
      },
      barrierDismissible: false
  );
  await Future.delayed(const Duration(seconds: 2), () {});
  Navigator.pop(context);

  Navigator.pop(context);
  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  Fluttertoast.showToast(
    msg: "Logout Successful",
    backgroundColor: Color(secondaryGreenColor),
  );
}