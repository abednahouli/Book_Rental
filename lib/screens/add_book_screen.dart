import 'dart:io';

import 'package:Book_Rental/models/profileModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  static const routeName = '/add-book';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController _controller = new TextEditingController();

  String price = '0.0';

  String bookName;
  File bookImage;
  DateTime publishdate;
  BuildContext ctx;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  double getPriceDouble() {
    double pricec = double.parse(price);
    return pricec;
  }

  String changeprice(bool increase) {
    double pricec = double.parse(price);
    if (increase) {
      pricec += 10;
    } else if (pricec > 0 && increase == false) {
      pricec -= 10;
    }
    String price2 = pricec.toString();
    setState(() {
      price = price2;
    });

    print(price);
    return price;
  }

  Future<void> addBook(bookName) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('books').doc().set({
        'bookName': bookName,
        'bookPrice': getPriceDouble(),
        'createdAt': Timestamp.now(),
        'publishDate': publishdate,
        'submit_user': FirebaseAuth.instance.currentUser.uid,
        'username': Provider.of<Profile>(context,listen:false).username,
        'image_url': '',
      });
      final data = await FirebaseFirestore.instance
          .collection('books')
          .orderBy('createdAt', descending: true)
          .get();

      final newBookId = data.docs[0].id;
      print(newBookId);

      final ref = FirebaseStorage.instance
          .ref()
          .child('book_images')
          .child(newBookId + 'jpg');

      await ref.putFile(bookImage).onComplete;

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('books')
          .doc(newBookId)
          .update({'image_url': url});
    } catch (err) {
      var message = 'An error occured!';
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      _controller.clear();
      isLoading = false;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      addBook(
        bookName.trim(),
      );
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100, maxWidth: 150);

    setState(() {
      bookImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Book'),
      ),
      body: Scaffold(
        backgroundColor: Colors.green[100],
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Card(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            bookImage != null ? FileImage(bookImage) : null,
                        radius: 40,
                      ),
                      FlatButton.icon(
                        onPressed:
                            // ignore: unnecessary_statements
                            getImage,
                        textColor: Theme.of(context).primaryColor,
                        icon: Icon(Icons.image),
                        label: Text('Add image'),
                      ),
                      TextFormField(
                        key: ValueKey('bookName'),
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Book Name...',
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Book name should be at least 4 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          bookName = value;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Price: '),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                changeprice(false);
                              }),
                          Text('\$$price'),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                changeprice(true);
                              }),
                        ],
                      ),
                      FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2000, 3, 5),
                              maxTime: DateTime.now(), onChanged: (date) {
                            var date1 = date.year;
                            print('change $date1');
                          }, onConfirm: (date) {
                            var date1 = date;
                            publishdate = date1;
                            print('confirm $date1');
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          'show date time picker (English)',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 10),
                        child: isLoading
                            ? SpinKitRotatingCircle(
                                color: Colors.green,
                                size: 50.0,
                              )
                            : ButtonTheme(
                                minWidth: 200,
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    'Submit Book',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    _trySubmit();
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
