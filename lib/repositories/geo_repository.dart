import 'package:geolocator/geolocator.dart';

class GeoRepository {
  final GeolocatorPlatform _geolocator;

  const GeoRepository(this._geolocator);

  Stream<Position> getCurrentLocation() {
    return _geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
