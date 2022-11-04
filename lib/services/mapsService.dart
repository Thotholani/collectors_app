import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../theme.dart';

class MapWithPoly extends StatefulWidget {
  @override
  State<MapWithPoly> createState() => _MapWithPolyState();
}

class _MapWithPolyState extends State<MapWithPoly> {
  final String _googleApiKey = "AIzaSyCZZ_8RSLTF0eQIyjXpjXb51AwanWMm-yg";
  LocationData?  currentLocation;

  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng source = LatLng(-15.5101,28.3114);
  static const LatLng destination = LatLng(-15.5036,28.3242);

  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    print("Running get current location code");
    Location location = Location();
    location.getLocation().then((location) => currentLocation = location);
    GoogleMapController googleMapController = await _controller.future;
    getPolyPoints();
    print("Current location is");
    print(location.getLocation().toString());
    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLocation.latitude!,newLocation.longitude!),zoom: 13.5)));
      setState((){});
    });
  }

  void getPolyPoints( ) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(_googleApiKey, PointLatLng(currentLocation!.latitude!,currentLocation!.longitude!), PointLatLng(destination.latitude,destination.longitude));
    if(result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
    }
    setState((){});
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/source.png").then((icon){
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/destination.png").then((icon){
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/truck.png").then((icon){
      currentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    setState((){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: (gmapCon) {
        _controller.complete(gmapCon);
      },
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),zoom: 20),
      polylines: {
        Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(secondaryGreenColor),
            width: 6
        ),
      },
      markers: {
        Marker(
            icon:currentLocationIcon,
            markerId: MarkerId("Current Location"),
            position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!)
        ),
        Marker(
            icon:destinationIcon,
            markerId: MarkerId("Destination"),
            position: destination
        )
      },
    );
  }
}
