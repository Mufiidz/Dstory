part of 'home_cubit.dart';

@MappableClass()
class HomeState extends BaseState with HomeStateMappable {
  final List<Story> stories;

  HomeState({super.message, super.statusState, this.stories = const <Story>[]});
}
