import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart'; // we’ll define this next
import 'user_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFBEFF6),
      )),
      debugShowCheckedModeBanner: false,
      // home: HomePage(),ß
      home: const UserProfilePage(),
    );
  }
}
