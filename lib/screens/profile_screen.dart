import 'package:Book_Rental/models/profileModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  bool isEdit = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(5, 5), // changes position of shadow
              ),
              BoxShadow(
                color: Colors.green[50],
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(-5, -5), // changes position of shadow
              ),
            ],
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Consumer<Profile>(builder: (context, profile, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(5, 5), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Colors.grey[200],
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(
                                    -5, -5), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                profile.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                  if (!isEdit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  if (isEdit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit mode on',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        profile.email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // Future<void> _setMode() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final lightMode = json.encode(
  //     {
  //       'Mode': isLight,
  //     },
  //   );
  //   prefs.setString('LightMode', lightMode);
  // }
}
