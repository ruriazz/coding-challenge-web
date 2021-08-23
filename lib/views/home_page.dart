import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool onLoad = true;

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool isAuth = await Application.userService.isAuth();
      if(!isAuth) {
        Application.router.navigateTo(context, '/auth', clearStack: true);
        return;
      }

      Application.router.navigateTo(context, '/detail-pay/20202108246123e8ef858ac');
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