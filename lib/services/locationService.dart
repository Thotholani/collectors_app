import 'package:location/location.dart';

class LocationService {
  LocationData?  currentLocation;

  Future<LocationData?> getCurrentLocation() async {
    print("Running get current location code");
    Location location = Location();
    currentLocation = await location.getLocation();
    print("Current location is: " + currentLocation!.toString());
    return currentLocation;
  }
}