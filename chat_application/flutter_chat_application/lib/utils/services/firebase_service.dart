import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_application/presentation/view/profile_screen.dart';

import '../../presentation/view/OTPScreen.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();

  factory FirebaseService() {
    return instance;
  }

  FirebaseService._internal();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              debugPrint('The provided phone number is not valid.');
              Navigator.pop(context);
              _showAlertDialog(context);
            }
          },
          codeSent: (String verificationId, int? resendToken) {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OTPScreen(
                          phoneNo: phoneNumber,
                          verificationId: verificationId,
                          userId: "",
                        )));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> verifyFirebasePhoneNumberOTP(String verificationId,String otp,BuildContext context) async{
    try{
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp);
      auth.signInWithCredential(credential).then(
              (value) =>
              Navigator.pushNamed(context, ProfileScreen.route));

    } on FirebaseException catch(e) {
      debugPrint(e.message);
    }

  }

  Future<void> _showAlertDialog(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog.adaptive(
            content:
            const Text("Wrong Number, Please Try Again with valid Number"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"))
            ],
          );
        });
  }



}

