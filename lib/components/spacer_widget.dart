import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  final double size;
  final bool isHorizontal;
  const SpacerWidget(this.size, {super.key, this.isHorizontal = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isHorizontal ? 0 : size,
      width: isHorizontal ? size : 0,
    );
  }
}
