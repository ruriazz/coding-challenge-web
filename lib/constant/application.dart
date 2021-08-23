import 'package:arcainternational/services/api/payment_service.dart';
import 'package:arcainternational/services/api/user_service.dart';
import 'package:arcainternational/services/app_session.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application {
  static late final FluroRouter router;
  static late final Dio dio;
  static late final GlobalKey<NavigatorState> navigatorKey;
  static late final String baseUrl;
  static late final AppSession session;
  static late final UserService userService;
  static late final PaymentService paymentService;

  static Map<int, String>? urlParts;
  static String? authToken;
  static bool isAdmin = false;
  static double percentTotal = 100.00;
}