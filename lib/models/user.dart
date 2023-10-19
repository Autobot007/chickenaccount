import 'package:flutter/material.dart';

class User {
  final String email;
  final String uid;
  final String firmName;
  final String mobile;

  const User(
      {required this.email,
      required this.uid,
      required this.firmName,
      required this.mobile});

  Map<String, dynamic> toJson() =>
      {"email": email, "uid": uid, "firmName": firmName, "mobile": mobile};
}
