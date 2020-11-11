import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class Profile extends ChangeNotifier{
  String email;
  String image_url;
  String username;

  Profile({this.email,this.image_url,this.username});

  Future<void> getCurrentUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    final response = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    email=response.data()["email"];
    image_url=response.data()["image_url"];
    username=response.data()["username"];
    notifyListeners();
  }
}