import 'package:flutter/material.dart';
//import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* Future<ParseUser> getUser() async {
    ParseUser currentUser = await ParseUser.currentUser();
    return currentUser;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Homepage'),
        ),
        body: const Text('This is Homepage textview'));
  }
}
