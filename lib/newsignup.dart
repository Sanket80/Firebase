import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test8/uihelpher.dart';

class NewSignUpPage extends StatefulWidget {
  const NewSignUpPage({super.key});

  @override
  State<NewSignUpPage> createState() => _NewSignUpPageState();
}

class _NewSignUpPageState extends State<NewSignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? pickedImage;

  signUp(String email, String password) async {
    if (email == "" || password == "" || pickedImage == null) {
      UiHelper.CustomAlertBox(context, "Enter required Details");
    } else {
      try {
        UserCredential? usercredential;
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        uploadData();
      } on FirebaseAuthException catch (ex) {
        UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  uploadData() async {
    try {
      if (pickedImage == null || emailController.text.isEmpty) {
        throw Exception("Image or email is missing");
      }

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("ProfileImages")
          .child(emailController.text)
          .putFile(pickedImage!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(emailController.text.toString())
          .set({
        "Email": emailController.text.toString(),
        "ProfileImage": downloadUrl
      });

      log("Data Uploaded");
    } catch (e) {
      log("Upload Error: $e");
    }
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick Image From"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text("Camera"),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image_rounded),
                  title: Text("Gallery"),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showAlertBox();
            },
            child: pickedImage != null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(pickedImage!),
                  )
                : CircleAvatar(
                    radius: 80,
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      size: 60,
                    ),
                  ),
          ),
          SizedBox(
            height: 15,
          ),
          UiHelper.CustomTextfield(
              emailController, "Email", Icons.email_rounded, false),
          SizedBox(
            height: 15,
          ),
          UiHelper.CustomTextfield(
              passwordController, "Password", Icons.lock_open_rounded, true),
          SizedBox(
            height: 30,
          ),
          UiHelper.CustomButton(() {
            signUp(emailController.text.toString(),
                passwordController.text.toString());
          }, "Sign Up"),
        ],
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      if (pickedFile == null) return;
      final image = File(pickedFile.path);
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
