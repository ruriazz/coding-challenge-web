import 'package:flutter/services.dart';

class PercentInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    
    if(newValue.text.isEmpty)
      return newValue.copyWith(
        text: "0",
        selection: new TextSelection.collapsed(offset: 1)
      );

    String value = newValue.text;
    if(value[0] == '0' && value[1] != ',') {
      value = value.replaceFirst('0', '');
    }

    if(value.split(',').length > 2)
      value = value.replaceRange(value.length - 1, value.length, '');

    double x = double.parse(value.replaceAll(',', '.'));
    if(x > 100) {
      return newValue.copyWith(
        text: oldValue.text,
        selection: new TextSelection.collapsed(offset: oldValue.text.length)
      );
    }

    return newValue.copyWith(
      text: "$value",
      selection: new TextSelection.collapsed(offset: "$value".length)
    );
  }
}