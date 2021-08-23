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
}