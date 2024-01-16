import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chickenaccount/models/bill.dart' as model;

class NewBillWidget {
  final User? _auth = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> newBill(
      {required String shopName,
      required String customerName,
      required String contactNo,
      required String date,
      required List<Map<String, dynamic>> entry,
      required double total,
      required String balance,
      required String grandTotal}) async {
    try {
      model.Bill bill = model.Bill(
          shopName: shopName,
          customerName: customerName,
          contactNo: contactNo,
          date: date,
          entry: entry,
          total: total,
          balance: balance,
          grandTotal: grandTotal);
      await _firestore
          .collection('users')
          .doc(_auth!.uid)
          .collection('bill')
          .add(bill.toJson());

      return 'success';
    } catch (e) {
      return (e.toString());
    }
  }
}
