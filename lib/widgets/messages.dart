import 'package:Book_Rental/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  String chatterId;
  String chatterName;
  Messages(this.chatterId, this.chatterName);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUserName(),
      // ignore: missing_return
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              print(chatDocs.length);
              print(chatterId);
              return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    if ((chatDocs[index].data()['senderId'].toString() !=
                            chatterId) &&
                        (chatDocs[index].data()['senderId'].toString() !=
                            FirebaseAuth.instance.currentUser.uid)) return null;
                    if ((chatDocs[index].data()['receiverId'].toString() !=
                            chatterId) &&
                        (chatDocs[index].data()['receiverId'].toString() !=
                            FirebaseAuth.instance.currentUser.uid)) return null;
                    return MessageBubble(
                      chatDocs[index].data()['text'],
                      chatDocs[index].data()['senderName'],
                      chatDocs[index].data()['senderImage'],
                      chatDocs[index].data()['senderId'] ==
                          futureSnapshot.data.uid,
                      key: ValueKey(chatDocs[index].documentID),
                    );
                  });
            });
      },
    );
  }
}

// ignore: deprecated_member_use
Future<User> _getCurrentUserName() async {
  // ignore: deprecated_member_use
  User user = await FirebaseAuth.instance.currentUser;
  return user;
}
