import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckBoxListTile extends StatefulWidget {
  Function(bool?) onAction;
  String title;
  String? subtitle;
  bool isSelected;

  CheckBoxListTile({required this.onAction, required this.title, required this.isSelected, this.subtitle});

  _CheckBoxListTileState createState() => new _CheckBoxListTileState();
}

class _CheckBoxListTileState extends State<CheckBoxListTile> {
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        widget.title.capitalize(),
        style: TextStyle(fontSize: 12),
      ),
      subtitle: widget.subtitle == null ? null : Text(
        widget.subtitle!.toLowerCase(),
        style: TextStyle(fontSize: 11),
      ),
      value: widget.isSelected,
      onChanged: (bool? value) {
        widget.onAction(value);
        super.setState(() {
          widget.isSelected = value!;
        });
      }
    );
  }
}