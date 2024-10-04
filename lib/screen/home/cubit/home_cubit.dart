import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../data/network/responses/stories_response.dart';
import '../../../model/story.dart';
import '../../../repository/story_repositories.dart';

part 'home_state.dart';
part 'home_cubit.mapper.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final StoryRepository _storyRepository;
  HomeCubit(this._storyRepository) : super(HomeState());

  void getStories({int page = 1}) async {
    emit(state.copyWith(statusState: StatusState.loading));
    final BaseResult<StoriesResponse> response =
        await _storyRepository.getAllStories(page: page);
    final HomeState newState = response.when(
      result: (StoriesResponse data) => state.copyWith(
          statusState: StatusState.idle, stories: data.listStory),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
