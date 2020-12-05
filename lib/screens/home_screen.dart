import 'package:Book_Rental/controllers/booksController.dart';
import 'package:Book_Rental/models/bookModel.dart';
import 'package:Book_Rental/models/booksModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  Future<void> getBooksFunc() async {
    bool hasData =
        Provider.of<Books>(context, listen: false).getAllBooksList().isEmpty;
    if (hasData)
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
      body: Consumer<Books>(builder: (context, books, child) {
        List<Book> bookList = books.getAllBooksList();
        if (isLoading)
          return Center(child: CircularProgressIndicator());
        else {
          return RefreshIndicator(
            onRefresh: () => _refresh(),
            child: ListView.builder(
              itemCount: books.getAllBooksList().length,
              itemBuilder: (ctx, i) => Column(
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
                                bookList[i].submitUserImage,
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
                          bookList[i].submitUserName ?? "No name",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(bookList[i].imageUrl),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price: " + bookList[i].bookPrice.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Description: The financial sector contributes to the the success of our economy; it secures and creates jobs: over 650,000 people are currently working in the financial industry - enjoying attractive benefits and a wide range of career options.",
                          maxLines: 4,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
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
            ),
          );
        }
      }),
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

// ignore: deprecated_member_use

}

// floatingActionButton: SpeedDial(
//   //for multiple floating action buttons
//   // both default to 16
//   marginRight: 18,
//   marginBottom: 20,
//   animatedIcon: AnimatedIcons.menu_close,
//   animatedIconTheme: IconThemeData(size: 22.0),
//   // this is ignored if animatedIcon is non null
//   // child: Icon(Icons.add),
//   visible: true,
//   // If true user is forced to close dial manually
//   // by tapping main button and overlay is not rendered.
//   closeManually: false,
//   curve: Curves.bounceIn,
//   overlayColor: Colors.black,
//   overlayOpacity: 0.5,
//   onOpen: () => print('OPENING DIAL'),
//   onClose: () => print('DIAL CLOSED'),
//   tooltip: 'Speed Dial',
//   heroTag: 'speed-dial-hero-tag',
//   backgroundColor: Colors.white,
//   foregroundColor: Colors.black,
//   elevation: 8.0,
//   shape: CircleBorder(),
//   children: [
//     SpeedDialChild(
//         child: Icon(Icons.add),
//         backgroundColor: Colors.red,
//         label: 'Add book',
//         labelStyle: TextStyle(fontSize: 18.0),
//         onTap: () =>
//             Navigator.of(context).pushNamed(AddBookScreen.routeName)),
//     SpeedDialChild(
//       child: Icon(Icons.brush),
//       backgroundColor: Colors.blue,
//       label: 'disfunctional',
//       labelStyle: TextStyle(fontSize: 18.0),
//       onTap: () => print('SECOND CHILD'),
//     ),
//     SpeedDialChild(
//       child: Icon(Icons.keyboard_voice),
//       backgroundColor: Colors.green,
//       label: 'disfunctional',
//       labelStyle: TextStyle(fontSize: 18.0),
//       onTap: () => print('THIRD CHILD'),
//     ),
//   ],
// ),
