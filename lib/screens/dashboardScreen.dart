import 'dart:async';
import 'dart:convert';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:collectors_app/components/buttons.dart';
import 'package:collectors_app/models/collection.dart';
import 'package:collectors_app/screens/homePage.dart';
import 'package:collectors_app/screens/onDemandScreen.dart';
import 'package:collectors_app/screens/pickupsPage.dart';
import 'package:collectors_app/screens/profilePage.dart';
import 'package:collectors_app/services/locationService.dart';
import 'package:collectors_app/theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/collectionPopUp.dart';
import '../main.dart';
import '../services/authentication.dart';
import 'mapPage.dart';

late String collector_id = "";
late String name = "";
late String balance = "";
late String phoneNumber = "";
late String email = "";

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);
  bool displayedNotification = true;
  bool isBusy = false;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences sharedPrefs;

  int index = 0;
  bool _isVisible = true;

  String obtainedAddress = "";
  String obtainedServiceFee = "";
  String collection_id = "";

  LocationData? currentLocation;

  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async{
    currentLocation = await LocationService().getCurrentLocation();
  }

  void changeLocationMarkersIcons() {
    // BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/source.png").then((icon){
    //   sourceIcon = icon;
    // });
    // BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/destination.png").then((icon){
    //   destinationIcon = icon;
    // });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/truck.png").then((icon){
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    changeLocationMarkersIcons();
    setState((){});
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
    Future<List<Collection>> getCollections() async {
      List<Collection> _collections = [];
      // TODO : Implement check to see if a collector has a request that they have accepted. If so ignore other requests
      if(widget.displayedNotification && widget.isBusy == false) {
        String apiURL = MyApp().url;
        String url = apiURL;
        url = url+"/getRequests.php";

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // print(response);
          if(response.body.isNotEmpty) {
            final body = jsonDecode(response.body.toString());
            print(body);
            _collections = List.from(body.map<Collection>(Collection.fromJson).toList());
          }
        }
        obtainedAddress = _collections.first.address;
        collection_id = _collections.first.collection_id;
        print("Obtained Address: "+obtainedAddress);
        obtainedServiceFee = "50";

        if(_collections.isNotEmpty && widget.displayedNotification) {
          showDialog(context: context, builder: (BuildContext context) => CollectionDialog(address: obtainedAddress, serviceFee: obtainedServiceFee, setPage: (bool value) {
            widget.displayedNotification = value;
          }, collection_id: collection_id, acceptedRequest: (bool value) { widget.isBusy = value; },));
        }
        if(_collections.isEmpty) {
          print("The collections list contains no information");
        }
        return _collections;
      }
      return _collections;
    }

    Future<List<Collection>> collectionsFuture = getCollections();

    final pages = [
      HomePage(currentLocation: currentLocation,currentLocationIcon: currentLocationIcon),
      OnDemandScreen(),
      PickupsPage(),
      ProfileScreen()
    ];

    return Scaffold(
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: Container(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            tooltip: "Logout Button",
            backgroundColor: Color(lightGreenColor),
            child: Icon(
              size: 30,
              CarbonIcons.logout,
              color: Color(primaryBlueColor),
            ),
            onPressed: () {
              logout(context, "/login");},
          ),
        ),
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(
              fontSize: 14,
              color: Color(secondaryGreenColor)
            )
          ),
          iconTheme: MaterialStateProperty.all<IconThemeData>(
            IconThemeData(
              color: Color(greyishBlueColor)
            )
          )
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          height: 85, destinations: [
            NavigationDestination(icon: Icon(CarbonIcons.home), label: "Home",selectedIcon: Icon(CarbonIcons.home,color: Color(secondaryGreenColor),),),
            NavigationDestination(icon: Icon(CarbonIcons.timer), label: "On Demand",selectedIcon: Icon(CarbonIcons.timer,color: Color(secondaryGreenColor),),),
            NavigationDestination(icon: Icon(CarbonIcons.delivery), label: "Pickups",selectedIcon: Icon(CarbonIcons.delivery,color: Color(secondaryGreenColor),),),
            NavigationDestination(icon: Icon(CarbonIcons.user_profile), label: "Profile",selectedIcon: Icon(CarbonIcons.user_profile,color: Color(secondaryGreenColor),),)
        ],
        ),
      ),
    );
  }
}
