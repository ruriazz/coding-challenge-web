import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  double? width;
  String label;
  EdgeInsetsGeometry? margin;
  Function() onPressed;
  Color? backgroundColor;

  AppButton({
    this.width = 65,
    this.label = "Button",
    this.margin,
    this.backgroundColor,
    required this.onPressed
  });

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SizedBox(
        width: width,
        // ignore: deprecated_member_use
        child: FlatButton(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 12
            ),
          ),
          padding: EdgeInsets.all(15),
          color: backgroundColor == null ? Colors.blue : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: backgroundColor == null ? Colors.blue : backgroundColor!,
              width: 1,
              style: BorderStyle.solid
            )
          ),
          onPressed: onPressed,
        )
      )
    );
  }
}