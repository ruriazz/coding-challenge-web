import 'dart:convert';
import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/payment_model.dart';
import 'package:arcainternational/services/api/_base_api.dart';
import 'package:dio/dio.dart';

class PaymentService {

  final BaseApi _api = new BaseApi();
  final Dio _dio = Application.dio;

  Future<Payment?> submitData({required Payment data}) async {
    final Response response = await _api.jsonPost(dio: _dio, path: '/payment', data: {
      "payment": data.toJson()
    });

    if(response.statusCode == 200) {
      final content = response.data['content'];
      final Payment payment = new Payment.fromJson(content);

      return payment;
    }

    return null;
  }

  Future<Payment?> getPayment({String? id}) async {
    final Response response = await _api.get(dio: _dio, path: '/payment?id=$id');
    if(response.statusCode == 200) {
      final content = response.data['content'];
      final Payment data = new Payment.fromJson(content);

      return data;
    }

    return null;
  }

  Future<bool> deletePayment({required String id}) async {
    final Response response = await _api.delete(dio: _dio, path: '/payment/$id');

    if(response.statusCode == 200)
      return true;

    return false;
  }

  Future<bool> updatePayment({required Payment newData}) async {
    final Response response = await _api.jsonPatch(dio: _dio, path: '/payment', data: {
      "payment": newData.toJson()
    });

    if(response.statusCode == 200)
      return true;

    return false;
  }

  Future<List<Payment>> getAllPayment() async {
    List<Payment> result = <Payment>[];
    final Response response = await _api.get(dio: _dio, path: '/payment');

    if(response.statusCode == 200) {
      final content = response.data['content'];
      for(final c in content) {
        final Payment data = new Payment.fromJson(c);
        result.add(data);
      }
    }

    return result;
  }
}