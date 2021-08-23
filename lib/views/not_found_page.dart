import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatefulWidget {
  _NotfoundPageState createState() => new _NotfoundPageState();
}

class _NotfoundPageState extends State<NotFoundPage> {
  Widget build(BuildContext context) {
    return MainView(
      context: context,
      body: Center(
        child: Text(
          "404 | Page Not Found",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}