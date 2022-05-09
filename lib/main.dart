

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'memeScreen.dart';
import 'login.dart';
//import 'dart:io' as Io;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  final String title="The Memeing of Life";
  
  final routes = <String, WidgetBuilder>{
    LoginScreen.tag: (context) => const LoginScreen(),
    MemeScreen.tag: (context) => const MemeScreen(),
  };


  MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      // theme: ThemeData(fontFamily: 'Mango'),
      home: LoginScreen(),
      routes: routes, 
      /*home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                shadows: [ 
                  Shadow(color: Color.fromARGB(55, 255, 255, 255), 
                  blurRadius:10 ) 
                ], 
                fontFamily: 'Mango'
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        ),
        body: const  MemeScreen()
      ),*/
    );
  }
}

