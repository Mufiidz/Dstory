import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:latlong2/latlong.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/location_mark.dart';
import '../../model/story.dart';
import '../../utils/export_utils.dart';
import '../home/home_screen.dart';
import 'cubit/add_story_cubit.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  late final AddStoryCubit _cubit;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final LoadingDialog _loadingDialog;
  LatLng _latLng = const LatLng(0, 0);

  @override
  void initState() {
    _cubit = getIt<AddStoryCubit>();
    _loadingDialog = getIt<LoadingDialog>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(LocaleKeys.add_story.localized),
      body: BlocListener<AddStoryCubit, AddStoryState>(
        bloc: _cubit,
        listener: (BuildContext context, AddStoryState state) {
          final AddStoryState(
            :LocationMark? locationMark,
            :bool isError,
            :bool isSuccess,
            :String message,
            :bool isLoading
          ) = state;
          _loadingDialog.show(context, isLoading);

          final double? lat = locationMark?.lat;
          final double? lng = locationMark?.lng;

          if (lat != null && lng != null) {
            _latLng = LatLng(lat, lng);
          }

          if (isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              message,
              context,
              state: SnackbarState.error,
            ));
          }

          if (isSuccess) {
            context.snackbar.showSnackBar(SnackbarWidget(
              message,
              context,
              state: SnackbarState.success,
            ));
            _formKey.currentState?.reset();
            AppRoute.clearAll(const HomeScreen());
          }
        },
        child: FormBuilder(
          key: _formKey,
          child: ListWidget<Widget>(
            _contents,
            isSeparated: true,
            itemBuilder: (BuildContext context, Widget item, int index) {
              if (index == 0 || index == 2) {
                return item;
              }
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: item);
            },
            separatorBuilder: (BuildContext context, Widget item, int index) {
              if (index == 1) {
                return const Divider();
              }
              return const SizedBox(
                height: 16,
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> get _contents => <Widget>[
        BlocSelector<AddStoryCubit, AddStoryState, String>(
          bloc: _cubit,
          selector: (AddStoryState state) => state.pathImage,
          builder: (BuildContext context, String state) {
            return PickImageWidget(
              'photo',
              pickImage: (FormFieldState<String> field) =>
                  _chooseImage(context, field),
              image: state,
            );
          },
        ),
        TextFieldWidget(
          'description',
          hint: LocaleKeys.description.localized,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 3,
          border: InputBorder.none,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.normal, color: Colors.grey),
          validators: <String? Function(String? p1)>[
            FormBuilderValidators.required()
          ],
        ),
        InkWell(
          onTap: _cubit.pickLocation,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                const Icon(Icons.location_on),
                const SpacerWidget(
                  8,
                  isHorizontal: true,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      LocaleKeys.add_location,
                      style: TextStyle(fontSize: 15),
                    ).tr(),
                    BlocSelector<AddStoryCubit, AddStoryState, LocationMark?>(
                      bloc: _cubit,
                      selector: (AddStoryState state) => state.locationMark,
                      builder: (BuildContext context, LocationMark? state) {
                        return Visibility(
                            visible: state != null && state.location.isNotEmpty,
                            child: Text(
                              state?.location ?? '-',
                              style: const TextStyle(fontSize: 12),
                            ));
                      },
                    )
                  ],
                )),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        ),
        SizedBox(
            height: 50,
            child: FilledButton(
                onPressed: _onSubmit, child: const Text(LocaleKeys.post).tr()))
      ];

  void _onSubmit() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    logger.d('formKeyState: ${formKeyState.value}');

    StoryDTO story = StoryDTO.fromJson(formKeyState.value);
    story = story.copyWith(lat: _latLng.latitude, lon: _latLng.longitude);

    final String newDesc = story.description.cleanedText;
    logger.d('newDesc: $newDesc');
    story = story.copyWith(description: newDesc);
    logger.d('story: $story');
    _cubit.addStory(story);
  }

  @override
  void dispose() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState != null) {
      formKeyState
        ..deactivate()
        ..dispose();
    }
    super.dispose();
  }

  void _chooseImage(BuildContext context, FormFieldState<String> field) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text(LocaleKeys.camera).tr(),
                  onTap: () {
                    _cubit.openCamera(field);
                    AppRoute.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_album),
                  title: const Text(LocaleKeys.gallery).tr(),
                  onTap: () {
                    _cubit.pickImage(field);
                    AppRoute.back();
                  },
                ),
              ]),
            ));
  }
}
