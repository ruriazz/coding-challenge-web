import 'dart:convert';
import 'package:arcainternational/datamodels/member_model.dart';
import 'package:arcainternational/datamodels/user_model.dart';


class Payment {
  Payment({
    this.id,
    this.totalPayment,
    this.submiter,
    this.member,
    this.timeStored,
  });

  String? id;
  double? totalPayment;
  User? submiter;
  List<Member>? member;
  int? timeStored;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        totalPayment: json["total_payment"].toDouble(),
        submiter: User.fromJson(json["submiter"]),
        member:
            List<Member>.from(json["member"].map((x) => Member.fromJson(x))),
        timeStored: json["time_stored"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_payment": totalPayment,
        "submiter": submiter!.toJson(),
        "member": List<dynamic>.from(member!.map((x) => x.toJson())),
        "time_stored": timeStored,
      };

  String toString() => json.encode(toJson());
}
