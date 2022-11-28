import 'dart:convert';
import 'dart:ui';
import 'package:collectors_app/models/collection.dart';
import 'package:collectors_app/models/newCollection.dart';
import 'package:collectors_app/screens/dashboardScreen.dart';
import 'package:collectors_app/screens/homePage.dart';
import 'package:collectors_app/services/locationService.dart';
import 'package:collectors_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../screens/mapPage.dart';

String apiURL = MyApp().url;
String googleApiKey = MyApp().googleApiKey;
List<LatLng> polylineCoordinates = [];

void  acceptRequest(String collection_id,String collector_id, BuildContext context) async {
  String url = apiURL;
  url = url + "/acceptRequest.php";

  var response = await http.post(Uri.parse(url), body: {'collector_id': collector_id, 'collection_id': collection_id});
  if (response.statusCode == 200) {
    // print(response);
    print(response.body);
    var jsondata = jsonDecode(response.body.toString());
    if(jsondata["success"]) {
      String collectionId = jsondata["collection_id"];
      String name = jsondata["name"];
      String phoneNumber = jsondata["phone_number"];
      String latitude = jsondata["latitude"] ;
      String longitude =jsondata["longitude"];
      String address = jsondata["address"];

      NewCollection collection = NewCollection(name: name, phoneNumber: phoneNumber, address: address, latitude: double.parse(latitude), longitude: double.parse(longitude), collection_id: collectionId);
      print("Success! Plotting a route to the pickup point!");

      var pickupLocation = LatLng(double.parse(latitude), double.parse(longitude));
      var carLocation = await LocationService().getCurrentLocation();
      var polypoints = await getPolypoints(pickupLocation, carLocation);

      await Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage(currentCollection: collection, carLocationVariable: carLocation,polylineCoordinates: polypoints,)));
      Navigator.pop(context);
    } else {
      print("Error");
    }
  } else {
    Fluttertoast.showToast(
      msg: "Error connecting to server",
      backgroundColor: Color(cancelRedColor),
    );
  }
}

Future<List<LatLng>> getPolypoints(LatLng pickupLocation, LocationData? carLocation) async {
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleApiKey, PointLatLng(carLocation!.latitude!,carLocation.longitude!), PointLatLng(pickupLocation.latitude,pickupLocation.longitude));
  if(result.points.isNotEmpty) {
    result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
  }
  return polylineCoordinates;
}

class CollectionsService {
  static Future<List<Collection>> getCurrentCollections(String collectorId) async {
    String url = MyApp().url + "/getCurrentCollections.php";

    var response = await http.post(Uri.parse(url), body: {
      'collector_id': collectorId,
    });

    final body = json.decode(response.body);
    print(body);
    return List.from(body.map<Collection>(Collection.fromJson).toList());
  }

  static Future<List<Collection>> getPreviousCollections(String collectorId) async {
    String url = MyApp().url + "/getPreviousCollections.php";

    var response = await http.post(Uri.parse(url), body: {
      'collector_id': collectorId,
    });

    final body = json.decode(response.body);
    return List.from(body.map<Collection>(Collection.fromJson).toList());
  }

  static Future<List<Collection>> getOnDemandRequests() async {
    String url = MyApp().url + "/getOnDemandRequests.php";
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);
    return List.from(body.map<Collection>(Collection.fromJson).toList());
  }

  static Future<void> confirmPickup(String collectionId, BuildContext context) async {
    String url = apiURL;
    url = url + "/confirmPickup.php";

    var response = await http.post(Uri.parse(url), body: {'collection_id': collectionId});
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body.toString());
      if(jsondata["success"]) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Column(children: [
              Icon(FeatherIcons.checkCircle,size: 50,color: Color(secondaryGreenColor),),
              SizedBox(height: 5,),
              const Text('Pickup Confirmed')
            ])),
            content: Text("Thank you for your service.",style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: const Text('Dismiss',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/dashboard', (route) => false);
                },
              ),
            ],
          );
        });
      } else {
        print("Error");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error connecting to server",
        backgroundColor: Color(cancelRedColor),
      );
    }
  }
}