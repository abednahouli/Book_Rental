import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/profileModel.dart';
import 'package:provider/provider.dart';

class ProfileController extends ChangeNotifier {
  Future<void> getCurrentUserData(context,{loop=true}) async {
    while (loop) {
      try {
        final profileProvider = Provider.of<Profile>(context, listen: false);
        String userId = FirebaseAuth.instance.currentUser.uid;
        final response = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        profileProvider.id= userId;
        profileProvider.email = response.data()["email"];
        profileProvider.imageUrl = response.data()["image_url"];
        profileProvider.username = response.data()["username"];
        profileProvider.favorites = response.data()["favorites"] ?? [];
        profileProvider.notifyListeners();
        loop=false;
      } catch (err) {
        print(err);
      }
    }
  }
}
