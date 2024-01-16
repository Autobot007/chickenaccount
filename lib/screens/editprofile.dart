import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firmNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  final User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  void getData() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapShot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

    _firmNameController.text = userSnapShot['firmname'];
    _emailController.text = userSnapShot['email'];
    _mobileController.text = userSnapShot['mobile'];
    setState(() {});
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _firmNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void updateProfile() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    Map<String, dynamic> updateDetails = {};
    updateDetails['firmname'] = _firmNameController.text;
    updateDetails['email'] = _emailController.text;
    updateDetails['mobile'] = _mobileController.text;

    setState(() {
      _isLoading = true;
    });
    try {
      await user?.updateEmail(_emailController.text);
      
      //  await user.updateEmail(_emailController.text.trim());
      await _firestore.collection('users').doc(user!.uid).update(updateDetails);
      DocumentSnapshot<Map<String, dynamic>> userSnapShot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      localData.setString('FirmName', userSnapShot.data()?['firmname']);
      localData.setString('Email', userSnapShot.data()?['email']);
      localData.setString('Mobile', userSnapShot.data()?['mobile']);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error updating email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _firmNameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
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
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                  onTap: () {
                    updateProfile();
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
