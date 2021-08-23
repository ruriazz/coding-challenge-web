import 'dart:convert';

class User {
  static const String sessionKey = "user-session";

  User({
    this.id,
    this.email,
    this.authToken,
    this.name,
    this.role,
    this.photo,
    this.timeStored,
  });

  String? id;
  String? email;
  String? authToken;
  String? name;
  String? role;
  String? photo;
  int? timeStored;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        authToken: json["auth_token"],
        name: json["name"],
        role: json["role"],
        photo: json["photo"],
        timeStored: json["time_stored"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "auth_token": authToken,
        "name": name,
        "role": role,
        "photo": photo,
        "time_stored": timeStored,
      };

  String toString() => json.encode(toJson());
}
