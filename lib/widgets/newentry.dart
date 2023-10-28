import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chickenaccount/models/entry.dart' as model;
import 'package:flutter/material.dart';

class NewEntry {
  final User? _auth = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> newEntry(
      {required String date,
      required String customer,
      required String nos,
      required String weight,
      required String rate,
      required String total,
      required bool billed}) async {
    bool billed = false;
    String res = 'some error occured';
    try {
      if (customer.isNotEmpty &&
          nos.isNotEmpty &&
          weight.isNotEmpty &&
          rate.isNotEmpty &&
          total.isNotEmpty) {
        model.Entry entry = model.Entry(
            date: date,
            customer: customer,
            nos: nos,
            weight: weight,
            rate: rate,
            total: total,
            billed: billed);
        await _firestore
            .collection('users')
            .doc(_auth!.uid)
            .collection('entry')
            .add(entry.toJson());

        return 'success';
      } else {
        return 'All fields are Mandatory';
      }
    } catch (err) {
      return err.toString();
    }
  }
}
