import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../di/injection.dart';
import '../../utils/export_utils.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<SplashCubit>()..loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: Jiffy.setLocale(context.locale.toString()),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
            BlocListener<SplashCubit, SplashState>(
          bloc: _cubit,
          listener: (BuildContext context, SplashState state) {
            if (state.isSuccess) {
              AppRoute.clearAll(
                  state.isLoggedIn ? const HomeScreen() : const LoginScreen());
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: context.mediaSize.width,
                height: context.mediaSize.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Constant.getColorList,
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
              Text(
                Constant.appName,
                style: context.textTheme.displayLarge
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
