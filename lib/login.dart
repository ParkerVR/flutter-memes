import 'package:app_1/memeScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'controller.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String tag = 'MemeScreen';



  @override
  Widget build(BuildContext context) {
    const appTitle = 'Username Entry';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}


// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final usernameTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: usernameTextController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          c.setUsername(usernameTextController.text);
          Get.to(const MemeScreen());
        },
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}