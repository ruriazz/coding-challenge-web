import 'package:arcainternational/constant/app_colors.dart';
import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/user_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainLayout extends StatelessWidget {
  BuildContext context;
  Widget? body;

  MainLayout({
    required this.context,
    this.body
  });

  Widget build(BuildContext ctx) {
    return Container(
      color: Colors.white,
      width: 1080,
      margin: EdgeInsets.all(0),
      child: Column(
        children: [
          _Header(),
          Container(
            padding: EdgeInsets.all(15),
            child: body == null ? Container() : body,
          )
        ],
      ),
    );
  }

  void _logout() async {
    String? next = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Lanjutkan logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'false'),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'true'),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if(next == 'true') {
      Application.authToken = null;
      await Application.session.unsetSession(key: User.sessionKey);
      Application.router.navigateTo(context, '/auth', clearStack: true, replace: true);
    }
  }

  // ignore: non_constant_identifier_names
  Widget _Header() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 17.5, horizontal: 12.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  InkWell(
                    child: Text(
                      "Coding Challenge",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.fontColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () => Application.router.navigateTo(context, '/'),
                  )
                ],
              ),
            )
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 21.5, horizontal: 12.5),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Application.isAdmin ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      child: Text(
                        "Buat Pembayaran",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () => Application.router.navigateTo(context, '/pay'),
                    ),
                  ) : Container(),
                  Application.isAdmin ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      child: Text(
                        "Buruh",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () => Application.router.navigateTo(context, '/employee'),
                    ),
                  ) : Container(),
                  Container(
                    padding: EdgeInsets.only(left: 17.5),
                    child: InkWell(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: _logout,
                    ),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

}