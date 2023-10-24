import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_v2/components/rounded_button.dart';
import 'package:flash_chat_v2/constants.dart';
import 'package:flash_chat_v2/main.dart';
import 'package:flash_chat_v2/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  late String email;
  late String password;

  void navigateToChat() {
    Navigator.pushNamed(context, ChatScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
                obscureText: true,
                textAlign: TextAlign.center,
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
                text: 'Login',
                color: Colors.lightBlueAccent,
                action: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final loggingInUser =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    navigateToChat();
                    setState(() {
                      showSpinner = true;
                    });
                  } catch (e) {
                    FlashChat.logger.e('an error occured');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
