import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AppTextField extends StatelessWidget {
  double? width;
  double? height;
  String? label;
  EdgeInsetsGeometry? margin;
  bool isPassword;
  Widget? suffixIcon;
  String? errorText;
  FocusNode focusNode;
  TextEditingController controller;
  Function()? onEditingComplete;
  TextInputType? keyboardType;
  bool isError;
  Function(String)? onChanged;
  String? prefixText;
  List<TextInputFormatter>? inputFormatter;
  String? suffixText;
  String? initialValue;

  AppTextField({
    required this.controller,
    required this.focusNode,
    this.width = 265, 
    this.height = 40,
    this.label = "label",
    this.margin,
    this.isPassword = false,
    this.suffixIcon,
    this.errorText,
    this.onEditingComplete,
    this.keyboardType = TextInputType.text,
    this.isError = false,
    this.onChanged,
    this.prefixText,
    this.inputFormatter,
    this.suffixText,
    this.initialValue
  });

  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(fontSize: 13.5),
          initialValue: initialValue,
          inputFormatters: this.inputFormatter,
          decoration: InputDecoration(
            prefixText: prefixText,
            suffixText: suffixText,
            labelText: label,
            errorText: errorText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: isError ? BorderSide(color: Colors.red, width: 1.75) : BorderSide(color: Colors.blue, width: 1.25),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: isError ? BorderSide(color: Colors.red, width: 2) : BorderSide(color: Colors.black54, width: 1)
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: new BorderSide(color: Colors.red, width: 1)
            ),
            suffixIcon: suffixIcon,
          ),
        )
      )
    );
  }
}