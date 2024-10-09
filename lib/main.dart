import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_app/Firebase/firebase_auth.dart';
import 'package:poke_app/data_manager.dart';
import 'package:provider/provider.dart';

import 'View/Login/login_screen.dart';
import 'View/home/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DataManager dataManager = DataManager();
    return ChangeNotifierProvider(
      create: (_) => dataManager,
      builder: (context, dataManager) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: FirebaseAuth.instance.currentUser == null ? const LoginScreen() : const HomePage(),
        );
      },
    );
  }
}
