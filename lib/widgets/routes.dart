import 'package:chickenaccount/main.dart';
import 'package:chickenaccount/screens/deliverychallanentry.dart';
import 'package:chickenaccount/screens/home.dart';
import 'package:chickenaccount/screens/loginscreen.dart';
import 'package:chickenaccount/screens/newbill.dart';
import 'package:chickenaccount/screens/newcustomer.dart';
import 'package:chickenaccount/screens/signupscreen.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/SignUp': (context) => const SignUpScreen(),
        '/Home': (context) => const Home(),
        '/NewCustomer': (context) => const NewCustomer(),
        '/DeliveryChallan': (context) => const DeliveryChallanEntry(),
        "/NewBill": (context) => const NewBill(),
        //'/Old Bill':(context)=>const OldBill()
      },
    );
  }
}
