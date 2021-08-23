// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/routing/routes.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppComponent extends StatefulWidget {
  static AppComponentState _state = AppComponentState();

  static void get getHref {
    _state.getHref;
  }

  @override
  State createState() {
    _state = AppComponentState();
    if(Application.authToken != null)
      initialRoute = Routes.HOME;

    return _state;
  }

  String? initialRoute = Routes.AUTH;
}

class AppComponentState extends State<AppComponent> {
  
  AppComponentState() {
    getHref;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: Application.pageTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: widget.initialRoute,
      onGenerateRoute: Application.router.generator,
      navigatorKey: Application.navigatorKey,
    );
  }

  void get getHref {
    final String href = window.location.href;
    List<String> urlParts = href.split('//');
    urlParts = urlParts[1].split('/');

    Application.baseUrl = urlParts[0];
    Application.urlParts = urlParts.asMap();
  }
}