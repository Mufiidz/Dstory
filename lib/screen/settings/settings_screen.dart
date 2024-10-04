import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/export_utils.dart';
import '../login/login_screen.dart';
import 'cubit/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsCubit _cubit;
  late final LoadingDialog _loadingDialog;
  @override
  void initState() {
    _loadingDialog = getIt<LoadingDialog>();
    _cubit = getIt<SettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(LocaleKeys.settings.localized),
      body: BlocListener<SettingsCubit, SettingsState>(
        bloc: _cubit,
        listener: (BuildContext context, SettingsState state) {
          _loadingDialog.show(context, state.isLoading);

          if (state.isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.error,
            ));
          }
          if (state.isSuccess) {
            context.snackbar
                .showSnackBar(SnackbarWidget(state.message, context));
            AppRoute.clearAll(const LoginScreen());
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: Text(LocaleKeys.language.localized),
              subtitle: Text(context.locale.toString().countryName),
              leading: Text(
                context.locale.toString().countryCodeToEmoji(),
                style: const TextStyle(fontSize: 24),
              ),
              onTap: () => _cubit.changeLanguage(context),
            ),
            ListTile(
              title: Text(LocaleKeys.logout.localized),
              leading: const Icon(
                Icons.logout,
                size: 24,
              ),
              onTap: _cubit.logOut,
            ),
          ],
        ),
      ),
    );
  }
}
