import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:logger/logger.dart';
import 'package:mekinaye/generated/assets.dart';
import 'package:mekinaye/model/api_exceptions.dart';
import 'package:mekinaye/service/authorization_service.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/custom_snackbar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum RequestType {
  get,
  post,
  put,
  delete,
  patch,
}

class ApiService {
  static final Dio _dio = Dio(BaseOptions(headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

  // request timeout (default 10 seconds)
  static const int _timeoutInSeconds = 10;

  /// dio getter (used for testing)
  static get dio => _dio;

  /// perform safe api request
  static safeApiCall(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;
      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.patch) {
        response = await _dio.patch(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      }
      // 3) return response (api done successfully)
      await onSuccess(response);
    } on DioException catch (error) {
      print(error);
     //  if(error.message == 'Invalid credentials'){
     //    CustomSnackBar.showCustomErrorToast(
     //      title: 'Login Error',
     //      message: 'Invalid credentials',
     //      duration: Duration(seconds: 2),
     //    );
     //  }
     // else if(error.message == 'User not found'){
     //    CustomSnackBar.showCustomErrorToast(
     //      title: 'Login Error',
     //      message: 'User not found',
     //      duration: Duration(seconds: 2),
     //    );
     //  }
    } on SocketException {
      // No internet connection
      _handleSocketException(url: url, onError: onError);
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(url: url, onError: onError);
    } catch (error, stackTrace) {
      // print the line of code that throw unexpected exception
      Logger().e(stackTrace);
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds)),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception =
          ApiException(url: url, title: "Error", message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException(
      {Function(ApiException)? onError,
      required String url,
      required Object error}) {
    if (onError != null) {
      onError(ApiException(
          title: "Error",
          message: error.toString(),
          url: url,
          image: Assets.errorsUnknown));
    } else {
      _handleError(error.toString());
    }
  }

  /// handle timeout exception
  static _handleTimeoutException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
          title: 'Server Not Responding',
          message:
              "Something went wrong, please refresh the page in order to continue",
          url: url,
          image: Assets.errorsInternalServer));
    } else {
      _handleError('Server Not Responding');
    }
  }

  /// handle timeout exception
  static _handleSocketException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
          title: 'No Internet Connection',
          message: "Check your connection and refresh the page.",
          url: url,
          image: Assets.errorsInternalServer)); //Todo replace
    } else {
      _handleError('No Internet Connection');
    }
  }

  /// handle Dio error
  static _handleDioError(
      {required DioException error,
      Function(ApiException)? onError,
      required String url}) {
    // 404 error
    if (error.response?.statusCode == 404) {
      if (onError != null) {
        return onError(ApiException(
            title: 'Page Not Found',
            message: "The requested resource was not found.",
            url: url,
            statusCode: 404,
            image: Assets.errorsNotFound));
      } else {
        return _handleError('Page Not Found');
      }
    }

    // no internet connection
    if (error.message != null &&
        (error.message!.toLowerCase().contains('socket') ||
            error.message!.toLowerCase().contains('the connection errored'))) {
      //Todo test if this always detects conection errors
      if (onError != null) {
        return onError(ApiException(
            title: 'No Internet Connection',
            message: "Check your connection and refresh the page.",
            url: url,
            image: Assets.errorsInternalServer)); //Todo replace
      } else {
        return _handleError('No Internet Connection');
      }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      var exception = ApiException(
          title: 'Internal Server Error',
          message:
              "We're experiencing technical issues and  We are trying our best to bring it back",
          url: url,
          statusCode: 500,
          image: Assets.errorsInternalServer);

      if (onError != null) {
        return onError(exception);
      } else {
        return handleApiError(exception);
      }
    }

    var exception = ApiException(
        url: url,
        title: 'Unknown Error',
        message: error.message ??
            "Something went wrong, please refresh the page in order to continue",
        response: error.response,
        statusCode: error.response?.statusCode,
        image: Assets.errorsUnknown);
    if (onError != null) {
      return onError(exception);
    } else {
      return handleApiError(exception);
    }
  }

  /// handle error automatically (if user didn't pass onError) method
  /// it will try to show the message from api if there is no message
  /// from api it will show the reason (the dio message)
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    CustomSnackBar.showCustomErrorToast(message: msg);
  }
}
