import 'package:flutter/material.dart';
import 'src/app.dart';
 
void main() {
  runApp(new MaterialApp(
  //theme: new ThemeData(scaffoldBackgroundColor: const Color(0xff151232)),
  theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
  debugShowCheckedModeBanner: true, 
  home: new PasswordlessApp(), 
   ));
}