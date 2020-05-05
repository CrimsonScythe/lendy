import 'package:geolocator/geolocator.dart';

class LocationProvider {

  Future<Position> getLocation() {
    return Geolocator().getCurrentPosition();
  }

}