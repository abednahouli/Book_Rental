import 'package:Book_Rental/screens/add_book_screen.dart';
import 'package:Book_Rental/screens/chats.dart';
import 'package:Book_Rental/screens/favorites_screen.dart';
import 'package:Book_Rental/screens/home_screen.dart';
import 'package:Book_Rental/screens/profile_screen.dart';
import 'package:Book_Rental/widgets/tabFade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPageLayout extends StatefulWidget {
  @override
  _MainPageLayoutState createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  int _currentIndex;

  @override
  void initState() {
    _currentIndex = 0;
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> alltabs = [
    HomeScreen(),
    FavoritesScreen(),
    AddBookScreen(),
    Chats(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Me!'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            )
          ],
        ),
        body: TabFade(
          index: _currentIndex,
          children: alltabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            onTabTapped(index);
          },
          type: BottomNavigationBarType.fixed,
          currentIndex:
              _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
