import 'package:Book_Rental/configs/genreList.dart';
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


  Future<void> _searchFunc(value,{int genre}) async {
    Provider.of<BooksController>(context, listen: false).searchBookName(value,context,genre: genre!=null?genre:null);
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
                      Provider.of<Books>(context, listen: false).searchBooks.clear();
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

  Widget _genreHorizontalScroll(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: GenreList.genres.length,itemBuilder: (context,i){
        return Row(
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                _searchEnabled=true;
                                  
                                });
                _searchFunc(GenreList.genres[i],genre: i);

              },
              child: Container(
                decoration: BoxDecoration(color: Colors.green[100],borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(GenreList.genres[i],style:TextStyle(fontWeight: FontWeight.bold),),
                ),
                width: 120,
              ),
            ),
            SizedBox(width: 10,)
          ],
        );
      },),
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
          _genreHorizontalScroll(),
          SizedBox(height: 10,),
          Container(
            height:MediaQuery.of(context).size.height-256,
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
