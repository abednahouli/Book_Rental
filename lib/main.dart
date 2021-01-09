import 'package:Book_Rental/controllers/booksController.dart';
import 'package:Book_Rental/controllers/profileController.dart';
import 'package:Book_Rental/models/booksModel.dart';
import 'package:Book_Rental/models/profileModel.dart';
import 'package:Book_Rental/screens/book_details_screen.dart';
import 'package:Book_Rental/widgets/mainPageLayout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
      theme: ThemeData(primaryColor: Colors.green, accentColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return FlutterLogo();
          }
          if (userSnapshot.hasData) {
            return MainPageLayout();
          }
          return AuthScreen();
        },
      ),
      routes: {
        BookDetailsScreen.routeName: (ctx) => BookDetailsScreen(),
      },
    );
  }
}


