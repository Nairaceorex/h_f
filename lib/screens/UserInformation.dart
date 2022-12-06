import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:h_f/domain/FirebaseConfig.dart';
import 'package:h_f/screens/WebViewPage.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Plans').snapshots();

  var keyLink = 'link';

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewPage(url, title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text("${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              "Loading",
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      data['name'],
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setLink('link', data['link']);
                      print(getLink('link'));

                      _handleURLButtonPress(
                          context, data['link'], data['name']);
                    },
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
