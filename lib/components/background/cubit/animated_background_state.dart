part of 'animated_background_cubit.dart';

@MappableClass(generateMethods: GenerateMethods.equals | GenerateMethods.copy)
class AnimatedBackgroundState extends BaseState
    with AnimatedBackgroundStateMappable {
  final int counter;

  AnimatedBackgroundState({super.message, super.statusState, this.counter = 0});
}
