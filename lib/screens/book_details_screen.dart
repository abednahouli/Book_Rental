import 'package:Book_Rental/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  static const routeName = '/book-details';

  String imageUrl;
  String bookName;
  String bookPrice;
  Timestamp publishYear;
  String userId;

  BookDetailsScreen(
      {this.imageUrl,
      this.bookName,
      this.bookPrice,
      this.publishYear,
      this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage(imageUrl),
            ),
            Text('Publish date:' + publishYear.toDate().year.toString()),
            Text('Fa5eeeeem')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ChatScreen(userId),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.chat,
        ),
      ),
    );
  }
}
