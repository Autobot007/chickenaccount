import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String firmname,
      required String email,
      required String mobile,
      required String password}) async {
    String res = 'Some error occured';
    try {
      if (firmname.isNotEmpty ||
          email.isNotEmpty ||
          mobile.isNotEmpty ||
          password.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //add user to firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
          'uid': cred.user!.uid,
          'mobile': mobile,
        });
        res = 'success';
      }
    } // on FirebaseAuthException catch (err){
    /*switch (err){
      {
          
        }

      }*/
    /* if (err.code == 'invalid-email'){
        // snackbar or dialog code for email #Please enter valid email #
      }else if(err.code == 'weak-password') {

      }
    } */

    catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = " Some error occured";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
