import 'package:flutter/material.dart';

import '../theme.dart';

class NoInformation extends StatelessWidget {
  NoInformation({required this.errorHeading, required this.errorDetail});
  final String errorHeading;
  final String errorDetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
            children: [
              Image.asset("assets/images/no_information.png"),
              Text(
                errorHeading,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(errorDetail),
              SizedBox(
                height: 20,
              ),
            ]
        ),
      ),
    );
  }
}
