import 'package:flutter/material.dart';

typedef OnItemBuilder<Item> = Widget Function(
    BuildContext context, Item item, int index);

class ListWidget<T> extends StatelessWidget {
  final bool isSeparated;
  final List<T> list;
  final OnItemBuilder<T> itemBuilder;
  final OnItemBuilder<T>? separatorBuilder;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool isHorizontal;
  final int? length;
  const ListWidget(this.list,
      {required this.itemBuilder,
      super.key,
      this.isSeparated = false,
      this.separatorBuilder,
      this.shrinkWrap = false,
      this.scrollPhysics = const BouncingScrollPhysics(),
      this.controller,
      this.padding,
      this.isHorizontal = false,
      this.length});

  @override
  Widget build(BuildContext context) {
    return !isSeparated
        ? ListView.builder(
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: scrollPhysics,
            controller: controller,
            scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
            itemBuilder: (BuildContext context, int index) =>
                itemBuilder(context, list[index], index),
            itemCount: length ?? list.length,
          )
        : ListView.separated(
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: scrollPhysics,
            controller: controller,
            scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
            itemBuilder: (BuildContext context, int index) =>
                itemBuilder(context, list[index], index),
            separatorBuilder: (BuildContext context, int index) =>
                separatorBuilder != null
                    ? separatorBuilder!(context, list[index], index)
                    : const Divider(),
            itemCount: length ?? list.length);
  }
}
