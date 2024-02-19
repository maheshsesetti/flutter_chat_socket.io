import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_application/model/profileModel.dart';
import 'package:flutter_chat_application/utils/services/share_preference.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/ProfileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final _imagePicker = ImagePicker();
  XFile? _image;
  String? _imageURL;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void dispose() {
    nameController.dispose();
    statusController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_rounded)),
              ),
              InkWell(
                onTap: () async {
                  await pickImage();
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.greenAccent,
                  child: _image == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ):
                  ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(40), // Image radius
                      child: Image.file(File(_image!.path),fit: BoxFit.cover,),
                    ),
                  )
                      // : Image.file(File(_image!.path)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${Prefs.getString("phoneNumber")}",
                textAlign: TextAlign.center,
              ),
              textField("Enter Your Name", nameController, validation: (value) {
                if (nameController.text.isEmpty) {
                  return "Please Enter Name";
                } else {
                  return null;
                }
              }),
              textField("Enter your status", statusController,
                  validation: (value) {
                if (statusController.text.isEmpty) {
                  return "Please Enter Status";
                } else {
                  return null;
                }
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_image!.path.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please Select Image")));
                      }
                      formKey.currentState!.validate();
                      try {
                        await storageRef
                            .child("users/${Prefs.getString("userId")}/profile.jpg")
                            .putFile(File(_image!.path));
                        _imageURL = await storageRef.getDownloadURL();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      try {
                        await ref.push().set({
                          "userId": Prefs.getString("userId") ?? "",
                          "name": nameController.text,
                          "status": statusController.text,
                          "phNumber": Prefs.getString("phoneNumber") ?? "",
                          "profilePic": _imageURL
                        }
                          // ProfileModel(
                          //     userId: Prefs.getString("userId") ?? "",
                          //     name: nameController.text,
                          //     status: statusController.text,
                          //     phNumber: Prefs.getString("phoneNumber") ?? "",
                          //     profilePic: _image!.path
                          //     )
                        );
                      } catch (e) {
                        debugPrint(e.toString());
                      }

                      ref.onValue.listen((event) {
                        print(event.snapshot.children);
                        print(event.snapshot.children.length);
                        for (final child in event.snapshot.children) {
                          print(child.value);
                        }
                      }, onError: (err) {
                        print(err);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String hint, TextEditingController controller,
      {required String? Function(dynamic value) validation}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          validator: validation),
    );
  }

  Future<void> pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
}
