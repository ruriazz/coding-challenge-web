import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.text.isEmpty)
      return newValue.copyWith(
        text: "0",
        selection: new TextSelection.collapsed(offset: 1)
      );

    String newValInt = newValue.text;
    if(oldValue.text == '0') {
      newValInt = int.parse(newValue.text).toString();
    }

    String x = NumberFormat.simpleCurrency(locale: 'id').format(int.parse(newValInt));
    x = x.replaceAll('Rp', '');
    x = x.replaceAll(',00', '');

    return newValue.copyWith(
      text: "$x",
      selection: new TextSelection.collapsed(offset: "$x".length)
    );
  }
}