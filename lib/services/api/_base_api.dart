import 'dart:convert';
import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/helpers/api_helper.dart';
import 'package:dio/dio.dart';

class BaseApi {
  Api helper = new Api();

  static const int RESPONSE_OK = 200;
  static const int BAD_RESPONSE = 400;
  static const int NOT_FOUND = 404;
  static const int NO_CONNECTION = 0;

  Dio get connection => Application.dio;

  static Future<bool> get online async => true;

  Future<Response> multipartPost({required Dio dio, required String path, required FormData data}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    try {
      dio.options.contentType = "multipart/form-data";
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.post(path, data: data);
    } on DioError catch (e) {
      response = e.response!;
    }

    return response;
  }

  Future<Response> jsonPost({required dio, required String path, required Map<String, dynamic> data}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    try {
      dio.options.contentType = Headers.jsonContentType;
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.post(path, data: json.encode(data));
    } on DioError catch (e) {
      response = e.response!;
    }

    return response;
  }

  Future<Response> jsonPut({required Dio dio, required String path, required Map<String, dynamic> data}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    try {
      dio.options.contentType = Headers.jsonContentType;
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.put(path, data: json.encode(data));
    } on DioError catch (e) {
      response = e.response!;
    }

    return response;
  }

  Future<Response> jsonPatch({required Dio dio, required String path, required Map<String, dynamic> data}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    try {
      dio.options.contentType = Headers.jsonContentType;
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.patch(path, data: json.encode(data));
    } on DioError catch (e) {
      response = e.response!;
    }

    return response;
  }

  Future<Response> get({required Dio dio, required String path, Map<String, dynamic>? data}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    if (data != null) {
      dio.options.queryParameters = data;
    }

    try {
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.get(path);
    } on DioError catch (e) {
      response = e.response!;
    }
    return response;
  }

  Future<Response> delete({required Dio dio, required String path}) async {
    late Response response = new Response(requestOptions: RequestOptions(path: path));
    try {
      dio.options.headers['Authorization'] = "Bearer ${Application.authToken}";
      response = await dio.delete(path);
    } on DioError catch (e) {
      response = e.response!;
    }

    return response;
  }
}
