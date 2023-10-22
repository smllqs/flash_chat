import 'package:flash_chat_v2/screens/chat_screen.dart';
import 'package:flash_chat_v2/screens/login_screen.dart';
import 'package:flash_chat_v2/screens/registration_screen.dart';
import 'package:flash_chat_v2/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen()
      },
    );
  }
}
