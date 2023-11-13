import 'package:chickenaccount/screens/billing.dart';
import 'package:chickenaccount/screens/newcustomer.dart';
import 'package:chickenaccount/widgets/newcustomer.dart';
import 'package:flutter/material.dart';

import 'deliverychallanentry.dart';

class Drawer1 extends StatefulWidget {
  const Drawer1({super.key});

  @override
  State<Drawer1> createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
              accountName: Text(
                'Fatema Traders',
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: Text(
                'dart123@gmail.com',
                style: TextStyle(fontSize: 15),
              )),
          ListTile(
            title: const Text('Delivery Chalan'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeliveryChallanEntry()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Billing '),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Billing()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Add new Customer '),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NewCustomer())); // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Sales Report '),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          )
        ],
      ),
    );
  }
}
