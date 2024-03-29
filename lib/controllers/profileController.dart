import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/profileModel.dart';
import 'package:provider/provider.dart';

class ProfileController extends ChangeNotifier {
  Future<void> getCurrentUserData(context) async {
    final profileProvider = Provider.of<Profile>(context, listen: false);
    User user = FirebaseAuth.instance.currentUser;
    final response = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    profileProvider.email = response.data()["email"];
    profileProvider.imageUrl = response.data()["image_url"];
    profileProvider.username = response.data()["username"];
    notifyListeners();
  }
}
