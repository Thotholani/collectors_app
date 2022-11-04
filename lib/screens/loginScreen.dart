import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wasteaway/models/client.dart';
// import 'package:wasteaway/services/tests.dart';
// import 'package:wasteaway/theme.dart';

import '../components/buttons.dart';
import '../components/inputBox.dart';
import '../services/authentication.dart';
import '../theme.dart';
// import '../services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString("email");
    setState(() {
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Container(
               color: Color(lightGreenColor),height: 220,
               width: double.infinity,
               child: Center(child: Image.asset("assets/images/logo.png",height: 105,)),
             ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    Text("Welcome",style: Theme.of(context).textTheme.headline1,),
                    SizedBox(height: 40,),
                    textInputBox(controller: emailController,inputLabel: "Email",inputType: TextInputType.emailAddress),
                    SizedBox(height: 15,),
                    passwordInputBox(passwordController: passwordController),
                    SizedBox(height: 15,),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password"),
                      ),
                    ),
                    SecondaryGreenButton(buttonText: "Login", onPressed: (){
                      emailController.text.isNotEmpty && passwordController.text.isNotEmpty ? emailController.text.contains("@") ? login(emailController.text,passwordController.text,context) :  Fluttertoast.showToast(
                        msg: "Your email must contain the @ symbol ",
                        backgroundColor: Color(cancelRedColor),
                      ) :  Fluttertoast.showToast(
                        msg: "Please fill in all fields",
                        backgroundColor: Color(cancelRedColor),
                      );
                    },),
                    SizedBox(height: 20,),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Color(primaryBlueColor),
                          textStyle: TextStyle(fontWeight: FontWeight.normal)
                      ),
                      onPressed: () {

                      },
                      child: Text("Not registered? Find out how you can"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
