import 'package:flash_chat_v2/components/rounded_button.dart';
import 'package:flash_chat_v2/constants.dart';
import 'package:flash_chat_v2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const String id = '/registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool isUserNull = true;
  late String email;
  late String password;
  final Logger _logger = Logger(
      printer: PrettyPrinter(
    printEmojis: true,
    printTime: true,
    colors: true,
  ));

  @override
  Widget build(BuildContext context) {
    void navigateToChat() {
      Navigator.pushNamed(context, ChatScreen.id);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'enter your email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'enter your password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: 'Register',
              color: Colors.blueAccent,
              action: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  navigateToChat();
                } catch (e) {
                  _logger.e('error occurred');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
