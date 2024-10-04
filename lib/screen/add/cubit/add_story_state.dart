part of 'add_story_cubit.dart';

@MappableClass()
class AddStoryState extends BaseState with AddStoryStateMappable {
  final String pathImage;
  final LocationMark? locationMark;

  AddStoryState({
    super.message,
    super.statusState,
    this.pathImage = '',
    this.locationMark,
  });
}
