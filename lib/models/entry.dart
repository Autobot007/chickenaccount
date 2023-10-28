import 'package:flutter/material.dart';

class Entry {
  final String date;
  final String customer;
  final String nos;
  final String weight;
  final String rate;
  final String total;
  final bool billed;

  const Entry(
      {required this.date,
      required this.customer,
      required this.nos,
      required this.weight,
      required this.rate,
      required this.total,
      required this.billed});
  Map<String, dynamic> toJson() => {
        "Date": date,
        "CustomerName": customer,
        "ContactNo": nos,
        "Weight": weight,
        "Rate": rate,
        "Total": total,
        "Billed": false
      };
}
