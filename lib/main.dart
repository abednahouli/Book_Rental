import 'package:Book_Rental/controllers/booksController.dart';
import 'package:Book_Rental/controllers/profileController.dart';
import 'package:Book_Rental/models/booksModel.dart';
import 'package:Book_Rental/models/profileModel.dart';
import 'package:Book_Rental/screens/add_book_screen.dart';
import 'package:Book_Rental/screens/book_details_screen.dart';
import 'package:Book_Rental/screens/chats.dart';
import 'package:Book_Rental/screens/favorites_screen.dart';
import 'package:Book_Rental/screens/home_screen.dart';
import 'package:Book_Rental/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'screens/profile_screen.dart';

import 'screens/auth_Screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => Profile()),
        ChangeNotifierProvider(create: (context) => Books()),
        ChangeNotifierProvider(create: (context) => BooksController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return FlutterLogo();
          }
          if (userSnapshot.hasData) {
            return TabViewScreen();
          }
          return AuthScreen();
        },
      ),
      routes: {
        AddBookScreen.routeName: (ctx) => AddBookScreen(),
        BookDetailsScreen.routeName: (ctx) => BookDetailsScreen(),
      },
    );
  }
}

class TabViewScreen extends StatefulWidget {
  @override
  _TabViewScreenState createState() => _TabViewScreenState();
}

class _TabViewScreenState extends State<TabViewScreen> {
  int _currentIndex;
  PageController _pageController;

  List _screens = [
    HomeScreen(),
    FavoritesScreen(),
    AddBookScreen(),
    Chats(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileController>(context, listen: false)
        .getCurrentUserData(context);
    _currentIndex = 0;
    _pageController = new PageController();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    });
  }

  final List<Widget> _children = [
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
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            _children[_currentIndex],
          ],
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
              label: 'Messages',
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
