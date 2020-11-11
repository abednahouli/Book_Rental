import 'dart:convert';

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
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Profile()),
      ],
      child: MyApp(),
    ),);
}

Color newColor = Colors.blueGrey[900];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _tabKey = GlobalKey<ScaffoldState>();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Profile>(context, listen: false).getCurrentUserData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: isLight ? Colors.green[900] : newColor),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return FlutterLogo();
          }
          if (userSnapshot.hasData) {
            return DefaultTabController(
              key: _tabKey,
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
                  bottom: (TabBar(tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.favorite)),
                    Tab(icon: Icon(Icons.chat)),
                    Tab(icon: Icon(Icons.person)),
                  ])),
                ),
                body: TabBarView(children: [
                  HomeScreen(),
                  FavoritesScreen(),
                  Chats(),
                  ProfileScreen(changeState),
                ]),
              ),
            );
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

  void changeState() {
    setState(() {});
  }

  // Future<bool> saveLightMode() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('LightMode')) {}
  //   final extractedLightModeData =
  //       json.decode(prefs.getString('LightMode')) as Map<String, Object>;
  //   if (extractedLightModeData['Mode'] == true) {
  //     isLight = true;
  //   } else {
  //     isLight = false;
  //   }
  //   return true;
  // }
}
