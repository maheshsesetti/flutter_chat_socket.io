import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../presentation/view/Home_Page.dart';
import '../../presentation/view/OTPScreen.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();

  factory FirebaseService() {
    return instance;
  }

  FirebaseService._internal();

  FirebaseAuth auth = FirebaseAuth.instance;

  // void initFirebase() async {
  //
  // }

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
              Navigator.pushNamed(context, HomePage.route));

    } on FirebaseException catch(e) {
      debugPrint(e.message);
    }

  }

}

