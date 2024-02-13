import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test8/loginpage.dart';
import 'package:test8/main.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return MyHomePage(title: "HomeScreen");
    }
    else{
      return LoginPage();
    }
  }
}
