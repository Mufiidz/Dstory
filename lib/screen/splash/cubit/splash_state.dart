part of 'splash_cubit.dart';

@MappableClass()
class SplashState extends BaseState with SplashStateMappable {
  final bool isLoggedIn;

  SplashState({super.message, super.statusState, this.isLoggedIn = false});
}
