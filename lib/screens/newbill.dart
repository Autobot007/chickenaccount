import 'package:chickenaccount/screens/billscreen.dart';
import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/screens/newcustomer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewBill extends StatefulWidget {
  const NewBill({super.key});

  @override
  State<NewBill> createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  final TextEditingController _shopNameController = TextEditingController();
  List<Map<String, dynamic>> entryList = [];
  final querySnapshotfirestore = FirebaseFirestore.instance;
  final User? _auth = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> _entries = [];
  Set<int> _checkedItems = {};
  List<DocumentSnapshot> _selectedEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New bill')),
      drawer: const Drawer1(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Expanded(
                child: TypeAheadField<String>(
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    textCapitalization: TextCapitalization.words,
                    controller: _shopNameController,
                    decoration: InputDecoration(
                      //suffixIcon: const Icon(Icons.search),
                      suffixIcon: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NewCustomer()),
                            );
                          },
                          child: const Icon(Icons.person_add)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Customer',
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _shopNameController.text = suggestion;
                    // Handle what happens when a suggestion is selected.
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _selectedEntries = [];
                  _checkedItems = {};
                  getEntry(_shopNameController.text);
                },
                child: const Text("Search"),
              )
            ]),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _entries[index]["ShopName"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${_entries[index]["Date"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                      tileColor: _checkedItems.contains(index)
                          ? Colors.green[100]
                          : Colors.white,
                      value: _checkedItems.contains(index),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _checkedItems.add(index);
                            _selectedEntries.add(_entries[index]);
                            print(_selectedEntries);
                          } else {
                            _checkedItems.remove(index);
                            _selectedEntries.remove(_entries[index]);
                          }

                          //_selectedEntries.add(_entries[index]);
                          // print(_selectedEntries);
                        });
                      },
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Nos:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text("${_entries[index]["Nos"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Weight:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text("${_entries[index]["Weight"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Rate:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Text("${_entries[index]["Rate"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text("Total:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900)),
                                      Text("${_entries[index]["Total"]}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _entries.length,
                )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BillScreen(),
                          settings:
                              RouteSettings(arguments: _selectedEntries)));
                },
                child: const Text('Generate'))
          ],
        ),
      ),
    );
  }

  Future<List<String>> getSuggestions(String query) async {
    final User? _auth = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth!.uid)
        .collection('customers')
        .where('ShopName', isGreaterThanOrEqualTo: query)
        .where('ShopName', isLessThan: query + 'z')
        .get();

    return querySnapshot.docs.map((doc) => doc['ShopName'] as String).toList();
  }

  /*Future<List<Map<String, dynamic>>?> getEntry(String query) async {
    final User? _auth = FirebaseAuth.instance.currentUser;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth!.uid)
          .collection('entry')
          .where('ShopName', isEqualTo: query)
          .where('Billed', isEqualTo: false)
          .get();
      setState(() {
        entryList = querySnapshot.docs.map((doc) => doc.data()).toList();
      });

      // Print the result to the console
      print("Query Result:");
      entryList.forEach((entry) {
        print(entry);
      });

      return entryList;
    } catch (e) {
      print('Error fetching entries: $e');
      return null;
    }
  }*/
  Future<void> getEntry(String query) async {
    try {
      QuerySnapshot querySnapshot = await querySnapshotfirestore
          .collection('users')
          .doc(_auth!.uid)
          .collection('entry')
          .where('ShopName', isEqualTo: query)
          .where('Billed', isEqualTo: false)
          .get();
      setState(() {
        _entries = querySnapshot.docs;
        print(_entries);
      });
    } catch (e) {
      print("error fetching data");
    }
  }
}

/*
    querySnapshot
        .collection("users")
        .doc(_auth!.uid)
        .collection('entry')
        .where('ShopName', isEqualTo: query)
        .where('Billed', isEqualTo: false)
        .get();
    print(querySnapshot.toString());
    return querySnapshot;*/

  /*final User? _auth = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth!.uid)
        .collection('entry')
        .where('ShopName', isGreaterThanOrEqualTo: query)
        .where('ShopName', isLessThan: query + 'z')
        .where('Billed', isEqualTo: false)
        .get();
    entryList.add(querySnapshot.docs as Map<String, dynamic>);


    print(querySnapshot);*/

