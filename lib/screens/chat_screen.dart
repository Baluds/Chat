import 'package:flutter/material.dart';
import 'package:Chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedinuser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgtxtcon = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        //print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future getmessages() async {
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for (var message in messages.documents) {
  //     print(message.data);
  //   }
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.documents) {
  //       print(message.data);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                // getmessages();
                // messagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgtxtcon,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      msgtxtcon.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedinuser.email,
                        'text': messageText,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<Widget> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final currentuser = loggedinuser.email;

          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isme: currentuser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({this.sender, this.text, this.isme});
  final String sender;
  final String text;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5.0,
            color: isme ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15, color: isme ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
