import 'package:flutter/material.dart';
import 'package:chat_app/chatroom.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController chatRoomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flutter Chat')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: userNameController,
                    autocorrect: true,
                    decoration: InputDecoration(hintText: 'Your Username'),
                  )
              ),
              Container(
                  width: 280,
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 20, right: 10),
                  child: TextField(
                    controller: chatRoomController,
                    autocorrect: true,
                    decoration: InputDecoration(hintText: 'Chat Room'),
                  )
              ),
              RaisedButton(
                onPressed: () {
                  _sendDataToSecondScreen(context);
                },
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('LOGIN HERE'),
              )
            ],
          ),
        ));
  }

  // get the text in the TextField and start the chat room
  void _sendDataToSecondScreen(BuildContext context) {
    String userNameText = userNameController.text;
    String chatRoomText = chatRoomController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoom(userName: userNameText,
              roomName: chatRoomText),
        ));
  }
}