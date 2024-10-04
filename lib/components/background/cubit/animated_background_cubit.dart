import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../utils/export_utils.dart';

part 'animated_background_state.dart';
part 'animated_background_cubit.mapper.dart';

@injectable
class AnimatedBackgroundCubit extends Cubit<AnimatedBackgroundState> {
  Timer? timer;
  AnimatedBackgroundCubit() : super(AnimatedBackgroundState());

  void startGradient() {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      emit(state.copyWith(counter: state.counter));
    });

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      logger.d('Counter: ${timer.tick} => ${state.counter}');
      final int counter = state.counter;
      if (counter == Constant.getAligments.length - 1) {
        emit(state.copyWith(counter: 0));
      } else {
        emit(state.copyWith(counter: state.counter + 1));
      }
    });
  }

  void stopGradient() {
    timer?.cancel();
    emit(state.copyWith(counter: 0));
  }
}
