import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(245, 248, 255, 1),
      child: Container(
        margin: EdgeInsets.all(15.0),
        width:double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFf5f8ff),
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3BA935)),),
              SizedBox(width: 25,),
              Text(message,style: TextStyle(color: Color(0xFF192C49)),)
            ],
          ),
        ),
      ),
    );
  }
}
