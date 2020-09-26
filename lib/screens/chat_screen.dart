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
          try {
            return Scaffold(
              appBar: AppBar(
                title: Text(futurSnapshot.data),
              ),
              // ignore: deprecated_member_use
              body: Container(
                child: Column(
                  children: [
                    Expanded(child: Messages(chatterId, futurSnapshot.data)),
                    NewMessage(chatterId, futurSnapshot.data),
                  ],
                ),
              ),
            );
          } catch (err) {
            print('no data');
          }
          return Container();
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
