import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // Import NavMenu
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn() async {
    try {
      UserCredential user = await fireAuth.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );
      print("Logged in as ${user.user?.email}");
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavMenu()),
        );
      }
    }on FirebaseAuthException catch (e) {
      print("Login failed: ${e.message}");
    }
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
            TextField(
              controller: username,
              style: TextStyle(color:Colors.pink),
              decoration: InputDecoration(
                labelText: 'Enter your username (email)',
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
            TextField(
              controller: password,
              style: TextStyle(color:Colors.pink),
              obscureText: true,
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
              onPressed: () {
                signIn();
            },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            
            ElevatedButton(
              onPressed: () {
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
