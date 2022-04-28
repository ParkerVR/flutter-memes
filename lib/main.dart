

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:io' as Io;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  
  final String title="The Memeing of Life";

  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      // theme: ThemeData(fontFamily: 'Mango'),
      home: Scaffold(
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
        body: const BackgroundImg()
      ),
    );
  }
}

Future<Meme> fetchMeme() async {
  try {
    final response = await http
      .get(Uri.parse('http://10.0.2.2:4200/randomMeme'));
      // This URL is used for android emulator as loopback for localhost.

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      String decodedBody = utf8.decode(base64Decode(response.body.replaceAll("\"", "")));
      var jsonDecodedBody = json.decode(decodedBody);
      return Meme.fromJson(jsonDecodedBody);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load meme');
    }
  } on Exception { 
    return const Meme(imgurl: "https://i.imgur.com/PLTmBlW.png", title: "Fail");
  }
}

class Meme {
  final String title;
  final String imgurl;

  const Meme({
    required this.title,
    required this.imgurl,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      title: json['title'],
      imgurl: json['imgurl'],
    );
  }
}

class BackgroundImg extends StatefulWidget {
  const BackgroundImg({Key? key}) : super(key: key);

  @override
  _BackgroundImgState createState() => _BackgroundImgState();
}

class _BackgroundImgState extends State<BackgroundImg> {
  
  @protected
  @override
  void initState() {
    super.initState();
  }

  late Meme currentMeme = const Meme(title: "Base Page", imgurl: "https://i.imgur.com/PLTmBlW.png", );
  late Meme nextMeme = const Meme(title: "Base Page", imgurl: "https://i.imgur.com/PLTmBlW.png", );


  void setupNextMeme() async {
    nextMeme = await fetchMeme();
    precacheImage(NetworkImage(nextMeme.imgurl), context);
  }
  
  void updateImage() {
    currentMeme = nextMeme;
    setupNextMeme();
  }
  

  void fiyaButtonHandler() {
    print("Fiya Meme: \"" + currentMeme.title + "\" (" + currentMeme.imgurl +")");
    updateImage();
  }

  void mehButtonHandler() {
    print("Meh Meme: \"" + currentMeme.title + "\" (" + currentMeme.imgurl +")");
    updateImage();
  }

  @override
  void didChangeDependencies() {
    setupNextMeme();
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      

      /*
      // To add text: set FAB.extended, set child as 'icon:'
      floatingActionButton: FloatingActionButton(

        // Icon
        child: const Icon(Icons.toggle_off_rounded),
        foregroundColor: Colors.red,
        
        // Background
        hoverColor: Colors.amberAccent,
        backgroundColor: Colors.amber,

        // Button Action
        onPressed: ()  {
          setState(() {
            updateImage();
          });
        },
      ), // FloatingActionButton
      */

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: NetworkImage(currentMeme.imgurl),
          ),
        ),
        child: Container(
          
          margin: const EdgeInsets.only(top: 10.0),
          child: Center(
            child: Column(
              children: [
                Row(children:[
                  Flexible( child: Text(
                    "TITLE: " + currentMeme.title, 
                    style: const TextStyle(
                      color: Color.fromARGB(255, 22, 22, 22), 
                      backgroundColor: Color.fromARGB(225, 233, 233, 233), 
                      fontFamily: "ComicMono"
                    )
                  ))
                ]),
                const Spacer(flex: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center ,
                  children: [
                    const Spacer(flex: 4),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.money_off_sharp, 
                        color: Colors.amber,
                        size: 15, 
                      ),
                      label: const Text('meh', style:TextStyle(
                        fontSize: 20, 
                        color: Colors.amber, 
                        fontFamily: "ComicMono", 
                        fontWeight: FontWeight.normal),

                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        
                        primary: Colors.red,

                        shape: const StadiumBorder(
                          side: BorderSide(width: 5, color: Colors.red),
                        )
                        //side: 
                      ), 
                      onPressed: () {
                        setState(() {
                          mehButtonHandler();
                        });
                      },
                      
                    ),
                    const Spacer(flex: 1),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.local_fire_department_sharp, 
                        color: Colors.red,
                        size: 18, 
                      ),
                      label: const Text('FIYA', style:TextStyle(
                        fontSize: 20, 
                        color: Colors.red, 
                        fontFamily: "ComicMono", 
                        fontWeight: FontWeight.normal),

                      ),
                      style: ElevatedButton.styleFrom(
                        
                        elevation: 0.0,
                        
                        primary: Colors.amber,
                        
                        shape: const StadiumBorder(
                          side: BorderSide(width: 5, color: Colors.amber),
                        )
                        //side: 
                      ), 
                      onPressed: () {
                        setState(() {
                          fiyaButtonHandler();
                        });
                      },
                      
                    ),
                    const Spacer(flex: 4),
                  ]
                ),
                const Spacer(),
              ],
              
            ),
          ),
        ),
      ),
    );
  }
}
