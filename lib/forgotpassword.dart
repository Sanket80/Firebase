import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/uihelpher.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailController = TextEditingController();

  forgotPassword(String email) async {
    if (email == "") {
      UiHelper.CustomAlertBox(context, "Enter an Email to reset password");
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        UiHelper.CustomAlertBox(context, "Password Reset Email Sent");
      } on FirebaseAuthException catch (ex) {
        UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextfield(emailController, "Email", Icons.email_outlined, false),
          SizedBox(
            height: 15,
          ),
          UiHelper.CustomButton(() {
            forgotPassword(emailController.text.toString());
          }, "Reset Password")
        ],
      ),
    );
  }
}
