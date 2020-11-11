import 'dart:convert';

import 'package:Book_Rental/models/profileModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.function);
  final void Function() function;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

bool isLight = true;

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLight ? Colors.green[100] : Colors.blueGrey,
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(5, 5), // changes position of shadow
              ),
              BoxShadow(
                color: Colors.green[50],
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(-5, -5), // changes position of shadow
              ),
            ],
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Consumer<Profile>(builder: (context, profile, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(5, 5), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Colors.grey[200],
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(
                                    -5, -5), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                profile.image_url,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                  if (!isEdit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  if (isEdit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit mode on',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isLight ? 'Light Mode' : 'Dark Mode'),
                      Switch(
                        value: !isLight,
                        onChanged: (newValue) {
                          setState(() {
                            isLight = !newValue;
                            widget.function();
                            _setMode();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEdit = !isEdit;
          });
        },
        child: Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Future<DocumentSnapshot> _getCurrentUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userData;
  }

  Future<void> _setMode() async {
    final prefs = await SharedPreferences.getInstance();
    final lightMode = json.encode(
      {
        'Mode': isLight,
      },
    );
    prefs.setString('LightMode', lightMode);
  }
}
