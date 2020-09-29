import 'package:Book_Rental/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class Messages extends StatefulWidget {
  String chatterId;
  String chatterName;

  Messages(this.chatterId, this.chatterName);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String cU = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentId(),
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
            print(widget.chatterName);
            print(cU);
            print(chatDocs[1].data()['receiverName']);
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                if ((chatDocs[index].data()['senderName'].toString() !=
                        widget.chatterName) &&
                    (chatDocs[index].data()['senderName'].toString() != cU)) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                }
                if ((chatDocs[index].data()['receiverName'].toString() !=
                        widget.chatterName) &&
                    (chatDocs[index].data()['receiverName'].toString() != cU)) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                }
                return MessageBubble(
                  chatDocs[index].data()['text'],
                  chatDocs[index].data()['senderName'],
                  chatDocs[index].data()['senderImage'],
                  chatDocs[index].data()['senderId'] == futureSnapshot.data.uid,
                  key: ValueKey(chatDocs[index].documentID),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<User> _getCurrentId() async {
    // ignore: deprecated_member_use
    String userid = FirebaseAuth.instance.currentUser.uid;
    final userdata =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    final username = userdata.data()['username'];
    cU = username;
    User user = FirebaseAuth.instance.currentUser;

    return user;
  }
}

// ignore: deprecated_member_use
