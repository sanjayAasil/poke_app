import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/Firebase/firebase_auth.dart';
import 'package:poke_app/View/home/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          const Spacer(),
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.asset(
                fit: BoxFit.cover,
                'assets/pokemon.jpg',
              ),
            ),
          ),
          const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: () async {
                  UserCredential? user = await FirebaseAuthManager.signInWithGoogle();
                  if (user == null) return;
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                  }
                  print('Check cred ${user.user}');
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/google.jpg',
                      ),
                    ),
                    const Text('Sign in with google'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
