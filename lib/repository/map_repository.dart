import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../data/data_result.dart';
import '../generated/locale_keys.g.dart';
import '../model/location_mark.dart';
import '../utils/export_utils.dart';

abstract class MapRepository {
  Future<BaseResult<void>> locationPermission();
  Future<BaseResult<LocationMark>> getCurrentPosition();
  Future<BaseResult<List<LocationMark>>> searchMap(String query);
  Future<BaseResult<LocationMark>> getAddress(
      double latitude, double longitude);
}

@Injectable(as: MapRepository)
class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl();

  @override
  Future<BaseResult<void>> locationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return DataResult<void>(null);
      }

      permission = await Geolocator.requestPermission();

      return switch (permission) {
        LocationPermission.always => DataResult<void>(null),
        LocationPermission.whileInUse => DataResult<void>(null),
        LocationPermission.deniedForever =>
          ErrorResult<void>(LocaleKeys.permission_denied_forever_msg.localized),
        LocationPermission.denied =>
          ErrorResult<void>(LocaleKeys.permission_denied_msg.localized),
        LocationPermission.unableToDetermine =>
          ErrorResult<void>(LocaleKeys.permission_determine_msg.localized),
      };
    } catch (e) {
      return ErrorResult<void>(e.toString());
    }
  }

  @override
  Future<BaseResult<LocationMark>> getCurrentPosition() async {
    try {
      final Position(:double latitude, :double longitude) =
          await Geolocator.getCurrentPosition();
      final Placemark placemark = await _getPlace(latitude, longitude);
      logger.d('placemark: $placemark');
      final LocationMark locationMark = LocationMark(
          lat: latitude,
          lng: longitude,
          placemark: placemark,
          location: Utils.getPlaceMark(
                  placemark.street, placemark.administrativeArea) ??
              '-');

      return DataResult<LocationMark>(locationMark);
    } catch (e) {
      return ErrorResult<LocationMark>(e.toString());
    }
  }

  @override
  Future<BaseResult<List<LocationMark>>> searchMap(String query) async {
    try {
      List<LocationMark> locationMarks = <LocationMark>[];
      final List<Location> locations = await locationFromAddress(query);

      for (Location location in locations) {
        final Placemark placeMark =
            await _getPlace(location.latitude, location.longitude);
        final LocationMark locationMark = LocationMark(
            lat: location.latitude,
            lng: location.longitude,
            placemark: placeMark,
            location: Utils.getPlaceMark(
                    placeMark.street, placeMark.administrativeArea) ??
                '-');
        locationMarks.add(locationMark);
      }

      return DataResult<List<LocationMark>>(locationMarks);
    } catch (e) {
      return ErrorResult<List<LocationMark>>(e.toString());
    }
  }

  @override
  Future<BaseResult<LocationMark>> getAddress(
      double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return ErrorResult<LocationMark>(LocaleKeys.address_not_found_msg.localized);
      }

      logger.d('placemark: ${placemarks.first}');
      final Placemark(:String? street, :String? subAdministrativeArea) =
          placemarks.first;

      final String? city = subAdministrativeArea;

      final LocationMark locationMark = LocationMark(
          lat: latitude,
          lng: longitude,
          placemark: placemarks.first,
          location: Utils.getPlaceMark(street, city) ?? '-');

      return DataResult<LocationMark>(locationMark);
    } catch (e) {
      return ErrorResult<LocationMark>(e.toString());
    }
  }

  Future<Placemark> _getPlace(double latitude, double longitude) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    return placemarks.first;
  }
}
