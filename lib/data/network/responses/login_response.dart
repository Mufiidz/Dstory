import 'package:dart_mappable/dart_mappable.dart';

import '../../../model/user.dart';
import 'base_response.dart';

part 'login_response.mapper.dart';

@MappableClass()
class LoginResponse extends BaseResponse with LoginResponseMappable {
  final User loginResult;

  const LoginResponse(
      {super.error, super.message, this.loginResult = const User()});

  factory LoginResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return LoginResponseMapper.fromJson(json);
    if (json is String) return LoginResponseMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
