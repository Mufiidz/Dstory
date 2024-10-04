import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../data/network/responses/base_response.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../model/location_mark.dart';
import '../../../model/story.dart';
import '../../../repository/story_repositories.dart';
import '../../../utils/export_utils.dart';
import '../../map/pick_map_screen.dart';

part 'add_story_state.dart';
part 'add_story_cubit.mapper.dart';

@injectable
class AddStoryCubit extends Cubit<AddStoryState> {
  final StoryRepository _storyRepository;
  AddStoryCubit(this._storyRepository) : super(AddStoryState());

  void pickImage(FormFieldState<String> field) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final BaseResult<String> result = await _storyRepository.pickImage();

    final AddStoryState newState = result.when(
        result: (String data) {
          field.didChange(data);
          return state.copyWith(pathImage: data, statusState: StatusState.idle);
        },
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));

    emit(newState);
  }

  void openCamera(FormFieldState<String> field) async {
    emit(state.copyWith(statusState: StatusState.loading));
    final BaseResult<String> result = await _storyRepository.takePicture();

    final AddStoryState newState = result.when(
        result: (String data) {
          field.didChange(data);
          return state.copyWith(pathImage: data, statusState: StatusState.idle);
        },
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));

    emit(newState);
  }

  void addStory(StoryDTO story) async {
    emit(state.copyWith(statusState: StatusState.loading));
    story = story.copyWith(description: story.description.trim());

    final BaseResult<BaseResponse> result =
        await _storyRepository.addStory(story);

    final AddStoryState newState = result.when(
        result: (BaseResponse data) => state.copyWith(
            statusState: StatusState.success,
            message: LocaleKeys.success_add_story_msg.localized),
        error: (String error) =>
            state.copyWith(statusState: StatusState.failure, message: error));

    emit(newState);
  }

  void pickLocation() async {
    emit(state.copyWith(statusState: StatusState.loading));
    final LocationMark? locationMark = state.locationMark;
    final double? latitude = locationMark?.lat;
    final double? longitude = locationMark?.lng;
    LatLng? oldLatLng;

    if (latitude != null && longitude != null) {
      oldLatLng = LatLng(latitude, longitude);
    }

    final dynamic newLocationMark = await AppRoute.to(PickMapScreen(
      latLng: oldLatLng,
    ));
    logger.d('result Pick Map: $newLocationMark');
    if (newLocationMark == null && newLocationMark is! LocationMark) return;

    emit(state.copyWith(
        statusState: StatusState.idle, locationMark: newLocationMark));
  }
}
