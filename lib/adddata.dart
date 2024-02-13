import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addData(String title,String desc) async{
    if(title=="" || desc==""){
      log("Enter required Details");
    }
    else{
      // Add data to Firebase
      FirebaseFirestore.instance.collection("Data").doc(title).set({
        "Title": title,
        "Description": desc
      }).then((value) => log("Data Inserted")).catchError((error) => log("Failed to add data: $error")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
                icon: Icon(Icons.title),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
                icon: Icon(Icons.description),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              // Add data to Firebase
              addData(titleController.text.toString(), descriptionController.text.toString());
            },
            child: Text("Add Data"),
          )
        ],
      ),
    );
  }
}
