import 'package:dart_mappable/dart_mappable.dart';

part 'base_response.mapper.dart';

@MappableClass()
class BaseResponse with BaseResponseMappable {
  final bool error;
  final String message;

  const BaseResponse({this.error = false, this.message = ''});

  factory BaseResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return BaseResponseMapper.fromJson(json);
    if (json is String) return BaseResponseMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
