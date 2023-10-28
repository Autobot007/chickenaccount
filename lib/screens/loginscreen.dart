import 'package:chickenaccount/resources/auth_methods.dart';
import 'package:chickenaccount/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:chickenaccount/screens/home.dart';
//import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      setState(() {
        _isLoading = false;
      });
    } else {
      print("some error occured");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        shadowColor: Colors.white,
        title: const Center(
            child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
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
                  onTap: () {
                    if (_emailController.text.trim().isEmpty ||
                        _passwordController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please Enter Details')),
                      );
                    } else {
                      loginUser();
                      //doUserLogin();
                    }
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
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  )),
              const SizedBox(height: 24),
              const Text(
                'Dont have a account?',
                style: TextStyle(
                    textBaseline: TextBaseline.alphabetic, fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  'SignUp here',
                  style: TextStyle(
                      color: Colors.lightGreen,
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /* void doUserLogin() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      showSuccess("User was successfully login!");
      //setState(() async {
      // const storage = FlutterSecureStorage();
      // await storage.write(key: 'USERNAME', value: username);
      // await storage.write(key: 'PASSWORD', value: password);
      //await storage.write(key: 'FIRMNAME', value: user.get('firmname'));
      // });
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      showError(response.error!.message);
    }
  }

  

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
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
}*/
/*void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/
}
