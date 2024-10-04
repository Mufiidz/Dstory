import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/base_state.dart';
import '../../../utils/export_utils.dart';

part 'splash_state.dart';
part 'splash_cubit.mapper.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final SharedPreferences _preferences;
  SplashCubit(this._preferences) : super(SplashState());

  void loginCheck() async {
    emit(state.copyWith(statusState: StatusState.loading));
    final bool isLoggedIn =
        await Future<bool>.delayed(const Duration(seconds: 2), () {
      final String token =
          _preferences.getString(Constant.sharedPreferencesKeys.token) ?? '';
      return token.isNotEmpty;
    });

    emit(state.copyWith(
        statusState: StatusState.success, isLoggedIn: isLoggedIn));
  }
}
