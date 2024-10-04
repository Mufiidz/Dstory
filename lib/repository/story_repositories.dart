import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../data/data_result.dart';
import '../data/network/api_services.dart';
import '../data/network/responses/base_response.dart';
import '../data/network/responses/stories_response.dart';
import '../generated/locale_keys.g.dart';
import '../model/story.dart';
import '../utils/export_utils.dart';

abstract class StoryRepository {
  Future<BaseResult<StoriesResponse>> getAllStories(
      {int page, int size, int location});
  Future<BaseResult<String>> pickImage();
  Future<BaseResult<String>> takePicture();
  Future<BaseResult<BaseResponse>> addStory(StoryDTO story);
}

@Injectable(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final ApiServices _apiServices;
  final Dio dio;
  final ImagePicker imagePicker;
  StoryRepositoryImpl(this._apiServices, this.dio, this.imagePicker);

  @override
  Future<BaseResult<StoriesResponse>> getAllStories(
      {int page = 1, int size = 10, int location = 0}) async {
    try {
      final BaseResult<StoriesResponse> response = await _apiServices
          .getStories(page: page, size: size, location: location)
          .awaitResponse;

      if (response is ErrorResult) return response;
      final StoriesResponse storiesResponse = response.onDataResult;

      List<Story> stories = <Story>[];

      for (Story story in storiesResponse.listStory) {
        final double lat = story.lat;
        final double lng = story.lon;

        if (lat == 0.0 && lng == 0.0) {
          stories.add(story);
          continue;
        }

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

          if (placemarks.isEmpty) {
            stories.add(story);
            continue;
          }
          final String? street = placemarks.first.street;
          final String? city = placemarks.first.subAdministrativeArea;
          stories
              .add(story.copyWith(placemark: Utils.getPlaceMark(street, city)));
        } catch (e) {
          continue;
        }
      }

      logger.d('stories: ${stories.first}');

      return DataResult<StoriesResponse>(
          storiesResponse.copyWith(listStory: stories));
    } catch (e) {
      return ErrorResult<StoriesResponse>(e.toString());
    }
  }

  @override
  Future<BaseResult<String>> pickImage() async {
    try {
      final XFile? result =
          await imagePicker.pickImage(source: ImageSource.gallery);
      final String? imagePath = result?.path;
      if (result == null || imagePath == null || imagePath.isEmpty) {
        throw LocaleKeys.no_file_selected_msg.localized;
      }

      final File file = File(imagePath);
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 1) {
        throw LocaleKeys.bigger_image_msg.localized;
      }
      return DataResult<String>(imagePath);
    } catch (e) {
      return ErrorResult<String>(e.toString());
    }
  }

  @override
  Future<BaseResult<BaseResponse>> addStory(StoryDTO story) async {
    final StoryDTO(
      :String description,
      :String photo,
      :double? lat,
      :double? lon
    ) = story;
    if (photo.isEmpty) {
      return ErrorResult<BaseResponse>(
          LocaleKeys.no_file_selected_msg.localized);
    }
    final File fileImg = File(photo);
    return await _apiServices
        .postStory(fileImg, description, lat: lat, lon: lon)
        .awaitResponse;
  }

  @override
  Future<BaseResult<String>> takePicture() async {
    try {
      final XFile? photo =
          await imagePicker.pickImage(source: ImageSource.camera);

      final String? imagePath = photo?.path;
      if (imagePath == null || imagePath.isEmpty) {
        throw LocaleKeys.no_image_captured.localized;
      }

      final File file = File(imagePath);
      int sizeInBytes = file.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 1) throw LocaleKeys.bigger_image_msg.localized;

      return DataResult<String>(imagePath);
    } catch (e) {
      return ErrorResult<String>(e.toString());
    }
  }
}
