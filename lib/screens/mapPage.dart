import 'dart:async';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:collectors_app/models/newCollection.dart';
import 'package:collectors_app/services/collectionService.dart';
import 'package:collectors_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import 'mapPage.dart';

LocationData? carLocation;
double distance = 100.0;

class MapPage extends StatefulWidget {
  MapPage(
      {required this.currentCollection,
      required this.carLocationVariable,
      required this.polylineCoordinates});
  late final LocationData? carLocationVariable;
  final NewCollection currentCollection;
  final List<LatLng> polylineCoordinates;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final panelController = PanelController();

  var location = Location();

  late double latitude = widget.currentCollection.latitude;
  late double longitude = widget.currentCollection.longitude;

  final Completer<GoogleMapController> _controller = Completer();
  late LatLng destination = LatLng(latitude, longitude);

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location myLocation = Location();

    myLocation.getLocation().then((location) {
      carLocation = location;
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) {
      carLocation = newLocation;
      print(
          "New Location latlong: ${newLocation.latitude}, ${newLocation.longitude}");
      print(
          "Old Car latlong: ${carLocation?.latitude}, ${carLocation?.longitude}");
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(newLocation.latitude!, newLocation.longitude!),
              zoom: 18)));
      distance = calculateDistance(
          carLocation!.latitude, carLocation!.longitude, latitude, longitude);
      print("distance: ${distance}");
      setState(() {});
    });
  }

  void updateLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLocation) {
      carLocation = newLocation;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(newLocation.latitude!, newLocation.longitude!),
              zoom: 13.5)));
      setState(() {});
    });
    setState(() {});
  }

  void changeLocationMarkersIcons() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/destination.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/truck.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    carLocation = widget.carLocationVariable;
    changeLocationMarkersIcons();
    getCurrentLocation();
    // updateLocation();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // updateLocation();
    getCurrentLocation();
    changeLocationMarkersIcons();

    return Scaffold(
      body: carLocation == null
          ? Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Creating a route to the pickup point..."),
                  ]),
            )
          : SlidingUpPanel(
              controller: panelController,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              minHeight: MediaQuery.of(context).size.height * 0.01,
              maxHeight: MediaQuery.of(context).size.height * 0.35,
              body: Container(
                child: GoogleMap(
                  onMapCreated: (gmapCon) {
                    _controller.complete(gmapCon);
                  },
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          carLocation!.latitude!, carLocation!.longitude!),
                      zoom: 10),
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("route"),
                        points: widget.polylineCoordinates,
                        color: Color(secondaryGreenColor),
                        width: 6),
                  },
                  markers: {
                    Marker(
                        icon: currentLocationIcon,
                        markerId: MarkerId("Current Location"),
                        position: LatLng(
                            carLocation!.latitude!, carLocation!.longitude!)),
                    Marker(
                        icon: destinationIcon,
                        markerId: MarkerId("Destination"),
                        position: destination)
                  },
                ),
              ),
              panelBuilder: (scrollCon) => PanelWidget(thePanelController: panelController, name: widget.currentCollection.name, thePhoneNumber: widget.currentCollection.phoneNumber, collectionId: widget.currentCollection.collection_id, address: widget.currentCollection.address,)
              ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  PanelWidget({required this.thePanelController, required this.address, required this.name, required this.thePhoneNumber, required this.collectionId});
  final PanelController thePanelController;
  final String address;
  final String name;
  final String thePhoneNumber;
  final String collectionId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () =>
            thePanelController.isPanelOpen ? thePanelController.close() : thePanelController.open(),
          child: Center(child: Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
                color: Color(secondaryGreenColor),
              borderRadius: BorderRadius.circular(15)
            ),
          )),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Navigating...',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    baseColor: Color(secondaryGreenColor),
                    highlightColor: Colors.white),
                Text(address),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/avatar.png",
                        height: 45,
                      ),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(secondaryGreenColor),
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        width: 50,
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              var phoneNumber = Uri.parse("tel:" +
                                  thePhoneNumber);
                              launchUrl(phoneNumber);
                            },
                            icon: Icon(CarbonIcons.phone)),
                      ),
                    ]),
                distance <= 0.05
                    ? SlideAction(
                        sliderRotate: false,
                        borderRadius: 12,
                        elevation: 0,
                        innerColor: Color(secondaryGreenColor),
                        outerColor: Color(lightGreenColor),
                        text: "Slide to Confirm Pickup",
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Color(secondaryGreenColor)),
                        onSubmit: () {
                          CollectionsService.confirmPickup(
                              collectionId,
                              context);
                        },
                      )
                    : Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffE8F4EA),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(child: Text("In Transit"))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
