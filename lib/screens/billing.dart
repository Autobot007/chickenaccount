import 'package:flutter/material.dart';

import 'drawer.dart';

class Billing extends StatefulWidget {
  const Billing({super.key});

  @override
  State<Billing> createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
      ),
      drawer: const Drawer1(),
      body: SingleChildScrollView(child: Container()),
    );
  }
}
