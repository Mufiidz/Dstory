import 'package:flutter/material.dart';

import '../../components/export_components.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/story.dart';
import '../../utils/export_utils.dart';
import '../home/item_story.dart';

class DetailStoryScreen extends StatefulWidget {
  final Story story;
  const DetailStoryScreen({required this.story, super.key});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(LocaleKeys.story.localized),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: SizedBox(
            width: context.mediaSize.width,
            child: ItemStory(
              story: widget.story,
              isRelativeTime: false,
            ),
          )),
    );
  }
}
