import 'package:arcainternational/views/auth_page.dart';
import 'package:arcainternational/views/detail_employee_page.dart';
import 'package:arcainternational/views/detail_payment_page.dart';
import 'package:arcainternational/views/employee_page.dart';
import 'package:arcainternational/views/home_page.dart';
import 'package:arcainternational/views/not_found_page.dart';
import 'package:arcainternational/views/payment_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String HOME = "/";
  static const String PAY = "/pay";
  static const String DETAIL_PAY = "/detail-pay/:id";
  static const String EMPLOYEE = "/employee";
  static const String DETAIL_EMPLOYEE = "/detail-employee";
  static const String AUTH = "/auth";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? c, Map<String, List<String>> p) => NotFoundPage()
    );

    router.define(HOME, handler: RouteHandler.home, transitionType: TransitionType.fadeIn);
    router.define(PAY, handler: RouteHandler.payment, transitionType: TransitionType.fadeIn);
    router.define(DETAIL_PAY, handler: RouteHandler.detailPayment, transitionType: TransitionType.fadeIn);
    router.define(EMPLOYEE, handler: RouteHandler.employee, transitionType: TransitionType.fadeIn);
    router.define(DETAIL_EMPLOYEE, handler: RouteHandler.detailEmployee, transitionType: TransitionType.fadeIn);
    router.define(AUTH, handler: RouteHandler.auth, transitionType: TransitionType.fadeIn);
  }
}

class RouteHandler {
  static Handler get home {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => HomePage()
    );
  }

  static Handler get payment {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => PaymentPage(params: params)
    );
  }


  static Handler get detailPayment {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => DetailPaymentPage(id: params['id']![0])
    );
  }

  static Handler get employee {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => EmployeePage()
    );
  }

  static Handler get detailEmployee {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => DetailEmployeePage()
    );
  }

  static Handler get auth {
    return new Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => AuthPage()
    );
  }
}
