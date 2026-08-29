import 'package:flutter/material.dart';

import '../../main.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;

    if (!auth.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B0B0D),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD71920),
          ),
        ),
      );
    }

    if (!auth.hasAccount) {
      return const WelcomeScreen();
    }

    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    return const MainNavigation();
  }
}
