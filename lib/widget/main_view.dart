import 'package:arcainternational/constant/app_colors.dart';
import 'package:arcainternational/constant/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  Widget body;
  PreferredSizeWidget? appBar;
  String title = 'CODING CHALLENGE | Aziz Ruri Suparman';
  BuildContext context;

  MainView({required this.body, String? title, required this.context, this.appBar}) {
    if(title != null)
      this.title = title;

    _setPageTitle(context: context);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: AppColors.primaryTheme,
      appBar: appBar,
      body: WillPopScope(
        onWillPop: () async {
          Application.router.pop(context);
          return false;
        },
        child: Title(
          title: this.title,
          color: Colors.black,
          child: this.body
        ),
      ),
    );
  }

  void _setPageTitle({required BuildContext context}) {
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: "",
      primaryColor: Theme.of(context).primaryColor.value,
    ));
  }
}