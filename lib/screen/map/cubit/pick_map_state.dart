part of 'pick_map_cubit.dart';

@MappableClass()
class PickMapState extends BaseState with PickMapStateMappable {
  final LocationMark? locationMark;
  final List<LocationMark> locations;
  final bool isInitial;
  final Set<Marker> markers;

  PickMapState(
      {super.message,
      super.statusState,
      this.locations = const <LocationMark>[],
      this.locationMark,
      this.isInitial = true,
      this.markers = const <Marker>{}});
}
