// ignore: unused_import
import 'package:arcainternational/widget/app_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppModal extends StatefulWidget {
  BuildContext context;
  Widget? body;
  double? width;
  List<Widget>? actions;

  AppModal({required this.context, this.body, this.width = 700, this.actions});
  _AppModalState createState() => new _AppModalState();
}

class _AppModalState extends State<AppModal> {
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: widget.width,
        child: widget.body != null ? widget.body : Container(),
      ),
      insetPadding: EdgeInsets.symmetric(vertical: 200, horizontal: 0),
      actions: widget.actions,
    );
  }
}