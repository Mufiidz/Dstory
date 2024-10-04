import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.I;

@InjectableInit(preferRelativeImports: true)
Future<void> setupDI() async => getIt.init();

/// Registers a singleton instance of type [T] in the [getIt] dependency injection container.
///
/// If an instance of type [T] is already registered, it returns the existing instance.
/// Otherwise, it registers the provided [instance] as a singleton and returns it.
///
/// Parameters:
/// - [instance]: The instance of type [T] to be registered as a singleton.
///
/// Returns:
/// - The registered singleton instance of type [T].
T safeRegisterSingleton<T extends Object>(T instance) {
  if (!getIt.isRegistered<T>()) {
    return getIt.registerSingleton<T>(instance);
  }
  return getIt<T>();
}
