import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String userId;
  final String name;
  final String token;

  const User({
    this.userId = '',
    this.name = '',
    this.token = '',
  });

  factory User.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return UserMapper.fromJson(json);
    if (json is String) return UserMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}

@MappableClass(ignoreNull: true)
class UserDTO with UserDTOMappable {
  final String? name;
  final String email;
  final String password;

  const UserDTO({this.name, this.email = '', this.password = ''});

  factory UserDTO.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return UserDTOMapper.fromJson(json);
    if (json is String) return UserDTOMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
