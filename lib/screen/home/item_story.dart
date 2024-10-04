import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../components/export_components.dart';
import '../../model/story.dart';
import '../../utils/export_utils.dart';

typedef OnClick = void Function(Story story);

class ItemStory extends StatelessWidget {
  final Story story;
  final OnClick? onClick;
  final int? maxLines;
  final bool isRelativeTime;
  const ItemStory(
      {required this.story,
      this.onClick,
      super.key,
      this.maxLines,
      this.isRelativeTime = true});

  @override
  Widget build(BuildContext context) {
    final Story(
      :String name,
      :String photoUrl,
      :String description,
      :DateTime? createdAt,
      :double? lat,
      :double? lon,
      :String? placemark
    ) = story;
    return GestureDetector(
      onTap: () => onClick?.call(story),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.account_circle,
                  size: 36,
                ),
                const SpacerWidget(
                  8,
                  isHorizontal: true,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Visibility(
                      visible: placemark != null,
                      child: Text(
                        placemark ?? 'Lat: $lat, Lon: $lon',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SpacerWidget(16),
          CachedNetworkImage(
            imageUrl: photoUrl,
            width: context.mediaSize.width,
            fit: BoxFit.cover,
            errorListener: (Object value) {
              logger.e('Image Error: $value');
            },
            progressIndicatorBuilder: (BuildContext context, String url,
                    DownloadProgress progress) =>
                Container(
                    width: context.mediaSize.width,
                    height: context.mediaSize.height * 0.3,
                    color: context.colorScheme.surface,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(value: progress.progress)),
            errorWidget: (BuildContext context, String url, Object error) =>
                Container(
                    width: context.mediaSize.width,
                    height: context.mediaSize.height * 0.3,
                    color: context.colorScheme.surface,
                    alignment: Alignment.center,
                    child: const Text('Cant load image')),
          ),
          const SpacerWidget(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(
                    text: ' ',
                  ),
                  TextSpan(text: description),
                ]),
                textAlign: TextAlign.justify,
                overflow: maxLines != null ? TextOverflow.ellipsis : null,
                maxLines: maxLines),
          ),
          const SpacerWidget(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              (isRelativeTime
                      ? createdAt?.toRelativeTime()
                      : createdAt?.formatWithoutTime) ??
                  '-',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
