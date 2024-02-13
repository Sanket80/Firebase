import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class OTPScreen extends StatefulWidget {

  String verificationId;
  OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('OTP Screen'),
    centerTitle: true,
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter OTP",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: () async {
            try{
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otpController.text);
              FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "HomePage"))));
            }
            catch(e){
              log(e.toString());
            }
          }, child: Text("Verify OTP")),
        ],
      ),
    );
  }
}
