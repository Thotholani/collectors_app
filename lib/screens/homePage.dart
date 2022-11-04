import 'dart:async';

import 'package:collectors_app/components/buttons.dart';
import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/screens/mapPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/newCollection.dart';
import '../services/mapsService.dart';
import '../theme.dart';

late String collector_id = "";
late String name = "";
late String balance = "";
late String phoneNumber = "";
late String email = "";

class HomePage extends StatefulWidget {
  HomePage({required this.currentLocation, required this.currentLocationIcon});
  final LocationData? currentLocation;
  final BitmapDescriptor currentLocationIcon;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      collector_id = prefs.getString("collector_id")!;
      name = sharedPrefs.getString("name")!;
      balance = sharedPrefs.getString("balance")!;
      phoneNumber = sharedPrefs.getString("phoneNumber")!;
      email = sharedPrefs.getString("email")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Color(lightGreenColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello $name" ,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text("Let’s clean up this city",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: widget.currentLocation == null ? Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 30,),
                              Text("Getting Your Current Location..."),
                            ]
                        )
                    ) : GoogleMap(
                        initialCameraPosition: CameraPosition(
                        target: LatLng(widget.currentLocation!.latitude!,widget.currentLocation!.longitude!),
                            zoom: 20
                        ),
                      markers: {
                        Marker(
                            icon:widget.currentLocationIcon,
                            markerId: MarkerId("Current Location"),
                            position: LatLng(widget.currentLocation!.latitude!,widget.currentLocation!.longitude!)
                        ),
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    color: Color(primaryBlueColor),
                    width: double.infinity,
                    height: 95,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Balance",style: Theme.of(context).textTheme.subtitle2),
                          Text("K$balance.00",style: Theme.of(context).textTheme.subtitle1)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Container(
                  //   child: DashboardScreen().isBusy == true ? SecondaryGreenButton(buttonText: "Go to Navigation", onPressed: (){}) : SizedBox(
                  //     height: 55,
                  //     width: double.infinity,
                  //     child: ElevatedButton( style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all<Color>(Color(secondaryGreenColor)),
                  //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5.0),
                  //           )
                  //       ),
                  //     ),onPressed: null, child: Text("Button Disabled")),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
