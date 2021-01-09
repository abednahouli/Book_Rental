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

    var _searchEnabled = false;
  final _searchController = TextEditingController();

  Future<void> getBooksFunc() async {
    await Provider.of<BooksController>(context, listen: false)
        .getBooks(context);
    setState(() {
      isLoading = false;
    });
  }


  Future<void> _searchFunc(value) async {
    Provider.of<BooksController>(context, listen: false).searchBookName(value,context);
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10,10,10,10),
      height: 50,
      child: Row(
        children: [
          Container(
            width: _searchEnabled ? MediaQuery.of(context).size.width - 80 : MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Theme.of(context).accentColor, width: 3)),
            child: Form(
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    if (value.length >= 1) {
                      _searchFunc(value);
                    }
                    if (value.isEmpty) {
                      _searchEnabled = false;
                    } else {
                      _searchEnabled = true;
                    }
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for Name/Id',
                  hintStyle: TextStyle(color: Theme.of(context).accentColor),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          if (_searchEnabled)
            FlatButton(
              minWidth: 0,
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchEnabled = false;
                });
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    getBooksFunc();
  }

 @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _searchBar(),
          Container(
            height:MediaQuery.of(context).size.height-206,
            child: 
            !_searchEnabled?Consumer<Books>(
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
            ):Consumer<Books>(
              builder: (context, books, child) {
                List<Book> bookList = books.getSearchBooksList();
                print(bookList);
                if (isLoading)
                  return Center(child: CircularProgressIndicator());
                else if (books.getSearchBooksList().length == 0) {
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
                      itemCount: books.getSearchBooksList().length,
                      itemBuilder: (ctx, i) {
                        return Post(bookList[i]);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
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
