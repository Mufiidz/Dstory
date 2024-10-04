import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../model/location_mark.dart';
import '../../../repository/map_repository.dart';
import '../../../utils/export_utils.dart';

part 'pick_map_state.dart';
part 'pick_map_cubit.mapper.dart';

@injectable
class PickMapCubit extends Cubit<PickMapState> {
  final MapRepository _mapRepository;
  PickMapCubit(this._mapRepository) : super(PickMapState());

  void initial(double? latitude, double? longitude) async {
    emit(state.copyWith(statusState: StatusState.loading, isInitial: true));

    final bool isNotEmptLatLng = await Future<bool>.delayed(
        const Duration(seconds: 2),
        () => latitude != null && longitude != null);

    if (isNotEmptLatLng) {
      final BaseResult<LocationMark> resultLocation =
          await _mapRepository.getAddress(latitude ?? 0, longitude ?? 0);

      final PickMapState newState = resultLocation.when(
          result: (LocationMark locationMark) {
            final LocationMark(:double lat, :double lng, :String location) =
                locationMark;

            final Marker marker = Marker(
              markerId: const MarkerId('current_position'),
              position: LatLng(lat, lng),
              infoWindow:
                  InfoWindow(title: location, snippet: '$latitude, $longitude'),
              onTap: () => emit(state.copyWith(locationMark: locationMark)),
            );

            return state.copyWith(
                locationMark: locationMark,
                statusState: StatusState.idle,
                markers: <Marker>{marker});
          },
          error: (String error) =>
              state.copyWith(statusState: StatusState.failure, message: error));
      emit(newState);
      return;
    }

    final BaseResult<void> result = await _mapRepository.locationPermission();

    if (result is ErrorResult) {
      emit(state.copyWith(
          statusState: StatusState.failure, message: result.message));
      return;
    }

    final BaseResult<LocationMark> resultPosition =
        await _mapRepository.getCurrentPosition();

    final PickMapState newState = resultPosition.when(
        result: (LocationMark locationMark) {
          final LocationMark(:double lat, :double lng, :String location) =
              locationMark;

          logger.d('locationMark: $locationMark');

          final Marker marker = Marker(
            markerId: const MarkerId('current_position'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: location, snippet: '$lat, $lng'),
            onTap: () => emit(state.copyWith(locationMark: locationMark)),
          );
          return state.copyWith(
              locationMark: locationMark,
              statusState: StatusState.idle,
              markers: <Marker>{marker});
        },
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));
    emit(newState);
  }

  void searchMap(String query) async {
    if (query.isEmpty || query.length <= 3) return;
    emit(state.copyWith(statusState: StatusState.loading, isInitial: false));

    final BaseResult<List<LocationMark>> result =
        await _mapRepository.searchMap(query);

    final PickMapState newState = result.when(
        result: (List<LocationMark> data) {
          Set<Marker> markers = <Marker>{};
          if (data.isNotEmpty) {
            final Set<Marker> newMarkers =
                data.mapIndexed((int index, LocationMark locationMark) {
              final LocationMark(:double lat, :double lng, :String location) =
                  locationMark;
              return Marker(
                markerId: MarkerId('Location $index'),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                  title: location,
                  snippet: '$lat, $lng',
                ),
                onTap: () => emit(state.copyWith(locationMark: locationMark)),
              );
            }).toSet();
            markers.addAll(newMarkers);
          }

          return state.copyWith(
              statusState: StatusState.idle, locations: data, markers: markers);
        },
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));
    emit(newState);
  }

  void onMapTap(LatLng latLng) async {
    emit(state.copyWith(statusState: StatusState.loading, isInitial: false));

    final BaseResult<LocationMark> result =
        await _mapRepository.getAddress(latLng.latitude, latLng.longitude);

    final PickMapState newState = result.when(
        result: (LocationMark data) {
          final Marker marker = Marker(
            markerId: const MarkerId('current_position'),
            position: latLng,
            infoWindow: InfoWindow(
                title: data.location,
                snippet: '${latLng.latitude}, ${latLng.longitude}'),
            onTap: () => emit(state.copyWith(locationMark: data)),
          );
          return state.copyWith(
              statusState: StatusState.idle,
              locationMark: data,
              markers: <Marker>{marker});
        },
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));
    emit(newState);
  }
}
