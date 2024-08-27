import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String? url;
  final String? title;
  final String? message;
  final String? image;
  final int? statusCode;
  final Response? response;

  ApiException({
    this.url,
    this.title,
    this.message,
    this.response,
    this.statusCode,
    this.image,
  });

  /// IMPORTANT NOTE
  /// here you can take advantage of toString() method to display the error for user
  /// lets make an example
  /// so in onError method when you make api you can just user apiExceptionInstance.toString() to get the error message from api
  @override
  toString() {
    String result = '';

    // TODO add error message field which is coming from api for you (For ex: response.data['error']['message']
    result += response?.data?['error'] ?? '';

    if(result.isEmpty){
      result += message!; // message is the (dio error message) so usualy its not user friendly
    }

    return result;
  }
}