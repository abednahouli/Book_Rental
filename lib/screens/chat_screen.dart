import 'package:Book_Rental/widgets/messages.dart';
import 'package:Book_Rental/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  String chatterId;
  ChatScreen(this.chatterId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUsersData(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(futureSnapshot.data),
            ),
            // ignore: deprecated_member_use
            body: Container(
              child: Column(
                children: [
                  Expanded(child: Messages(chatterId, futureSnapshot.data)),
                  NewMessage(chatterId, futureSnapshot.data),
                ],
              ),
            ),
          );
        });
  }

  Future<String> _getUsersData() async {
    // ignore: deprecated_member_use
    DocumentSnapshot users = await FirebaseFirestore.instance
        .collection('users')
        .doc(chatterId)
        .get();
    final user = users.data()['username'];
    return user;
  }
}
