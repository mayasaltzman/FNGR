import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart'; // we’ll define this next
import 'user_profile_page.dart';
import 'create_profile_page.dart';

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
          fontFamily: "Gilroy-bold",
          colorScheme: const ColorScheme.light(
              primary: Color(0xFFFBEFF6), //app background
              primaryContainer:
                  Color(0xFFF9E7F2), //to distinguish from background
              primaryFixed: Color(0xFFAA4E85), //pink dark text
              secondary: Color(0xFFD461A6), //header color
              secondaryFixed: Color(0xFFFFFFFF), //white
              tertiary: Color(0xFFFF9B55),
              tertiaryContainer: Color(0xFFFFF0E6),
              tertiaryFixed: Color(0xFFFFE0CA)),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 22,
              ),
              bodyMedium: TextStyle(
                fontSize: 16,
              ),
              bodySmall: TextStyle(fontSize: 14))),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      //home: const UserProfilePage(),
      home: const CreateProfilePage(),
    );
  }
}
