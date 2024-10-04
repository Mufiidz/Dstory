import 'package:dart_mappable/dart_mappable.dart';

part 'story.mapper.dart';

@MappableClass()
class Story with StoryMappable {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime? createdAt;
  double lat;
  double lon;
  String? placemark;

  Story(
      {this.id = '',
      this.name = '',
      this.description = '',
      this.photoUrl = '',
      this.createdAt,
      this.lat = 0.0,
      this.lon = 0.0,
      this.placemark});

  factory Story.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return StoryMapper.fromJson(json);
    if (json is String) return StoryMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}

@MappableClass(ignoreNull: true)
class StoryDTO with StoryDTOMappable {
  String description;
  String photo;
  double? lat;
  double? lon;

  StoryDTO({
    this.description = '',
    this.photo = '',
    this.lat,
    this.lon,
  });

  factory StoryDTO.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return StoryDTOMapper.fromJson(json);
    if (json is String) return StoryDTOMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
