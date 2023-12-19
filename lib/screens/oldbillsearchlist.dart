import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/screens/newbill.dart';
import 'package:chickenaccount/screens/oldbillscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OldBillSearch extends StatefulWidget {
  const OldBillSearch({super.key});

  @override
  State<OldBillSearch> createState() => _OldBillSearchState();
}

class _OldBillSearchState extends State<OldBillSearch> {
  late DocumentSnapshot billDocumentSnapshot;
  final TextEditingController _shopNameController = TextEditingController();
  List<DocumentSnapshot> _bill = [];
  final querySnapshotfirestore = FirebaseFirestore.instance;
  final User? _auth = FirebaseAuth.instance.currentUser;
  Set<int> _checkedItems = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Old bill')),
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
                                  builder: (context) => const NewBill()),
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
                    return ListTile(
                      onTap: () {
                        billDocumentSnapshot = _bill[index];
                        print(_bill[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OldBillScreen(
                              billDocumentSnapshot: billDocumentSnapshot,
                            ),
                          ),
                        );
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _bill[index]["ShopName"],
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
                                "${_bill[index]["Date"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ],
                      ),
                      tileColor: Colors.white,
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Total:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  )),
                              Text("${_bill[index]["Total"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: _bill.length,
                )),
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

  Future<void> getEntry(String query) async {
    try {
      QuerySnapshot querySnapshot = await querySnapshotfirestore
          .collection('users')
          .doc(_auth!.uid)
          .collection('bill')
          .where('ShopName', isEqualTo: query)
          .orderBy('Date', descending: true)
          .get();
      setState(() {
        _bill = querySnapshot.docs;
        print(_bill);
      });
    } catch (e) {
      print("error fetching data");
    }
  }
}
