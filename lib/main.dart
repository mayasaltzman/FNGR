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
        colorScheme: const ColorScheme.light(
          primary:  Color(0xFFFBEFF6),
          primaryContainer: Color(0xFFF9E7F2),
          primaryFixed: Color(0xFFAA4E85),
          secondary:  Color(0xFFD461A6),
          secondaryContainer: Color(0xFFFFFFFF),
          tertiary:  Color(0xFFFF9B55),
          tertiaryContainer: Color(0xFFFFF0E6),
          tertiaryFixed: Color(0xFFFFE0CA)
        )
      ),
      debugShowCheckedModeBanner: false,
      // home: HomePage(),ß
      home: const UserProfilePage(),
      );
     
  }
}
