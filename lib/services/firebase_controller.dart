import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class FirebaseController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? _loggedInUser;

  User get logggedInUser {
    print(_loggedInUser);
    return _loggedInUser!;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
        print("not null");
      }
    } catch (e) {
      FlashChat.logger.e('unable to get current user.');
    }
  }

  Future<void> populate(String messageText) async {
    if (_loggedInUser != null) {
      await _firestore.collection('messages').add({
        'timestamp': Timestamp.now(),
        'text': messageText,
        'sender': logggedInUser.email,
      });
    }
  }

  void signout() {
    _auth.signOut();
  }
}
