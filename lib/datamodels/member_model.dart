import 'dart:convert';
import 'package:arcainternational/datamodels/user_model.dart';

class Member {
  Member({
    this.payment,
    this.user,
    this.value,
  });

  String? payment;
  User? user;
  double? value;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        payment: json["payment"],
        user: User.fromJson(json["user"]),
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "payment": payment,
        "user": user!.toJson(),
        "value": value,
      };

  String toString() => json.encode(toJson());
}
