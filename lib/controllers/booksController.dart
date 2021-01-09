import 'package:Book_Rental/models/bookModel.dart';
import 'package:Book_Rental/models/profileModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/booksModel.dart';

class BooksController extends ChangeNotifier {
  Future<void> getBooks(context, {loop = true}) async {
    while (loop) {
      try {
        final booksProvider = Provider.of<Books>(context, listen: false);
        final prProvider = Provider.of<Profile>(context, listen: false);
        booksProvider.allBooks.clear();
        booksProvider.favoriteBooks.clear();
        // ignore: deprecated_member_use
        QuerySnapshot books = await FirebaseFirestore.instance
            .collection('books')
            .orderBy('createdAt')
            .get();

        books.docs.forEach(
          (newBook) {
            final newBookData = newBook.data();
            if (newBookData["submit_user"] !=
                FirebaseAuth.instance.currentUser.uid) {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(newBookData["submit_user"])
                  .get()
                  .then(
                (document) {
                  bool isFavorite = false;
                  prProvider.favorites.forEach((favorite) {
                    if (newBook.id == favorite) {
                      isFavorite = true;
                    }
                  });

                  Book book = new Book(
                    bookName: newBookData["bookName"],
                    bookPrice: newBookData["bookPrice"],
                    imageUrl: newBookData["image_url"],
                    genre: newBookData["genre"],
                    submitUserImage: document.data()["image_url"],
                    createdAt: newBookData["createdAt"],
                    publishDate: newBookData["publishDate"],
                    submitUserId: newBookData["submit_user"],
                    submitUserName: document.data()["username"],
                    bookId: newBook.id,
                    isFavorite: isFavorite,
                  );
                  if (isFavorite == true) {
                    booksProvider.favoriteBooks.add(book);
                  }
                  booksProvider.allBooks.add(book);
                  booksProvider.notifyListeners();
                  booksProvider.allBooks
                      .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  booksProvider.favoriteBooks
                      .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                },
              );
            }
          },
        );
        loop = false;
      } catch (err) {print(err);}
    }
  }

  void changeFavorite(
    Book book,
    BuildContext context,
  ) async {
    final booksProvider = Provider.of<Books>(context, listen: false);
    final prProvider = Provider.of<Profile>(context, listen: false);
    if (booksProvider.favoriteBooks.contains(book)) {
      booksProvider.favoriteBooks.remove(book);
      prProvider.favorites.remove(book.bookId);
      booksProvider.notifyListeners();
    } else {
      booksProvider.favoriteBooks.add(book);
      prProvider.favorites.add(book.bookId);
      booksProvider.notifyListeners();
    }

    booksProvider.allBooks.firstWhere((exBook) => exBook == book).isFavorite =
        !booksProvider.allBooks
            .firstWhere((exBook) => exBook == book)
            .isFavorite;

    List newFavorites = prProvider.favorites;
    prProvider.favorites = newFavorites;

    print(newFavorites);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'favorites': newFavorites});
    booksProvider.notifyListeners();
  }

  void searchBookName(String searchedValue,BuildContext context){
    final booksProvider = Provider.of<Books>(context, listen: false);
    booksProvider.searchBooks.clear();
    booksProvider.allBooks.forEach((book){
      print(book);
      print(searchedValue);
      if(book.bookName.toLowerCase().replaceAll(new RegExp(r"\s+"), "").contains(searchedValue.toLowerCase().replaceAll(new RegExp(r"\s+"), ""))){
        booksProvider.searchBooks.add(book);
      }
    });
  }

  // void addSingleBook(
  //   String newBookName,
  //   double newBookPrice,
  //   String newImageUrl,
  //   Timestamp newCreatedAt,
  //   Timestamp newPublishDate,
  //   BuildContext context,
  // ) {
  //   final booksProvider = Provider.of<Books>(context, listen: false);
  //   final prProvider = Provider.of<Profile>(context, listen: false);
  //   Book book = new Book(
  //     bookName: newBookName,
  //     bookPrice: newBookPrice,
  //     imageUrl: newImageUrl,
  //     createdAt: newCreatedAt,
  //     publishDate: newPublishDate,
  //     submitUserId: FirebaseAuth.instance.currentUser.uid,
  //     submitUserImage: prProvider.imageUrl,
  //     submitUserName: prProvider.username,
  //   );
  //   booksProvider.allBooks.add(book);
  //   booksProvider.notifyListeners();
  // }
}
