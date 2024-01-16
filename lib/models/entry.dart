import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String date;
  final String shopName;
  final String nos;
  final String weight;
  final String rate;
  final String total;
  final bool billed;

  const Entry(
      {required this.date,
      required this.shopName,
      required this.nos,
      required this.weight,
      required this.rate,
      required this.total,
      required this.billed});
  Map<String, dynamic> toJson() => {
        "Date": date,
        "ShopName": shopName,
        "Nos": nos,
        "Weight": weight,
        "Rate": rate,
        "Total": total,
        "Billed": false,
        "TimeStamp":FieldValue.serverTimestamp()
      };
}
