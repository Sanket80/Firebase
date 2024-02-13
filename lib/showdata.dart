import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Data'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text("${snapshot.data!.docs[index]["Email"]}"),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No data available"), // Placeholder for no data
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(), // Loading indicator
            );
          }
        },
      )
    );
  }
}
