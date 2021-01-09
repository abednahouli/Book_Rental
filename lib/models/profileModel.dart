import 'package:flutter/cupertino.dart';

class Profile extends ChangeNotifier {
  String id;
  String email;
  String imageUrl;
  String username;
  List favorites;

  Profile({this.id,this.email, this.imageUrl, this.username, this.favorites});
}
