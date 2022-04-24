# Flutter Memes

This app allows for showing memes (or other images) based on an API that looks like this:

```
GET localhost:4200/randomMeme
Response (b64 encoded) with code 200
{
  "title": "TheTitleOfTheMeme",
  "imgurl": "http://TheUrlOfTheMeme.com/img.png" 
}
```
## Getting Started With Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Run the App

`flutter run lib/main.dart` (Though I prefer to use VSCode Flutter Plugin and hit the play button! Tested on Windows and Android Emulator)

## About the App
This app supports caching of the next image!
