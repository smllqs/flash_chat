import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_v2/components/message_bubble.dart';
import 'package:flash_chat_v2/services/firebase_controller.dart';
import 'package:flutter/material.dart';

final FirebaseController firebaseController = FirebaseController();

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
        print("test");
        final messages = documents
            .map((doc) => MessageBubble(
                timestamp: doc['timestamp'],
                text: doc['text'],
                sender: doc['sender'],
                isMe: firebaseController.logggedInUser.email == doc['sender']))
            .toList();
        print(firebaseController.logggedInUser.email);

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
