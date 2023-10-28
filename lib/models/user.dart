class User {
  final String email;
  final String uid;
  final String firmname;
  final String mobile;

  const User(
      {required this.email,
      required this.uid,
      required this.firmname,
      required this.mobile});

  Map<String, dynamic> toJson() =>
      {"email": email, "uid": uid, "firmname": firmname, "mobile": mobile};
}
