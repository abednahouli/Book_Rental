import 'package:Book_Rental/models/bookModel.dart';
import 'package:flutter/cupertino.dart';

class Books extends ChangeNotifier {
  List<Book> allBooks = [];
  List<Book> favoriteBooks = [];

  List<Book> getAllBooksList() {
    return [...allBooks];
  }

  List<Book> getFavoriteBooksList() {
    return [...favoriteBooks];
  }
}
