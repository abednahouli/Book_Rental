import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String bookName;
  String imageUrl;
  String submitUserImage;
  String submitUserId;
  int genre;
  double bookPrice;
  Timestamp createdAt;
  Timestamp publishDate;
  String submitUserName;
  String bookId;
  bool isFavorite;

  Book({
    this.bookName,
    this.bookPrice,
    this.createdAt,
    this.imageUrl,
    this.genre,
    this.publishDate,
    this.submitUserId,
    this.submitUserName,
    this.submitUserImage,
    this.bookId,
    this.isFavorite,
  });
}
