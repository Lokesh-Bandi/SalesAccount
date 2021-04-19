import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
class CurrentPosition {

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied');
      }
    }

    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final coordinates = new Coordinates(position.latitude,position.longitude);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    return addresses[0].locality+','+addresses[0].subAdminArea+' '+addresses[0].postalCode;
  }
}