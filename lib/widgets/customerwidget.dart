import 'package:chickenaccount/screens/mycustomers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chickenaccount/models/customer.dart' as model;
import 'package:flutter/material.dart';

// ignore: camel_case_types
class CustomerWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _auth = FirebaseAuth.instance.currentUser;
  String existingDocumentId = '';

  Future<bool> doesDocumentExist(String shopName) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(_auth!.uid)
        .collection('customers')
        .where('ShopName', isEqualTo: shopName)
        .get();
    if (snapshot.docs.isEmpty) {
      // customer with same shopname exist the return value will true
      return false;
    }
    existingDocumentId = snapshot.docs.first.id;
    return true;
  }

  Future<String> deleteCustomer(
    BuildContext context,
    String docId,
  ) async {
    return 'success';
  }

  Future<String> newCustomer(
      {required String shopName,
      required String customerName,
      required String contactNo}) async {
    try {
      if (shopName.isNotEmpty &&
          customerName.isNotEmpty &&
          contactNo.isNotEmpty) {
        model.Customer customer = model.Customer(
            shopName: shopName,
            customerName: customerName,
            contactNo: contactNo);
        if (await doesDocumentExist(shopName)) {
          print('documentexists');
          // customer with same already exist
          //showConfirmationDialog(
          //context, existingDocumentId, shopName, customerName, contactNo);
          return 'Already Exists';
        } else {
          await _firestore
              .collection('users')
              .doc(_auth!.uid)
              .collection('customers')
              .add(customer.toJson());
          return 'success';
        }
      } else {
        return 'All fields are Mandatory';
      }
    } catch (err) {
      return err.toString();
    }
  }

  void showConfirmationDialog(BuildContext context, String docId,
      String shopName, String customerName, String contactNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customer with same name already exists'),
          content: Text('Are you sure want to Update details'),
          actions: [
            TextButton(
                onPressed: () async {
                  try {
                    await _firestore
                        .collection('users')
                        .doc(_auth!.uid)
                        .collection('customers')
                        .doc(docId)
                        .update({
                      'ShopName': shopName,
                      'CustomerName': customerName,
                      'ContactNo': contactNo
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MyCustomers()),
                    );
                  } catch (e) {}
                  ;
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'))
          ],
        );
      },
    );
  }

  Future<String> updateCustomer(BuildContext context,
      {required String docId, //document id of customer
      required String shopName, //shopname of name to be updated
      required String customerName,
      required String contactNo}) async {
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
          showConfirmationDialog(
              context, docId, shopName, customerName, contactNo);

          return 'success';
        } else {
          await _firestore
              .collection('users')
              .doc(_auth!.uid)
              .collection('customers')
              .doc(docId)
              .set(customer.toJson());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: ((context) => const MyCustomers())));
          return 'success';
        }
      } else {
        return 'All Fields are Mandatory';
      }
    } catch (err) {
      return err.toString();
    }
  }
}
