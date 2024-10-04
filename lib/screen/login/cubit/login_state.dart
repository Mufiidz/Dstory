part of 'login_cubit.dart';

@MappableClass()
class LoginState extends BaseState with LoginStateMappable {
  final User user;
  final bool isLoggedIn;

  const LoginState({
    super.message,
    super.statusState,
    this.user = const User(),
    this.isLoggedIn = false,
  });
}
