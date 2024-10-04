import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../data/data_result.dart';
import '../../../data/network/responses/base_response.dart';
import '../../../model/user.dart';
import '../../../repository/auth_repository.dart';

part 'register_state.dart';
part 'register_cubit.mapper.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit(this._authRepository) : super(const RegisterState());

  void register(UserDTO user) async {
    emit(const RegisterState(statusState: StatusState.loading));
    final BaseResult<BaseResponse> response =
        await _authRepository.register(user);

    final RegisterState newState = response.when(
      result: (BaseResponse data) => state.copyWith(
          statusState: StatusState.success, message: data.message),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );
    emit(newState);
  }
}
