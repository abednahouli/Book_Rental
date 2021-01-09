import 'package:Book_Rental/controllers/booksController.dart';
import 'package:Book_Rental/models/bookModel.dart';
import 'package:Book_Rental/models/booksModel.dart';
import 'package:Book_Rental/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  Future<void> getBooksFunc() async {
    await Provider.of<BooksController>(context, listen: false)
        .getBooks(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooksFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<Books>(
        builder: (context, books, child) {
          List<Book> bookList = books.getAllBooksList();
          if (isLoading)
            return Center(child: CircularProgressIndicator());
          else if (books.getAllBooksList().length == 0) {
            return RefreshIndicator(
              onRefresh: () => _refresh(),
              child: Stack(
                children: <Widget>[
                  ListView(),
                  Center(
                    child: Text(
                      "No Books Currently Available",
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refresh(),
              child: ListView.builder(
                itemCount: books.getAllBooksList().length,
                itemBuilder: (ctx, i) {
                  return Post(bookList[i]);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<BooksController>(context, listen: false)
        .getBooks(context);
    setState(() {
      isLoading = false;
    });
  }
}
