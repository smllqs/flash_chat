import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_v2/components/message_bubble.dart';
import 'package:flash_chat_v2/constants.dart';
import 'package:flash_chat_v2/main.dart';
import 'package:flash_chat_v2/services/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String id = '/chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseController = FirebaseController();
  final _auth = FirebaseAuth.instance;
  final textController = TextEditingController();
  String messageText = '';

  @override
  void initState() {
    super.initState();
    _firebaseController.getCurrentUser;
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      FlashChat.logger.e('unable to get current user.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      textController.clear();
                      _firebaseController.populate(messageText);

                      await _firestore.collection('messages').add({
                        'timestamp': Timestamp.now(),
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: const Text(
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

//=========================================== MESSAGE STREAM ==============================================
class MessageStream extends StatelessWidget {
  MessageStream({super.key});
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        final messages = documents
            .map((doc) => MessageBubble(
                timestamp: doc['timestamp'],
                text: doc['text'],
                sender: doc['sender'],
                isMe: loggedInUser.email == doc['sender']))
            .toList();
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messages,
          ),
        );
      },
    );
  }
}
