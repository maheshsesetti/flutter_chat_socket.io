import 'package:appwrite/appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_chat_application/utils/services/firebase_service.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottie/lottie.dart';

import '../../client/main.dart';
import 'OTPScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedCountryCode = '+91';
  String selectedCountry = "India(IN)";
  bool isLoading = false;
  TextEditingController selectCountryController =
      TextEditingController(text: "India(IN)");
  TextEditingController selectCountryCodeController =
      TextEditingController(text: "91");
  TextEditingController phnoController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  FirebaseAuth auth = FirebaseAuth.instance;
  final account = Account(client);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset("assets/logo.json"),
                const Text(
                  "Enter Your Phone Number",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 40,
                ),
                RichText(
                  text: const TextSpan(
                      text:
                          "Flutter chat app will send SMS message to verify your phone number.",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(
                            text: "What's my number?",
                            style:
                                TextStyle(color: Colors.green, fontSize: 15)),
                      ]),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: selectCountryController,
                    readOnly: true,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              showCountryPicker(
                                context: context,
                                onSelect: (Country country) {
                                  debugPrint(
                                      'Select country: ${country.displayName}');
                                  selectCountryController.text =
                                      country.displayNameNoCountryCode;
                                  selectCountryCodeController.text =
                                      country.phoneCode;
                                  phnoController.clear();
                                },
                              );
                            },
                            icon: const Icon(Icons.arrow_drop_down_rounded))),
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          debugPrint('Select country: ${country.displayName}');
                          selectCountryController.text =
                              country.displayNameNoCountryCode;

                          selectCountryCodeController.text = country.phoneCode;
                          phnoController.clear();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: selectCountryCodeController,
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phnoController,
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      debugPrint(
                          "+${selectCountryCodeController.text}${phnoController.text}");
                      getPhoneNumber(
                          "+${selectCountryCodeController.text}${phnoController.text}",
                          context);

                      // createAppWritePhoneNumber("+${selectCountryCodeController.text}${phnoController.text}",context);
                    },
                    child: const Text("Next"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAppWritePhoneNumber(
      String phoneNumber, BuildContext context) async {
    try {
      final sessionToken = await account.createPhoneSession(
          userId: ID.unique(), phone: phoneNumber);
      debugPrint(sessionToken.toString());
      final userId = sessionToken.userId;
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OTPScreen(
          userId: userId, verificationId: '',phoneNo: "",
          // verificationId: verificationId,
        );
      }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getPhoneNumber(String phoneNumber, BuildContext context) async {
    try {
      PhoneNumber number =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
      _showLoadingImage();
      setState(() {
        this.number = number;
      });
      if (!mounted) return;
      FirebaseService.instance.signInWithPhoneNumber(phoneNumber, context);
      // await auth.verifyPhoneNumber(
      //     phoneNumber: phoneNumber,
      //     verificationCompleted: (PhoneAuthCredential credential) async {
      //
      //       await auth.signInWithCredential(credential);
      //     },
      //     verificationFailed: (FirebaseAuthException e) {
      //       if (e.code == 'invalid-phone-number') {
      //         debugPrint('The provided phone number is not valid.');
      //       }
      //     },
      //     codeSent: (String verificationId, int? resendToken) {
      //      _showLoadingImage();
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => OTPScreen(
      //                     verificationId: verificationId,
      //                      userId: "",
      //                   )));
      //     },
      //     codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      debugPrint("Invalid Number");
      _showAlertDialog();
    }
  }

  Future<void> _showLoadingImage() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog.adaptive(
              backgroundColor: Colors.transparent,
              content: Lottie.asset('assets/logo.json'));
        });
  }

  Future<void> _showAlertDialog() async {
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
