import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {this.key});

  final Key key;
  final String userName;
  final String userImage;
  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage(
                  userImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: 35,
            height: 35,
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.green : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).accentTextTheme.headline6.color),
              ),
              Text(
                message,
                style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).accentTextTheme.headline6.color),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        if (isMe)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: NetworkImage(
                  userImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
            width: 35,
            height: 35,
          ),
      ],
    );
  }
}
