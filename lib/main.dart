import 'package:Book_Rental/screens/add_book_screen.dart';
import 'package:Book_Rental/screens/favorites_screen.dart';
import 'package:Book_Rental/screens/home_screen.dart';
import 'package:Book_Rental/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/auth_Screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _tabKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[900]),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return DefaultTabController(
              key: _tabKey,
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Rent Me!'),
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
                  bottom: (TabBar(tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.favorite)),
                    Tab(icon: Icon(Icons.person)),
                  ])),
                ),
                body: TabBarView(children: [
                  HomeScreen(),
                  FavoritesScreen(),
                  ProfileScreen(),
                ]),
              ),
            );
          }
          return AuthScreen();
        },
      ),
      routes: {
        AddBookScreen.routeName: (ctx) => AddBookScreen(),
      },
    );
  }
}
