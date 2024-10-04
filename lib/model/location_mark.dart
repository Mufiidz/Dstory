import 'package:dart_mappable/dart_mappable.dart';
import 'package:geocoding/geocoding.dart';

part 'location_mark.mapper.dart';

@MappableClass(
    generateMethods: GenerateMethods.copy |
        GenerateMethods.stringify |
        GenerateMethods.equals)
class LocationMark with LocationMarkMappable {
  final double lat;
  final double lng;
  final String location;
  final Placemark? placemark;

  const LocationMark(
      {this.lat = 0, this.lng = 0, this.location = '', this.placemark});
}
