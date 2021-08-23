import 'package:dio/dio.dart';

class Api {
  Future<Dio> get initialize async {

    final BaseOptions options = BaseOptions(
      baseUrl: "https://api.aziz.warkopwarawiri.id",
      connectTimeout: 8000,
      receiveTimeout: 5000,
      sendTimeout: 7500,
      receiveDataWhenStatusError: true
    );

    final Dio dio = Dio(options);
    return dio;
  }
}