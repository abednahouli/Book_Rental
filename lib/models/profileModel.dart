import 'package:flutter/cupertino.dart';

class Profile extends ChangeNotifier {
  String email;
  String imageUrl;
  String username;
  List favorites;

  Profile({this.email, this.imageUrl, this.username, this.favorites});
}
