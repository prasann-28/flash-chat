import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  String messageText = '';

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for(var message in messages.docs){
  //     print(message.data());
  //   }
  //
  // }

  void messagesStream() async{
    await for ( var snapshot in _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    };

  }

  void getCurrentUser() async{
    final user = await _auth.currentUser;
    if(user!=null){
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                // Implement logout functionality
                await _auth.signOut();
                print('Logging user out ${loggedInUser.email}');
                Navigator.pop(context);

                // messagesStream();

              }),
        ],
        title: Text('️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    )
                  );
    }
                  var messages = snapshot.data?.docs;

                  List<MessageBubble> messageWidgets = [];
                  for( var message in messages!){
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');
                    

                    final messageWidget = MessageBubble(messageText: messageText, messageSender: messageSender, loggedInUser: loggedInUser,);
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      children: messageWidgets,
                    ),
                  );

                },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({"text": messageText,
                      'sender': loggedInUser.email,
                      'timestamp': Timestamp.now()});

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

class MessageBubble extends StatelessWidget {

  final String messageText;
  final String messageSender;
  final User loggedInUser;

  MessageBubble({ required this.messageText,required this.messageSender, required this.loggedInUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: messageSender == loggedInUser.email ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
              messageSender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            elevation: 5,
            color: messageSender != loggedInUser.email ? Colors.lightBlueAccent : Colors.pinkAccent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  messageText,
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 15
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
