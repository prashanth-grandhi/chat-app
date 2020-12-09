# Client

A flutter chat application.

## How to use

- Run the chat app in Android Studio and deploy to emulator or real device.
- Enter username and chat room and click Login button.

## Features

- The user can connect to chat room.
- The user can send messages to other members in the chat room.
- The user receives notifications when other members join or leave.


# Server side with Node.js

A Node.js app is built using Socket.io and Express framework. The server app is deployed to Heroku cloud. 

The Heroku app name is fierce-savannah-85196 and the git URL: https://git.heroku.com/fierce-savannah-85196.git

## How to use (local setup)

```
$ npm ci
$ npm start
$ node server.js
```

And point your client app to `http://10.0.2.2:3000`.

## Features

- Multiple users can join a chat room by each entering a unique username
on website load.
- Users can type chat messages to the chat room.
- A notification is sent to all users when a user joins or leaves
the chatroom.
