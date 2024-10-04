import 'package:injectable/injectable.dart';

@singleton
class Endpoint {
  static const String login = '/login';
  static const String register = '/register';
  static const String stories = '/stories';
}
