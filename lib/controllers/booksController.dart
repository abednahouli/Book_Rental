import 'package:Book_Rental/models/bookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/booksModel.dart';

class BooksController extends ChangeNotifier {
  Future<void> getBooks(context) async {
    final booksProvider = Provider.of<Books>(context, listen: false);
    booksProvider.allBooks.clear();
    // ignore: deprecated_member_use
    QuerySnapshot books = await FirebaseFirestore.instance
        .collection('books')
        .orderBy('createdAt')
        .get();

    books.docs.forEach(
      (newBook) {
        final newBookData = newBook.data();

        FirebaseFirestore.instance
            .collection('users')
            .doc(newBookData["submit_user"])
            .get()
            .then(
          (document) {
            print(document.data()["image_url"]);
            Book book = new Book(
              bookName: newBookData["bookName"],
              bookPrice: newBookData["bookPrice"],
              imageUrl: newBookData["image_url"],
              submitUserImage: document.data()["image_url"],
              createdAt: newBookData["createdAt"],
              publishDate: newBookData["publishDate"],
              submitUserId: newBookData["submit_user"],
              submitUserName: document.data()["username"],
            );
            booksProvider.allBooks.add(book);
            booksProvider.notifyListeners();
          },
        );
      },
    );
  }
}
