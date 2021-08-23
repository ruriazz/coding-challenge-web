import 'package:arcainternational/constant/app_component.dart';
import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/helpers/api_helper.dart';
import 'package:arcainternational/routing/routes.dart';
import 'package:arcainternational/services/api/payment_service.dart';
import 'package:arcainternational/services/api/user_service.dart';
import 'package:arcainternational/services/app_session.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:idb_shim/idb.dart';

void main() async {
  await _initializeApp;
  runApp(AppComponent());
}

Future<void> get _initializeApp async {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    Application.navigatorKey = new GlobalKey<NavigatorState>();
    Application.dio = await new Api().initialize;
    Database db = await AppSession.initialize;
    Application.session = new AppSession(db: db);
    Application.userService = new UserService();
    Application.paymentService = new PaymentService();
    await Application.userService.isAuth();
}