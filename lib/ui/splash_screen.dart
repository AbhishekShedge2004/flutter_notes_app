import 'dart:async';
import 'package:database_new/ui/home_page.dart';
import 'package:database_new/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? result = prefs.getInt("UID");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
            if(result == 0){
              return LoginPage();
            }else{
              return HomePage();
            }
        },));
      }
    ,);
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Note app", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}