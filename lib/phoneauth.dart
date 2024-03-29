import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/uihelpher.dart';

import 'otpscreen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Auth'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Enter Your Phone Number",
                    suffixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      UiHelper.CustomAlertBox(context, e.code.toString());
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      // Update the UI - Navigate to OTP Screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OTPScreen(verificationId: verificationId)));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // Auto retrieval time out
                    },
                  );
                },
                child: Text("Verify Phone Number")),
          ],
        ));
  }
}
