abstract class BaseState {
  final String message;
  final StatusState statusState;

  const BaseState({this.message = '', this.statusState = StatusState.idle});

  bool get isLoading => statusState == StatusState.loading;
  bool get isSuccess => statusState == StatusState.success;
  bool get isError => statusState == StatusState.failure;
  bool get isIdle => statusState == StatusState.idle;
}

enum StatusState { idle, loading, success, failure }
