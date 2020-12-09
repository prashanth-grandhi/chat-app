import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// Message Type
const CHAT_MINE = 0;
const CHAT_PARTNER = 1;
const USER_JOIN = 2;
const USER_LEAVE = 3;

// Message
class Message{
  String userName, messageContent, roomName;
  int viewType;
  Message({this.userName, this.messageContent, this.roomName, this.viewType});
}

class ChatRoom extends StatefulWidget {
  final String userName;
  final String roomName;

  // receive data from the login screen as a parameter
  ChatRoom({Key key, @required this.userName, @required this.roomName})
      : super(key: key);

  @override
  _ChatRoomState createState() {
    return _ChatRoomState();
  }
}

class _ChatRoomState extends State<ChatRoom> {
  IO.Socket socketIO;
  TextEditingController chatController;
  List<Message> listChat = new List<Message>();

  @override
  void initState() {
    super.initState();
    print('initState');
    chatController = new TextEditingController();
    initSocketIO();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    String jsonData = '{"userName":"'+widget.userName+'","roomName":"'+widget.roomName+'"}';
    print(jsonData);
    socketIO.emit("unsubscribe", jsonData);
    socketIO.disconnect();
  }

  initSocketIO() {
    print('initSocketIO');

//    socketIO = IO.io('http://10.0.2.2:3000', <String, dynamic>{
//      'transports': ['websocket'], 'forceNew': true
//    });

    socketIO = IO.io('https://fierce-savannah-85196.herokuapp.com', <String, dynamic>{
      'transports': ['websocket'], 'forceNew': true
    });

    socketIO.onConnect((_) {
      print('onConnect');
      String jsonData = '{"userName":"' + widget.userName + '","roomName":"' +
          widget.roomName + '"}';
      print(jsonData);
      socketIO.emit("subscribe", jsonData);
    });

    socketIO.on("newUserToChatRoom", _onNewUser);
    socketIO.on("updateChat", _onUpdateChat);
    socketIO.on("userLeftChatRoom", _onUserLeft);
  }

  void _onNewUser(dynamic userJoined) async {
    print('_onNewUser');
    print(userJoined);
    setState(() {
      listChat.add(new Message(userName: userJoined,
          messageContent: "", roomName: widget.roomName, viewType: USER_JOIN));
    });
  }

  void _onUpdateChat(dynamic data) async {
    print('_onUpdateChat');
    print(data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    setState(() {
      listChat.add(new Message(userName: map['userName'],
          messageContent: map['messageContent'], roomName: widget.roomName, viewType: CHAT_PARTNER));
    });
  }

  void _onUserLeft(dynamic userLeft) async {
    print('_onUserLeft');
    print(userLeft);
    setState(() {
      listChat.add(new Message(userName: userLeft,
          messageContent: "", roomName: widget.roomName, viewType: USER_LEAVE));
    });
  }

  void _handleSubmit(String text) {
    print('_handleSubmit');
    chatController.clear();
    String jsonData = '{"userName":"'+widget.userName+'","roomName":"'+widget.roomName+'","messageContent":"'+text+'"}';
    socketIO.emit("newMessage", jsonData);
    setState(() {
      listChat.add(new Message(userName: widget.userName,
          messageContent: text, roomName: "", viewType: CHAT_MINE));
    });
  }

  Widget _msgContainer(Message chat) {
    print('_msgContainer');
    print('user ID: '+widget.userName);
    print('chat user name: '+chat.userName);
    if (chat.viewType == USER_JOIN) {
      return new Container(
        padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(chat.userName + ' has entered the room', style: new TextStyle(color: Colors.grey),)
          ],
        ),
      );
    } else if (chat.viewType == USER_LEAVE) {
      return new Container(
        padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(chat.userName + ' has left the room', style: new TextStyle(color: Colors.grey),)
          ],
        ),
      );
    } else if (chat.viewType == CHAT_PARTNER) {
      return new Container(
        padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(chat.userName, style: new TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),),
            new Text(chat.messageContent, style: new TextStyle(fontSize: 16),)
          ],
        ),
      );
    } else{
      return new Container(
        padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 8.0, left: 8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text('Me', style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
            new Text(chat.messageContent, style: new TextStyle(fontSize: 16),)
          ],
        ),
      );
    }
  }

  Widget _chatEnvironment (){
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),

                onPressed: ()=> _handleSubmit(chatController.text),

              ),
            )
          ],
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Chat Room')),
        body: new Column(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text('Your ID: '+widget.userName),
                  new Text('Chat Room: '+widget.roomName)
                ],
              ),
            ),
            new Flexible(
              child: ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: listChat.length,
                itemBuilder: ((ctx, idx){
                  return _msgContainer(listChat[idx]);
                }),
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
              child: _chatEnvironment(),)
          ],
        ));
  }
}