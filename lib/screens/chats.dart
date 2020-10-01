import 'package:Book_Rental/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String userN = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: isLight ? Colors.green[100] : Colors.blueGrey,
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('coms')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('chats')
              .get(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final chats = futureSnapshot.data.documents;

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Text(chats[i].data()['Name']),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChatScreen(chats[i].data()['Id']),
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
      ),
    );
  }
}
