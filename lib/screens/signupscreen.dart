import 'package:chickenaccount/resources/auth_methods.dart';
import 'package:chickenaccount/screens/home.dart';
import 'package:chickenaccount/screens/loginscreen.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = false;

  final AuthMethods auth = AuthMethods();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firmNameController.dispose();
    _mobileController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
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
    setState(() {
      _isLoading = false;
    });
    
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
                onTap: signUpUser,
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
          ]),
        ),
      ),
    );
  }
}
