import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');
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
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_rounded)),
              ),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.greenAccent,
                child: Icon(Icons.person,color: Colors.white,size: 40,),
              ),
              const SizedBox(height: 10,),
              const Text("+916304274761",textAlign: TextAlign.center,),
              textField("Enter Your Name",nameController),
              textField("Enter your status",statusController),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                    onPressed: () async {
                      await ref.push().set({
                          "name": "mahesh",
                          "status": "Hi, I am new to chat!!",
                          "phNumber": "+916304274761"
                      });
                      ref.onValue.listen((event) {
                        print(event.snapshot.children);
                        print(event.snapshot.children.length);
                        for(final child in event.snapshot.children) {
                          print(child.value);
                        }
                      },onError: (err) {
                        print(err);
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green,),
                    child: const Text("Update",style: TextStyle(color: Colors.white),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String hint,TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
