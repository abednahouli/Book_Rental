import 'package:Book_Rental/screens/add_book_screen.dart';
import 'package:Book_Rental/screens/book_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getBooks(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,));
          }
          final bookDocs = futureSnapshot.data.documents;

          return RefreshIndicator(
            // ignore: missing_return
            onRefresh: () {
              _refresh(context);
            },
            child: GridView.builder(
              itemCount: bookDocs.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 5, left: 25, right: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: GridTile(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BookDetailsScreen(
                              bookName: bookDocs[i].data()['bookName'],
                              userId: bookDocs[i].data()['submit_user'],
                              bookPrice:
                                  bookDocs[i].data()['bookPrice'].toString(),
                              publishYear: bookDocs[i].data()['publishDate'],
                              imageUrl: bookDocs[i].data()['image_url'],
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        bookDocs[i].data()['image_url'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    footer: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      height: 70,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 5, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bookDocs[i].data()['bookName'],
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$' +
                                          bookDocs[i]
                                              .data()['bookPrice']
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.favorite_border,
                                  size: 40,
                                  color: Colors.amber,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        //for multiple floating action buttons
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Colors.red,
              label: 'Add book',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () =>
                  Navigator.of(context).pushNamed(AddBookScreen.routeName)),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'disfunctional',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: 'disfunctional',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh(ctx) async {
    setState(() {
      print('refreshed');
    });
    var message = 'Refreshed!!';
    final snack = Scaffold.of(ctx).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[700],
    ));
    return snack;
  }

// ignore: deprecated_member_use
  Future<QuerySnapshot> _getBooks() async {
    // ignore: deprecated_member_use
    QuerySnapshot books = await FirebaseFirestore.instance
        .collection('books')
        .orderBy('createdAt')
        .get();
    return books;
  }
}
