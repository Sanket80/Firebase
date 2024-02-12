import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/signup.dart';
import 'package:test8/uihelpher.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login(String email, String password) async {
    if (email == "" || password == "") {
      UiHelper.CustomAlertBox(context, "Enter required Details");
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: "HomePage")),
              ),
            );
      } on FirebaseAuthException catch (ex) {
        UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomTextfield(
                emailController, "Email", Icons.email_outlined, false),
            SizedBox(
              height: 15,
            ),
            UiHelper.CustomTextfield(
                passwordController, "Password", Icons.lock_open_rounded, true),
            SizedBox(
              height: 30,
            ),
            UiHelper.CustomButton(() {
              login(emailController.text.toString(),
                  passwordController.text.toString());
            }, "Login"),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
