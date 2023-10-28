import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chickenaccount/models/customer.dart' as model;
import 'package:flutter/material.dart';

class newcustomer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _auth = FirebaseAuth.instance.currentUser;

  Future<bool> doesDocumentExist(String shopName) async {
    final DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(_auth!.uid)
        .collection('customers')
        .doc(shopName)
        .get();
    return snapshot.exists;
  }

  Future<String> newCustomer(
      {required String shopName,
      required String customerName,
      required String contactNo}) async {
    String res = 'some error occured';
    try {
      if (shopName.isNotEmpty &&
          customerName.isNotEmpty &&
          contactNo.isNotEmpty) {
        model.Customer customer = model.Customer(
            shopName: shopName,
            customerName: customerName,
            contactNo: contactNo);
        if (await doesDocumentExist(shopName)) {
          // customer with same already exist
          return 'Already Exists';
        } else {
          await _firestore
              .collection('users')
              .doc(_auth!.uid)
              .collection('customers')
              .doc(shopName)
              .set(customer.toJson());
          return 'success';
        }
      } else {
        return 'All fields are Mandatory';
      }
    } catch (err) {
      return err.toString();
    }
  }
}


