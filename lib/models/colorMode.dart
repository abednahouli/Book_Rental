import 'package:flutter/material.dart';

//TODO: find way to update Theme Color without refreshing whole widget.
class ColorMode extends ChangeNotifier{
  Color mainColor=Colors.green[900];



  void changeMainColor(){
    if (mainColor==Colors.green[900]){
      mainColor= Colors.blueGrey[900];
      notifyListeners();
    }
    else if(mainColor==Colors.blueGrey[900]){
      mainColor= Colors.green[900];
      notifyListeners();
    }
  }

  Stream<ThemeData> returnChangedMainColor() async* {
      yield ThemeData(
          primaryColor: mainColor,
        );
  }
}