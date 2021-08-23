import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PayListValue extends StatelessWidget {
  double percent;
  String name;

  PayListValue({required this.name, required this.percent});

  Widget build(BuildContext context) {
    if(percent == 0)
      percent = 0.00;
    String fixedString = percent.toStringAsFixed(2);
    String x = NumberFormat.simpleCurrency(locale: 'id').format(double.parse(fixedString));
    x = x.replaceAll('Rp', '');

    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Text(name.capitalize()),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Rp. $x"),
                ),
              )
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}