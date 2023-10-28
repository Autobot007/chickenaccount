import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/widgets/newentry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:chickenaccount/models/entry.dart' as model;

class DeliveryChallanEntry extends StatefulWidget {
  const DeliveryChallanEntry({super.key, this.restorationID});
  final String? restorationID;

  @override
  State<DeliveryChallanEntry> createState() => _DeliveryChallanEntryState();
}

class _DeliveryChallanEntryState extends State<DeliveryChallanEntry> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nosController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  //String _selectedCustomer;
  final NewEntry entry = NewEntry();
  var selectedDate = DateTime.now();

  String _selectedCustomer = '';
  bool _isLoading = false;
  bool billed = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  double total = 0;
  @override
  void dispose() {
    _shopNameController.dispose();
    _dateController.dispose();
    _nosController.dispose();
    _weightController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          shadowColor: Colors.black,
          title: Text(
            "Delivery Challan Entry",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      drawer: const Drawer1(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 24),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                DateFormat('dd-MM-yyyy').format(selectedDate),
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                width: 40,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              )
            ]),
            const SizedBox(
              height: 12,
            ),
            TypeAheadField<String>(
              hideOnEmpty: true,
              textFieldConfiguration: TextFieldConfiguration(
                controller: _shopNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
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
            )
            /* TextFormField(
              controller: _shopNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "Enter Shop Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Shop Name"),
              textInputAction: TextInputAction.next,
            ),*/
            ,
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              controller: _nosController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter No of chicken",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Quantity/No.s"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              onChanged: (result) {
                double kg = double.tryParse(_weightController.text) ?? 0;
                double rate = double.tryParse(_rateController.text) ?? 0;
                double result = (kg * rate);
                setState(() {
                  total = result;
                });
              },
              controller: _weightController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter Total Weight",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Total Weight"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              onChanged: (result) {
                double kg = double.tryParse(_weightController.text) ?? 0;
                double rate = double.tryParse(_rateController.text) ?? 0;
                double result = (kg * rate);
                setState(() {
                  total = double.parse(result.toStringAsFixed(4));
                });
              },
              controller: _rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Enter Rate ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Enter Rate"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            Text(
              'Total= $total',
              style: const TextStyle(
                  textBaseline: TextBaseline.alphabetic, fontSize: 30),
            ),
            const SizedBox(height: 24),
            InkWell(
                onTap: addNewEntry,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add New Entry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ))
          ]),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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

  addNewEntry() async {
    setState(() {
      _isLoading = true;
    });
    String res = await entry.newEntry(
        date: DateFormat('dd-MM-yyyy').format(selectedDate),
        customer: _shopNameController.text,
        nos: _nosController.text,
        weight: _weightController.text,
        rate: _rateController.text,
        total: total.toString(),
        billed: billed);

    if (res == 'success') {
      print(res);
      _shopNameController.clear();
      _nosController.clear();
      _weightController.clear();
      _rateController.clear();
      total = 0;
    }
    setState(() {
      _isLoading = false;
    });
    print(res);
  }
}
