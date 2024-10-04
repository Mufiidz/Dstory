import 'package:dart_mappable/dart_mappable.dart';

import '../../../model/story.dart';
import 'base_response.dart';

part 'stories_response.mapper.dart';

@MappableClass()
class StoriesResponse extends BaseResponse with StoriesResponseMappable {
  final List<Story> listStory;

  const StoriesResponse(
      {super.error, super.message, this.listStory = const <Story>[]});

  factory StoriesResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return StoriesResponseMapper.fromJson(json);
    }
    if (json is String) return StoriesResponseMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
