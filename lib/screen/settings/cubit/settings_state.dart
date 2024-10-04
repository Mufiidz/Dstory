part of 'settings_cubit.dart';

@MappableClass(
    generateMethods: GenerateMethods.equals |
        GenerateMethods.stringify |
        GenerateMethods.copy)
class SettingsState extends BaseState with SettingsStateMappable {
  SettingsState({super.message, super.statusState});
}
