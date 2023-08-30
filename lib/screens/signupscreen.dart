import 'package:chickenaccount/resources/auth_methods.dart';
import 'package:chickenaccount/screens/home.dart';
import 'package:chickenaccount/screens/loginscreen.dart';
import 'package:flutter/material.dart';
//import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final AuthMethods auth = AuthMethods();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firmNameController.dispose();
    _mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        shadowColor: Colors.black,
        title: const Center(
          child: Text(
            "SignUp",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: _firmNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "Enter Your Firm Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "FirmName"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 12,
            ),

            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Enter Your Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Email"),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 12,
            ),

            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter Your Mobile no.",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Mobile No."),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 12,
            ),

            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Password"),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 24),
            InkWell(
                onTap: () async {
                  String res = await auth.signUpUser(
                      firmname: _firmNameController.text,
                      email: _emailController.text,
                      mobile: _mobileController.text,
                      password: _passwordController.text);
                  if (res == 'success') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  }
                  print(res);
                  // doUserRegistration();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: const Text(
                    'SignUp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            const Text(
              'Already have a account?',
              style: TextStyle(
                  textBaseline: TextBaseline.alphabetic, fontSize: 15),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Login here',
                style: TextStyle(
                    color: Colors.lightGreen,
                    textBaseline: TextBaseline.alphabetic,
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 24),
            //textfields
            //textfields
            //button
            //transitions
          ]),
        ),
      ),
    );
  }

  /*void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserRegistration() async {
    final username = _userNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Enter Details')),
      );
    } else {
      final user = ParseUser.createUser(
        username,
        password,
        email,
      );

      var response = await user.signUp();

      if (response.success) {
        ParseUser currentUser = await ParseUser.currentUser();
        await currentUser.saveInStorage('USER');
        const storage = FlutterSecureStorage();
        await storage.write(key: 'USERNAME', value: username);
        await storage.write(key: 'PASSWORD', value: password);
        await storage.write(
            key: 'FIRMNAME', value: _firmNameController.text.trim());
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );

        showSuccess();
      } else {
        showError(response.error!.message);
      }
    }
  }*/
}
