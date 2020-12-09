import 'package:flutter/material.dart';
import 'package:chat_app/login.dart';

void main() => runApp(new ChatApp());

class ChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      home: new Login(),

    );
  }
}
