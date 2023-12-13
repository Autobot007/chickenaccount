import 'package:chickenaccount/widgets/Newcustomer.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';

class NewCustomer extends StatefulWidget {
  const NewCustomer({super.key});

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();

  bool _isLoading = false;
  final newcustomer customer = newcustomer();

  @override
  void dispose() {
    _shopNameController.dispose();
    _customerNameController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  void addNewCustomer() async {
    setState(() {
      _isLoading = true;
    });
    String res = await customer.newCustomer(
        shopName: _shopNameController.text,
        customerName: _customerNameController.text,
        contactNo: _contactNoController.text);

    if (res == 'success') {
      _shopNameController.clear();
      _customerNameController.clear();
      _contactNoController.clear();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext newCustomerContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Customer'),
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
                  onTap: addNewCustomer,
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
                            'Add',
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
