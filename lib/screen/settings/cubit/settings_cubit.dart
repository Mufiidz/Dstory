import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../repository/auth_repository.dart';
import '../../../utils/string_ext.dart';

part 'settings_state.dart';
part 'settings_cubit.mapper.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  SettingsCubit(this._authRepository) : super(SettingsState());

  void changeLanguage(BuildContext context) async {
    emit(state.copyWith(statusState: StatusState.loading));
    final Locale currentLocale = context.locale;
    const Locale localeId = Locale('id');

    final Locale changedLocale = await Future<Locale>.delayed(
        const Duration(seconds: 2),
        () => Locale(currentLocale == localeId ? 'en' : 'id'));

    if (context.mounted) {
      await context.setLocale(changedLocale);
      await Jiffy.setLocale(changedLocale.toString());
    }
    emit(state.copyWith(statusState: StatusState.idle));
  }

  void logOut() async {
    emit(state.copyWith(statusState: StatusState.loading));
    final BaseResult<bool> result = await _authRepository.logOut();

    final SettingsState newState = result.when(
      result: (bool data) => state.copyWith(
          statusState: data ? StatusState.success : StatusState.failure,
          message: data ? LocaleKeys.logged_out_msg.localized : null),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
