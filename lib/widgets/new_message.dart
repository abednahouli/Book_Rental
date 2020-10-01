import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
  String chatterId, chatterName;
  NewMessage(this.chatterId, this.chatterName);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance
        .collection('coms')
        .doc(user.uid)
        .collection('chats')
        .doc(widget.chatterId)
        .set({'Id': widget.chatterId, 'Name': widget.chatterName});
    FirebaseFirestore.instance
        .collection('coms')
        .doc(user.uid)
        .collection('chats')
        .doc(widget.chatterId)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'senderId': user.uid,
      'receiverId': widget.chatterId,
      'senderName': userData.data()['username'],
      'receiverName': widget.chatterName,
      'senderImage': userData.data()['image_url'],
    });
    FirebaseFirestore.instance
        .collection('coms')
        .doc(widget.chatterId)
        .collection('chats')
        .doc(user.uid)
        .set({'Id': user.uid, 'Name': userData.data()['username']});
    FirebaseFirestore.instance
        .collection('coms')
        .doc(widget.chatterId)
        .collection('chats')
        .doc(user.uid)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'senderId': user.uid,
      'receiverId': widget.chatterId,
      'senderName': userData.data()['username'],
      'receiverName': widget.chatterName,
      'senderImage': userData.data()['image_url'],
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
