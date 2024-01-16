import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/widgets/customerwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCustomer extends StatefulWidget {
  final DocumentSnapshot customer;
  const EditCustomer({super.key, required this.customer});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {

/// *******Page for Editing Existing Customer******

  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  String customerid = '';
  @override
  void initState() {
    _shopNameController.text = widget.customer['ShopName'];
    _customerNameController.text = widget.customer['CustomerName'];
    _contactNoController.text = widget.customer['ContactNo'];
    customerid = widget.customer.id;//getting document id from previous screen
    // TODO: implement initState
    super.initState();
  }

  bool _isLoading = false;
  final CustomerWidget customer = CustomerWidget();

  @override
  void dispose() {
    _shopNameController.dispose();
    _customerNameController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  void updateCustomer(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    String res = await customer.updateCustomer(context,
        docId: customerid,
        shopName: _shopNameController.text,
        customerName: _customerNameController.text,
        contactNo: _contactNoController.text);

    if (res == 'success') {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext newCustomerContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
      ),
      drawer: const Drawer1(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _shopNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: "Enter Shop Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    labelText: "Shop Name"),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _customerNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: "Enter Customer Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    labelText: "Customer Name"),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _contactNoController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "Enter contact No",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    labelText: "Contact No"),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    updateCustomer(context);
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
