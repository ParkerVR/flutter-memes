

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:io' as Io;

const String backendip="167.99.234.238:4200";

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
      .get(Uri.parse('http://$backendip/randomMeme'));
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
    return Meme(imgurl: "https://i.imgur.com/PLTmBlW.png", title: "Fail");
  }
}

Future<int> fetchMemeLikes(String imgurl) async {
  String url = 'http://$backendip/getMemeLikes?imgurl='+imgurl;
  try {
    final response = await http
      .get(Uri.parse(url));
      // This URL is used for android emulator as loopback for localhost.
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then return the value
      return int.parse(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Fail");
      throw Exception('Failed to get likes');
    }
  } on Exception { 
    return -1;
  }
}

void postLikeMeme(Meme meme) async {
  String url = "http://$backendip/likeMeme";
  // This URL is used for android emulator as loopback for localhost.

  Random r = Random();
  int uid = r.nextInt(1000);
  print("Meme Liked: " + meme.imgurl);
  try {
    final response = await http
      .post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{
          "imgurl": meme.imgurl,
          "title": meme.title,
          "liker": "ParkerVR",//+uid.toString(),
        })
      );

    if (response.statusCode == 202) {
      // If the server did return a 202 ACCEPTED response,
      // then return the value
      Icons.assignment_return_outlined;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to like');
    }
  } on Exception { 
    return;
  }
}

class Meme {
  final String title;
  final String imgurl;
  late int likes = 0;

  Meme({
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

  late Meme currentMeme = Meme(title: "Base Page", imgurl: "https://i.imgur.com/PLTmBlW.png", );
  late Meme nextMeme = Meme(title: "Base Page", imgurl: "https://i.imgur.com/PLTmBlW.png", );


  void setupNextMeme() async {
    nextMeme = await fetchMeme();
    precacheImage(NetworkImage(nextMeme.imgurl), context);
    int nextLikes = await fetchMemeLikes(nextMeme.imgurl);
    nextMeme.likes = nextLikes;
    print("Next Meme URL: " + nextMeme.imgurl);
    print("Next Meme Likes: " + nextMeme.likes.toString());
  }
  
  void updateImage() {
    currentMeme = nextMeme;
    setupNextMeme();
    print("Current Meme Likes: " + currentMeme.likes.toString());
  }

  void updateCurrentLikes() async {
    int likes = await fetchMemeLikes(currentMeme.imgurl);
    setState(() {
      currentMeme.likes = likes;  
    });
    print("Current Meme Likes: " + currentMeme.likes.toString());
  }

  void likeCurrentMeme() async {
    currentMeme.likes++;
    postLikeMeme(currentMeme);
  }

  void fiyaButtonHandler() async {
    likeCurrentMeme();
    //try {
    //  await GallerySaver.saveImage(currentMeme.imgurl);
    //} on Exception { 
    //  return;
    //}
    print("Fiya Meme: \"" + currentMeme.title + "\" (" + currentMeme.imgurl +")");
    updateImage();
  }

  void mehButtonHandler() async {
    print("Meh Meme: \"" + currentMeme.title + "\" (" + currentMeme.imgurl +")");
    updateImage();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      updateCurrentLikes();
      setupNextMeme();
    });
    
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
                Row(children:[
                  Flexible( child: Text(
                    "LIKES: " + currentMeme.likes.toString(), 
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
                    ElevatedButton(
                      child: const Text('meh.', style:TextStyle(
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
