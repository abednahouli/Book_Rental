import 'package:Book_Rental/models/bookModel.dart';
import 'package:Book_Rental/models/booksModel.dart';
import 'package:Book_Rental/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<Books>(
        builder: (context, books, child) {
          List<Book> bookList = books.getFavoriteBooksList();
          if (books.getFavoriteBooksList().length == 0) {
            return Stack(
              children: <Widget>[
                ListView(),
                Center(
                  child: Text(
                    "No Favorite Books",
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            );
          } else {
            return ListView.builder(
              itemCount: books.getFavoriteBooksList().length,
              itemBuilder: (ctx, i) {
                return Post(bookList[i]);
              },
            );
          }
        },
      ),
    );
  }
}
