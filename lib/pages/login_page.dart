import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.red.shade700,
                Colors.lightBlue.shade900,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
          ),
          Center(child: AuthForm())
        ],
      ),
    );
  }
}
