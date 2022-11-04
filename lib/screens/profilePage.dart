import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../theme.dart';
import 'dashboardScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/collectorProfile.png",height: 150,),
                TextBoxContainer(text: name, textHeader: 'Company Name', icon: EvaIcons.personOutline,),
                TextBoxContainer(text: phoneNumber, icon: EvaIcons.smartphoneOutline, textHeader: 'Mobile Number',),
                TextBoxContainer(text: email, icon: EvaIcons.emailOutline, textHeader: 'Email',),
                PrimaryBlueButton(buttonText: "Edit Details", onPressed: (){}),
              ],
            ),
          )
      ),
    );
  }
}

class TextBoxContainer extends StatelessWidget {
  TextBoxContainer({required this.text, required this.textHeader, required this.icon});
  final String text;
  final String textHeader;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Color(greyishBlueColor)),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width: 15,),
            Container(child: Center(child: Icon(icon)),height: 20,width: 20,),
            SizedBox(width: 30,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(textHeader),
                Text(text,style: TextStyle(fontSize: 20,color: Color(primaryBlueColor)),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
