import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_result.dart';
import '../data/network/api_services.dart';
import '../data/network/responses/base_response.dart';
import '../data/network/responses/login_response.dart';
import '../model/user.dart';
import '../utils/export_utils.dart';

abstract class AuthRepository {
  Future<BaseResult<BaseResponse>> register(UserDTO user);
  Future<BaseResult<LoginResponse>> login(UserDTO user);
  Future<BaseResult<bool>> logOut();
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final ApiServices _apiServices;
  final SharedPreferences _sharedPreferences;
  final Dio dio;
  AuthRepositoryImpl(this._apiServices, this._sharedPreferences, this.dio);

  @override
  Future<BaseResult<LoginResponse>> login(UserDTO user) async {
    final BaseResult<LoginResponse> response =
        await _apiServices.login(user).awaitResponse;

    if (response is ErrorResult) return response;

    final LoginResponse loginResponse = response.onDataResult;

    _sharedPreferences.setString(
        Constant.sharedPreferencesKeys.token, loginResponse.loginResult.token);

    dio.options.headers = <String, String>{
      'authorization': 'Bearer ${loginResponse.loginResult.token}'
    };

    return response;
  }

  @override
  Future<BaseResult<BaseResponse>> register(UserDTO user) async =>
      await _apiServices.register(user).awaitResponse;

  @override
  Future<BaseResult<bool>> logOut() async {
    try {
      final bool isRemoved =
          await _sharedPreferences.remove(Constant.sharedPreferencesKeys.token);
      dio.options.headers = <String, String>{};
      return DataResult<bool>(isRemoved);
    } catch (e) {
      return ErrorResult<bool>(e.toString());
    }
  }
}
