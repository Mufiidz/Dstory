import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../data/network/responses/login_response.dart';
import '../../../model/user.dart';
import '../../../repository/auth_repository.dart';
import '../../../utils/export_utils.dart';

part 'login_state.dart';
part 'login_cubit.mapper.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  Timer? timer;
  LoginCubit(this._authRepository, this._sharedPreferences)
      : super(const LoginState());

  void userCheck() async {
    final String token =
        _sharedPreferences.getString(Constant.sharedPreferencesKeys.token) ??
            '';
    final bool isLogin = await Future<bool>.delayed(
        const Duration(seconds: 2), () => token.isNotEmpty);
    logger.d('UserCheck token: $token');
    emit(state.copyWith(isLoggedIn: isLogin));
  }

  void login(UserDTO user) async {
    emit(const LoginState(statusState: StatusState.loading));
    logger.d('user: $user');
    final BaseResult<LoginResponse> response =
        await _authRepository.login(user);
    final LoginState newState = response.when(
      result: (LoginResponse data) => state.copyWith(
          statusState: StatusState.success, user: data.loginResult),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
