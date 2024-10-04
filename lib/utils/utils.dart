import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';

@singleton
class Utils {
  static String? getPlaceMark(String? street, String? city) {
    if (street != null && city != null) {
      return '$street, $city';
    } else if (street != null) {
      return street;
    } else if (city != null) {
      return city;
    } else {
      return null;
    }
  }

  static String getFullPlaceMark(Placemark? placeMark) {
    if (placeMark == null) return '-';
    final Placemark(
      :String? street,
      :String? subLocality,
      :String? locality,
      :String? subAdministrativeArea,
      :String? administrativeArea,
      :String? country,
      :String? postalCode
    ) = placeMark;
    final List<String?> placemarks = <String?>[
      street,
      subLocality,
      locality,
      subAdministrativeArea,
      administrativeArea,
      country,
      postalCode
    ]..removeWhere((String? element) => element == null);
    return "${placemarks.join(', ')}.";
  }
}
