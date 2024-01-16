import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/screens/editcustomer.dart';
import 'package:chickenaccount/widgets/customerwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCustomers extends StatefulWidget {
  const MyCustomers({super.key});

  @override
  State<MyCustomers> createState() => _MyCustomersState();
}

class _MyCustomersState extends State<MyCustomers> {
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _isExpanded = false;
  final CustomerWidget customer = CustomerWidget();

  final User? _auth = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> customerList = [];
  @override
  void dispose() {
    // TODO: implement dispose
    _shopNameController.dispose();
    _customerNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          getData();
        },
      ),
      drawer: Drawer1(),
      appBar: AppBar(title: Text('My Customers')),
      body: Container(
        padding: EdgeInsets.all(4),
        child: ListView.builder(
          itemCount: customerList.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              childrenPadding: EdgeInsets.all(10),
              backgroundColor: Colors.green[100], 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              title: Text(customerList[index]['ShopName']),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              initiallyExpanded: _isExpanded,
              children: [
                ListTile(
                  title: Text(customerList[index]['CustomerName']),
                  trailing: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'Edit') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditCustomer(
                                    customer: customerList[index])));
                      } else if (value == 'Delete') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure want to delete \n${customerList[index]['ShopName']} ?'),
                              actions: [
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    await _firestore
                                        .collection('users')
                                        .doc(_auth!.uid)
                                        .collection('customers')
                                        .doc(customerList[index].id)
                                        .delete();
                                    print('deleted');
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyCustomers()),
                                    );
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'))
                              ],
                            );
                          },
                        );

                        // customer.deleteCustomer(
                        //     context, customerList[index].id);
                        // Navigator.pushReplacement(
                        //     (context),
                        //     MaterialPageRoute(
                        //         builder: (context) => const MyCustomers()));
                      }
                      // Handle menu item selection
                      print('Selected: $value');
                      print(customerList[index].toString());
                    },
                  ),
                ),
                ListTile(
                  title: Text(customerList[index]['ContactNo']),
                ),
              ],

              // Add onTap to toggle the expansion state
            );
          },
        ),
      ),
    );
  }

  getData() async {
    final User? _auth = FirebaseAuth.instance.currentUser;

    // Retrieving customers from customers collections
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth!.uid)
        .collection('customers')
        .orderBy('ShopName', descending: false)
        .get();

    // Access the documents from the snapshot
    customerList = querySnapshot.docs;
    setState(() {});
  }
}
