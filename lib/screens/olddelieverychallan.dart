import 'package:chickenaccount/screens/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OldDelieveryChallan extends StatefulWidget {
  const OldDelieveryChallan({super.key});

  @override
  State<OldDelieveryChallan> createState() => _OldDelieveryChallanState();
}

class _OldDelieveryChallanState extends State<OldDelieveryChallan> {
  final TextEditingController _shopNameController = TextEditingController();
  List<Map<String, dynamic>> entryList = [];
  final querySnapshotfirestore = FirebaseFirestore.instance;
  final User? _auth = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> _entries = [];
  Set<int> _checkedItems = {};
  List<DocumentSnapshot> _selectedEntries = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    if (_shopNameController.text.isEmpty) {
      getAllEntry();
    } else {
      getEntry(_shopNameController.text);
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _shopNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Entries'),
      ),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const NewCustomer()),
                            // );
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
                  if (_shopNameController.text.isEmpty) {
                  } else {
                    getEntry(_shopNameController.text);
                  }
                },
                child: const Text("Search"),
              )
            ]),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: InkWell(
                          onTap: () {
                            _showConfirmationDialog(
                                context, _entries[index].id);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
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
                              Text(
                                "${_entries[index]["Date"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                      //_selectedEntries.add(_entries[index]);

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
          ],
        ),
      ),
    );
  }

  Future<List<String>> getSuggestions(String query) async {
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

  Future<void> getAllEntry() async {
    try {
      QuerySnapshot querySnapshot = await querySnapshotfirestore
          .collection('users')
          .doc(_auth!.uid)
          .collection('entry')
          .where('Billed', isEqualTo: false)
          .orderBy('TimeStamp', descending: false)
          .get();
      setState(() {
        _entries = querySnapshot.docs;
        print(_entries);
      });
    } catch (e) {
      print("error fetching data");
    }
  }

  Future<void> deleteEntry(String document) async {
    try {
      final deleteSnapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth!.uid)
          .collection('entry')
          .doc(document)
          .delete();

      initState();
    } catch (e) {}
  }

  void _showConfirmationDialog(BuildContext context, String documentid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure want to delete Entry?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Return false when "No" is pressed.
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                deleteEntry(documentid);
                Navigator.of(context)
                    .pop(); // Return true when "Yes" is pressed.
              },
            ),
          ],
        );
      },
    );
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



  
