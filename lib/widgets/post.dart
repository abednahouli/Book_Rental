import 'package:Book_Rental/controllers/booksController.dart';
import 'package:Book_Rental/models/bookModel.dart';
import 'package:Book_Rental/screens/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  final Book book;
  Post(this.book);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _isFavorite;

  @override
  Widget build(BuildContext context) {
    _isFavorite = widget.book.isFavorite;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                BookDetailsScreen(book: widget.book),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 10,
              bottom: 10,
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.book.submitUserImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  widget.book.submitUserName ?? "No name",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(widget.book.imageUrl),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<BooksController>(context, listen: false)
                        .changeFavorite(widget.book, context);
                    setState(
                      () {
                        _isFavorite = !_isFavorite;
                      },
                    );
                  },
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.black,
                    size: 25,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Name: " + widget.book.bookName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Price: " + widget.book.bookPrice.toString(),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Description: The financial sector contributes to the the success of our economy; it secures and creates jobs: over 650,000 people are currently working in the financial industry - enjoying attractive benefits and a wide range of career options.",
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
