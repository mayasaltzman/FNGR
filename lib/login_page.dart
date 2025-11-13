import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 300),
            const Text(
              "Login page baddies", 
              style: TextStyle(color: Colors.pink),
            ),
            const SizedBox(height: 30),
            const TextField(
              style: TextStyle(color:Colors.pink),
              decoration: InputDecoration(
                labelText: 'Enter your username',
                labelStyle: TextStyle(color:Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                ),
              ),
            ), 
            const SizedBox(height: 10),
            const TextField(
              style: TextStyle(color:Colors.pink),
              decoration: InputDecoration(
                labelText: 'Enter your password',
                labelStyle: TextStyle(color:Colors.pink),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                ),
              ),
            ), 
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){
                print("go to login");
            },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                print("go to create account");
            },
              child: const Text(
                "Create account", 
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        )
      ),
    );
  }
}
