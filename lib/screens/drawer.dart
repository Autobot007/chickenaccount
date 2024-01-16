import 'package:chickenaccount/resources/auth_methods.dart';
import 'package:chickenaccount/screens/billing.dart';
import 'package:chickenaccount/screens/editprofile.dart';
import 'package:chickenaccount/screens/loginscreen.dart';
import 'package:chickenaccount/screens/mycustomers.dart';
import 'package:chickenaccount/screens/newbill.dart';
import 'package:chickenaccount/screens/newcustomer.dart';
import 'package:chickenaccount/screens/oldbillscreen.dart';
import 'package:chickenaccount/screens/oldbillsearchlist.dart';
import 'package:chickenaccount/screens/olddelieverychallan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deliverychallanentry.dart';

class Drawer1 extends StatefulWidget {
  const Drawer1({super.key});

  @override
  State<Drawer1> createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  String tradersName = '';
  String mobile = '';
  String email = '';
  AuthMethods auth = AuthMethods();

  Future<void> getDetails() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    tradersName = localData.getString('FirmName').toString();
    email = localData.getString('Email').toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

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
          UserAccountsDrawerHeader(
            arrowColor: Colors.black,
            accountName: Text(
              tradersName.toString(),
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              email.toString(),
              style: TextStyle(fontSize: 15),
            ),
            otherAccountsPictures: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => EditProfile()))),
                child: CircleAvatar(
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
          ListTile(
            title: const Text('My Customers'),
            trailing: Icon(Icons.person),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MyCustomers()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Add new Customers'),
            trailing: Icon(Icons.person_add),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const NewCustomer()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Add Delivery Chalan'),
            trailing: Icon(Icons.edit_calendar),
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
            title: const Text('My Delivery Chalan'),
            trailing: Icon(Icons.inventory_outlined),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OldDelieveryChallan()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('New Bill '),
            trailing: Icon(Icons.edit_document),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const NewBill()));
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text('Old Bill '),
            trailing: Icon(Icons.list_alt),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OldBillSearch()));
              // Update the state of the app.
              // ...
            },
          ),
          // ListTile(
          //   title: const Text('Sales Report '),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.logout),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure want to Logout?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          TextButton(
                              onPressed: () {
                                auth.logOutUser();
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text('Yes'))
                        ],
                      ));
            },
          )
        ],
      ),
    );
  }
}
