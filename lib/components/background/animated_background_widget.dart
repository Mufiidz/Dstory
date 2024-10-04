import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../utils/export_utils.dart';
import 'cubit/animated_background_cubit.dart';

class AnimatedBackgroundWidget extends StatefulWidget {
  final void Function(AnimatedBackgroundCubit cubit) onInit;
  final List<Color>? customColorList;
  const AnimatedBackgroundWidget(
      {required this.onInit, super.key, this.customColorList});

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState
    extends LifecycleEventHandler<AnimatedBackgroundWidget> {
  late final AnimatedBackgroundCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<AnimatedBackgroundCubit>();
    _cubit.startGradient();
    widget.onInit(_cubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AnimatedBackgroundCubit, AnimatedBackgroundState, int>(
      bloc: _cubit,
      selector: (AnimatedBackgroundState state) => state.counter,
      builder: (BuildContext context, int state) {
        return AnimatedContainer(
            width: context.mediaSize.width,
            height: context.mediaSize.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.customColorList ?? Constant.getColorList,
                    stops: const <double>[0, 1],
                    begin: Constant
                        .getAligments[state % Constant.getAligments.length],
                    end: Constant.getAligments[
                        (state + 2) % Constant.getAligments.length])),
            duration: const Duration(seconds: 4));
      },
    );
  }

  @override
  void onPaused() {
    _cubit.stopGradient();
    super.onPaused();
  }

  @override
  void onResumed() {
    _cubit.startGradient();
    super.onResumed();
  }

  @override
  void dispose() {
    _cubit.stopGradient();
    super.dispose();
  }
}
