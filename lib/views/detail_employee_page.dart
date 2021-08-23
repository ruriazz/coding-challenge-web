import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';

class DetailEmployeePage extends StatefulWidget {
  _DetailEmployeePageState createState() {
    return new _DetailEmployeePageState();
  }
}

class _DetailEmployeePageState extends State<DetailEmployeePage> {
  bool onLoad = true;

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool isAuth = await Application.userService.isAuth();
      if(!isAuth) {
        Application.router.navigateTo(context, '/auth', clearStack: true);
        return;
      }

      _initialPage();
    });
  }

  void _initialPage() async {

    super.setState(() {
      onLoad = false;
    });
  }

  Widget build(BuildContext context) {
    return MainView(
      context: context,
      body: Center(
        child: onLoad ? SizedBox(
            width: 65,
            height: 65,
            child: CircularProgressIndicator(strokeWidth: 2)
          ) : MainLayout(
            context: context,
          )
      ),
    );
  }
}