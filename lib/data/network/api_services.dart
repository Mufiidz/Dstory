import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../model/user.dart';
import '../../utils/endpoint.dart';
import 'responses/base_response.dart';
import 'responses/login_response.dart';
import 'responses/stories_response.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(@factoryParam Dio dio, {@factoryParam String baseUrl}) =
      _ApiServices;

  @POST(Endpoint.register)
  Future<BaseResponse> register(@Body(nullToAbsent: true) UserDTO user);

  @POST(Endpoint.login)
  Future<LoginResponse> login(@Body(nullToAbsent: true) UserDTO user);

  @GET(Endpoint.stories)
  Future<StoriesResponse> getStories(
      {@Query('page') int page = 1,
      @Query('size') int size = 10,
      @Query('location') int location = 0});

  @POST(Endpoint.stories)
  @MultiPart()
  Future<BaseResponse> postStory(@Part(name: 'photo') File file,
      @Part(name: 'description') String description,
      {@Part(name: 'lat') double? lat, @Part(name: 'lon') double? lon});
}
