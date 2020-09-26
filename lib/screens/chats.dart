import 'package:Book_Rental/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String userN = '';
  String userId = '';
  List duplicateNames = [];
  List duplicateIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getchats(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chats = futureSnapshot.data.documents;

          for (var j = 0; j < chats.length; j++) {
            if (chats[j].data()['senderName'] == userN) {
              duplicateNames.add(chats[j].data()['receiverName']);
              duplicateIds.add(chats[j].data()['receiverId']);
            } else
              duplicateNames.add(chats[j].data()['senderName']);
            duplicateIds.add(chats[j].data()['senderId']);
          }

          duplicateNames = duplicateNames.toSet().toList();
          duplicateIds = duplicateIds.toSet().toList();
          for (var i = 0; i < duplicateIds.length; i++) {
            if (duplicateIds[i] == userId) {
              duplicateIds.remove(duplicateIds[i]);
            }
          }

          return ListView.builder(
            itemCount: duplicateNames.length,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Text(duplicateNames[i]),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChatScreen(duplicateIds[i]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<QuerySnapshot> _getchats() async {
    final userId1 = FirebaseAuth.instance.currentUser.uid;
    userId = userId1;
    final user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final username = user.data()['username'].toString();
    userN = username;
    final chats = await FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .get();

    return chats;
  }
}
