import 'package:dio/dio.dart';

import '../data/data_result.dart';
import '../data/network/responses/base_response.dart';
import '../generated/locale_keys.g.dart';
import 'export_utils.dart';

extension RetrofitExt<T> on Future<T> {
  Future<BaseResult<T>> get awaitResponse async {
    try {
      logger.d(await this);
      return DataResult<T>(await this);
    } on DioException catch (dioException) {
      final Response<dynamic>? response = dioException.response;
      final DioExceptionType errorType = dioException.type;

      if (errorType == DioExceptionType.connectionTimeout) {
        return ErrorResult<T>(LocaleKeys.connection_timeout.localized);
      }

      if (errorType == DioExceptionType.connectionError) {
        return ErrorResult<T>(LocaleKeys.connection_error.localized);
      }

      logger
        ..e('response: $response')
        ..e('response: ${dioException.message}');
      if (response == null) {
        return ErrorResult<T>(
            dioException.message ?? LocaleKeys.empty_response.localized);
      }

      logger.d('response.data: ${response.data}');
      final BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return ErrorResult<T>(baseResponse.message);
    } catch (e) {
      return ErrorResult<T>(e.toString());
    }
  }
}
