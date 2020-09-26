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
        builder: (ctx, futurSnapshot) {
          final chatter = futurSnapshot.data.data()['username'];

          return Scaffold(
            appBar: AppBar(
              title: Text(chatter),
            ),
            // ignore: deprecated_member_use
            body: Container(
              child: Column(
                children: [
                  Expanded(child: Messages(chatterId, chatter)),
                  NewMessage(chatterId, chatter),
                ],
              ),
            ),
          );
        });
  }

  Future<DocumentSnapshot> _getUsersData() async {
    // ignore: deprecated_member_use
    DocumentSnapshot users = await FirebaseFirestore.instance
        .collection('users')
        .doc(chatterId)
        .get();
    return users;
  }
}
