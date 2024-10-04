import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/story.dart';
import '../../utils/export_utils.dart';
import '../add/add_story_screen.dart';
import '../detail/detail_story_screen.dart';
import '../settings/settings_screen.dart';
import 'cubit/home_cubit.dart';
import 'item_story.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _cubit;
  late final PagingController<int, Story> _pagingController;

  @override
  void initState() {
    _cubit = getIt<HomeCubit>()..getStories();
    _pagingController = PagingController<int, Story>(firstPageKey: 1);
    _pagingController.addPageRequestListener(
        (int pageKey) => _cubit.getStories(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        Constant.appName,
        showBackButton: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: LocaleKeys.add_story.localized,
            onPressed: () => AppRoute.to(const AddStoryScreen()),
          ),
          IconButton(
            onPressed: () => AppRoute.to(const SettingsScreen()),
            icon: const Icon(Icons.settings),
            tooltip: context.tr(LocaleKeys.settings),
          )
        ],
      ),
      body: BlocListener<HomeCubit, HomeState>(
          bloc: _cubit,
          listener: (BuildContext context, HomeState state) {
            if (!state.isLoading) {
              _handlePagination(state.stories);
            }
            if (state.isError) {
              _pagingController.error = state.message;
              context.snackbar.showSnackBar(SnackbarWidget(
                state.message,
                context,
                state: SnackbarState.error,
              ));
            }
          },
          child: RefreshIndicator.adaptive(
              onRefresh: () async => _pagingController.refresh(),
              child: PagedListView<int, Story>.separated(
                pagingController: _pagingController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                builderDelegate: PagedChildBuilderDelegate<Story>(
                  itemBuilder: (BuildContext context, Story item, int index) =>
                      ItemStory(
                    story: item,
                    maxLines: 3,
                    onClick: (Story story) =>
                        AppRoute.to(DetailStoryScreen(story: story)),
                  ),
                  newPageProgressIndicatorBuilder: (BuildContext context) =>
                      Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                  newPageErrorIndicatorBuilder: (BuildContext context) =>
                      Center(
                    child: TextButton(
                        onPressed: _pagingController.retryLastFailedRequest,
                        child: const Text(LocaleKeys.retry).tr()),
                  ),
                  firstPageErrorIndicatorBuilder: (BuildContext context) =>
                      Center(
                    child: TextButton(
                        onPressed: _pagingController.retryLastFailedRequest,
                        child: const Text(LocaleKeys.retry).tr()),
                  ),
                  firstPageProgressIndicatorBuilder: (BuildContext context) =>
                      const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  noItemsFoundIndicatorBuilder: (BuildContext context) =>
                      Center(
                    child: const Text(LocaleKeys.empty_data).tr(),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SpacerWidget(20),
              ))),
    );
  }

  void _handlePagination(List<Story> stories) {
    final int? nextPageKey = _pagingController.nextPageKey;
    const int pageSize = 10;
    if (stories.isEmpty || stories.length < pageSize || nextPageKey == null) {
      _pagingController.appendLastPage(stories);
    } else {
      _pagingController.appendPage(stories, nextPageKey + 1);
    }
  }
}
