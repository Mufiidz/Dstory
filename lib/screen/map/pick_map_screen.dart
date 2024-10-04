import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/location_mark.dart';
import '../../utils/export_utils.dart';
import 'cubit/pick_map_cubit.dart';

class PickMapScreen extends StatefulWidget {
  final LatLng? latLng;
  const PickMapScreen({super.key, this.latLng});

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  late final GoogleMapController _controller;
  LocationMark? _currentLocationMark;
  late final PickMapCubit _cubit;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final LoadingDialog _loadingDialog;
  Set<Marker> markers = const <Marker>{};

  @override
  void initState() {
    _cubit = getIt<PickMapCubit>();
    _loadingDialog = getIt<LoadingDialog>();

    final double? latitude = widget.latLng?.latitude;
    final double? longitude = widget.latLng?.longitude;

    _cubit.initial(latitude, longitude);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PickMapCubit, PickMapState>(
        bloc: _cubit,
        listener: (BuildContext context, PickMapState state) {
          final PickMapState(
            :LocationMark? locationMark,
            :List<LocationMark> locations,
            :bool isLoading,
            :bool isError,
            :String message,
            :bool isInitial
          ) = state;
          logger.d('state: $state');
          _loadingDialog.show(context, isLoading);
          _currentLocationMark = locationMark;

          final double? latitude = locationMark?.lat;
          final double? longitude = locationMark?.lng;

          if (latitude != null && longitude != null && locationMark != null) {
            final LatLng latLng = LatLng(latitude, longitude);

            _controller.moveCamera(isInitial
                ? CameraUpdate.newLatLngZoom(latLng, 20.0)
                : CameraUpdate.newLatLng(latLng));
          }

          if (locations.isNotEmpty) {
            final LocationMark searchLocationMark = locations.first;
            _currentLocationMark = searchLocationMark;

            final LatLng latLng =
                LatLng(searchLocationMark.lat, searchLocationMark.lng);

            _controller.moveCamera(isInitial
                ? CameraUpdate.newLatLngZoom(latLng, 20.0)
                : CameraUpdate.newLatLng(latLng));
          }

          if (isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              message,
              context,
              state: SnackbarState.error,
            ));
          }
        },
        builder: (BuildContext context, PickMapState state) {
          final PickMapState(
            :LocationMark? locationMark,
            :Set<Marker> markers,
          ) = state;
          final double lat = locationMark?.lat ?? 0;
          final double lng = locationMark?.lng ?? 0;
          final Placemark? placemark = locationMark?.placemark;
          return Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: LatLng(lat, lng)),
                      onMapCreated: (GoogleMapController controller) =>
                          _controller = controller,
                      onTap: (LatLng argument) => _cubit.onMapTap(argument),
                      markers: markers,
                    )),
                Visibility(
                  visible: locationMark != null,
                  child: Container(
                    width: context.mediaSize.width,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(placemark?.street ?? '-',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: context.mediaSize.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Text(
                            Utils.getFullPlaceMark(placemark),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SpacerWidget(32),
                        SizedBox(
                          width: context.mediaSize.width,
                          child: FilledButton(
                              onPressed: () =>
                                  AppRoute.back(_currentLocationMark),
                              child: Text(LocaleKeys.pick_location.localized)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SafeArea(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                            onPressed: () => AppRoute.back(),
                            icon: const Icon(Icons.arrow_back)),
                      ),
                      Expanded(
                          child: FormBuilder(
                              key: _formKey,
                              child: TextFieldWidget(
                                'search',
                                hint: LocaleKeys.search.localized,
                                border: InputBorder.none,
                                onSubmitted: (String? value) {
                                  if (value != null && value.isNotEmpty) {
                                    _cubit.searchMap(value);
                                  }
                                },
                              ))),
                    ],
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
